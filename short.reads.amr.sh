#!/bin/bash
#SBATCH --account=sjbay
#SBATCH --nodes=1
#SBATCH --partition=ord
#SBATCH --time=0-10:00:00 #days-hours:min:sec
#SBATCH --output=/work/NRSAAMR/slurm/ARGs.%j
#SBATCH --ntasks-per-node=16

source activate AMR

sample="BANANA"
base=$(echo ${sample} | sed "s/_R1.fastq.gz//")
home="/work/NRSAAMR/Projects/FDA-Enrichments"
fastqs="/work/NRSAAMR/Projects/FDA-Enrichments/fastqs"
krdb="/work/NRSAAMR/Software_Databases/Kraken16"
megares="/work/NRSAAMR/Projects/BanklickCreek/databases/megaresv3_db.dmnd"
card="/work/NRSAAMR/Software_Databases/databases/CARD_3.2.7.dmnd"

###########################
if test -f "$fastqs"/merged/${base}_merged.fastq.gz; then
	echo "skipping fastp, already exists"
	continue
	else
fastp -i "$fastqs"/${base}_R1.fastq.gz -I "$fastqs"/${base}_R2.fastq.gz --merge --include_unmerged --merged_out "$fastqs"/merged/${base}_merged.fastq.gz \
	--html /dev/null/ --json /dev/null/
	fi
###########################
if test -f "$home"/diamond/${base}.card; then
	echo "skipping diamond, already exists"
        continue
        else
diamond blastx -d "$card" -q "$fastqs"/merged/${base}_merged.fastq.gz -o "$home"/diamond/${base}.card -p 16 --max-target-seqs 1 --evalue 1e-10 --id 80
fi
###########################
if test -f "$home"/KrakenReports/${base}.kreport; then
        continue
        else
kraken2 --db "$krdb" --threads 16 --report "$home"/KrakenReports/${base}.kreport --paired "$fastqs"/${base}_R1.fastq.gz "$fastqs"/${base}_R2.fastq.gz
fi
###########################
if test -f "$home"/nonpareil/$base.nonpareil.npo; then
        continue
        else
gunzip -k "$fastqs"/$sample
nonpareil -s "$fastqs"/${base}_R1.fastq -T kmer -f fastq -b "$home"/nonpareil/$base.nonpareil
rm "$fastqs"/${base}_R1.fastq
fi
