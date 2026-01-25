Quicklinks :  
[Perfs expe](https://github.com/vicLeva/benchmarks_kaminari/wiki/Performances-benchmark)  
[FPR & RBO](https://github.com/vicLeva/benchmarks_kaminari/wiki/RBO-&-FPR-benchmark)  

# Kaminari paper benchmark

This repository contains everything you need to conduct the experiments we presented in Kaminari's paper [LINK PAPER]

## Competitors

### Install the tools 

All the tools have been installed following the documentations

+ **Kaminari** : https://github.com/yhhshb/kaminari?tab=readme-ov-file#compiling-the-code
+ **Fulgor** : https://github.com/jermp/fulgor/tree/main?tab=readme-ov-file#compiling-the-code
+ **Cobs** : https://github.com/bingmann/cobs?tab=readme-ov-file#installation
+ **Kmindex** : https://tlemane.github.io/kmindex/installation/
+ **Metagraph** : https://github.com/ratschlab/metagraph?tab=readme-ov-file#install
+ **Raptor** : https://github.com/seqan/raptor?tab=readme-ov-file#download-and-installation

### Run the tools

The following directory  
[scripts_expe/](https://github.com/vicLeva/benchmarks_kaminari/scripts_expe)   
contains the scripts used to build the indexes and query them. For a tool `X`, refer to script `scripts_expe/build_X` or `scripts_expe/query_X`.

For **Metagraph**, we used this pipeline [https://github.com/theJasonFan/metagraph-workflows/tree/main](https://github.com/theJasonFan/metagraph-workflows/tree/main) 


## Data

+ **Ecoli** : https://zenodo.org/records/6577997 
    
+ **Human** : https://github.com/human-pangenomics/HPP_Year1_Assemblies?tab=readme-ov-file 
    - 60 first files

+ **Salmonella** : http://ftp.ebi.ac.uk/pub/databases/ENA2018-bacteria-661k/
    - 10.000 first files

+ **Gut** : https://arken.nmbu.no/~larssn/humgut/
    - 10.000 first files

+ **Tara/SeaWater** : https://github.com/vicLeva/benchmarks_kaminari/wiki/Tara-dataset

+ **Refseq** : https://zenodo.org/records/7742011


Advanced statistics for these datasets are available [HERE](https://github.com/vicLeva/benchmarks_kaminari/wiki/Datasets-advanced-statistics) 


## Indexes construction and query - benchmark

A summary of all the performance results is available [HERE](https://github.com/vicLeva/benchmarks_kaminari/wiki/Performances-benchmark) 


## Indexes false positives study


For the approximate indexes - **Kaminari**, **COBS**, **Kmindex** and **Raptor** - we processed the False positive rate of the queries (FPR) and the similarity between the answers and the ground truth (RBO).  
Results are presented [HERE](https://github.com/vicLeva/benchmarks_kaminari/wiki/RBO-&-FPR-benchmark)  
RBO values were computed using the `rbo` tool of **Kaminari** (see Kaminari's documentation for more details). We compared the results of each tool with the result of **Fulgor** as it is an exact index. Note that **Fulgor** does not natively compute a ranked result so we had to modify it.
