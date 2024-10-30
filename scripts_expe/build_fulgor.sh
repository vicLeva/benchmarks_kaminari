#!/bin/bash


#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/fulgor/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/fulgor/build/fulgor" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list"


echo "start ecoli" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -l "$fof_ecoli" \
  -o "$index_dir"/ecoli \
  -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_filename" 2>&1

#===============================================================================

echo "start human" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -l "$fof_human" \
  -o "$index_dir"/human \
  -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_filename" 2>&1

#===============================================================================

echo "start gut" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -l "$fof_gut" \
  -o "$index_dir"/gut \
  -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_filename" 2>&1

#===============================================================================

echo "start salmonella" >> "$log_filename"

/usr/bin/time -v "$cmd" build \
  -l "$fof_salmonella" \
  -o "$index_dir"/salmonella \
  -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_filename" 2>&1
