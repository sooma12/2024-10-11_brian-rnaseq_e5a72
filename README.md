# 
Written Mark Soo Oct 11 2024 for analysis of Brian Nguyen's RNA-seq data using the reference genome: https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_004797155.2/

## Reference genome

Link to assembly:
https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_004797155.2/

Assembly is in 3 parts, 1 chromosome and 2 plasmids.

Chromosome  GenBank RefSeq  Size (bp)   GC content (%)
chromosome	CP039025.2	NZ_CP039025.2	3,955,017	39
unnamed1	CP039024.1	NZ_CP039024.1	30,876	35.5
unnamed2	CP039026.1	NZ_CP039026.1	30,410	36

Downloaded files to /scratch/soo.m/2024-10-11_brian-rnaseq_e5a72/REF using download_genome_files.sh script

Reference GTF was made as follows:
1.  Downloaded gff3 files to ./REF/
wget -O CP039025.2.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP039025.2&rettype=gff3"
wget -O CP039024.1.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP039024.1&rettype=gff3"
wget -O CP039026.1.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP039026.1&rettype=gff3"

2. gff3 files converted to GTF files 
gffread CP039024.1.gff3 -T -o CP039024.1.gtf
gffread CP039025.2.gff3 -T -o CP039025.2.gtf
gffread CP039026.1.gff3 -T -o CP039026.1.gtf

3. Merged gtf files
cat CP039024.1.gtf CP039025.2.gtf CP039026.1.gtf >merged_17978_e5a72.gtf

