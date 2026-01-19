#!/bin/bash

# =============================================================================
#                             CONFIGURATION SECTION
# =============================================================================

# Tool command
FULGOR_CMD="/WORKS/vlevallois/softs/fulgor/build/fulgor"

# Paths
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/fulgor"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"
TMP_DIR="/WORKS/vlevallois/tmp"

# Dataset FOF (file of files) paths
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof_10k.list"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/fof.list"
)

# Indexing parameters
KMER_SIZE=31
MINIMIZER_SIZE=19
MEMORY_LIMIT=256
THREADS=32

# Log file setup
mkdir -p "$LOG_DIR"
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# =============================================================================
#                                SCRIPT START
# =============================================================================

echo "Starting Fulgor index construction..." | tee -a "$LOG_FILENAME"

for dataset in "${!DATASETS[@]}"; do
  fof_path="${DATASETS[$dataset]}"
  output_index="$INDEX_DIR/${dataset}"

  echo "Building index for $dataset" | tee -a "$LOG_FILENAME"

  /usr/bin/time -v "$FULGOR_CMD" build \
    -l "$fof_path" \
    -o "$output_index" \
    -k "$KMER_SIZE" \
    -m "$MINIMIZER_SIZE" \
    -d "$TMP_DIR" \
    -g "$MEMORY_LIMIT" \
    -t "$THREADS" \
    --verbose >> "$LOG_FILENAME" 2>&1

  echo "Completed $dataset" | tee -a "$LOG_FILENAME"
  echo "----------------------------------------------------" >> "$LOG_FILENAME"
done

echo "All datasets processed successfully." | tee -a "$LOG_FILENAME"
