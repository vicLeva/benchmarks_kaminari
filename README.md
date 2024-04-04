# benchmarks_kaminari
Benchmarks of Kaminari competitors

## Salmonella Enterica - Pangenome

+ 4546 .fasta files
+ 21GB uncompressed .fasta files (total)
+ according to cobs `doc-list` tool :
  - minimum 31-mers: 4,329,157
  - maximum 31-mers: 5,577,093
  - average 31-mers: 4,862,991
  - total 31-mers: 22,107,159,189 
+ for RAMBO
  - need of counted kmers as input
  - use of KMC
  - kmer counted files : 700GB


## Building indexes

|          Tool |              Time Build | Peak mem  usage (GB) | Index size (disk)(GB) |
|--------------:|------------------------:|---------------------:|----------------------:|
|          COBS |                  22m52s |                 7.72 |                   7.4 |
|           PAC |                  31m17s |                 1.03 |                  16.0 |
|       kmindex | 157m41s or  72m53s(ssd) |                 5.11 |                   81? |
|        Raptor |                  30m41s |                29.48 |                  28.0 |
|         RAMBO |                    ~32h |                   NA |                    NA |
|   fulgor (PC) |                  15m17s |                 6.56 |                 0.253 |
| kaminari (PC) |                  29m53s |                13.08 |                 0.394 |

## Kaminari / fulgor space breakdown

#### Kaminari

```
Step 1: reading files
        total k-mers: 22,105,111,708
        total m-mers: 22,109,928,350
        total minimizers (with repetitions): 3,158,639,752
Step 2: aggregating colors
Step 3: building the MPHF for 8,261,979 minimizers
Step 4: list deduplication and mapping
```

+ m_num_total_integers 1,199,741,856
+ total bits for ints = 2,994,706,286 (=347MB)
+ total bits per offsets = 15528576 (=1.94MB)
+ total bits = 3010234862 (=376MB)        
+ offsets: 0.0129433 bits/int
+ lists: 2.49613 bits/int
+ Number of colors (lists of ids): 1,094,308
+ The list of input filenames weights: 439756 Bytes (=0.43MB) (0.1%)
+ The MPHF of minimizers weights: 2366936 Bytes (=2.36MB) (0.5%)
+ Colors weight: 376279388 Bytes (=376.27MB) (91.3%)
+ The mapping from minimizers to colors weights: 33047924 Bytes (=33.04MB) (8.1%)

+ Written 412134023 Bytes (=412.13MB)

#### Fulgor

+ num_unitigs 1,884,865
+ num_distinct_colors 972,178

+ m_num_total_integers 2,139,057,102
+ total bits for ints = 1586995456 (=198MB)
+ total bits per offsets = 12791696 (=1.6MB)
+ total bits = 1599787152 (=200MB)
+ offsets: 0.00598006 bits/int
+ lists: 0.741914 bits/int

```
SPACE BREAKDOWN:
  minimizers: 0.431941 [bits/kmer]
  pieces: 0.394388 [bits/kmer]
  num_super_kmers_before_bucket: 0.302511 [bits/kmer]
  offsets: 5.8751 [bits/kmer]
  strings: 4.58267 [bits/kmer]
  skew_index: 0.0289185 [bits/kmer]
  weights: 3.36159e-05 [bits/kmer]
    weight_interval_values: 5.84625e-06 [bits/kmer]
    weight_interval_lengths: 2.19234e-05 [bits/kmer]
    weight_dictionary: 5.84625e-06 [bits/kmer]
```
```
SPACE BREAKDOWN:
  K2U: 63578912 bytes / 0.0635789 GB (24.0502%)
  CCs: 199973414 bytes / 0.199973 GB (75.6445%)
  Other: 807072 bytes / 0.000807072 GB (0.305293%)
    U2C: 294568 bytes / 0.000294568 GB (0.111427%)
    filenames: 512504 bytes / 0.000512504 GB (0.193866%)
Color id range 0..4545
Number of distinct color classes: 972178
Number of ints in distinct color classes: 2139057102 (0.747894 bits/int)
k: 31
m: 19 (minimizer length used in K2U)
Number of kmers in dBG: 43788757 (11.6156 bits/kmer)
Number of unitigs in dBG: 1884865
```

+ colors: 0.741914 bits/int
+ offsets: 0.00598011 bits/int


