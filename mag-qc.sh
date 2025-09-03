source activate magqc

mags="/work/NRSAAMR/Projects/EFLMR-Pilot/metabat2_out/skder/Dereplicated_Representative_Genomes/"
fastqs="/work/NRSAAMR/Projects/EFLMR-Pilot/fastqs"
tmp="/work/NRSAAMR/Projects/EFLMR-Pilot/work"

export TMPDIR="/work/NRSAAMR/Projects/EFLMR-Pilot/work"

#checkm lineage_wf "$mags" "$mags"/checkm -x fa --tmpdir "$tmp" -t 32
#checkm qa "$mags"/checkm/lineage.ms "$mags"/checkm -f "$mags"/checkm/binstats.tsv

#for d in "$mags"/*; do
#if test -d "$d"/checkm.out; then
#        continue
#        else
#echo "checkm not done, processing $d"
checkm2 predict --threads 32 --input "$mags"/*.fa --output-directory "$mags"/checkm.out -x fa --tmpdir "$tmp"
#fi
#done
#dRep dereplicate "$mags"/dRep -g "$mags"/*.fa -p 128 -comp 50 -con 10 --genomeInfo "$mags"/checkm/binstats.csv --debug
#gtdbtk classify_wf --genome_dir "$mags" --out_dir "$mags"/gtdb.out  -x fasta --cpus 32 --skip_ani_screen
#VeryFastTree "$mags"/gtdb.out/align/gtdbtk.bac120.user_msa.fasta.gz -gamma -wag -threads 32 > "$mags"/gtdb.out/908_mags.nwk

#coverm genome --coupled "$fastqs"/118_S42_R1.clean.fastq.gz "$fastqs"/118_S42_R2.clean.fastq.gz --genome-fasta-directory "$mags" -x fasta -m relative_abundance covered_fraction trimmed_mean \
#	--min-covered-fraction 0.001 --trim-min 0.1 --trim-max 0.9 --contig-end-exclusion 75 -o /work/NRSAAMR/Projects/EFLMR-Pilot/deepurify_filtered_out/skder/coverm.test
