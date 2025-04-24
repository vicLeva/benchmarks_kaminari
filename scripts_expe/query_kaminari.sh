#!/bin/bash

# =============================================================================
#                                CONFIGURATION
# =============================================================================

# Executable and directories
KAMINARI_CMD="/WORKS/vlevallois/softs/kaminari/build/kaminari"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kaminari"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/kaminari"
TMP_DIR="/WORKS/vlevallois/tmp"

# Log file
LOG_FILE="$LOG_DIR/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Kaminari query parameters
THREADS=32
THRESHOLD=0.8
VERBOSE=1

# Dataset definitions: name:positive_query_file:index_file
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta:$INDEX_DIR/ecoli.kaminari"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta:$INDEX_DIR/human.kaminari"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta:$INDEX_DIR/gut.kaminari"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta:$INDEX_DIR/salmonella.kaminari"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta:$INDEX_DIR/tara.kaminari"
)

NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# =============================================================================
#                              MAIN EXECUTION
# =============================================================================

echo "Starting Kaminari queries..." | tee -a "$LOG_FILE"

for dataset in "${!DATASETS[@]}"; do
  IFS=":" read -r POS_QUERY INDEX <<< "${DATASETS[$dataset]}"
  echo "Running queries for $dataset" | tee -a "$LOG_FILE"

  # Positive query
  /usr/bin/time -v "$KAMINARI_CMD" query \
    -i "$POS_QUERY" \
    -x "$INDEX" \
    -d "$TMP_DIR" \
    -t "$THREADS" \
    -r "$THRESHOLD" \
    -v "$VERBOSE" \
    -o "$OUTPUT_DIR/${dataset}_kaminari_pos.txt" >> "$LOG_FILE" 2>&1

  # Negative query
  /usr/bin/time -v "$KAMINARI_CMD" query \
    -i "$NEG_QUERIES" \
    -x "$INDEX" \
    -d "$TMP_DIR" \
    -t "$THREADS" \
    -r "$THRESHOLD" \
    -v "$VERBOSE" \
    -o "$OUTPUT_DIR/${dataset}_kaminari_neg.txt" >> "$LOG_FILE" 2>&1

  echo "Finished $dataset" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"
done

echo "All Kaminari queries completed." | tee -a "$LOG_FILE"
