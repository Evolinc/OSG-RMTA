FROM ubuntu:16.04
MAINTAINER Upendra Devisetty <upendra@cyverse.org>
LABEL Description "This Dockerfile is used for hisat2 tool with sra option and cufflinks/stringtie with Cuffcompare and Cuffmerge"

RUN mkdir /cvmfs /work

RUN apt-get update && apt-get install -y build-essential \
                                         git \
                                         python3 \
                                         wget \
                                         unzip \
					                     build-essential \
        				                 zlib1g-dev \
        				                 libncurses5-dev \
        				                 software-properties-common \
					                     lsb \
					                     apt-transport-https \
					                     python-requests

# Install icommands.
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands

RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk

# Install miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda config --add channels conda-forge 
RUN conda config --add channels defaults 
RUN conda config --add channels r 
RUN conda config --add channels bioconda

# Install Conda packages
RUN conda install sra-tools==2.9.1_1
RUN conda install parallel-fastq-dump==0.6.3
RUN conda install hisat2==2.1.0
RUN conda install stringtie==1.3.4
RUN conda install samtools==1.9
RUN conda install sambamba==0.6.8
RUN conda install picard==2.18.27
RUN conda install fastqc==0.11.8
RUN conda install cufflinks==2.2.1
RUN conda install subread==1.6.3

# Bowtie2
WORKDIR /
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.5/bowtie2-2.3.5-sra-linux-x86_64.zip
RUN unzip bowtie2-2.3.5-sra-linux-x86_64.zip

# Caching the sra data
RUN vdb-config --root -s /repository/user/cache-disabled="true"

# Environment
ENV BINPATH /usr/bin
ENV LC_ALL C 

# Set environment
RUN cp /bowtie2-2.3.5-sra-linux-x86_64/bowtie2* $BINPATH && \
    cp /opt/conda/bin/stringtie $BINPATH && \
    cp /opt/conda/bin/cuffcompare $BINPATH && \
    cp /opt/conda/bin/featureCounts $BINPATH && \
    cp /opt/conda/bin/sambamba $BINPATH && \
    cp /opt/conda/bin/picard $BINPATH && \
    cp /opt/conda/bin/fastqc $BINPATH && \
    cp /opt/conda/bin/hisat2* $BINPATH && \
    cp /opt/conda/bin/samtools $BINPATH && \
    cp /opt/conda/bin/sra* $BINPATH

# Scripts for OSG
COPY upload-files wrapper /usr/bin/

# Wrapper script
ADD osg-rmta.sh $BINPATH
RUN chmod +x $BINPATH/osg-rmta.sh

ENTRYPOINT ["osg-rmta.sh"]
