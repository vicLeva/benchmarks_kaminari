#!/bin/bash

#to change
log_prefix="/WORKS/vlevallois/expes_kaminari/logs"
log_suffix="build_150k_$(date '+%Y-%m-%d_%H-%M-%S').log" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
fof_salmonella_150k="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_150k.list"
fof_salmonella_kmindex_150k="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_kmindex_150k.list"


echo "!!!==!!! start cobs !!!==!!!" >> "$log_prefix/cobs/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/cobs/build/src/cobs compact-construct --file-type list --continue "$fof_salmonella_150k" "$index_dir"/cobs/salmonella_150k.cobs_compact -m 274877906944 -k 31 -T 32 --false-positive-rate 0.05 --num-hashes 4 >> "$log_prefix/cobs/$log_suffix" 2>&1

#===============================================================================

echo "!!!==!!! start fulgor !!!==!!!" >> "$log_prefix/fulgor/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/fulgor/build/fulgor build -l "$fof_salmonella_150k" -o "$index_dir"/fulgor/salmonella_150k -k 31 -m 19 -d "$tmp_dir" -g 256 -t 32 --verbose >> "$log_prefix/fulgor/$log_suffix" 2>&1

#===============================================================================

echo "!!!==!!! start kmndex !!!==!!!" >> "$log_prefix/kmindex/$log_suffix"

/usr/bin/time -v kmtricks pipeline --file "$fof_salmonella_kmindex_150k" --run-dir "$index_dir"/kmindex/index_salmonella_150k_on_disk --kmer-size 25 --hard-min 1 --mode hash:bf:bin --bloom-size 36754250 -t 32 --until count >> "$log_prefix/kmindex/$log_suffix" 2>&1
#TODO : check bloom-size

/usr/bin/time -v kmtricks merge --run-dir "$index_dir"/kmindex/index_salmonella_150k_on_disk --mode hash:bf:bin -t 4 >> "$log_prefix/kmindex/$log_suffix" 2>&1

/usr/bin/time -v kmindex register --global-index "$index_dir"/kmindex/salmonella_150k_index --name salmonella_150k.kmindex --index-path "$index_dir"/kmindex/index_salmonella_150k_on_disk >> "$log_prefix/kmindex/$log_suffix" 2>&1

rm -rf "$index_dir"/kmindex/index_salmonella_150k_on_disk/fpr \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/filters \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/howde_index \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/merge_infos \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/counts \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/histograms \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/partition_infos \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/superkmers \
    "$index_dir"/kmindex/index_salmonella_150k_on_disk/minimizers


#===============================================================================

echo "!!!==!!! start raptor !!!==!!!" >> "$log_prefix/raptor/$log_suffix"

preprocessing_dir="/WORKS/vlevallois/expes_kaminari/indexes/raptor/preprocessing_files"

/usr/bin/time -v raptor layout --input-file "$fof_salmonella_150k"  --kmer-size 31 --output-filename "$preprocessing_dir"/salmonella_150k_binning.out --threads 32 --false-positive-rate 0.05 --num-hash-functions 4 >> "$log_prefix/raptor/$log_suffix" 2>&1

/usr/bin/time -v raptor build --input "$preprocessing_dir"/salmonella_150k_binning.out --output "$index_dir"/raptor/salmonella_150k.raptor --threads 32 >> "$log_prefix/raptor/$log_suffix" 2>&1