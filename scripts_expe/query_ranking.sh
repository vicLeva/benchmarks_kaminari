#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/ranking/logs/kaminari/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/kaminari/build/kaminari" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
output_dir="/WORKS/vlevallois/expes_kaminari/ranking/kaminari"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella"

data_dir="/WORKS/vlevallois/data"



echo "start ecoli kam 80" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_ecoli"/pos_queries_80.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_80_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_80.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_80_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start ecoli kam 500" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_ecoli"/pos_queries_500.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_500_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_500.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_500_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start ecoli kam 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_ecoli"/pos_queries_2000.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_2000_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_2000.fasta \
  -x "$index_dir"/ecoli.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/ecoli_kaminari_2000_neg.txt -v 1 >> "$log_filename" 2>&1


#===============================================================================
#===============================================================================


echo "start human kam 80" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_human"/pos_queries_80.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_80_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_80.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_80_neg.txt -v 1 >> "$log_filename" 2>&1


#===============================================================================

echo "start human kam 500" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_human"/pos_queries_500.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_500_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_500.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_500_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================

echo "start human kam 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_human"/pos_queries_2000.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_2000_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_2000.fasta \
  -x "$index_dir"/human.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/human_kaminari_2000_neg.txt -v 1 >> "$log_filename" 2>&1



#===============================================================================
#===============================================================================


echo "start gut kam 80" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_gut"/pos_queries_80.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_80_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_80.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_80_neg.txt -v 1 >> "$log_filename" 2>&1


#===============================================================================


echo "start gut kam 500" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_gut"/pos_queries_500.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_500_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_500.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_500_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================


echo "start gut kam 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_gut"/pos_queries_2000.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_2000_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_2000.fasta \
  -x "$index_dir"/gut.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/gut_kaminari_2000_neg.txt -v 1 >> "$log_filename" 2>&1



#===============================================================================
#===============================================================================


echo "start salmonella kam 80" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_salmonella"/pos_queries_80.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_80_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_80.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_80_neg.txt -v 1 >> "$log_filename" 2>&1


#===============================================================================


echo "start salmonella kam 500" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_salmonella"/pos_queries_500.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_500_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_500.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_500_neg.txt -v 1 >> "$log_filename" 2>&1

#===============================================================================


echo "start salmonella kam 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" query \
  -i "$pos_queries_salmonella"/pos_queries_2000.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_2000_pos.txt -v 1 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query \
  -i "$data_dir"/neg_queries_2000.fasta \
  -x "$index_dir"/salmonella.kaminari -d "$tmp_dir" -g 256 \
  -t 1 -r 0.8 --ranking -o "$output_dir"/salmonella_kaminari_2000_neg.txt -v 1 >> "$log_filename" 2>&1




#to change
log_filename="/WORKS/vlevallois/expes_kaminari/ranking/logs/fulgor/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/home/genouest/genscale/vlevallois/giulio_colab/benchmarks_kaminari/softs/fulgor_ranking/build/fulgor" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"
output_dir="/WORKS/vlevallois/expes_kaminari/ranking/fulgor"




echo "start ecoli fulgor 80" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_ecoli"/pos_queries_80.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_80_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_80.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_80_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start ecoli fulgor 500" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_ecoli"/pos_queries_500.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_500_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_500.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_500_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start ecoli fulgor 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_ecoli"/pos_queries_2000.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_2000_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_2000.fasta \
  -i "$index_dir"/ecoli.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/ecoli_fulgor_2000_neg.txt >> "$log_filename" 2>&1


#===============================================================================
#===============================================================================


echo "start human fulgor 80" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_human"/pos_queries_80.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_80_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_80.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_80_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start human fulgor 500" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_human"/pos_queries_500.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_500_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_500.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_500_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start human fulgor 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_human"/pos_queries_2000.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_2000_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_2000.fasta \
  -i "$index_dir"/human.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/human_fulgor_2000_neg.txt >> "$log_filename" 2>&1


#===============================================================================
#===============================================================================


echo "start gut fulgor 80" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_gut"/pos_queries_80.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_80_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_80.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_80_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start gut fulgor 500" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_gut"/pos_queries_500.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_500_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_500.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_500_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start gut fulgor 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_gut"/pos_queries_2000.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_2000_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_2000.fasta \
  -i "$index_dir"/gut.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/gut_fulgor_2000_neg.txt >> "$log_filename" 2>&1


#===============================================================================
#===============================================================================


echo "start salmonella fulgor 80" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_salmonella"/pos_queries_80.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_80_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_80.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_80_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella fulgor 500" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_salmonella"/pos_queries_500.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_500_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_500.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_500_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella fulgor 2000" >> "$log_filename"

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$pos_queries_salmonella"/pos_queries_2000.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_2000_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" pseudoalign \
  -q "$data_dir"/neg_queries_2000.fasta \
  -i "$index_dir"/salmonella.fur \
  -t 1 --threshold 0.8  -o "$output_dir"/salmonella_fulgor_2000_neg.txt >> "$log_filename" 2>&1