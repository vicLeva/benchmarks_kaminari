#!/bin/bash

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
pos_queries_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_ecoli" -i "$index_dir"/ecoli.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/ecoli_cobs_pos.txt 2>> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/ecoli.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/ecoli_cobs_neg.txt 2>> "$log_filename"

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_human" -i "$index_dir"/human.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/human_cobs_pos.txt 2>> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/human.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/human_cobs_neg.txt 2>> "$log_filename"

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$pos_queries_gut" -i "$index_dir"/gut.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/gut_cobs_pos.txt 2>> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/gut.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/gut_cobs_neg.txt 2>> "$log_filename"

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" query -f "$pos_queries_salmonella" -i "$index_dir"/salmonella.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/salmonella_cobs_pos.txt 2>> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/salmonella.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/salmonella_cobs_neg.txt 2>> "$log_filename"

#===============================================================================

echo "!!!==!!! start tara !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" query -f "$pos_queries_tara" -i "$index_dir"/tara.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/tara_cobs_pos.txt 2>> "$log_filename"

/usr/bin/time -v "$cmd" query -f "$neg_queries" -i "$index_dir"/tara.cobs_compact -T 32 --threshold 0.8 --load-complete > "$output_dir"/tara_cobs_neg.txt 2>> "$log_filename"