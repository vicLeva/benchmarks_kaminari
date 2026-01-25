import rbo
import numpy as np
import math
import ast
import time
from copy import *
from scipy.optimize import root_scalar
import json

NB_QUERIES = 50000

def read_json(file_path):
        with open(file_path, 'r') as file:
            data = json.load(file)
        return data[list(data.keys())[0]]

def RBO_MIN(A, B, p) -> float:
    """
    Args:
        A: first ranked list.
        B: second ranked list.
        p: Weight of each agreement at depth d: p**(d-1).
    Returns:
        The RBO_MIN(A, B, p) at depth D = min(len(A), len(B))
    """

    assert 0.0 < p < 1.0
    assert len(set(A)) == len(A) # no duplicates
    assert len(set(B)) == len(B) # no duplicates

    D = min(len(A), len(B))
    A_prefix, B_prefix = set(), set()
    rbo_min = 0.0
    X_d = 0 # overlap at depth d
    P = 1   # current power of p
    X_D = len(list(set(A[:D]) & set(B[:D])))

    for i in range(D):
        d = i+1 # depth
        ov = 0
        if A[i] in B_prefix:
            ov += 1
        if B[i] in A_prefix:
            ov += 1
        if A[i] == B[i]:
            ov += 1

        X_d += ov
        assert X_d == len(list(set(A[:d]) & set(B[:d])))
        # print(f"overlap at depth d={d} is {X_d}")

        rbo_min += (X_d - X_D) / d * P
        #print(f"i = {i}, X_d = {X_d}, X_D = {X_D}, rbo_min = {rbo_min}")
        P *= p
        A_prefix.add(A[i])
        B_prefix.add(B[i])

    return (1-p) * (rbo_min - X_D*np.log(1-p)/p)

def Wrbo(p, d):
    """ returns the weight distribution over the d first ranked elements for a given p value (cf paper)"""
    return 1 - (p**(d-1)) + ((1-p)/p) * d * ( np.log(1/(1-p)) - math.fsum([(p**i)/i for i in range(1,d)]) )

def find_p_from_Wrbo(W_target, d):
    """Finds the value of p given W_target and d using numerical methods."""
    def equation_to_solve(p):
        return Wrbo(p, d) - W_target

    # Use root_scalar to find the root of the equation
    result = root_scalar(equation_to_solve, bracket=[1e-10, 1-1e-10], method='brentq')
    
    if result.converged:
        return result.root
    else:
        raise ValueError("Root-finding did not converge.")


def line_to_list(line):
    line = line.rstrip()
    res = line.split("\t")[2:] #remove name + length
    return list(map(lambda x: int(ast.literal_eval(x)[0]), res)) #res = "(id, score)"

def line_to_sorted_list(line):
    """ making sure fulgor and kam results are comparable"""
    sorted_list = list()
    buffer = list()
    last_score = -1

    line = line.rstrip()
    for tup in line.split("\t")[2:]: #remove name + length
        id, score = ast.literal_eval(tup)
        if score != last_score:
            last_score = score
            buffer.sort()
            sorted_list.extend(buffer)
            buffer = list()
        buffer.append(id)
    buffer.sort()
    sorted_list.extend(buffer)
    return sorted_list

def kmindex_result_to_sorted_list(result):
    result_list = [(int(k)-1, v) for (k, v) in result.items()] #-1 because kmindex ids start at 1
    result_list.sort(key=lambda x: (-x[1], x[0])) #sort score then ids to compare w/ fulgor
    return [x[0] for x in result_list]

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

def list_cobs_to_sorted_list(docs_n_scores):
    docs_n_scores.sort(key=lambda x: (-x[1], x[0]))
    return [doc for doc, score in docs_n_scores]


def compute_RBOs_kaminari(file_kam, file_fur):
    res = [-1]*NB_QUERIES
    with open(file_kam, "r") as fkam:
        with open(file_fur, "r") as ffur:
            for i in range(NB_QUERIES):
                list_kam = line_to_sorted_list(fkam.readline())
                list_fur = line_to_sorted_list(ffur.readline())
                if len(list_fur) >= 10 and len(list_kam) > 0:
                    p = find_p_from_Wrbo(0.9, int(0.1*len(list_fur)))
                    tup = (RBO_MIN(list_kam, list_fur, p), len(list_kam), len(list_fur), p)
                    res[i] = tup
                    #computing rbo with p being such as 10% of the list explains 90% of the value
    return res

def compute_RBOs_kmindex(file_kmindex, file_fur):
    data_json = read_json(file_kmindex)
    res = [-1]*NB_QUERIES
    with open(file_fur, "r") as ffur:
        for i in range(NB_QUERIES):
            line_fur = ffur.readline()
            query_name = line_fur.split("\t")[0]
            list_fur = line_to_sorted_list(line_fur)
            list_kmi = kmindex_result_to_sorted_list(data_json[query_name])
            
            if len(list_fur) >= 10 and len(list_kmi) > 0:
                p = find_p_from_Wrbo(0.9, int(0.1*len(list_fur)))
                tup = (RBO_MIN(list_kmi, list_fur, p), len(list_kmi), len(list_fur), p)
                res[i] = tup
                #computing rbo with p being such as 10% of the list explains 90% of the value
    return res

