#!/bin/bash

# =============================================================================
#                             CONFIGURATION SECTION
# =============================================================================

# Tool command
COBS_CMD="/WORKS/vlevallois/softs/cobs/build/src/cobs"

# Paths
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/cobs"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/cobs"
TMP_DIR="/WORKS/vlevallois/tmp"

# Dataset FOF (file of files) paths
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
)

# Indexing parameters
KMER_SIZE=31
NUM_HASHES=1
THREADS=32
MEMORY_LIMIT=274877906944 # 256 GB
FPR=0.3

# Log file setup
mkdir -p "$LOG_DIR"
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# =============================================================================
#                                SCRIPT START
# =============================================================================

echo "Starting COBS index construction..." | tee -a "$LOG_FILENAME"

for dataset in "${!DATASETS[@]}"; do
  fof_path="${DATASETS[$dataset]}"
  output_index="$INDEX_DIR/${dataset}.cobs_compact"

  echo "Building index for $dataset" | tee -a "$LOG_FILENAME"

  /usr/bin/time -v "$COBS_CMD" compact-construct \
    --file-type list \
    --continue \
    "$fof_path" \
    "$output_index" \
    -m "$MEMORY_LIMIT" \
    -k "$KMER_SIZE" \
    -T "$THREADS" \
    --false-positive-rate "$FPR" \
    --num-hashes "$NUM_HASHES" >> "$LOG_FILENAME" 2>&1

  echo "Completed $dataset" | tee -a "$LOG_FILENAME"
  echo "----------------------------------------------------" >> "$LOG_FILENAME"
done

echo "All datasets processed successfully." | tee -a "$LOG_FILENAME"
