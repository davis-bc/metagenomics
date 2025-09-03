source activate anvio8

export TMPDIR="/work/NRSAAMR/Projects/FDA-Enrichments/work"

contigs="/work/NRSAAMR/Projects/FDA-Enrichments/Contigs"
home="/work/NRSAAMR/Projects/FDA-Enrichments/plasx"
Pfam="/work/NRSAAMR/Software_Databases/Pfam_v32"
COG14="/work/NRSAAMR/Software_Databases/COG_2014"

SAMPLE="BANANA"
base=$(echo ${SAMPLE} | sed "s/.fa//")

anvi-script-reformat-fasta "$contigs"/"$SAMPLE" -o "$home"/${base}.cor.fa --simplify-names
anvi-gen-contigs-database -L 0 -T 16 --project-name "$base" -f "$home"/${base}.cor.fa -o "$home"/${base}.db
anvi-export-gene-calls --gene-caller prodigal -c "$home"/${base}.db -o "$home"/${base}-gene-calls.txt
anvi-run-ncbi-cogs -T 16 --cog-version COG14 --cog-data-dir "$COG14" -c "$home"/${base}.db
anvi-run-pfams -T 16 --pfam-data-dir "$Pfam" -c "$home"/${base}.db
anvi-export-functions --annotation-sources COG14_FUNCTION,Pfam -c "$home"/${base}.db -o "$home"/${base}-cogs-and-pfams.txt
