#!/bin/bash

# Logging and paths
log_filename="/WORKS/vlevallois/expes_kaminari/logs/fulgor/query_all_query_size_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/home/genouest/genscale/vlevallois/giulio_colab/benchmarks_kaminari/softs/fulgor_ranking/build/fulgor"
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"
output_dir="/WORKS/vlevallois/expes_kaminari/ranking/fulgor"

# Query file locations by dataset
declare -A datasets=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli"
  [human]="/WORKS/vlevallois/data/dataset_genome_human"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella"
)

query_counts=(80 500 2000)

# Main loop
for dataset in "${!datasets[@]}"; do
  dataset_path="${datasets[$dataset]}"
  for count in "${query_counts[@]}"; do
    query_file="${dataset_path}/pos_queries_${count}.fasta"
    output_file="${output_dir}/${dataset}_fulgor_pos_${count}.txt"

    echo "=== Start $dataset with $count queries ===" >> "$log_filename"

    /usr/bin/time -v "$cmd" pseudoalign \
      -q "$query_file" \
      -i "$index_dir/${dataset}.fur" \
      -t 1 --threshold 0.8 \
      -o "$output_file" >> "$log_filename" 2>&1
  done
done

