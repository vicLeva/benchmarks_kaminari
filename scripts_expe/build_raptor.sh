#!/bin/bash

# =============================================================================
#                            CONFIGURATION SECTION
# =============================================================================

# Executable and paths to be customized
RAPTOR_CMD="/WORKS/vlevallois/softs/raptor/build/bin/raptor"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/raptor"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/raptor"
PREPROCESS_DIR="$INDEX_DIR/preprocessing_files"
TMP_DIR="/WORKS/vlevallois/tmp"

# Create necessary directories
mkdir -p "$LOG_DIR" "$PREPROCESS_DIR"

# Log file
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Raptor parameters
KMER_SIZE=19
WINDOW_SIZE=31
THREADS=32
FPR=0.05
HASHES=2

# Dataset definitions: name:fof_path
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/fof.list"
)

# =============================================================================
#                               SCRIPT EXECUTION
# =============================================================================

echo "Starting Raptor index construction..." | tee -a "$LOG_FILENAME"

for dataset in "${!DATASETS[@]}"; do
  fof_path="${DATASETS[$dataset]}"
  layout_file="$PREPROCESS_DIR/${dataset}_binning.out"
  index_file="$INDEX_DIR/${dataset}.raptor"

  echo "Processing $dataset..." | tee -a "$LOG_FILENAME"

  # Step 1: Layout
  /usr/bin/time -v "$RAPTOR_CMD" layout \
    --input "$fof_path" \
    --kmer "$KMER_SIZE" \
    --window "$WINDOW_SIZE" \
    --output "$layout_file" \
    --threads "$THREADS" \
    --fpr "$FPR" \
    --hash "$HASHES" >> "$LOG_FILENAME" 2>&1

  # Step 2: Build
  /usr/bin/time -v "$RAPTOR_CMD" build \
    --input "$layout_file" \
    --output "$index_file" \
    --window "$WINDOW_SIZE" \
    --threads "$THREADS" >> "$LOG_FILENAME" 2>&1

  echo "$dataset indexing completed." | tee -a "$LOG_FILENAME"
  echo "------------------------------------------------------" >> "$LOG_FILENAME"
done

echo "All Raptor indexes built successfully." | tee -a "$LOG_FILENAME"
