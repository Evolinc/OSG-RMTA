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
					 python-requests

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

# Hisat2
WORKDIR /hisat2
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip 
RUN unzip hisat2-2.1.0-Linux_x86_64.zip

# Cufflinks
WORKDIR /
RUN wget -O- http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz | tar xzvf -

# Stringtie
RUN wget -O- http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.4d.Linux_x86_64.tar.gz | tar xzvf -

# Samtools
RUN apt-get install -y libbz2-dev liblzma-dev
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN tar xvf samtools-1.9.tar.bz2
WORKDIR /samtools-1.9
RUN make

# Sambamba
WORKDIR /
RUN wget https://github.com/biod/sambamba/releases/download/v0.6.8/sambamba-0.6.8-linux-static.gz
RUN gzip -d sambamba-0.6.8-linux-static.gz
RUN chmod +x sambamba-0.6.8-linux-static
RUN mv sambamba-0.6.8-linux-static /usr/bin

# Wrapper script
ADD Hisat2-Cuffcompare-Cuffmerge.sh $BINPATH
RUN chmod +x $BINPATH/Hisat2-Cuffcompare-Cuffmerge.sh

# Scripts for OSG
COPY upload-files wrapper /usr/bin/

# Set environment
ENV PATH /cufflinks-2.2.1.Linux_x86_64/:$PATH
ENV PATH /stringtie-1.3.4d.Linux_x86_64/:$PATH
ENV PATH /samtools-1.9/:$PATH
ENV PATH /hisat2/hisat2-2.1.0/:$PATH

ENTRYPOINT ["Hisat2-Cuffcompare-Cuffmerge.sh"]
