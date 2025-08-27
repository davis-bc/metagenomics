#!/bin/bash
#SBATCH --account=nrsaamr
#SBATCH --array=1-246%8
#SBATCH --partition=ord
#SBATCH --time=1-00:00:00
#SBATCH --ntasks-per-node=32
#SBATCH --job-name="rarefaction"
#SBATCH --output="/work/NRSAAMR/Projects/EFLMR-Pilot/slurm/rarefaction_%A_%a"

### Set environmental variables
home="/work/NRSAAMR/Projects/FDA-Enrichments"
fastqs="/work/NRSAAMR/Projects/FDA-Enrichments/fastqs"
contigs="/work/NRSAAMR/Projects/FDA-Enrichments/Contigs"
deepdb="/work/NRSAAMR/Software_Databases/Deepurify-DB"
mags="/work/NRSAAMR/Projects/FDA-Enrichments/deepurify/good_mags_drep"
#mags="/work/NRSAAMR/Projects/EFLMR-Pilot/deepurify_filtered_out/skder/Dereplicated_Representative_Genomes"

# Get list of files
files=($(ls ${fastqs}/*R1*))

# Get the current file based on the SLURM_ARRAY_TASK_ID
index=$(($SLURM_ARRAY_TASK_ID - 1))

# Define R1 and R2 files
r1=${files[$index]}
r2=${r1/_R1.fastq.gz/_R2.fastq.gz}

# Extract the basename of the sample
sample=$(basename ${r1} _R1.fastq.gz)

Skip samples that have already been processed
if [[ -d "$home"/deepurify/"$sample" ]]; then
        echo "Output already exists for $sample, skipping"
        exit 0
fi

export TMPDIR="/work/NRSAAMR/Projects/EFLMR-Pilot/work"

#source activate deepurify
#deepurify iter-clean -c "$contigs"/${sample}.final.contigs.fa -o "$home"/deepurify2/"$sample" -s "$contigs"/${sample}.sorted.bam --gpu_num 1 --each_gpu_threads 1 --db_folder_path "$deepdb"

#source activate magqc
#out="/work/NRSAAMR/Projects/FDA-Enrichments/deepurify/good_mags_drep/coverm"
#coverm genome --coupled "$r1" "$r2" --genome-fasta-directory "$mags" -x fasta -m relative_abundance covered_fraction trimmed_mean \
#        --min-covered-fraction 0.001 --trim-min 0.1 --trim-max 0.9 --contig-end-exclusion 75 -o "$out"/${sample}.txt

#source activate AMR
#card="/work/NRSAAMR/Software_Databases/databases/CARD_3.2.7.dmnd"
#diamond blastx -d "$card" -q "$fastqs"/merged/${sample}_merged.fastq.gz -a "$home"/diamond/SAM/${sample}.daa -p 32 --max-target-seqs 1 --evalue 1e-10 --id 80
#diamond view -a "$home"/diamond/SAM/${sample}.daa -o "$home"/diamond/SAM/${sample}.sam
#samtools depth "$home"/diamond/SAM/${sample}.sam > "$home"/diamond/SAM/${sample}.depth
#awk '{depth[$3]++} END {for (d in depth) print d, depth[d]}' "$home"/diamond/SAM/${sample}.depth | sort -nk1 > "$home"/diamond/SAM/${sample}.depth_to_hits.tsv
