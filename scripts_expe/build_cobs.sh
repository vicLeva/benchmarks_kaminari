#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/cobs/build_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/cobs/build/src/cobs" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/cobs"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list"
fof_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_ecoli" "$index_dir"/ecoli.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_human" "$index_dir"/human.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_gut" "$index_dir"/gut.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_salmonella" "$index_dir"/salmonella.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 1 >> "$log_filename" 2>&1


#===============================================================================

echo "!!!==!!! start tara !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_tara" "$index_dir"/tara.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 1 >> "$log_filename" 2>&1