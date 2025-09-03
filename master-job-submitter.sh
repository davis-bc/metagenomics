### Set environmental variables
home="/work/NRSAAMR/Projects/EFLMR-Pilot"
fastqs="/work/NRSAAMR/Projects/EFLMR-Pilot/fastqs"
contigs="/work/NRSAAMR/Projects/EFLMR-Pilot/contigs"
logs="/work/NRSAAMR/Projects/EFLMR-Pilot/scripts/logs"
slurm="/work/NRSAAMR/Projects/EFLMR-Pilot/slurm"
deepdb="/work/NRSAAMR/Software_Databases/Deepurify-DB"

rm "$slurm"/*
rm "$logs"/*

for R1 in "$fastqs"/*R1*;  do

sample=$(basename "$R1" _R1.clean.fastq.gz)

### Set file size limit to 3 gigabytes for the R1 file, equivalent to ~10 Gb for the fastq pair
#limit=$((3 * 1024 * 1024 * 1024))
#file_size=$(stat -c%s "$R1")

#if (( file_size < limit )); then
#        echo "$sample is less than 10 Gb, proceeding"
#else
#        echo "$sample is larger than 10Gb, no job submission"
#        continue
#fi

### Cancel if the output directory already exists
if [[ -d "$home"/deepurify/"$sample" ]]; then
	#echo "$sample already processed, no job submission"
	continue
fi

### Only run 2 jobs at any given time (not including the job submission script)
#while true; do
#current_jobs=$(squeue -u bdavis05 --states=R,PD --noheader | wc -l)
#	if (( current_jobs < 3 )); then
#		break
#	fi
#sleep 3600
#done

    JOB_SCRIPT="$logs/${sample}_job.sh"
    cat > "$JOB_SCRIPT" << EOF
#!/bin/bash
#SBATCH --account=nrsaamr
#SBATCH --nodes=1
#SBATCH --partition=ord
#SBATCH --time=6-00:00:00 #days-hours:min:sec
#SBATCH --output="$slurm"/deepurify."$sample".%j
#SBATCH --job-name="$sample"
#SBATCH --exclusive

source activate deepurify

export TMPDIR="/work/NRSAAMR/Projects/EFLMR-Pilot/work"

deepurify iter-clean -c "$contigs"/${sample}.final.contigs.fa -o "$home"/deepurify2/"$sample" -s "$contigs"/${sample}.sorted.bam --gpu_num 0 --db_folder_path "$deepdb"

EOF

sbatch "$JOB_SCRIPT"
echo "Submitted $sample at $(date)"
done
