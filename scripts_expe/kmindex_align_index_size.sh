#!/bin/bash

#see run_individual_ntcards.sh for the commands to calculate the bloom size

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/kmindex/aligned(onlytara)_build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="kmindex"
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/kmindex"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof_kmindex.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof_kmindex.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof_kmindex.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k_kmindex.list"
fof_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/fof_kmindex.list"

pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"
pos_queries_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta"



echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_ecoli" -i "$index_dir"/ecoli_index_aligned -r ecoli_aligned.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 1166476 -d "$index_dir"/index_aligned_aligned_ecoli_on_disk >> "$log_filename" 2>&1

# -bloom-size 1166476 because 0.5 (kam size) * 1024*1024*1024*8 for all BF, / 3682 for each BF

rm -rf "$index_dir"/index_aligned_ecoli_on_disk/fpr \
    "$index_dir"/index_aligned_ecoli_on_disk/filters \
    "$index_dir"/index_aligned_ecoli_on_disk/howde_index \
    "$index_dir"/index_aligned_ecoli_on_disk/merge_infos \
    "$index_dir"/index_aligned_ecoli_on_disk/counts \
    "$index_dir"/index_aligned_ecoli_on_disk/histograms \
    "$index_dir"/index_aligned_ecoli_on_disk/partition_infos \
    "$index_dir"/index_aligned_ecoli_on_disk/superkmers \
    "$index_dir"/index_aligned_ecoli_on_disk/minimizers

/usr/bin/time -v  "$cmd" query -i "$index_dir"/ecoli_index_aligned -o "$output_dir"/ecoli_kmindex_pos_aligned  -q "$pos_queries_ecoli" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/ecoli_kmindex_pos_aligned/batch*

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_human" -i "$index_dir"/human_index_aligned -r human_aligned.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 161777101 -d "$index_dir"/index_aligned_human_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_aligned_human_on_disk/fpr \
    "$index_dir"/index_aligned_human_on_disk/filters \
    "$index_dir"/index_aligned_human_on_disk/howde_index \
    "$index_dir"/index_aligned_human_on_disk/merge_infos \
    "$index_dir"/index_aligned_human_on_disk/counts \
    "$index_dir"/index_aligned_human_on_disk/histograms \
    "$index_dir"/index_aligned_human_on_disk/partition_infos \
    "$index_dir"/index_aligned_human_on_disk/superkmers \
    "$index_dir"/index_aligned_human_on_disk/minimizers

/usr/bin/time -v  "$cmd" query -i "$index_dir"/human_index_aligned -o "$output_dir"/human_kmindex_pos_aligned  -q "$pos_queries_human" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/human_kmindex_pos_aligned/batch*

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_salmonella" -i "$index_dir"/salmonella_index_aligned -r salmonella_aligned.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 695784 -d "$index_dir"/index_aligned_salmonella_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_aligned_salmonella_on_disk/fpr \
    "$index_dir"/index_aligned_salmonella_on_disk/filters \
    "$index_dir"/index_aligned_salmonella_on_disk/howde_index \
    "$index_dir"/index_aligned_salmonella_on_disk/merge_infos \
    "$index_dir"/index_aligned_salmonella_on_disk/counts \
    "$index_dir"/index_aligned_salmonella_on_disk/histograms \
    "$index_dir"/index_aligned_salmonella_on_disk/partition_infos \
    "$index_dir"/index_aligned_salmonella_on_disk/superkmers \
    "$index_dir"/index_aligned_salmonella_on_disk/minimizers

/usr/bin/time -v  "$cmd" query -i "$index_dir"/salmonella_index_aligned -o "$output_dir"/salmonella_kmindex_pos_aligned  -q "$pos_queries_salmonella" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/salmonella_kmindex_pos_aligned/batch*

======================================================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -f "$fof_gut" -i "$index_dir"/gut_index_aligned -r gut_aligned.kmindex --hard-min 1 -k 25 -t 32 --bloom-size 4054449 -d "$index_dir"/index_aligned_gut_on_disk >> "$log_filename" 2>&1

rm -rf "$index_dir"/index_aligned_gut_on_disk/fpr \
    "$index_dir"/index_aligned_gut_on_disk/filters \
    "$index_dir"/index_aligned_gut_on_disk/howde_index \
    "$index_dir"/index_aligned_gut_on_disk/merge_infos \
    "$index_dir"/index_aligned_gut_on_disk/counts \
    "$index_dir"/index_aligned_gut_on_disk/histograms \
    "$index_dir"/index_aligned_gut_on_disk/partition_infos \
    "$index_dir"/index_aligned_gut_on_disk/superkmers \
    "$index_dir"/index_aligned_gut_on_disk/minimizers

/usr/bin/time -v  "$cmd" query -i "$index_dir"/gut_index_aligned -o "$output_dir"/gut_kmindex_pos_aligned  -q "$pos_queries_gut" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/gut_kmindex_pos_aligned/batch*


======================================================================================================

echo "!!!==!!! start refseq !!!==!!!" >> "$log_filename"

echo "see build_kmindex_refseq.sh for building though kmindex merge"
echo "to align with kaminari's size, need --bloom-size 7273696"
