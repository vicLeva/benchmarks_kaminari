#!/bin/bash

# =============================================================================
#                             CONFIGURATION SECTION
# =============================================================================

# Executable command
KAMINARI_CMD="/WORKS/vlevallois/softs/kaminari/build/kaminari"

# Paths
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kaminari"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
TMP_DIR="/WORKS/vlevallois/tmp"

# Dataset FOFs (file of files): dataset_name=fof_path:is_metagenome
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/fof.list"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/fof.list"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/fof.list"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/fof.list"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/fof.list"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/fof.list"
  #[661k]="/WORKS/vlevallois/data/dataset_661k/fof.list"
)

# Indexing parameters
KMER_SIZE=31
MINIMIZER_SIZE=19
MEMORY_LIMIT=262144 # 256GB
THREADS=32
VERBOSITY=2

# Log file setup
mkdir -p "$LOG_DIR"
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# =============================================================================
#                                SCRIPT START
# =============================================================================

echo "Starting Kaminari index construction..." | tee -a "$LOG_FILENAME"

for dataset in "${!DATASETS[@]}"; do
  fof_path="${DATASETS[$dataset]}"
  output_index="$INDEX_DIR/${dataset}_index"

  echo "Building index for $dataset" | tee -a "$LOG_FILENAME"

  /usr/bin/time -v "$KAMINARI_CMD" build \
    -i "$fof_path" \
    -o "$output_index" \
    -k "$KMER_SIZE" \
    -m "$MINIMIZER_SIZE" \
    -a \
    -v "$VERBOSITY" \
    -t "$THREADS" \
    -g "$MEMORY_LIMIT" \
     >> "$LOG_FILENAME" 2>&1

  echo "Completed $dataset" | tee -a "$LOG_FILENAME"
  echo "----------------------------------------------------" >> "$LOG_FILENAME"
done

echo "All datasets processed successfully." | tee -a "$LOG_FILENAME"
