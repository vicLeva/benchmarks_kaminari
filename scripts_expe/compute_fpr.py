import rbo
import numpy as np
import math
import ast
import time
from copy import *
from scipy.optimize import root_scalar
import json
import matplotlib.pyplot as plt
import sys

NB_QUERIES = 50000

# Define constants
OFFICIAL_DIR = "/home/vlevallo/tmp/ranking"
RANKING_DIR = "/home/vlevallo/tmp/ranking"

DATASETS = {
    #"ecoli": 3682,
    #"human": 60,
    #"gut": 10000,
    #"salmonella": 10000,
    #"tara": 12,
    "refseq": 25321
}

def fof_to_links(fof):
    links = dict()
    with open(fof, "r") as f:
        i = 0
        for line in f:
            line = line.rstrip()
            line = line.split("/")[-1].split(".")[0]
            links[line] = i
            i += 1
    return links

def read_json(file_path):
        with open(file_path, 'r') as file:
            data = json.load(file)
        return data[list(data.keys())[0]]

def read_raptor(file_path, nbdocs, fof):
    fof_dict = fof_to_links(fof)
    links = dict()
    data = dict()
    with open(file_path, "r") as f:
        for _ in range(21): #21 for new raptor, 22 for old
            f.readline() #informations
        for i in range(nbdocs):
            line = f.readline().rstrip().split("\t")[1] #full path
            line = line.split("/")[-1].split(".")[0] #doc name
            links[i] = fof_dict[line]
        f.readline() #header
        for line in f:
            line = line.rstrip().split("\t")
            data[line[0]] = list(map(lambda x: links[int(x)], line[1].split(",")))
    return data

def line_to_list(line):
    line = line.rstrip()
    res = line.split("\t")[2:] #remove name + length
    return list(map(lambda x: int(ast.literal_eval(x)[0]), res)) #res = "(id, score)"

def line_to_best_scores_list(line):
    line = line.rstrip()
    answer = line.split("\t")[2:]  # remove name + length
    if len(answer) == 0:
        return []
    res = [int(ast.literal_eval(answer[0])[0])]
    score = int(ast.literal_eval(answer[0])[1])
    for elem in answer[1:]:
        if int(ast.literal_eval(elem)[1]) == score:
            res.append(int(ast.literal_eval(elem)[0]))
        else:
            return res
    return res

def kmindex_result_to_list(result):
    result_list = [(int(k)-1, v) for (k, v) in result.items()] #-1 because kmindex ids start at 1
    result_list.sort(key=lambda x: (-x[1], x[0])) #sort score then ids to compare w/ fulgor
    return [x[0] for x in result_list]

def kmindex_result_to_best_scores_list(result):
    result_list = [(int(k)-1, v) for (k, v) in result.items()] #-1 because kmindex ids start at 1
    result_list.sort(key=lambda x: (-x[1], x[0])) #sort score then ids to compare w/ fulgor
    score = result_list[0][1]
    return [x[0] for x in result_list if x[1] == score]

def list_cobs_to_sorted_list(docs_n_scores):
    docs_n_scores.sort(key=lambda x: (-x[1], x[0]))
    return [doc for doc, score in docs_n_scores]

def cobs_list_to_best_scores_list(docs_n_scores):
    docs_n_scores.sort(key=lambda x: (-x[1], x[0]))
    best_score = docs_n_scores[0][1]
    return [doc for doc, score in docs_n_scores if score == best_score]


def compute_fpr_kam(file_kam, file_fur):
    res = [-1]*NB_QUERIES
    with open(file_kam, "r") as fkam:
        with open(file_fur, "r") as ffur:
            nb_fps = 0
            nb_fps_amongst_best_score = 0
            for i in range(NB_QUERIES): #make it NB_QUERIES
                line_kam = fkam.readline()
                line_fur = ffur.readline()

                #if len(line_fur.rstrip().split("\t")[2:]) < 10:
                set_kam = frozenset(line_to_list(line_kam))
                set_fur = frozenset(line_to_list(line_fur))

                set_best_kam = frozenset(line_to_best_scores_list(line_kam))

                if len(set_kam) == 0:
                    print("bugged", i)
                    continue

                fps = set_kam - set_fur
                nb_fps += len(fps)
                nb_fps_amongst_best_score += len(set_best_kam & fps)

                res[i] = len(fps) / len(set_kam)
            
            #print(f"\t\tNb of fps: {nb_fps}, avg : {nb_fps/len([r for r in res if r!=-1])}  Nb of fps amongst best score set: {nb_fps_amongst_best_score}")
    
    return res

