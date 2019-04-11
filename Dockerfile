FROM ubuntu:16.04
MAINTAINER Upendra Devisetty <upendra@cyverse.org>
LABEL Description "This Dockerfile is used for hisat2 tool with sra option and cufflinks/stringtie with Cuffcompare and Cuffmerge"

RUN mkdir /cvmfs /work

RUN apt-get update && apt-get install -y build-essential \
                                         git \
                                         python2.7 \
                                         wget \
                                         unzip \
                    					 build-essential \
                            			 zlib1g-dev \
                            			 libncurses5-dev \
                            			 software-properties-common \
                    					 lsb \
                    					 apt-transport-https \
                    					 python-requests \
                                         libbz2-dev \
                                         liblzma-dev

# Install icommands.
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands

RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk

ENV BINPATH /usr/bin

# NCBI SRA-TOOL kit
WORKDIR /ncbi
RUN git clone https://github.com/ncbi/ngs.git
RUN git clone https://github.com/ncbi/ncbi-vdb.git
RUN git clone https://github.com/ncbi/sra-tools.git
RUN ngs/ngs-sdk/configure --prefix=~/software/apps/sratoolkit/gcc/64/2.5.8
RUN make default install -C ngs/ngs-sdk
RUN ncbi-vdb/configure --prefix=~/software/apps/sratoolkit/gcc/64/2.5.8
RUN make default install -C ncbi-vdb
RUN sra-tools/configure --prefix=~/software/apps/sratoolkit/gcc/64/2.5.8
RUN make default install -C sra-tools

# Caching the sra data
RUN /root/software/apps/sratoolkit/gcc/64/2.5.8/bin/vdb-config --root -s /repository/user/cache-disabled="true"

# Hisat2
WORKDIR /hisat2
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip 
RUN unzip hisat2-2.1.0-Linux_x86_64.zip && rm hisat2-2.1.0-Linux_x86_64.zip

# Bowtie2
WORKDIR /
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.5/bowtie2-2.3.5-sra-linux-x86_64.zip
RUN unzip bowtie2-2.3.5-sra-linux-x86_64.zip && rm bowtie2-2.3.5-sra-linux-x86_64.zip

# Cufflinks
WORKDIR /
RUN wget -O- http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz | tar xzvf -

# Stringtie
RUN wget -O- http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz | tar xzvf -

# Samtools
RUN apt-get install -y 
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN tar xvf samtools-1.9.tar.bz2
WORKDIR /samtools-1.9
RUN make

# Sambamba
WORKDIR /
RUN wget https://github.com/biod/sambamba/releases/download/v0.6.8/sambamba-0.6.8-linux-static.gz
RUN gzip -d sambamba-0.6.8-linux-static.gz
RUN chmod +x sambamba-0.6.8-linux-static
RUN mv sambamba-0.6.8-linux-static sambamba
RUN mv sambamba $BINPATH

# Picard
WORKDIR /
RUN git clone https://github.com/broadinstitute/picard.git
WORKDIR picard
RUN git checkout 2.18.27
RUN ./gradlew shadowJar

# Fastqc
WORKDIR /
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip
RUN unzip fastqc_v0.11.8.zip && rm fastqc_v0.11.8.zip
RUN chmod 755 FastQC/fastqc

# Subread
WORKDIR /
RUN wget https://sourceforge.net/projects/subread/files/subread-1.6.3/subread-1.6.3-Linux-x86_64.tar.gz
RUN tar xvf subread-1.6.3-Linux-x86_64.tar.gz && rm subread-1.6.3-Linux-x86_64.tar.gz

# Wrapper script
ADD osg-rmta.sh $BINPATH
RUN chmod +x $BINPATH/osg-rmta.sh

# Scripts for OSG
COPY upload-files wrapper /usr/bin/

# Set environment
RUN cp /cufflinks-2.2.1.Linux_x86_64/cuffcompare $BINPATH && \
    cp /stringtie-1.3.4d.Linux_x86_64/stringtie $BINPATH && \
    cp /samtools-1.9/samtools $BINPATH && \
    cp /hisat2/hisat2-2.1.0/hisat2* $BINPATH && \
    cp /bowtie2-2.3.5-sra-linux-x86_64/bowtie2* $BINPATH && \
    ln -s /FastQC/fastqc $BINPATH/fastqc && \
    cp subread-1.6.3-Linux-x86_64/bin/featureCounts $BINPATH

ENTRYPOINT ["osg-rmta.sh"]
