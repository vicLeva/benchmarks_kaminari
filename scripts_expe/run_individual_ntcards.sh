#!/bin/bash

# Path to the fof.list file containing the list of input files
fof_list="/WORKS/vlevallois/data/dataset_refseq/fof.list"

# Directory to store ntCard results
output_dir="/WORKS/vlevallois/data/dataset_refseq/ntcard_results"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"


# Get the 500 largest files in the list based on file size (in bytes)
largest_files=$(while IFS= read -r file; do
    if [ -f "$file" ]; then
        echo "$(stat -c%s "$file") $file"
    fi
done < "$fof_list" | sort -nr | head -n 500 | awk '{print $2}')

# Loop through each of the 500 largest files and process them with ntCard
for input_file in $largest_files; do
    # Extract the filename without path and extension for use as prefix
    filename=$(basename "$input_file")
    prefix="${filename%.*}"  # Remove extension for the prefix

    # Run ntCard with the input file and specific output prefix
    /home/genouest/genscale/vlevallois/ntCard/ntcard -t 4 -k 25 -p "${output_dir}/${prefix}" "$input_file"
    
    echo "ntCard finished processing: $input_file"
done

echo "Processed the 500 largest files and saved results in $output_dir"
echo "see end of run_individual_ntcards.sh for the command to get the file with the highest #distinct_kmers"


# awk '$1 == "F0" {print FILENAME, $2}' * | sort -k2,2nr | head -n1
# in the ntcard_results directory to get the file with the highest #distinct_kmers
