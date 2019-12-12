# RMTA on OSG

Here are the instructions for running RMTA on OSG (Open Science Grid)

##  Login to Submit host

```
ssh <username>@login.osgconnect.net # username is your username
```

## Run OSG-RMTA on the sample data

The sample data can be found in the sample_data folder in [here](https://github.com/Evolinc/OSG-RMTA/tree/master/sample_data_arabi) 

```
git clone https://github.com/Evolinc/OSG-RMTA.git
cd OSG-RMTA/sample_data_osg
```

In the `sample_data_arabi` folder you will find the files and the scripts that are required for job submission to OSG

### Job description file

Here is an example of Job description file (`osg-rmta.submit`) for running RMTA

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
+SingularityImage = "/cvmfs/singularity.opensciencegrid.org/evolinc/osg-rmta:2.6.3"

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

### Executable wrapper script

Here is an example of executable script (`osg-rmta-wrapper.sh`)

```
#!/bin/bash

osg-rmta.sh -g genome_chr1.fa -A annotation_chr1.gtf -l "US" -n 0 -y "PE" -1 SRR2037320_R1.fastq.gz -1 SRR2932454_R1.fastq.gz -2 SRR2037320_R2.fastq.gz -2 SRR2932454_R2.fastq.gz -O final_out -p 6 -5 0 -3 0 -m 20 -M 50000 -t -e -u "exon" -a "gene_id" -n 0 -f 1 -k 1

```

### Job submission

Submit the job using `condor_submit`.

```
condor_submit osg-rmta.submit

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
