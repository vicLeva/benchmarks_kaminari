#!/bin/bash

# Logging
log_filename="/WORKS/vlevallois/expes_kaminari/logs/raptor/build_aligned_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="raptor"
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/raptor"
preprocessing_dir="$index_dir/preprocessing_files"
mkdir -p "$preprocessing_dir"

# Dataset info: name:fof_path:target_size_in_KB
declare -A datasets=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list:520164"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof.list:1183328"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list:4950684"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list:854088"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list:4737584"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/fof.list:22494208"
)

# Constants
threads=32
kmer=19
window=31
num_hashes=2
precision=0.0001

# Loop through datasets
for dataset in "${!datasets[@]}"; do
  IFS=":" read -r fof_path target_size <<< "${datasets[$dataset]}"
  echo "🔧 Processing $dataset → Target = ${target_size} KB" | tee -a "$log_filename"

  best_fpr=0
  best_diff=999999999
  upper=0.9999
  lower=0.0500

  while (( $(echo "$upper - $lower > $precision" | bc -l) )); do
    fpr=$(echo "scale=6; ($upper + $lower) / 2" | bc)
    layout_file="$preprocessing_dir/${dataset}_fpr_${fpr}.binning.out"
    output_file="$index_dir/${dataset}_aligned.raptor"

    echo "➡️ Trying FPR = $fpr" | tee -a "$log_filename"

    # Step 1: layout
    /usr/bin/time -v "$cmd" layout \
      --input-file "$fof_path" \
      --kmer $kmer \
      --window $window \
      --output "$layout_file" \
      --threads $threads \
      --fpr $fpr \
      --hash $num_hashes >> "$log_filename" 2>&1

    # Step 2: build
    /usr/bin/time -v "$cmd" build \
      --input "$layout_file" \
      --output "$output_file" \
      --window $window \
      --threads $threads >> "$log_filename" 2>&1

    # Measure size
    size=$(du -k "$output_file" | cut -f1)
    diff=$(echo "scale=6; ($size - $target_size) / $target_size" | bc)
    abs_diff=$(echo "$diff" | awk '{print ($1 >= 0) ? $1 : -$1}')
    echo "   Size = ${size} KB (diff = $diff)" | tee -a "$log_filename"

    # Track best match
    if (( $(echo "$abs_diff < $best_diff" | bc -l) )); then
      best_diff=$abs_diff
      best_fpr=$fpr
    fi

    # Binary search adjustment
    if (( $(echo "$size > $target_size" | bc -l) )); then
      lower=$fpr
    else
      upper=$fpr
    fi
  done
  echo "📦 Final size = $size KB with FPR = $fpr" | tee -a "$log_filename"
  echo "✅ $dataset: Best FPR found = $best_fpr (diff = $best_diff)" | tee -a "$log_filename"
done
