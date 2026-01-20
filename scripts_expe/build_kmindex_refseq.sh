#!/bin/bash

# =============================================================================
#                            CONFIGURATION SECTION
# =============================================================================

# =============================================================================
# bloom_size is computed by checking the size (in kmers) of the biggest file
# then using https://hur.st/bloomfilter/, we can aim for a 80% FPR, with 1 hash function and knowing the size of the biggest file, we deduce the size of the bloom filter
# example with ecoli : https://hur.st/bloomfilter/?n=10898880&p=0.8&m=&k=1
# ntcard (https://github.com/bcgsc/ntCard) was used to compute the size of the biggest file
# ==============================================================================

# Executable command
KMINDEX_CMD="kmindex"

# Directory paths
LOG_DIR="/WORKS/vlevallois/expes_kaminari/logs/kmindex"
INDEX_DIR="/WORKS/vlevallois/expes_kaminari/indexes/kmindex"
TMP_DIR="/WORKS/vlevallois/tmp"

# Output log file
mkdir -p "$LOG_DIR"
LOG_FILENAME="$LOG_DIR/build_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Indexing parameters
KMER_SIZE=25
THREADS=32
HARD_MIN=1

# =============================================================================
#                               SCRIPT EXECUTION
# =============================================================================

echo "Starting kmindex index construction..." | tee -a "$LOG_FILENAME"

echo "Part 1/4: Building refseq group 1 index..." | tee -a "$LOG_FILENAME"

/usr/bin/time -v "$KMINDEX_CMD" build \
  -f "/WORKS/vlevallois/data/dataset_refseq/fof_kmindex_grp1.list" \
  -i "$INDEX_DIR/refseq_index" \
  -d "$INDEX_DIR/refseq_grp1_index" \
  -r "refseq_grp1.kmindex" \
  --hard-min "$HARD_MIN" \
  -k "$KMER_SIZE" \
  -t "$THREADS" \
  --bloom-size "9869292" \
   >> "$LOG_FILENAME" 2>&1

echo "Part 2/4: Building refseq group 2 index..." | tee -a "$LOG_FILENAME"

/usr/bin/time -v "$KMINDEX_CMD" build \
  -f "/WORKS/vlevallois/data/dataset_refseq/fof_kmindex_grp2.list" \
  -i "$INDEX_DIR/refseq_index" \
  -d "$INDEX_DIR/refseq_grp2_index" \
  -r "refseq_grp2.kmindex" \
  -t "$THREADS" \
  --from "refseq_grp1.kmindex" >> "$LOG_FILENAME" 2>&1

echo "Part 3/4: Merging refseq indexes..." | tee -a "$LOG_FILENAME"

/usr/bin/time -v "$KMINDEX_CMD" build \
  -f "/WORKS/vlevallois/data/dataset_refseq/fof_kmindex_grp3.list" \
  -i "$INDEX_DIR/refseq_index" \
  -d "$INDEX_DIR/refseq_grp3_index" \
  -r "refseq_grp3.kmindex" \
  -t "$THREADS" \
  --from "refseq_grp1.kmindex" >> "$LOG_FILENAME" 2>&1

echo "Part 4/4: Building refseq group 4 index..." | tee -a "$LOG_FILENAME"

/usr/bin/time -v "$KMINDEX_CMD" build \
  -f "/WORKS/vlevallois/data/dataset_refseq/fof_kmindex_grp4.list" \
  -i "$INDEX_DIR/refseq_index" \
  -d "$INDEX_DIR/refseq_grp4_index" \
  -r "refseq_grp4.kmindex" \
  -t "$THREADS" \
  --from "refseq_grp1.kmindex" >> "$LOG_FILENAME" 2>&1

echo "Merging all refseq group indexes into a final index..." | tee -a "$LOG_FILENAME"

/usr/bin/time -v "$KMINDEX_CMD" merge \
  -i "$INDEX_DIR/refseq_index" \
  -n "refseq_merged" \
  -p "$INDEX_DIR/refseq_on_disk" \
  -m "refseq_grp1.kmindex,refseq_grp2.kmindex,refseq_grp3.kmindex,refseq_grp4.kmindex" >> "$LOG_FILENAME" 2>&1


echo "Cleaning temporary files for $dataset..." | tee -a "$LOG_FILENAME"

#rm -rf "$on_disk_dir"/{fpr,filters,howde_index,merge_infos,counts,histograms,partition_infos,superkmers,minimizers}

echo "$dataset completed." | tee -a "$LOG_FILENAME"
echo "----------------------------------------------------" >> "$LOG_FILENAME"

echo "All datasets processed successfully." | tee -a "$LOG_FILENAME"
