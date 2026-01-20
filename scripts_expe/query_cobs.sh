#!/bin/bash

# =============================================================================
#                              CONFIGURATION
# =============================================================================

# Paths to executables and directories (edit here as needed)
COBS_CMD="/WORKS/vlevallois/softs/cobs/build/src/cobs"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/cobs"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/cobs"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/cobs"
TMP_DIR="/WORKS/vlevallois/tmp"

# Log file
LOG_FILE="$LOG_DIR/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# COBS query parameters
THRESHOLD=0.8
THREADS=32

# Dataset definitions: name:positive_query_file:index_file
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta:$INDEX_DIR/ecoli.cobs_compact"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta:$INDEX_DIR/human.cobs_compact"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta:$INDEX_DIR/gut.cobs_compact"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta:$INDEX_DIR/salmonella.cobs_compact"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta:$INDEX_DIR/tara.cobs_compact"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/pos_queries.fasta:$INDEX_DIR/refseq.cobs_compact"
)

NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# =============================================================================
#                               MAIN EXECUTION
# =============================================================================

echo "Starting COBS queries..." | tee -a "$LOG_FILE"

for dataset in "${!DATASETS[@]}"; do
  IFS=":" read -r POS_QUERY INDEX <<< "${DATASETS[$dataset]}"
  echo "Running queries for $dataset" | tee -a "$LOG_FILE"

  # Positive query
  /usr/bin/time -v "$COBS_CMD" query \
    -f "$POS_QUERY" \
    -i "$INDEX" \
    -T "$THREADS" \
    --threshold "$THRESHOLD" \
    --load-complete > "$OUTPUT_DIR/${dataset}_cobs_pos.txt" 2>> "$LOG_FILE"

  # Negative query
  /usr/bin/time -v "$COBS_CMD" query \
    -f "$NEG_QUERIES" \
    -i "$INDEX" \
    -T "$THREADS" \
    --threshold "$THRESHOLD" \
    --load-complete > "$OUTPUT_DIR/${dataset}_cobs_neg.txt" 2>> "$LOG_FILE"

  echo "Finished $dataset" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"
done

echo "All COBS queries completed." | tee -a "$LOG_FILE"
