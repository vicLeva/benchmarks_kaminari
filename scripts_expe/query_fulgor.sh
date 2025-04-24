#!/bin/bash

# =============================================================================
#                                CONFIGURATION
# =============================================================================

# Paths to executables and directories (edit these if needed)
FULGOR_CMD="/WORKS/vlevallois/softs/fulgor/build/fulgor"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/fulgor"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/fulgor"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/fulgor"
TMP_DIR="/WORKS/vlevallois/tmp"

# Log file
LOG_FILE="$LOG_DIR/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Fulgor query parameters
THREADS=32
THRESHOLD=0.8

# Dataset definitions: name:positive_query_file:index_file
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta:$INDEX_DIR/ecoli.fur"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta:$INDEX_DIR/human.fur"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta:$INDEX_DIR/gut.fur"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta:$INDEX_DIR/salmonella.fur"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta:$INDEX_DIR/tara.fur"
)

NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# =============================================================================
#                              MAIN EXECUTION
# =============================================================================

echo "Starting Fulgor queries..." | tee -a "$LOG_FILE"

for dataset in "${!DATASETS[@]}"; do
  IFS=":" read -r POS_QUERY INDEX <<< "${DATASETS[$dataset]}"
  echo "Running queries for $dataset" | tee -a "$LOG_FILE"

  # Positive query
  /usr/bin/time -v "$FULGOR_CMD" pseudoalign \
    -q "$POS_QUERY" \
    -i "$INDEX" \
    -t "$THREADS" \
    --threshold "$THRESHOLD" \
    -o "$OUTPUT_DIR/${dataset}_fulgor_pos.txt" >> "$LOG_FILE" 2>&1

  # Negative query
  /usr/bin/time -v "$FULGOR_CMD" pseudoalign \
    -q "$NEG_QUERIES" \
    -i "$INDEX" \
    -t "$THREADS" \
    --threshold "$THRESHOLD" \
    -o "$OUTPUT_DIR/${dataset}_fulgor_neg.txt" >> "$LOG_FILE" 2>&1

  echo "Finished $dataset" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"
done

echo "All Fulgor queries completed." | tee -a "$LOG_FILE"
