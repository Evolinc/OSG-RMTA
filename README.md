# OSG-RMTA: Read Mapping and Transcript Assembly workflow using Open Science Grid and CyVerse

## Introduction

RMTA is a wrapper script built on top of several bioinformatics tools that can rapidly process raw RNA-seq illumina data by mapping reads using HiSat2 and then assemble transcripts using either Cufflinks or StringTie. RMTA can process FASTQ files containing paired-end or single-end reads and can directly process one or more sequence read archives (SRA) from NCBI using a SRA ID. RMTA has been successfully used by many groups as a first step towards identification of long-non coding RNA workflow. More information about RMTA can be found [here](https://github.com/Evolinc/RMTA) 

The [OSG](http://www.opensciencegrid.org/) is a consortium of research communities which facilitates distributed high throughput computing for scientific research. The Open Science Grid (OSG) enables distributed computing on more than 120 institutions, supports efficient data processing and provides large scale scientific computing of 2 million core CPU hours per day. More about OSG can be found [here](https://docs.google.com/presentation/d/1QGNxBXFcFJ4SkP3nhywtpYRx8kC0C6j5NTP_ZuVx4Qw/edit?usp=sharing)

## How OSG and DE help RMTA?

RMTA is currently available as Docker image and also as a CyVerse Discovery Environment (DE) app. Many users find RMTA DE app to be quite useful because DE provides, GUI for the RMTA tool, Data store for storing the data and finally computation for running the analysis. However, processing thousands of RNA-Seq datasets in DE is challenging because DE can run 8 concurrent jobs at a time. Eventhough RMTA solved the challenge with functional data processing workflow, the computation challenge still remains for high-throughput analyses. In order to address this, we have developed `OSG-RMTA` which is a highly scalable RMTA for processing high-throughput RNA-Seq datasets using computational resources available to U.S-based researchers on the OSG. The user may run OSG-RMTA workflow directly on the OSG by submitting the jobs to the HTCondor or run it on CyVerse Discovery Environment as OSG-RMTA app which is recommended because the jobs submitted to OSG through DE can be decomposed into multiple tasks that can be carried out parallely. Ideally, these tasks will transfer the input data from Discovery Environment into OSG, run some computation on it and then finally return results directly in CyVerse's datastore. 

## Minimum requirements for running RMTA

RMTA minimally requires the following input data:

1. Reference Genome (FASTA) or Hisat2 Indexed Reference Genome (in a subdirectory)
2. Reference Transcriptome (GFF3/GTF/GFF)
3. RNA-Seq reads (FASTQ) - Single end or Paired end or NCBI SRA id or multiple NCBI SRA id's (list in a single column text file)

# Availability 

## RMTA on CyVerse's DE

The OSG-RMTA-v2.1 app is currently integrated in CyVerse’s Discovery Environment (DE) and is free to use by researchers. Register for a free account at [CyVerse](https://user.cyverse.org) The complete tutorial is available at this [CyVerse wiki](https://wiki.cyverse.org/wiki/display/DEapps/OSG-RMTA+v2.1). CyVerse's DE is a free and easy to use GUI that simplifies many aspects of running bioinformatics analyses. If you do not currently have access to a high performance computing cluster, consider taking advantange of the DE. You can submit thousands of jobs using OSG-RMTA v2.1 app and they will run on OSG instead on DE.

## RMTA on OSG

The OSG-RMTA-v2.1 Docker image app is currently available in OSG and is free to use by researchers. In order to run OSG-RMTA on OSG, you first need to have account with OSG. Register for a free account at [osg-connect](http://osgconnect.net/). After you register, you need to add your keys because OSG no longer allow password access. You can find more information [here](https://support.opensciencegrid.org/support/solutions/articles/12000027675-generate-ssh-key-pair-and-add-the-public-key-to-your-account). 
The complete tutorial for running RMTA on OSG is available in [here](https://hackmd.io/s/rJjrqyAAQ). 

# Issues
If you experience any issues with running OSG-RMTA (DE app or source code or Docker image), please open an issue on this github repo. Alternatively you can post your queries and feature requests in this [google groups](https://groups.google.com/forum/#!forum/evolinc)

# Copyright free
The sources in this [Github](https://github.com/Evolinc/OSG-RMTA.git) repository, are copyright free. Thus you are allowed to use these sources in which ever way you like. Here is the full [MIT](https://choosealicense.com/licenses/mit/#) license.
