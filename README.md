# Metagenomics
Just a place to store some useful CLI commands and project scripts

| Category | Function | Code |
|:---:|:---:|:---:|
|slurm|check slurm queue in long form|squeue --format="%.18i %.9P %.100j %.8u %.8T %.10M %.9l %.6D %R" --me
|slurm|checking job resource usage|sacct -u bdavis05 -o jobid,jobname,elapsed,TotalCPU,MaxRSS,MaxVMsize --starttime=01/10/25 --endtime=01/30/25 --state=COMPLETED
|slurm|cancel pending jobs|squeue -u bdavis05 --state=PENDING --noheader --format=%i | xargs scancel
|slurm|cancel job arrays|squeue -u bdavis05 -j 766815* --noheader --format=%i | xargs scancel
|file management|check sort directory files|du -sh * | sort -rh | head -30






awk 'FNR==1 && NR!=1 {next} 1' * > afp_sal.tsv

awk 'FNR==1 && NR!=1 {next} {print FILENAME "\t" $0}' *species > all.species.tsv 

awk -F "\t" '{ if(($9 >= 80) && ($17 <= 1E-10)) { print } }' sra.card.hits.tsv > sra.card.hits.filtered.tsv



samtools view -F 4 118_S42.sorted.bam | awk -v file="118_S42.sorted.bam" '{SUM += length($10)} END {print file "\t" SUM/10^9}'

find . -maxdepth 1 -type f -name "*.tif" -size -160k -delete

esearch -db nucleotide -query "rpob[All Fields] AND bacteria[organism]" | efetch -format fasta > bacterial_rpoB.fasta

esearch -db sra -query "soil metagenome[All Fields] AND USA[All Fields]" | efetch -format runinfo >> soil.runinfo.tsv

sacct -u bdavis05 --format=CPUTimeRAW,Elapsed --noheader --starttime 10/01/24 --endtime 04/29/25 | awk '{cpu += $1; split($2, t, "-"); d=(length(t)==2)?t[1]:0; ts=(length(t)==2)?t[2]:t[1]; split(ts, hms, ":"); wall += (d*86400 + hms[1]*3600 + hms[2]*60 + hms[3])} END {print "Total CPU hours: " cpu/3600; print "Total wall time (hours): " wall/3600}'

for file in *.fa*; do mv "$file" "${file/.bin/.crossmap.bin}"; done

sbatch --array=1-$(wc -l < run.pig.txt)%32 SRA_ARG_Pipeline.sh run.pig.txt card.4.0.0.dmnd

seqkit grep --pattern-file "$CARD_DIR/${SRR}_card_contig_ids.txt" --out-file "$CARD_DIR/${SRR}_card_contigs.fa" "$ASSEMBLY_DIR/$SRR/final.contigs.fa"

prefetch SRR21374569 && fasterq-dump -e 16 -t . -O . -S SRR21374569 && rm -rf ~/ncbi/public/sra/SRR21374569.sra

while IFS= read -r srr; do esearch -db sra -query "$srr" | efetch -format runinfo >> chicken.feces.info.tsv ; done < chicken.feces.usa.srr.txt
