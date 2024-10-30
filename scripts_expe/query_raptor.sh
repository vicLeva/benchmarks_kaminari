#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/raptor/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="raptor" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/raptor"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/raptor"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "start ecoli" >> "$log_filename"


/usr/bin/time -v "$cmd" search --index "$index_dir"/ecoli.raptor --query "$pos_queries_ecoli" --output "$output_dir"/ecoli_raptor_pos.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1


/usr/bin/time -v "$cmd" search --index "$index_dir"/ecoli.raptor --query "$neg_queries" --output "$output_dir"/ecoli_raptor_neg.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" search --index "$index_dir"/human.raptor --query "$pos_queries_human" --output "$output_dir"/human_raptor_pos.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1


/usr/bin/time -v "$cmd" search --index "$index_dir"/human.raptor --query "$neg_queries" --output "$output_dir"/human_raptor_neg.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" search --index "$index_dir"/gut.raptor --query "$pos_queries_gut" --output "$output_dir"/gut_raptor_pos.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1


/usr/bin/time -v "$cmd" search --index "$index_dir"/gut.raptor --query "$neg_queries" --output "$output_dir"/gut_raptor_neg.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" search --index "$index_dir"/salmonella.raptor --query "$pos_queries_salmonella" --output "$output_dir"/salmonella_raptor_pos.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1


/usr/bin/time -v "$cmd" search --index "$index_dir"/salmonella.raptor --query "$neg_queries" --output "$output_dir"/salmonella_raptor_neg.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_filename" 2>&1
