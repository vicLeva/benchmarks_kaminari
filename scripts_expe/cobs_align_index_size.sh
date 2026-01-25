#!/bin/bash

#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/cobs/build_aligned_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/cobs/build/src/cobs" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/cobs"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
fof_human="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
fof_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
fof_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list"
fof_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
fof_refseq="/WORKS/vlevallois/data/dataset_refseq/fof.list"



echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_ecoli" "$index_dir"/ecoli_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.995 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_human" "$index_dir"/human_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.999999999 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_gut" "$index_dir"/gut_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.435 --num-hashes 1 >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_salmonella" "$index_dir"/salmonella_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.9997 --num-hashes 1 >> "$log_filename" 2>&1


#===============================================================================

echo "!!!==!!! start tara !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_tara" "$index_dir"/tara_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.9999 --num-hashes 1 >> "$log_filename" 2>&1


#===============================================================================

echo "!!!==!!! start refseq !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" compact-construct --file-type list --continue "$fof_refseq" "$index_dir"/refseq_aligned.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.4578 --num-hashes 1 >> "$log_filename" 2>&1
