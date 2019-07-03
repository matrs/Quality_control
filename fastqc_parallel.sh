#! /usr/bin/env bash

#This script is used because in my cluster, fastqc fails with errors related to temp
#files. Also, when it didn't fail, it created faulty zip files making multiqc complain 
#or not recognize them. This failed either using the official wrapper or using snakemake 
#"shell" directive.

set -euxo pipefail

mkdir -p qc/fastqc

#Set the number of cores with -j, here two files at once are the input so -j10
#will call fastqc with 20 files and cores in total. For single-end units.tsv, use
#one column.
parallel -j $1 --skip-first-line --colsep '\t' "fastqc -t 2 --quiet \
-o qc/fastqc {3} {4}" :::: units.tsv 

