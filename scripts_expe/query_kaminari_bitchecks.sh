#!/bin/bash

# =============================================================================
#                                CONFIGURATION
# =============================================================================

# Executable and directories
KAMINARI_CMD="/WORKS/vlevallois/softs/kaminari/build/kaminari"
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kaminari"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kaminari"
OUTPUT_DIR="/WORKS/vlevallois/expes_kaminari/answers/kaminari"

# Query Files
POS_QUERY="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
NEG_QUERIES="/WORKS/vlevallois/data/neg_queries.fasta"

# Log file
LOG_FILE="$LOG_DIR/query_human_bits_threshold_variation_$(date '+%Y-%m-%d_%H-%M-%S').log"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Kaminari static parameters
THREADS=32
VERBOSE=1

# =============================================================================
#                              MAIN EXECUTION
# =============================================================================

echo "Starting Kaminari Bit & Threshold Variation Query Experiment..." | tee -a "$LOG_FILE"

# 1. Loop through Bit Variations (Indexes)
for b in 0 1 2 3 4 5; do

  CURRENT_INDEX="$INDEX_DIR/human_index_b${b}"

  # Check if index exists
  if [ ! -d "$CURRENT_INDEX" ]; then
    echo "[WARN] Index $CURRENT_INDEX not found. Skipping." | tee -a "$LOG_FILE"
    continue
  fi

  # 2. Loop through Thresholds
  for threshold in 0.5 0.8 1.0; do

    # Unique identifier for this combination
    RUN_ID="human_b${b}_t${threshold}"

    echo "Running queries for $RUN_ID" | tee -a "$LOG_FILE"
    echo "  > Index: $CURRENT_INDEX" | tee -a "$LOG_FILE"
    echo "  > Threshold: $threshold" | tee -a "$LOG_FILE"

    # ---------------------------------------------------------
    # Positive Query
    # ---------------------------------------------------------
    /usr/bin/time -v "$KAMINARI_CMD" query \
      -i "$POS_QUERY" \
      -x "$CURRENT_INDEX" \
      -t "$THREADS" \
      -r "$threshold" \
      -v "$VERBOSE" \
      -o "$OUTPUT_DIR/${RUN_ID}_kaminari_pos.txt" >> "$LOG_FILE" 2>&1

    # ---------------------------------------------------------
    # Negative Query
    # ---------------------------------------------------------
    /usr/bin/time -v "$KAMINARI_CMD" query \
      -i "$NEG_QUERIES" \
      -x "$CURRENT_INDEX" \
      -t "$THREADS" \
      -r "$threshold" \
      -v "$VERBOSE" \
      -o "$OUTPUT_DIR/${RUN_ID}_kaminari_neg.txt" >> "$LOG_FILE" 2>&1

  done # End Threshold Loop

  echo "Finished all thresholds for human_b${b}" | tee -a "$LOG_FILE"
  echo "------------------------------------------------------" >> "$LOG_FILE"

done # End Bit Loop

echo "All variations completed." | tee -a "$LOG_FILE"