def compute_fpr_kmindex(file_kmi, file_fur):

    data_json = read_json(file_kmi)
    res = [-1]*NB_QUERIES
    nb_fps = 0
    nb_fps_amongst_best_score = 0
    nb_fns = 0
    with open(file_fur, "r") as ffur:
        for i in range(NB_QUERIES):
            line_fur = ffur.readline()
            #if len(line_fur.rstrip().split("\t")[2:]) < 10:
            if True:
                if data_json[str(i)] == {}:
                    nb_fns += 1
                    continue
                set_fur = frozenset(line_to_list(line_fur))
                set_kmi = frozenset(kmindex_result_to_list(data_json[str(i)]))

                set_best_kmi = frozenset(kmindex_result_to_best_scores_list(data_json[str(i)]))

                fps = set_kmi - set_fur
                nb_fps += len(fps)
                nb_fps_amongst_best_score += len(set_best_kmi & fps)

                res[i] = len(fps) / len(set_kmi)

        #print(f"\t\tNb of fps: {nb_fps}, avg : {nb_fps/len([r for r in res if r!=-1])}  Nb of fps amongst best score set: {nb_fps_amongst_best_score}")
        print(f"\t\tNb of fn: {nb_fns}")
    return res


def compute_fpr_cobs(file_cobs, file_fur, fof):
    res = [-1]*NB_QUERIES
    links = fof_to_links(fof)
    nb_fps = 0
    nb_fps_amongst_best_score = 0
    with open(file_cobs, "r") as fcobs:
        with open(file_fur, "r") as ffur:
            for i in range(NB_QUERIES):
                line_cobs = fcobs.readline().rstrip().split("\t")
                query_cobs = int(line_cobs[0][1:])
                list_cobs = [0]*int(line_cobs[1])
                for j in range(int(line_cobs[1])):
                    line_docid_cobs = fcobs.readline().rstrip().split("\t")
                    list_cobs[j] = (links[line_docid_cobs[0]], int(line_docid_cobs[1]))
                
                list_cobsienne = list_cobs_to_sorted_list(list_cobs)
                
                line_fur = ffur.readline()
                assert(query_cobs == int(line_fur.split("\t")[0]))
                #if len(line_fur.rstrip().split("\t")[2:]) < 10:
                if True:
                    set_fur = frozenset(line_to_list(line_fur))
                    set_cobs = frozenset(list_cobsienne)

                    set_best_cobs = frozenset(cobs_list_to_best_scores_list(list_cobs))

                    fps = set_cobs - set_fur
                    nb_fps += len(fps)
                    nb_fps_amongst_best_score += len(set_best_cobs & fps)

                    res[i] = len(fps) / len(set_cobs)

            #print(f"\t\tNb of fps: {nb_fps}, avg : {nb_fps/len([r for r in res if r!=-1])}  Nb of fps amongst best score set: {nb_fps_amongst_best_score}")
    return res

def compute_fpr_raptor(file_raptor, file_fur, nbdocs, fof):
    data = read_raptor(file_raptor, nbdocs, fof)
    res = [-1]*NB_QUERIES
    nb_fps = 0
    with open(file_fur, "r") as ffur:
        for i in range(NB_QUERIES):
            line_fur = ffur.readline()
            #if len(line_fur.rstrip().split("\t")[2:]) < 10:
            set_fur = frozenset(line_to_list(line_fur))
            set_raptor = frozenset(data[str(i)])

            fps = set_raptor - set_fur
            nb_fps += len(fps)

            res[i] = len(fps) / len(set_raptor)

        #print(f"\t\tNb of fps: {nb_fps}, avg : {nb_fps/len([r for r in res if r!=-1])}  Nb of fps amongst best score set: NA")
            
    return res





              


def size_kam_negative_answer(file_kam):
    res = [0]*NB_QUERIES
    with open(file_kam, "r") as fkam:
        for i in range(NB_QUERIES): #make it NB_QUERIES
            size_kam = len(fkam.readline().rstrip().split("\t")[2:])

            res[i] = size_kam
    return res