def compute_RBOs_cobs(file_cobs, file_fur, fof):
    res = [-1]*NB_QUERIES
    links = fof_to_links(fof)

    with open(file_cobs, "r") as fcobs:
        with open(file_fur, "r") as ffur:
            for i in range(NB_QUERIES):
                line_cobs = fcobs.readline().rstrip().split("\t")
                query_cobs = line_cobs[0][1:]
                list_cobs = [0]*int(line_cobs[1])
                for i in range(int(line_cobs[1])):
                    line_docid_cobs = fcobs.readline().rstrip().split("\t")
                    list_cobs[i] = (links[line_docid_cobs[0]], int(line_docid_cobs[1]))
                
                list_cobs = list_cobs_to_sorted_list(list_cobs)
                
                line_fur = ffur.readline()

                #print("query_cobs", query_cobs, "query_fur", int(line_fur.split("\t")[0]))
                assert(query_cobs == line_fur.split("\t")[0])
                list_fur = line_to_sorted_list(line_fur)

                if len(list_fur) >= 10 and len(list_cobs) > 0:
                    p = find_p_from_Wrbo(0.9, int(0.1*len(list_fur)))
                    tup = (RBO_MIN(list_cobs, list_fur, p), len(list_cobs), len(list_fur), p)
                    res[i] = tup
                    #computing rbo with p being such as 10% of the list explains 90% of the value
    return res

def write_rbos_on_disk(rbos, output_file, dataset, length):
    with open(output_file, "a") as f:
        f.write(f">{dataset}\t{length}\n")
        f.write(str(rbos))
        f.write("\n")




def expe_RBO():
    fofs = {
        "ecoli": "/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list",
        "human": "/WORKS/vlevallois/data/dataset_genome_human/fof.list",
        "gut": "/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list",
        "salmonella": "/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list",
        "tara": "/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list",
        "refseq": "/WORKS/vlevallois/data/dataset_refseq/fof.list"}

    
    #/WORKS/vlevallois/expes_kaminari/ranking
    dir = "/WORKS/vlevallois/expes_kaminari/ranking"
    dir_fur = "/WORKS/vlevallois/expes_kaminari/ranking/fulgor"
    lengths = [80, 500, 2000]
    lengths = [1000]
    datasets = ["ecoli", "human", "gut", "salmonella", "tara", "resfseq"]
    datasets = ["ecoli", "salmonella", "gut"]
    tools = ["kaminari", "kmindex", "cobs"]
    tools = ["kaminari"]

    for dataset in datasets:
        for length in lengths:
            for tool in tools:
                print(f"Computing RBOs for {dataset}, queries of length {length}")

                start_time = time.time()

                # KAMINARI
                if tool == "kaminari":
                    rbos = compute_RBOs_kaminari(
                        f"/WORKS/vlevallois/expes_kaminari/ranking/kaminari/{dataset}_kaminari_pos.txt", 
                        f"/WORKS/vlevallois/expes_kaminari/ranking/fulgor/{dataset}_fulgor_pos.txt",
                    )   
                    write_rbos_on_disk(str(rbos), f"/WORKS/vlevallois/expes_kaminari/ranking/rbos/rbos_{refseq}_kaminari.txt", dataset, length)
                    print(f"\tElapsed: {time.time() - start_time} seconds (kaminari)")

                # KMINDEX
                elif tool == "kmindex":
                    rbos = compute_RBOs_kmindex(
                        f"{dir}/kmindex/{dataset}_kmindex_pos/{dataset}.kmindex.json",
                        f"{dir_fur}/{dataset}_fulgor_pos.txt"
                    )     
                    write_rbos_on_disk(str(rbos), f"/WORKS/vlevallois/expes_kaminari/ranking/rbos/rbos_{dataset}_kmindex.txt", dataset, length)
                    print(f"\tElapsed: {time.time() - start_time} seconds (kmindex)")

                # COBS
                elif tool == "cobs":
                    rbos = compute_RBOs_cobs(
                        f"{dir}/cobs/{dataset}_cobs_pos.txt",
                        f"{dir_fur}/{dataset}_fulgor_pos.txt",
                        fofs[dataset]
                    )      
                    write_rbos_on_disk(str(rbos), f"/WORKS/vlevallois/expes_kaminari/ranking/rbos/rbos_{dataset}_cobs.txt", dataset, length)
                    print(f"\tElapsed: {time.time() - start_time} seconds (cobs)")




if __name__ == "__main__":
    dir = "/WORKS/vlevallois/expes_kaminari/ranking"

    print(Wrbo(0.9, 25))
    print(find_p_from_Wrbo(0.9, 1000))


    expe_RBO()
    




