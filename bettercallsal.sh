source activate nextflow

bcs="/work/NRSAAMR/Software_Databases/bettercallsal"
bcs_db="/work/NRSAAMR/Software_Databases/bettercallsal/bcs_db/PDG000000002.3082"
fqs="/work/NRSAAMR/Projects/FDA-Enrichments/fastqs"
test="/work/NRSAAMR/Projects/FDA-Enrichments/Bins/filtered.bins/Salmonella/senterica_sim_reads/test"
work="/work/NRSAAMR/Projects/FDA-Enrichments/nf-work"
sal="/work/NRSAAMR/Projects/FDA-Enrichments/Bins/filtered.bins/Salmonella/senterica_sim_reads"

export TMPDIR=/work/NRSAAMR/Projects/FDA-Enrichments/nf-work


nextflow run CFSAN-Biostatistics/bettercallsal -profile epaatmos --pipeline bettercallsal --input "$fqs" --output /work/NRSAAMR/Projects/FDA-Enrichments/bettercallsal_out --bcs_root_dbdir "$bcs_db" \
 --fq_single_end false --fq_suffix '_R1.fastq.gz' --fq2_suffix '_R2.fastq.gz' --fq_filename_delim "_" --fq_filename_delim_idx 4 -w "$work" --bcs_thresholds relax