def size_cobs_negative_answer(file_cobs):
    res = [0]*NB_QUERIES
    with open(file_cobs, "r") as fcobs:
        for i in range(NB_QUERIES): #make it NB_QUERIES
            line_cobs = fcobs.readline().rstrip().split("\t")
            size_cobs = int(line_cobs[1])
            for i in range(size_cobs):
                fcobs.readline()
            res[i] = size_cobs
    return res

def size_kmi_negative_answer(file_kmi):
    res = [0]*NB_QUERIES
    data = read_json(file_kmi)
    for i in range(NB_QUERIES): #make it NB_QUERIES
        res[i] = len(data[str(i)])
    return res

def print_bins(sizes, nb_bins=5):
    bins = [0]*nb_bins # nb_0, nb_1, nb_2, nb_3, nb_4+
    for size in sizes:
        if size >= nb_bins -1:
            bins[nb_bins -1] += 1
        else:
            bins[size] += 1
    print(f"\tDistribution : {bins}")

def expe_negative_answers():
    dir = "/home/vlevallo/tmp/ranking"
    #dir = "/WORKS/vlevallois/expes_kaminari/ranking"
    lengths = [80, 500, 2000]
    lengths = [1000]

    datasets = ["ecoli", "human", "gut", "salmonella", "tara"]
    tools = ["kaminari", "kmindex", "cobs"]

    for dataset in datasets:
        for length in lengths:
            print("Kaminari")
            sizes = size_kam_negative_answer(
                    f"{dir}/kaminari/{dataset}_kaminari_neg.txt",
                )
            print_bins(sizes)
            
            print("Kmindex")
            sizes = size_kmi_negative_answer(
                    f"{dir}/kmindex/{dataset}_kmindex_neg/{dataset}.kmindex.json",
                )
            print_bins(sizes)

            print("Cobs")
            sizes = size_cobs_negative_answer(
                    f"{dir}/cobs/{dataset}_cobs_neg.txt",
                )
            print_bins(sizes)

def expe_intermediary_answers():
    #dir = "/home/vlevallo/tmp/ranking"
    dir = "/WORKS/vlevallois/expes_kaminari/ranking"
    official_dir = "/WORKS/vlevallois/expes_kaminari/answers"
    datasets = [("ecoli", 3682), ("human", 60), ("gut", 10000), ("salmonella", 10000)] #("tara", 12)
    datasets = [("ecoli", 3682), ("human", 60), ("salmonella", 10000)] #("tara", 12)
    

    for dataset in datasets:
        print(f"======\nComputing FPRs for {dataset[0]}\n======\n")

        print("Kaminari =======================")
        fprs = compute_fpr_kam(
            f"{official_dir}/kaminari/{dataset[0]}_kaminari_pos.txt",
            f"{dir}/fulgor/{dataset[0]}_fulgor_pos.txt"
        )
        fprs = [fpr for fpr in fprs if fpr != -1]
        print(f"\tSize of sample : {len(fprs)}  Average FPR: {np.mean(fprs)}")

        print("Kmindex =======================")
        fprs = compute_fpr_kmindex(
            f"{official_dir}/kmindex/{dataset[0]}_kmindex_pos/{dataset[0]}.kmindex.json",
            f"{dir}/fulgor/{dataset[0]}_fulgor_pos.txt"
        )
        fprs = [fpr for fpr in fprs if fpr != -1]
        print(f"\tSize of sample : {len(fprs)}  Average FPR: {np.mean(fprs)}")

        print("Cobs =======================")
        fprs = compute_fpr_cobs(
            f"{official_dir}/cobs/{dataset[0]}_cobs_pos.txt",
            f"{dir}/fulgor/{dataset[0]}_fulgor_pos.txt",
            f"{dir}/fofs/fof_{dataset[0]}.list"
        )
        fprs = [fpr for fpr in fprs if fpr != -1]
        print(f"\tSize of sample : {len(fprs)}  Average FPR: {np.mean(fprs)}")

        print("Raptor =======================")
        fprs = compute_fpr_raptor(
            f"{official_dir}/raptor/{dataset[0]}_raptor_pos.txt",
            f"{dir}/fulgor/{dataset[0]}_fulgor_pos.txt",
            dataset[1],
            f"{dir}/fofs/fof_{dataset[0]}.list"
        )
        fprs = [fpr for fpr in fprs if fpr != -1]
        print(f"\tSize of sample : {len(fprs)}  Average FPR: {np.mean(fprs)}")

