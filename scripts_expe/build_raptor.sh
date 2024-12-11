#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/raptor/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="raptor" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/raptor"

preprocessing_dir="/WORKS/vlevallois/expes_kaminari/indexes/raptor/preprocessing_files"
mkdir -p "$preprocessing_dir"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list"
fof_salmonella_150k="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_150k.list"




echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" layout --input-file "$fof_ecoli"  --kmer-size 31 --output-filename "$preprocessing_dir"/ecoli_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" build --input "$preprocessing_dir"/ecoli_binning.out --output "$index_dir"/ecoli.raptor --threads 32 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" layout --input-file "$fof_human"  --kmer-size 31 --output-filename "$preprocessing_dir"/human_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" build --input "$preprocessing_dir"/human_binning.out --output "$index_dir"/human.raptor --threads 32 >> "$log_filename" 2>&1


#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" layout --input-file "$fof_gut"  --kmer-size 31 --output-filename "$preprocessing_dir"/gut_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" build --input "$preprocessing_dir"/gut_binning.out --output "$index_dir"/gut.raptor --threads 32 >> "$log_filename" 2>&1


#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" layout --input-file "$fof_salmonella"  --kmer-size 31 --output-filename "$preprocessing_dir"/salmonella_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" build --input "$preprocessing_dir"/salmonella_binning.out --output "$index_dir"/salmonella.raptor --threads 32 >> "$log_filename" 2>&1



#===============================================================================

echo "!!!==!!! start salmonella 150k !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" layout --input-file "$fof_salmonella_150k"  --kmer-size 31 --output-filename "$preprocessing_dir"/salmonella_150k_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" build --input "$preprocessing_dir"/salmonella_150k_binning.out --output "$index_dir"/salmonella_150k.raptor --threads 32 >> "$log_filename" 2>&1