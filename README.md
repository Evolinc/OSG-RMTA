# OSG-RMTA: Read Mapping and Transcript Assembly workflow On OSG (Open Science Grid) and CyVerse DE (Discovery Environment)

## Introduction

RMTA is a wrapper script built on top of tools such as Hisat2, Cufflinks, StringTie, Cuffcompare, Cuffmerge that can rapidly process raw RNA-seq illumina data by mapping reads using HiSat2 and then assemble transcripts using either Cufflinks or StringtTie. RMTA can process FASTQ files containing paired-end or single-end reads and can directly process one or more sequence read archives (SRA) from NCBI using a SRA ID. RMTA has been successfully used by many groups as a first step towards identification of long-non coding RNA workflow. More information about RMTA can be found [here](https://github.com/Evolinc/RMTA) 

The [OSG](http://www.opensciencegrid.org/) is a consortium of research communities which facilitates distributed high throughput computing for scientific research. The Open Science Grid (OSG) enables distributed computing on more than 120 institutions, supports efficient data processing and provides large scale scientific computing of 2 million core CPU hours per day. More about OSG can be found [here](https://docs.google.com/presentation/d/1QGNxBXFcFJ4SkP3nhywtpYRx8kC0C6j5NTP_ZuVx4Qw/edit?usp=sharing)

### Why OSG for RMTA?

RMTA is currently available as Docker image and also as a CyVerse Discovery Environment app. Many users find RMTA app to be quite useful because DE provides data store along with the computation. However, processing thousands of RNA-Seq datasets in DE is challenging because DE can run 8 concurrent jobs at a time. Eventhough RMTA solved the challenge with functional data processing workflow, the computation challenge still remains. In order to address this, we have developed OSG-RMTA which is a highly scalable RMTA for processing high-throughput RNA-Seq datasets using computational resources available to U.S-based researchers on the OSG. The user may run OSG-RMTA workflow directly on the OSG or run it on CyVerse Discovery Environment as OSG-RMTA app which is recommended because the jobs submitted through DE on OSG can be decomposed into multiple tasks that can be carried out independently. Ideally, these tasks will transfer the input data from Discovery Environment into OSG, run some computation on it and then finally return results directly in CyVerse's datastore. 

RMTA minimally requires the following input data:

1. Reference Genome (FASTA) or Hisat2 Indexed Reference Genome (in a subdirectory)
2. Reference Transcriptome (GFF3/GTF/GFF)
3. RNA-Seq reads (FASTQ) - Single end or Paired end or NCBI SRA id or multiple NCBI SRA id's (list in a single column text file).

# Availability 

## Submitting jobs to the OSG

In order to run OSG-RMTA on OSG, you first need to have account with OSG. Register for an account at [osg-connect](http://osgconnect.net/)

###  Login to Submit Host

After you register, you need to add your keys because OSG no longer allow password access. You can find more information [here](https://support.opensciencegrid.org/support/solutions/articles/12000027675-generate-ssh-key-pair-and-add-the-public-key-to-your-account) 

```
$ ssh <username>@login.osgconnect.net # username is your username
```

### Run OSG-RMTA on the sample data

The sample data can be found in the sample_data folder in this (https://github.com/Evolinc/OSG-RMTA/tree/master/sample_data_osg) 

```
git clone https://github.com/Evolinc/OSG-RMTA.git
cd OSG-RMTA/sample_data_osg
```

In the `sample_data_osg` folder you will find input files and some script for job submission to OSG

### Job description file

Here is an example of Job description file for running RMTA

```
# The UNIVERSE defines an execution environment. You will almost always use VANILLA.
Universe = vanilla

# These are good base requirements for your jobs on OSG. It is specific on OS and
# OS version, core cound and memory, and wants to use the software modules. 
Requirements = HAS_SINGULARITY == True
request_cpus = 1
request_memory = 2 GB
request_disk = 4 GB

# Singularity settings
+SingularityImage = "/cvmfs/singularity.opensciencegrid.org/evolinc/osg-rmta:2.1"

# EXECUTABLE is the program your job will run It's often useful
# to create a shell script to "wrap" your actual work.
Executable = osg-rmta-wrapper.sh
Arguments =

# inputs/outputs
transfer_input_files = osg-rmta.sh, Sorghum_bicolor.Sorbi1.20.dna.toplevel_chr8.fa, Sorghum_bicolor.Sorbi1.20_chr8.gtf, sample_1_R1.fq.gz, sample_1_R2.fq.gz
transfer_output_files = final_out, index

# ERROR and OUTPUT are the error and output channels from your job
# that HTCondor returns from the remote host.
Error = $(Cluster).$(Process).error
Output = $(Cluster).$(Process).output

# The LOG file is where HTCondor places information about your
# job's status, success, and resource consumption.
Log = $(Cluster).$(Process).log

# Send the job to Held state on failure. 
on_exit_hold = (ExitBySignal == True) || (ExitCode != 0)

# Periodically retry the jobs every 1 hour, up to a maximum of 5 retries.
periodic_release =  (NumJobStarts < 5) && ((CurrentTime - EnteredCurrentStatus) > 60*60)

# QUEUE is the "start button" - it launches any jobs that have been
# specified thus far.
Queue 1
```

### Executable script

Here is an example of executable script

```
#!/bin/bash

Hisat2-Cuffcompare-Cuffmerge.sh -g Sorghum_bicolor.Sorbi1.20.dna.toplevel_chr8.fa -A Sorghum_bicolor.Sorbi1.20_chr8.gtf -l "FR" -1 sample_1_R1.fq.gz -2 sample_1_R2.fq.gz -O final_out -p 6 -5 0 -3 0 -m 20 -M 50000 -q -t -f 2 -k 2

```

### Wrapper script

Here is the wrapper script

```
#!/bin/bash

bash osg-rmta.sh > osg-rmta.out
```

### Job submission

Submit the job using `condor_submit`.

```
$ condor_submit osg-rmta.submit

```

### Job status

Your first job is on the grid! The `condor_q` command tells the status of currently running jobs. Generally you will want to limit it to your own jobs by adding your own username to the command.

```
condor_q <username>
```

### Job output

Once your job has finished, you can look at the files that HTCondor has returned to the working directory. If everything was successful, it should have returned:

- `final_out` which contains bam, gtf and other files

- `index` which contains the indices of the reference genome

### Using CyVerse Discovery Environment

The OSG-RMTA v2.1 app (Search for "OSG-RMTA" in the search bar in the App window) is currently integrated in CyVerse’s Discovery Environment (DE) and is free to use by researchers. The complete tutorial is available at this [CyVerse wiki](https://wiki.cyverse.org/wiki/display/TUT/RMTA+v1.5). CyVerse's DE is a free and easy to use GUI that simplifies many aspects of running bioinformatics analyses. If you do not currently have access to a high performance computing cluster, consider taking advantange of the DE.

# Issues
If you experience any issues with running OSG-RMTA (DE app or source code or Docker image), please open an issue on this github repo. Alternatively you can post your queries and feature requests in this [google groups](https://groups.google.com/forum/#!forum/evolinc)

# Copyright free
The sources in this [Github](https://github.com/Evolinc/OSG-RMTA.git) repository, are copyright free. Thus you are allowed to use these sources in which ever way you like. Here is the full [MIT](https://choosealicense.com/licenses/mit/#) license.
