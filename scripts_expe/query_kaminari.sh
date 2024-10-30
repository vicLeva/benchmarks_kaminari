#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/kaminari/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/kaminari/build/kaminari" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/kaminari"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "start ecoli" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_ecoli" \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/ecoli_kaminari_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$neg_queries" \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/ecoli_kaminari_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_human" \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/human_kaminari_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$neg_queries" \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/human_kaminari_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_gut" \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/gut_kaminari_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$neg_queries" \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/gut_kaminari_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_salmonella" \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/salmonella_kaminari_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$neg_queries" \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 32 -r 0.8  -o "$output_dir"/salmonella_kaminari_neg.txt -v 1 >> "$log_filename" 2>&1
