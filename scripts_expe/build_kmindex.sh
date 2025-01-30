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
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_kmindex_10k.list"
fof_salmonella_150k="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_kmindex_150k.list"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_ecoli" -i "$index_dir"/ecoli_index -r ecoli.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 6771855 -d "$index_dir"/index_ecoli_on_disk >> "$log_filename" 2>&1

# -bloom-size 30556899 because https://hur.st/bloomfilter/?n=10898880&p=0.3&m=&k=1 (nb kmers from ntcard) (updated to fpr=0.8)

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

/usr/bin/time -v "$cmd" build -f "$fof_human" -i "$index_dir"/human_index -r human.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 1479843013 -d "$index_dir"/index_human_on_disk >> "$log_filename" 2>&1

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

/usr/bin/time -v "$cmd" build -f "$fof_gut" -i "$index_dir"/gut_index -r gut.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 4664750 -d "$index_dir"/index_gut_on_disk >> "$log_filename" 2>&1

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

/usr/bin/time -v "$cmd" build -f "$fof_salmonella" -i "$index_dir"/salmonella_index -r salmonella.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 8145280 -d "$index_dir"/index_salmonella_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_salmonella_on_disk/fpr \
    "$index_dir"/index_salmonella_on_disk/filters \
    "$index_dir"/index_salmonella_on_disk/howde_index \
    "$index_dir"/index_salmonella_on_disk/merge_infos \
    "$index_dir"/index_salmonella_on_disk/counts \
    "$index_dir"/index_salmonella_on_disk/histograms \
    "$index_dir"/index_salmonella_on_disk/partition_infos \
    "$index_dir"/index_salmonella_on_disk/superkmers \
    "$index_dir"/index_salmonella_on_disk/minimizers

#===============================================================================

echo "!!!==!!! start tara !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_tara" -i "$index_dir"/tara_index -r tara.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 2420941782 -d "$index_dir"/index_tara_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_tara_on_disk/fpr \
    "$index_dir"/index_tara_on_disk/filters \
    "$index_dir"/index_tara_on_disk/howde_index \
    "$index_dir"/index_tara_on_disk/merge_infos \
    "$index_dir"/index_tara_on_disk/counts \
    "$index_dir"/index_tara_on_disk/histograms \
    "$index_dir"/index_tara_on_disk/partition_infos \
    "$index_dir"/index_tara_on_disk/superkmers \
    "$index_dir"/index_tara_on_disk/minimizers