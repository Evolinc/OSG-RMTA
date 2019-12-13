#!/bin/bash

# Genome

# PE (reads)

osg-rmta.sh -g genome_chr1.fa -A annotation_chr1.gtf -l "US" -n 0 -y "PE" -1 SRR2037320_R1.fastq.gz -1 SRR2932454_R1.fastq.gz -2 SRR2037320_R2.fastq.gz -2 SRR2932454_R2.fastq.gz -O final_out -p 6 -5 0 -3 0 -m 20 -M 50000 -t -e -u "exon" -a "gene_id" -n 0 -f 1 -k 1

#osg-rmta.sh -g genome_chr1.fa -A annotation_chr1.gtf -l "US" -1 SRR2037320_R1.fastq.gz -1 SRR2932454_R1.fastq.gz -2 SRR2037320_R2.fastq.gz -2 SRR2932454_R2.fastq.gz -O RMTA_out -p 6 -5 0 -3 0 -m 20 -M 5000 -f 0 -k 0 -t -y "PE" -e -u "exon" -a "gene_id" -n 0

# SE (reads)

#osg-rmta.sh -g genome_chr1.fa -l "US" -U SRR3464102.fastq.gz -U SRR3464103.fastq.gz -O RMTA_out -p 6 -5 0 -3 0 -m 20 -M 5000 -f 0 -k 0 -t -y "SE" -e

#osg-rmta.sh -g genome_chr1.fa -A annotation_chr1.gtf -l "US" -U SRR3464102.fastq.gz -U SRR3464103.fastq.gz -O RMTA_out -p 6 -5 0 -3 0 -m 20 -M 5000 -f 0 -k 0 -t -y "SE" -e -u "exon" -a "gene_id" -n 0

# PE (SRA)


# SE (SRA)


# Transcriptome

# PE (reads)


# SE (reads)


# PE (SRA)


# SE (SRA)
