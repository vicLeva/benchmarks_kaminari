#!/bin/bash

#to change
log_prefix="/WORKS/vlevallois/expes_kaminari/logs"
log_suffix="build_tara_$(date '+%Y-%m-%d_%H-%M-%S').log" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_tara="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
#fof_salmonella_kmindex_150k="/WORKS/vlevallois/data/dataset_metagenome_tara/fof_kmindex.list"


#===============================================================================

echo "!!!==!!! start fulgor !!!==!!!" >> "$log_prefix/fulgor/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/fulgor/build/fulgor build -l "$fof_tara" -o "$index_dir"/fulgor/tara -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_prefix/fulgor/$log_suffix" 2>&1

#===============================================================================

echo "!!!==!!! start kaminari !!!==!!!" >> "$log_prefix/kaminari/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/kaminari/build_b0/kaminari build -i "$fof_tara" -o "$index_dir"/kaminari/tara.kaminari -k 31 -m 19 -d "$tmp_dir" -a -v 3 -t 32 -g 256 >> "$log_prefix/kaminari/$log_suffix" 2>&1

#===============================================================================