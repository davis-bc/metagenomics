source activate mags

# Input files and directories
INDEX_FILE="/work/NRSAAMR/Projects/EFLMR-Pilot/siteid-seqid.txt"
CONTIGS_DIR="/work/NRSAAMR/Projects/EFLMR-Pilot/contigs.total" # Directory containing contigs.fasta files
FASTQ_DIR="/work/NRSAAMR/Projects/EFLMR-Pilot/fastqs"    # Directory containing paired-end FASTQ files
OUTPUT_DIR="/work/NRSAAMR/Projects/EFLMR-Pilot/contigs.total/cross-mapping"   # Directory to store mapping results
LOGS="/work/NRSAAMR/Projects/EFLMR-Pilot/contigs.total/LOGS"

# Clear the LOGS before the run
mkdir -p "$LOGS"

# Get the list of unique sites
SITES=($(tail -n +2 "$INDEX_FILE" | awk -F'\t' '{print $1}' | sort | uniq))

# Get the current site based on the SLURM_ARRAY_TASK_ID
SITE=${SITES[$SLURM_ARRAY_TASK_ID]}
echo "Processing site: $SITE"

# Create a directory for the site if it doesn't exist
SITE_OUTPUT_DIR="$OUTPUT_DIR/$SITE"
mkdir -p "$SITE_OUTPUT_DIR"

# Find all SeqIDs for the current site
SEQIDS=$(grep "^$SITE" "$INDEX_FILE" | awk -F'\t' '{print $2}')
echo -e "Which contains seqids:\n$SEQIDS"

# Concatenate all R1 and R2 FASTQ files for the current site
CONCAT_R1="$SITE_OUTPUT_DIR/${SITE}_R1.fastq.gz"
CONCAT_R2="$SITE_OUTPUT_DIR/${SITE}_R2.fastq.gz"

R1_FILES=$(ls "$FASTQ_DIR" | grep -E "${SEQIDS}.*_R1.clean.fastq.gz$")
R2_FILES=$(ls "$FASTQ_DIR" | grep -E "${SEQIDS}.*_R2.clean.fastq.gz$")

echo -e "These are the R1 files to concatenate:\n$R1_FILES"
echo -e "These are the R2 files to concatenate:\n$R2_FILES"

zcat $(echo "$R1_FILES" | xargs -I{} echo "$FASTQ_DIR/{}") > "$CONCAT_R1"
zcat $(echo "$R2_FILES" | xargs -I{} echo "$FASTQ_DIR/{}") > "$CONCAT_R2"

# Map the concatenated FASTQ files to the contigs for each SeqID in the site
for SEQID in $SEQIDS; do
    CONTIGS_FILE=$(ls "$CONTIGS_DIR" | grep -E "^${SEQID}.*.final.contigs.fa")
    MAPPING_OUTPUT="$SITE_OUTPUT_DIR/${SEQID}_mapping.bam"
    DEPTH_OUTPUT="$SITE_OUTPUT_DIR/${SEQID}_depth.txt"
	if [[ -n "$CONTIGS_FILE" ]]; then
        echo "mapping to $CONTIGS_FILE because it exists"
	else
	echo "$CONTIGS_FILE does not exist, skipping"
        continue
    	fi

export TMPDIR="/work/NRSAAMR/Projects/EFLMR-Pilot/work"

minimap2 -ax sr -t 32 "$CONTIGS_DIR"/"$CONTIGS_FILE" "$CONCAT_R1" "$CONCAT_R2" | \
samtools view -bS | samtools sort > "$MAPPING_OUTPUT"
jgi_summarize_bam_contig_depths --outputDepth "$DEPTH_OUTPUT" "$MAPPING_OUTPUT"
metabat2 -i "$CONTIGS_DIR"/"$CONTIGS_FILE" -a "$DEPTH_OUTPUT" -o "$SITE_OUTPUT_DIR"/${SEQID}.bin -m 1500

rm "$DEPTH_OUTPUT"
rm "$MAPPING_OUTPUT"

done

# Clean up concatenated files (optional)
rm "$CONCAT_R1" "$CONCAT_R2"
