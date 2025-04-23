#!/bin/bash

log_filename="/WORKS/vlevallois/expes_kaminari/logs/kaminari/query_all_query_size_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="/WORKS/vlevallois/softs/kaminari/build/kaminari"
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/kaminari"
tmp_dir="/WORKS/vlevallois/tmp"

declare -A datasets=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli"
  [human]="/WORKS/vlevallois/data/dataset_genome_human"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella"
)

query_counts=(80 500 2000)

for dataset in "${!datasets[@]}"; do
  dataset_path="${datasets[$dataset]}"
  for count in "${query_counts[@]}"; do
    query_file="${dataset_path}/pos_queries_${count}.fasta"
    output_file="${output_dir}/${dataset}_kaminari_pos_${count}.txt"

    echo "=== Start $dataset with $count queries ===" >> "$log_filename"

    /usr/bin/time -v "$cmd" query \
      -i "$query_file" \
      -x "$index_dir/${dataset}.kaminari" \
      -d "$tmp_dir" -g 256 \
      -t 1 -r 0.8 \
      -o "$output_file" -v 1 >> "$log_filename" 2>&1
  done
done

