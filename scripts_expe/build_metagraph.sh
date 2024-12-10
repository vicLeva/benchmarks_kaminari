#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/metagraph/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="metagraph" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/metagraph"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -k 31 --mode canonical -o "$index_dir"/ecoli --disk-swap "$tmp_dir" -p 32 --mem-cap-gb 256 /WORKS/vlevallois/data/dataset_genome_ecoli/data/*.fna >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" annotate -i "$index_dir"/ecoli.dbg --anno-filename --mem-cap-gb 256 -p 32 -v -o "$index_dir"/ecoli --disk-swap "$tmp_dir" /WORKS/vlevallois/data/dataset_genome_ecoli/data/*.fna >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -k 31 --mode canonical -o "$index_dir"/human --disk-swap "$tmp_dir" -p 32 --mem-cap-gb 256 /WORKS/vlevallois/data/dataset_genome_human/data/*.fa.gz >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" annotate -i "$index_dir"/human.dbg --anno-filename --mem-cap-gb 256 -p 32 -v -o "$index_dir"/human --disk-swap "$tmp_dir" /WORKS/vlevallois/data/dataset_genome_human/data/*.fa.gz >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" build -k 31 --mode canonical -o "$index_dir"/gut --disk-swap "$tmp_dir" -p 32 --mem-cap-gb 256 /WORKS/vlevallois/data/dataset_metagenome_gut/data/*.fna.gz >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" annotate -i "$index_dir"/gut.dbg --anno-filename --mem-cap-gb 256 -p 32 -v -o "$index_dir"/gut --disk-swap "$tmp_dir" /WORKS/vlevallois/data/dataset_metagenome_gut/data/*.fna.gz >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" build -k 31 --mode canonical -o "$index_dir"/salmonella --disk-swap "$tmp_dir" -p 32 --mem-cap-gb 256 /WORKS/vlevallois/data/dataset_pangenome_salmonella/data_10k/*.fa.gz >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" annotate -i "$index_dir"/salmonella.dbg --anno-filename --mem-cap-gb 256 -p 32 -v -o "$index_dir"/salmonella --disk-swap "$tmp_dir" /WORKS/vlevallois/data/dataset_pangenome_salmonella/data_10k/*.fa.gz >> "$log_filename" 2>&1


echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


#crashes because too big number of arguments
