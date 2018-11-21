#!/bin/bash

#Hisat2-Cuffcompare-Cuffmerge.sh -g Sorghum_bicolor.Sorbi1.20.dna.toplevel_chr8.fa -A Sorghum_bicolor.Sorbi1.20_chr8.gtf -l "FR" -1 sample_1_R1.fq.gz -2 sample_1_R2.fq.gz -O final_out -p 6 -5 0 -3 0 -m 20 -M 50000 -q -t -f 2 -k 2

Hisat2-Cuffcompare-Cuffmerge.sh -g Sorghum_bicolor.Sorbi1.20.dna.toplevel_chr8.fa -A Sorghum_bicolor.Sorbi1.20_chr8.gtf -l "FR" -s sra_id.txt -O final_out -p 6 -5 0 -3 0 -m 20 -M 50000 -q -t -f 2 -k 2
