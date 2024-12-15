
#to change
log_prefix="/WORKS/vlevallois/expes_kaminari/logs"
log_suffix="query_150k_$(date '+%Y-%m-%d_%H-%M-%S').log" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes"
output_dir="/WORKS/vlevallois/expes_kaminari/answers"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "!!!==!!! start cobs !!!==!!!" >> "$log_prefix/cobs/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/cobs/build/src/cobs query -f "$pos_queries_salmonella" -i "$index_dir"/cobs/salmonella_150k.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/cobs/salmonella_150k_cobs_pos.txt >> "$log_prefix/cobs/$log_suffix" 2>&1

/usr/bin/time -v /WORKS/vlevallois/softs/cobs/build/src/cobs query -f "$neg_queries" -i "$index_dir"/cobs/salmonella_150k.cobs_compact -T 32 --threshold 0.8 > "$output_dir"/cobs/salmonella_150k_cobs_neg.txt >> "$log_prefix/cobs/$log_suffix" 2>&1

#===============================================================================

echo "!!!==!!! start fulgor !!!==!!!" >> "$log_prefix/fulgor/$log_suffix"

/usr/bin/time -v /WORKS/vlevallois/softs/fulgor/build/fulgor pseudoalign \
  -q "$pos_queries_salmonella" \
  -i "$index_dir"/fulgor/salmonella_150k.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/fulgor/salmonella_150k_fulgor_pos.txt >> "$log_prefix/fulgor/$log_suffix" 2>&1

/usr/bin/time -v /WORKS/vlevallois/softs/fulgor/build/fulgor pseudoalign \
  -q "$neg_queries" \
  -i "$index_dir"/fulgor/salmonella_150k.fur \
  -t 32 --threshold 0.8  -o "$output_dir"/fulgor/salmonella_150k_fulgor_neg.txt >> "$log_prefix/fulgor/$log_suffix" 2>&1


#===============================================================================

echo "!!!==!!! start kmndex !!!==!!!" >> "$log_prefix/kmindex/$log_suffix"

/usr/bin/time -v kmindex query -i "$index_dir"/kmindex/salmonella_150k_index -o "$output_dir"/kmindex/salmonella_150k_kmindex_pos  -q "$pos_queries_salmonella" -z 6 -r 0.8 --aggregate -t 32 >> "$log_prefix/kmindex/$log_suffix" 2>&1

rm -rf "$output_dir"/kmindex/salmonella_150k_kmindex_pos/batch*

/usr/bin/time -v kmindex query -i "$index_dir"/kmindex/salmonella_150k_index -o "$output_dir"/kmindex/salmonella_150k_kmindex_neg  -q "$neg_queries" -z 6 -r 0.8 --aggregate -t 32 >> "$log_prefix/kmindex/$log_suffix" 2>&1

rm -rf "$output_dir"/kmindex/salmonella_150k_kmindex_neg/batch*

#===============================================================================

echo "!!!==!!! start raptor !!!==!!!" >> "$log_prefix/raptor/$log_suffix"

/usr/bin/time -v raptor search --index "$index_dir"/raptor/salmonella_150k.raptor --query "$pos_queries_salmonella" --output "$output_dir"/raptor/salmonella_150k_raptor_pos.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_prefix/raptor/$log_suffix" 2>&1

/usr/bin/time -v raptor search --index "$index_dir"/raptor/salmonella_150k.raptor --query "$neg_queries" --output "$output_dir"/raptor/salmonella_150k_raptor_neg.txt --threads 32 --threshold 0.8 --query_length 1000 >> "$log_prefix/raptor/$log_suffix" 2>&1