#!/bin/bash

# =============================================================================
#                                CONFIGURATION
# =============================================================================

# Executable and directories
KM_CMD="kmindex"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kmindex"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/kmindex"
TMP_DIR="/WORKS/vlevallois/tmp"

# Log file
LOG_FILE="$LOG_DIR/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Parameters
THREADS=32
RATIO=0.8
z=6 # indexed 25-mers, query 25+6=31-mers

# Dataset definitions: name:positive_query:index_name
declare -A DATASETS=(
  [ecoli]="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta:ecoli_index"
  [human]="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta:human_index"
  [gut]="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta:gut_index"
  [salmonella]="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta:salmonella_index"
  [tara]="/WORKS/vlevallois/data/dataset_metagenome_tara/pos_queries.fasta:tara_index"
  [refseq]="/WORKS/vlevallois/data/dataset_refseq/pos_queries.fasta:refseq_on_disk"
)

NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# =============================================================================
#                              MAIN EXECUTION
# =============================================================================

echo "Starting kmindex queries..." | tee -a "$LOG_FILE"

for dataset in "${!DATASETS[@]}"; do
  IFS=":" read -r POS_QUERY INDEX_NAME <<< "${DATASETS[$dataset]}"
  echo "Running queries for $dataset" | tee -a "$LOG_FILE"

  # Positive queries
  /usr/bin/time -v "$KM_CMD" query \
    -i "$INDEX_DIR/$INDEX_NAME" \
    -o "$OUTPUT_DIR/${dataset}_kmindex_pos" \
    -q "$POS_QUERY" \
    -z "$z" -r "$RATIO" --aggregate -t "$THREADS" >> "$LOG_FILE" 2>&1

  rm -rf "$OUTPUT_DIR/${dataset}_kmindex_pos/batch*"

  # Negative queries
  /usr/bin/time -v "$KM_CMD" query \
    -i "$INDEX_DIR/$INDEX_NAME" \
    -o "$OUTPUT_DIR/${dataset}_kmindex_neg" \
    -q "$NEG_QUERIES" \
    -z "$z" -r "$RATIO" --aggregate -t "$THREADS" >> "$LOG_FILE" 2>&1

  rm -rf "$OUTPUT_DIR/${dataset}_kmindex_neg/batch*"

  echo "Finished $dataset" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"
done

echo "All kmindex queries completed." | tee -a "$LOG_FILE"
