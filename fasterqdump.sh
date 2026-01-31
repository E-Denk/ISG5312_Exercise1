#!/bin/bash
#SBATCH --job-name=fasterq_dump_xanadu
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=denker@uchc.edu


hostname
date

#################################################################
# Download fastq files from SRA
#################################################################

# load software
module load parallel/20180122
module load sratoolkit/3.0.1

# The data are from this study:
    # https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA1126646

OUTDIR=../../data/fastq
    mkdir -p ${OUTDIR}


# 12 samples
ACCLIST=../../metadata/accessionlist.txt


# parallel issue saying not enough space >:(

# Set a custom temp directory
export TMPDIR=${OUTDIR}/tmp
mkdir -p ${TMPDIR}

# use parallel to download 2 accessions at a time
cat $ACCLIST | parallel -j 2 --tmpdir ${TMPDIR} "fasterq-dump -O ${OUTDIR} $

# compress the files
parallel -j 4 --tmpdir ${TMPDIR} gzip ::: ${OUTDIR}/*.fastq

# Clean up temp directory
rm -rf ${TMPDIR}

date
