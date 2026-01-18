#!/bin/bash

# =============================================================================
#                            CONFIGURATION SECTION
# =============================================================================

# =============================================================================
# bloom_size is computed by checking the size (in kmers) of the biggest file
# then using https://hur.st/bloomfilter/, we can aim for a 80% FPR, with 1 hash function and knowing the size of the biggest file, we deduce the size of the bloom filter
# example with ecoli : https://hur.st/bloomfilter/?n=10898880&p=0.8&m=&k=1
# ntcard (https://github.com/bcgsc/ntCard) was used to compute the size of the biggest file
# ==============================================================================

# Executable command
KMINDEX_CMD="kmindex"

# Directory paths
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kmindex"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"
TMP_DIR="/WORKS/vlevallois/tmp"

# Output log file
mkdir -p "$LOG_DIR"
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Indexing parameters
KMER_SIZE=25
THREADS=32
HARD_MIN=1

# Dataset definitions: name:fof_path:bloom_size
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof_kmindex.list:6771855"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof_kmindex.list:1479843013"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof_kmindex.list:4664750"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k_kmindex.list:8145280"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof_kmindex.list:2420941782"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/fof_kmindex.list:9869292"
)

# =============================================================================
#                               SCRIPT EXECUTION
# =============================================================================

echo "Starting kmindex index construction..." | tee -a "$LOG_FILENAME"

for dataset in "${!DATASETS[@]}"; do
  IFS=":" read -r fof_path bloom_size <<< "${DATASETS[$dataset]}"
  index_prefix="$INDEX_DIR/${dataset}_index"
  output_file="$INDEX_DIR/${dataset}.kmindex"
  on_disk_dir="$INDEX_DIR/index_${dataset}_on_disk"

  echo "Processing $dataset..." | tee -a "$LOG_FILENAME"

  /usr/bin/time -v "$KMINDEX_CMD" build \
    -f "$fof_path" \
    -i "$index_prefix" \
    -r "$output_file" \
    --hard-min "$HARD_MIN" \
    -k "$KMER_SIZE" \
    -t "$THREADS" \
    --bloom-size "$bloom_size" \
    -d "$on_disk_dir" >> "$LOG_FILENAME" 2>&1

  echo "Cleaning temporary files for $dataset..." | tee -a "$LOG_FILENAME"

  rm -rf "$on_disk_dir"/{fpr,filters,howde_index,merge_infos,counts,histograms,partition_infos,superkmers,minimizers}

  echo "$dataset completed." | tee -a "$LOG_FILENAME"
  echo "----------------------------------------------------" >> "$LOG_FILENAME"
done

echo "All datasets processed successfully." | tee -a "$LOG_FILENAME"
