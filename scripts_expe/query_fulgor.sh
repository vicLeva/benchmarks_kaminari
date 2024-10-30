#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/fulgor/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/fulgor/build/fulgor" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/fulgor"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "start ecoli" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_ecoli" \
  -i "$index_dir"/ecoli.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$neg_queries" \
  -i "$index_dir"/ecoli.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_human" \
  -i "$index_dir"/human.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/human_fulgor_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$neg_queries" \
  -i "$index_dir"/human.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/human_fulgor_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_gut" \
  -i "$index_dir"/gut.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/gut_fulgor_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$neg_queries" \
  -i "$index_dir"/gut.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/gut_fulgor_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_salmonella" \
  -i "$index_dir"/salmonella.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$neg_queries" \
  -i "$index_dir"/salmonella.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_neg.txt >> "$log_filename" 2>&1
