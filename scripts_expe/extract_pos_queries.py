import gzip

NB_QUERIES = 50000


def extract_random_sequences(fof, output, query_length, queries_per_contig):
    i = 0
    with open (output, 'w') as outfh:
        with open(fof, 'r') as file:
            for line in file:
                if i == NB_QUERIES:
                    break
                fasta_file = line.strip()
                i = write_random_sequences(fasta_file, outfh, i, query_length, queries_per_contig) 
    print("\tfinished with", i, " queries")

def write_random_sequences(fasta_file, outputstream, i, query_length, queries_per_contig):
    if fasta_file.endswith('.gz'): 
        fh = gzip.open(fasta_file, "rt")
    else:
        fh = open(fasta_file, "r")

    contig = "" 
    while True: 
        line = fh.readline()
        if line.startswith('>'):
            if contig == "":
                continue
            else:
                seqs = read_to_query_seqs(contig, query_length, queries_per_contig)
                for query_seq in (seqs):
                    outputstream.write(f'>{i}\n{query_seq}\n')
                    i += 1
                    if i == NB_QUERIES:
                        fh.close()
                        return i
                fh.close()
                return i
        
        elif line == "":
            seqs = read_to_query_seqs(contig, query_length, queries_per_contig)
            for query_seq in (seqs):
                outputstream.write(f'>{i}\n{query_seq}\n')
                i += 1
                if i == NB_QUERIES:
                    fh.close()
                    exit()
            fh.close()
            return i
        
        else:
            contig += line.strip()

    

def read_to_query_seqs(line, query_length, queries_per_contig):
    seqs = []
    j = 0
    for _ in range(queries_per_contig): 
        if (j+query_length) > len(line):
            break
        seqs.append(line[j:j+query_length])
        j += query_length
    return seqs


def write_random_seqs_fastq(fastq_file, outputstream, i, query_length, queries_per_file):
    if fastq_file.endswith('.gz'): 
        fh = gzip.open(fastq_file, "rt")
    else:
        fh = open(fastq_file, "r")

    contig = "" 
    is_seq = False

    target = i+queries_per_file

    while True:
        line = fh.readline()
        if line.startswith('@'):
            is_seq = True
        elif is_seq:
            is_seq = False
            if not all(char in 'ATCG' for char in line.strip()):
                continue
            contig += line.strip()
            if len(contig) > query_length:
                outputstream.write(f'>{i}\n{contig[:query_length]}\n')
                i += 1
                if i == NB_QUERIES:
                    fh.close()
                    exit()
                if i == target:
                    fh.close()
                    return i
                contig = ""
        else:
            continue

if __name__ == "__main__":
    repos = ["dataset_genome_ecoli", "dataset_metagenome_gut", "dataset_pangenome_salmonella", "dataset_genome_human"]
    #dataset_genome_human need 840 queries / contig, others can go w/ 200

    data_dir = '/WORKS/vlevallois/data'
    repo = "dataset_genome_ecoli"

    """ for repo in repos:
        for q_length in [80, 500, 2000]:
            print("doing " + repo + " with query length " + str(q_length))
            fof = f"{data_dir}/{repo}/fof.list"
            queries_per_contig = 200

            #specific cases
            if repo == "dataset_pangenome_salmonella":
                fof = f"{data_dir}/{repo}/fof_10k.list"
            if repo == "dataset_genome_human":
                queries_per_contig = 840

            output = f"{data_dir}/{repo}/pos_queries_{q_length}.fasta"

            extract_random_sequences(fof, output, q_length, queries_per_contig) """
    
    repo = "dataset_metagenome_tara"
    fof = f"{data_dir}/{repo}/fof.list"
    queries_per_file = 4200
    output = f"{data_dir}/{repo}/pos_queries.fasta"
    fh = open(output, "w") 
    with open(fof, 'r') as files:
        i = 0
        for f in files:
            i = write_random_seqs_fastq(f.strip(), fh, i, 1000, queries_per_file)    

    
