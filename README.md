# 2024-10-11_brian-rnaseq_e5a72
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

```bash
wget -O NZ_CP039025.2.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NZ_CP039025.2&rettype=gff3"
wget -O NZ_CP039024.1.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NZ_CP039024.1&rettype=gff3"
wget -O NZ_CP039026.1.gff3 "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NZ_CP039026.1&rettype=gff3"
```

2. gff3 files converted to GTF files 
```bash
gffread NZ_CP039024.1.gff3 -T -o NZ_CP039024.1.gtf
gffread NZ_CP039025.2.gff3 -T -o NZ_CP039025.2.gtf
gffread NZ_CP039026.1.gff3 -T -o NZ_CP039026.1.gtf
```


3. Merged gtf files
```bash
cat NZ_CP039024.1.gtf NZ_CP039025.2.gtf NZ_CP039026.1.gtf >merged_17978_e5a72.gtf
```

## Scripts

1. Bowtie2-build was run on fasta genome files (specified with -f) using 1_sbatch_bowtie2_build_ref.sh

Citation:

Langmead B, Salzberg SL. Fast gapped-read alignment with Bowtie 2. Nat Methods. 2012 Mar 4;9(4):357-9. doi: 10.1038/nmeth.1923. PMID: 22388286; PMCID: PMC3322381.

2. Sample sheet containing sample IDs and file paths for read files generated using 2_make_sample_sheet.sh

3. The bowtie2 aligner was called in paired end mode with 3_sbatch_array_bowtie2_align.sh using these settings:
```bash
bowtie2 \
--local \
--very-sensitive-local \
-p 8 \
-q
```

Note that the raw fastq files (not trimmed) were run through the bowtie2 aligner.  This takes advantage of bowtie2's ability to "soft clip" adapter sequences and should increase the number of reads mapped.

Citation:

Langmead B, Salzberg SL. Fast gapped-read alignment with Bowtie 2. Nat Methods. 2012 Mar 4;9(4):357-9. doi: 10.1038/nmeth.1923. PMID: 22388286; PMCID: PMC3322381.

4. Samtools was used to convert SAM outputs to BAM files, sort BAM files, and generate alignment stats.

Citation:

Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H. Twelve years of SAMtools and BCFtools. Gigascience. 2021 Feb 16;10(2):giab008. doi: 10.1093/gigascience/giab008. PMID: 33590861; PMCID: PMC7931819.

5. Featurecounts from the subread package was used to aggregate reads to genomic features using paired-end mode.
```bash
featureCounts \
-a $GENOME_GTF \
-o $COUNTS_OUTDIR/$COUNTS_FILE \
-p \
--countReadPairs \
-t transcript \
$MAPPED_DIR/*.bam
```

Citations:

Liao Y, Smyth GK and Shi W. featureCounts: an efficient general-purpose program for assigning sequence reads to genomic features. Bioinformatics, 30(7):923-30, 2014
Liao Y, Smyth GK and Shi W. The Subread aligner: fast, accurate and scalable read mapping by seed-and-vote. Nucleic Acids Research, 41(10):e108, 2013

6. MultiQC used to summarize pipeline statistics

Citation:

Ewels P, Magnusson M, Lundin S, Käller M. MultiQC: summarize analysis results for multiple tools and samples in a single report. Bioinformatics. 2016 Oct 1;32(19):3047-8. doi: 10.1093/bioinformatics/btw354. Epub 2016 Jun 16. PMID: 27312411; PMCID: PMC5039924.