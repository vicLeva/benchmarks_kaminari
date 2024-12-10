
#to change
log_filename="/WORKS/vlevallois/expes_kaminari/logs/metagraph/query_$(date '+%Y-%m-%d_%H-%M-%S').log"
cmd="metagraph" 
index_dir="/WORKS/vlevallois/expes_kaminari/indexes/metagraph"
output_dir="/WORKS/vlevallois/expes_kaminari/answers/metagraph"

#constants
tmp_dir="/WORKS/vlevallois/tmp"
pos_queries_ecoli="/WORKS/vlevallois/data/dataset_genome_ecoli/pos_queries.fasta"
pos_queries_human="/WORKS/vlevallois/data/dataset_genome_human/pos_queries.fasta"
pos_queries_gut="/WORKS/vlevallois/data/dataset_metagenome_gut/pos_queries.fasta"
pos_queries_salmonella="/WORKS/vlevallois/data/dataset_pangenome_salmonella/pos_queries.fasta"

neg_queries="/WORKS/vlevallois/data/neg_queries.fasta"


echo "!!!==!!! start ecoli !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" query -i "$index_dir"/ecoli.dbg -a "$index_dir"/ecoli.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$pos_queries_ecoli" > "$output_dir"/ecoli_metagraph_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -i "$index_dir"/ecoli.dbg -a "$index_dir"/ecoli.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$neg_queries_ecoli" > "$output_dir"/ecoli_metagraph_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start human !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -i "$index_dir"/human.dbg -a "$index_dir"/human.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$pos_queries_human" > "$output_dir"/human_metagraph_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -i "$index_dir"/human.dbg -a "$index_dir"/human.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$neg_queries_human" > "$output_dir"/human_metagraph_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start gut !!!==!!!" >> "$log_filename"

/usr/bin/time -v "$cmd" query -i "$index_dir"/gut.dbg -a "$index_dir"/gut.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$pos_queries_gut" > "$output_dir"/gut_metagraph_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -i "$index_dir"/gut.dbg -a "$index_dir"/gut.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$neg_queries_gut" > "$output_dir"/gut_metagraph_neg.txt >> "$log_filename" 2>&1

#===============================================================================

echo "!!!==!!! start salmonella !!!==!!!" >> "$log_filename"


/usr/bin/time -v "$cmd" query -i "$index_dir"/salmonella.dbg -a "$index_dir"/salmonella.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$pos_queries_salmonella" > "$output_dir"/salmonella_metagraph_pos.txt >> "$log_filename" 2>&1

/usr/bin/time -v "$cmd" query -i "$index_dir"/salmonella.dbg -a "$index_dir"/salmonella.column.annodbg -p 32 --min-kmers-fraction-label 0.8 "$neg_queries_salmonella" > "$output_dir"/salmonella_metagraph_neg.txt >> "$log_filename" 2>&1
