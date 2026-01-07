#!/bin/bash

# Script to validate and optionally correct paired FASTQ files using seqtk
# Usage: ./validate_and_fix_paired_fastq.sh R1.fastq.gz R2.fastq.gz

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <R1_fastq.gz> <R2_fastq.gz>"
    exit 1
fi

R1=$1
R2=$2

# Confirm seqtk is installed
if ! command -v seqtk &> /dev/null; then
    echo "seqtk could not be found. Please ensure seqtk is installed and accessible in your PATH."
    exit 1
fi

echo "Validating paired-end FASTQ files:"
echo "  R1: $R1"
echo "  R2: $R2"

# Check if files are readable
if ! [ -r "$R1" ]; then
    echo "Error: File $R1 does not exist or is not readable."
    exit 1
fi

if ! [ -r "$R2" ]; then
    echo "Error: File $R2 does not exist or is not readable."
    exit 1
fi

# Validate pairing with seqtk seq -A
echo "Checking pairing of the FASTQ files..."
PAIR_VALIDATION=$(seqtk seq -A "$R1" | awk '{if (NR%4==1) print substr($1, 2)}' | \
                  sort > R1_ids.txt)
seqtk seq -A "$R2" | awk '{if (NR%4==1) print substr($1, 2)}' | \
    sort > R2_ids.txt

comm -12 R1_ids.txt R2_ids.txt > paired_ids.txt

# Count IDs to determine pairing correctness
TOTAL_R1=$(wc -l < R1_ids.txt)
TOTAL_R2=$(wc -l < R2_ids.txt)
TOTAL_PAIRED=$(wc -l < paired_ids.txt)

rm R1_ids.txt R2_ids.txt

if [ "$TOTAL_PAIRED" -eq "$TOTAL_R1" ] && [ "$TOTAL_PAIRED" -eq "$TOTAL_R2" ]; then
    echo "Validation passed: Files are properly paired."
    rm paired_ids.txt
else
    echo "Validation FAILED: Files are not properly paired."
    echo "R1 has $TOTAL_R1 reads, R2 has $TOTAL_R2 reads, $TOTAL_PAIRED reads are properly paired."

    # Proceed to fix the files
    echo "Fixing unpaired FASTQ files..."
    seqtk subseq "$R1" paired_ids.txt > R1_fixed.fastq.gz
    seqtk subseq "$R2" paired_ids.txt > R2_fixed.fastq.gz
    echo "Fixed files created: R1_fixed.fastq.gz and R2_fixed.fastq.gz"
    rm paired_ids.txt
fi

echo "FASTQ file validation and correction completed."
