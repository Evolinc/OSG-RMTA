# OSG-RMTA: Read Mapping and Transcript Assembly workflow using the Open Science Grid and CyVerse

## Introduction

RMTA is a wrapper script built on top of several publicly available bioinformatic tools that can rapidly proceeds from raw short read data to assembled transcripts. RMTA performs this by mapping reads using HiSat2 and then assembling transcripts using either Cufflinks or StringTie according to user preference. RMTA can process FASTQ files containing paired-end or single-end reads or can directly process one or more sequence read archives (SRA) from NCBI using SRA IDs. RMTA has been successfully used by many groups as a first step towards identification of long-non coding RNAs using the Evolinc workflow. More information about RMTA can be found [here](https://github.com/Evolinc/RMTA) 

The [OSG](http://www.opensciencegrid.org/) is a consortium of research communities which facilitates distributed high throughput computing for scientific research. The Open Science Grid (OSG) enables distributed computing at more than 120 institutions, supports efficient data processing and provides large scale scientific computing of more than 2 million CPU hours per day. More about OSG can be found [here](https://docs.google.com/presentation/d/1QGNxBXFcFJ4SkP3nhywtpYRx8kC0C6j5NTP_ZuVx4Qw/edit?usp=sharing)

## How do the OSG and DE help RMTA?

RMTA is currently available as a Docker image and also as an app in CyVerse's Discovery Environment (DE). Many users find using RMTA in the DE to be quite useful because the DE provides a GUI (graphical user interface) for the RMTA tool and is coupled with CyVerse's Data store for storing the data. In addition, running jobs within the DE removes the computational requirements for running the analysis from the user. However, processing thousands of RNA-seq datasets in the DE is limited to the concurrent job restrictions in place (there is a limit of 8 concurrent jobs). 

Thus, for processing large data sets in a timely manner, the OSG serves as the perfect alternative to the DE. However, jobs submitted to the OSG typically require command-line experience. In order to allow users with minimal command-line experience to address their large RNA-seq data set questions, we have developed `OSG-RMTA` which is a highly scalable RMTA for processing high-throughput RNA-Seq datasets using computational resources available to U.S-based researchers on the OSG. Users familiar with command line can run the OSG-RMTA workflow directly on the OSG by submitting the jobs to the HTCondor or run it in CyVerse Discovery Environment as the OSG-RMTA app. Running jobs through CyVerse's DE is recommended because these jobs are decomposed into multiple tasks that can be carried out in parallel. In sum, input data transfers from the DE to the OSG, compute tasks (read mapping and transcript assembly) are performed on the OSG, and then results are returned to CyVerse's Datastore.  

## Minimum requirements for running RMTA

RMTA minimally requires the following input data:

1. Reference Genome (FASTA) or Hisat2 Indexed Reference Genome (in a subdirectory)
2. Reference Transcriptome (GFF3/GTF/GFF)
3. RNA-Seq reads (FASTQ) - Single end or Paired end or NCBI SRA id or multiple NCBI SRA id's (list in a single column text file)

# Availability 

## RMTA in CyVerse's DE

The OSG-RMTA-v2.1 app is currently integrated in CyVerse’s Discovery Environment (DE) and is free to use by researchers. Register for a free account at [CyVerse](https://user.cyverse.org). The complete tutorial is available at this location [CyVerse wiki](https://wiki.cyverse.org/wiki/display/DEapps/OSG-RMTA+v2.1). CyVerse's DE is a free and easy to use GUI that simplifies many aspects of running bioinformatics analyses. If you do not currently have access to a high performance computing cluster, consider taking advantange of the DE. You can submit thousands of jobs using the OSG-RMTA v2.1 app and they will run on OSG instead of on the DE.

## RMTA on OSG

The OSG-RMTA-v2.1 Docker image app is currently available on the OSG and is free to use by researchers. In order to run OSG-RMTA on OSG, you first need to have an account with OSG. Register for a free account at [osg-connect](http://osgconnect.net/). After you register, you need to add your keys because OSG no longer allows password access. You can find more information [here](https://support.opensciencegrid.org/support/solutions/articles/12000027675-generate-ssh-key-pair-and-add-the-public-key-to-your-account). 

The complete tutorial for running RMTA on the OSG is available in [here](https://hackmd.io/s/rJjrqyAAQ). 

# Issues
If you experience any issues with running OSG-RMTA (DE app, source code, or Docker image), please open an issue on this github repo. Alternatively you can post your queries and feature requests in this [google groups](https://groups.google.com/forum/#!forum/evolinc)

# Copyright free
The sources in this [Github](https://github.com/Evolinc/OSG-RMTA.git) repository, are copyright free. Thus you are allowed to use these sources in which ever way you like. Here is the full [MIT](https://choosealicense.com/licenses/mit/#) license.
