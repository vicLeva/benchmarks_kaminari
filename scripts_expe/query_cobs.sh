#!/bin/bash

#real    94m54.575s
#user    36m44.087s
#sys     48m46.584s


#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/cobs/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/cobs/build/src/cobs" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/cobs"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/cobs"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_ecoli" -i "$index_dir"/ecoli.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/ecoli_cobs_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/ecoli.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/ecoli_cobs_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_human" -i "$index_dir"/human.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/human_cobs_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/human.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/human_cobs_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_gut" -i "$index_dir"/gut.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/gut_cobs_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/gut.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/gut_cobs_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" query -f "$pos_queries_salmonella" -i "$index_dir"/salmonella.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/salmonella_cobs_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/salmonella.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/salmonella_cobs_neg.txt >> "$log_filename" 2>&1
