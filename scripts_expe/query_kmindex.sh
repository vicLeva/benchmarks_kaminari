#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/kmindex/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="kmindex" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/kmindex"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"
pos_queries_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"


/usr/bin/time -v  "$cmd" query -i "$index_dir"/ecoli_index -o "$output_dir"/ecoli_kmindex_pos  -q "$pos_queries_ecoli" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/ecoli_kmindex_pos/batch*

/usr/bin/time -v  "$cmd" query -i "$index_dir"/ecoli_index -o "$output_dir"/ecoli_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/ecoli_kmindex_neg/batch*

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v  "$cmd" query -i "$index_dir"/human_index -o "$output_dir"/human_kmindex_pos  -q "$pos_queries_human" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/human_kmindex_pos/batch*

/usr/bin/time -v  "$cmd" query -i "$index_dir"/human_index -o "$output_dir"/human_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/human_kmindex_neg/batch*

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v  "$cmd" query -i "$index_dir"/gut_index -o "$output_dir"/gut_kmindex_pos  -q "$pos_queries_gut" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/gut_kmindex_pos/batch*

/usr/bin/time -v  "$cmd" query -i "$index_dir"/gut_index -o "$output_dir"/gut_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/gut_kmindex_neg/batch*

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"

/usr/bin/time -v  "$cmd" query -i "$index_dir"/salmonella_index -o "$output_dir"/salmonella_kmindex_pos  -q "$pos_queries_salmonella" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/salmonella_kmindex_pos/batch*

/usr/bin/time -v  "$cmd" query -i "$index_dir"/salmonella_index -o "$output_dir"/salmonella_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/salmonella_kmindex_neg/batch*

#===============================================================================

echo "!!!==!!! start tara !!!==!!!" >> "$log_filename"

/usr/bin/time -v  "$cmd" query -i "$index_dir"/tara_index -o "$output_dir"/tara_kmindex_pos  -q "$pos_queries_tara" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/tara_kmindex_pos/batch*

/usr/bin/time -v  "$cmd" query -i "$index_dir"/tara_index -o "$output_dir"/tara_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_filename" 2>&1

rm -rf "$output_dir"/tara_kmindex_neg/batch*


