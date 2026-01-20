#!/bin/bash

# =============================================================================
#                             CONFIGURATION SECTION
# =============================================================================

# Executable and directories
RAPTOR_CMD="raptor"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/raptor"
LOG_FILE="$LOG_DIR/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/raptor"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/raptor"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Parameters
THRESHOLD=0.8
QUERY_LENGTH=1000
THREADS=32

# Dataset definitions: name=positive_query_file
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/pos_queries.fasta"
)

NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# =============================================================================
#                                 MAIN SCRIPT
# =============================================================================

echo "Starting Raptor queries..." | tee -a "$LOG_FILE"

for dataset in "${!DATASETS[@]}"; do
  POS_QUERY="${DATASETS[$dataset]}"
  INDEX_FILE="$INDEX_DIR/${dataset}.raptor"
  POS_OUTPUT="$OUTPUT_DIR/${dataset}_raptor_pos.txt"
  NEG_OUTPUT="$OUTPUT_DIR/${dataset}_raptor_neg.txt"

  echo "Running queries for $dataset" | tee -a "$LOG_FILE"

  # Positive queries
  /usr/bin/time -v "$RAPTOR_CMD" search \
    --index "$INDEX_FILE" \
    --query "$POS_QUERY" \
    --output "$POS_OUTPUT" \
    --threads "$THREADS" \
    --threshold "$THRESHOLD" \
    --query_length "$QUERY_LENGTH" >> "$LOG_FILE" 2>&1

  # Negative queries
  /usr/bin/time -v "$RAPTOR_CMD" search \
    --index "$INDEX_FILE" \
    --query "$NEG_QUERIES" \
    --output "$NEG_OUTPUT" \
    --threads "$THREADS" \
    --threshold "$THRESHOLD" \
    --query_length "$QUERY_LENGTH" >> "$LOG_FILE" 2>&1

  echo "Finished $dataset" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"
done

echo "All Raptor queries completed." | tee -a "$LOG_FILE"