def compute_and_print(tool, dataset_name, nb_docs):
    if tool.lower() == "kaminari":
        fprs = compute_fpr_kam(
            f"{OFFICIAL_DIR}/kaminari/{dataset_name}_kaminari_pos.txt",
            f"{RANKING_DIR}/fulgor/{dataset_name}_fulgor_pos.txt"
        )
    elif tool.lower() == "kmindex":
        fprs = compute_fpr_kmindex(
            f"{OFFICIAL_DIR}/kmindex/{dataset_name}_kmindex_pos/{dataset_name}.kmindex.json",
            f"{RANKING_DIR}/fulgor/{dataset_name}_fulgor_pos.txt"
        )
    elif tool.lower() == "cobs":
        fprs = compute_fpr_cobs(
            f"{OFFICIAL_DIR}/cobs/{dataset_name}_cobs_pos.txt",
            f"{RANKING_DIR}/fulgor/{dataset_name}_fulgor_pos.txt",
            f"{RANKING_DIR}/fofs/fof_{dataset_name}.list"
        )
    elif tool.lower() == "raptor":
        fprs = compute_fpr_raptor(
            f"{OFFICIAL_DIR}/raptor/{dataset_name}_raptor_pos.txt",
            f"{RANKING_DIR}/fulgor/{dataset_name}_fulgor_pos.txt",
            nb_docs,
            f"{RANKING_DIR}/fofs/fof_{dataset_name}.list"
        )
    else:
        print(f"Unknown tool: {tool}")
        return

    fprs = [fpr for fpr in fprs if fpr != -1]
    if fprs:
        print(f"{tool} (n={len(fprs)}) - Average FPR: {np.mean(fprs):.6f}\n")
    else:
        print(f"{tool} - No valid FPRs computed.\n")


def run_all():
    for dataset_name, nb_docs in DATASETS.items():
        print(f"======\nComputing FPRs for {dataset_name}\n======\n")

        #compute_and_print("Kaminari", dataset_name, nb_docs)
        compute_and_print("Kmindex", dataset_name, nb_docs)
        #compute_and_print("Cobs", dataset_name, nb_docs)
        #compute_and_print("Raptor", dataset_name, nb_docs)

def run_bitchecks():
    for b in range(3):
        for t in {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}:
            """ print(f"Bitchecks - b={b}, t={t} POS")
            fprs = compute_fpr_kam(
                f"{OFFICIAL_DIR}/kaminari/human_b{b}_t{t}_kaminari_pos.txt",
                f"{RANKING_DIR}/fulgor/human_t{t}_fulgor_pos.txt"
            )
            fprs = [fpr for fpr in fprs if fpr != -1]
            if fprs:
                print(f"(n={len(fprs)}) - Average FPR: {np.mean(fprs):.6f}\n")
            else:
                print(f"No valid FPRs computed.\n") """

            print(f"Bitchecks - b={b}, t={t} NEG")
            sizes = size_kam_negative_answer(
                f"{OFFICIAL_DIR}/kaminari/human_b{b}_t{t}_kaminari_neg.txt",
            )
            print_bins(sizes, nb_bins=11)
            

if __name__ == "__main__":
    if len(sys.argv) == 1:
        # No arguments → Full evaluation
        #run_all()
        run_bitchecks()
    elif len(sys.argv) == 3:
        # 2 arguments: tool and dataset
        tool = sys.argv[1]
        dataset_name = sys.argv[2]
        if dataset_name not in DATASETS:
            print(f"Dataset '{dataset_name}' not recognized. Available: {list(DATASETS.keys())}")
            sys.exit(1)
        compute_and_print(tool, dataset_name, DATASETS[dataset_name])
    else:
        print("Usage:")
        print("  python compute_fpr.py               # To compute FPRs for all datasets and tools")
        print("  python compute_fpr.py <tool> <dataset>  # To compute FPR for a specific tool and dataset")
        sys.exit(1)

