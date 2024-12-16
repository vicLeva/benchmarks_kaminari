#!/bin/bash


#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/kaminari/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/kaminari/build/kaminari" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list"
fof_salmonella_150k="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_150k.list"


echo "start ecoli" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_ecoli" \
  -o "$index_dir"/ecoli.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_human" \
  -o "$index_dir"/human.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_gut" \
  -o "$index_dir"/gut.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_salmonella" \
  -o "$index_dir"/salmonella.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella 150k !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_salmonella_150k" \
  -o "$index_dir"/salmonella_150k.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_filename" 2>&1


log_filename="/WORKS/vlevallois/expes_kaminari/logs/kaminari/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

echo "start ecoli" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_ecoli" \
  -o "$index_dir"/ecoli.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 1500 >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_human" \
  -o "$index_dir"/human.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 1500 >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_gut" \
  -o "$index_dir"/gut.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 1500 >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_salmonella" \
  -o "$index_dir"/salmonella.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 1500 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella 150k !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -i "$fof_salmonella_150k" \
  -o "$index_dir"/salmonella_150k.kaminari \
  -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 1500 >> "$log_filename" 2>&1