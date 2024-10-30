#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/kmindex/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="kmindex"
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof_kmindex.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof_kmindex.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof_kmindex.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_kmindex.list"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_ecoli" -i "$index_dir"/ecoli_index -r ecoli.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 30556899 -d "$index_dir"/index_ecoli_on_disk >> "$log_filename" 2>&1

# -bloom-size 30556899 because https://hur.st/bloomfilter/?n=10898880&p=0.3&m=&k=1 (nb kmers from ntcard)

rm -rf "$index_dir"/index_ecoli_on_disk/fpr \
    "$index_dir"/index_ecoli_on_disk/filters \
    "$index_dir"/index_ecoli_on_disk/howde_index \
    "$index_dir"/index_ecoli_on_disk/merge_infos \
    "$index_dir"/index_ecoli_on_disk/counts \
    "$index_dir"/index_ecoli_on_disk/histograms \
    "$index_dir"/index_ecoli_on_disk/partition_infos \
    "$index_dir"/index_ecoli_on_disk/superkmers \
    "$index_dir"/index_ecoli_on_disk/minimizers


#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_human" -i "$index_dir"/human_index -r human.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 6677551896 -d "$index_dir"/index_human_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_human_on_disk/fpr \
    "$index_dir"/index_human_on_disk/filters \
    "$index_dir"/index_human_on_disk/howde_index \
    "$index_dir"/index_human_on_disk/merge_infos \
    "$index_dir"/index_human_on_disk/counts \
    "$index_dir"/index_human_on_disk/histograms \
    "$index_dir"/index_human_on_disk/partition_infos \
    "$index_dir"/index_human_on_disk/superkmers \
    "$index_dir"/index_human_on_disk/minimizers

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

#NOTE for gut and salmonella (10k docs) need to to the merge with less threads because too many files opened at once else

/usr/bin/time -v kmtricks pipeline --file "$fof_gut" --run-dir "$index_dir"/index_gut_on_disk --kmer-size 25 --hard-min 1 --mode hash:bf:bin --bloom-size 21048925 -t 32 --until count >> "$log_filename" 2>&1

/usr/bin/time -v kmtricks merge --run-dir "$index_dir"/index_gut_on_disk --mode hash:bf:bin -t 4 >> "$log_filename" 2>&1

/usr/bin/time -v kmindex register --global-index "$index_dir"/gut_index --name gut.kmindex --index-path "$index_dir"/index_gut_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_gut_on_disk/fpr \
    "$index_dir"/index_gut_on_disk/filters \
    "$index_dir"/index_gut_on_disk/howde_index \
    "$index_dir"/index_gut_on_disk/merge_infos \
    "$index_dir"/index_gut_on_disk/counts \
    "$index_dir"/index_gut_on_disk/histograms \
    "$index_dir"/index_gut_on_disk/partition_infos \
    "$index_dir"/index_gut_on_disk/superkmers \
    "$index_dir"/index_gut_on_disk/minimizers

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"

/usr/bin/time -v kmtricks pipeline --file "$fof_salmonella" --run-dir "$index_dir"/index_salmonella_on_disk --kmer-size 25 --hard-min 1 --mode hash:bf:bin --bloom-size 36754250 -t 32 --until count >> "$log_filename" 2>&1

/usr/bin/time -v kmtricks merge --run-dir "$index_dir"/index_salmonella_on_disk --mode hash:bf:bin -t 4 >> "$log_filename" 2>&1

/usr/bin/time -v kmindex register --global-index "$index_dir"/salmonella_index --name salmonella.kmindex --index-path "$index_dir"/index_salmonella_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_salmonella_on_disk/fpr \
    "$index_dir"/index_salmonella_on_disk/filters \
    "$index_dir"/index_salmonella_on_disk/howde_index \
    "$index_dir"/index_salmonella_on_disk/merge_infos \
    "$index_dir"/index_salmonella_on_disk/counts \
    "$index_dir"/index_salmonella_on_disk/histograms \
    "$index_dir"/index_salmonella_on_disk/partition_infos \
    "$index_dir"/index_salmonella_on_disk/superkmers \
    "$index_dir"/index_salmonella_on_disk/minimizers
