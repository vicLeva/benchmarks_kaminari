import random

def random_seq(n):
    return ''.join(random.choice('ACGT') for _ in range(n))

def write_file(filename, read_length, nb_reads):
    with open(filename, "w") as fh:
        for i in range(nb_reads):
            fh.write(f">{i}\n")
            fh.write(random_seq(read_length) + "\n")

write_file("/WORKS/vlevallois/data/neg_queries_80.fasta", 80, 50000)
write_file("/WORKS/vlevallois/data/neg_queries_500.fasta", 500, 50000)
write_file("/WORKS/vlevallois/data/neg_queries_2000.fasta", 2000, 50000)