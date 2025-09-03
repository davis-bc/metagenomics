#for file in *mobileog*; do
#awk '{print $2}' "$file" | sort | uniq -c | awk -v fname=$(basename "$file") '{print fname "\t" $2 "\t" $1}'
#done > all.mobileog.summary.tsv

#for file in *crass*; do
#samtools depth -a "$file" | awk -v fname=$(basename "$file") '{ sum += $3; n++ } END { print fname "\t" (n > 0 ? sum / n : 0); }'
#done > all.crass.summary.tsv
