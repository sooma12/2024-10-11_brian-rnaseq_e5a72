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

## Setting up config.cfg

Open config.cfg in a text editor.

Under `# Main directory`:

Set BASE_DIR to the main project directory (replace <>).  In general, this should be the template directory that you copied and renamed above.

Under `# Location of untrimmed fastq files`:

Set FASTQDIR_UNTRIMMED to the location of the raw, untrimmed fastq files received from the sequencing company.

Other settings don't need to be changed if analyzing using the 17978-mff annotations.  If you're using another strain, do the following:

1. Change REF_CHR_FA and subsequent files to the fasta files for the organism's genome.  If using more or fewer plasmids/reference sequences, you'll need to change bowtie2_build script as well. 
2. Set BT2_OUT_BASE to a shorthand for the species you're using (this is just to name the bowtie2 index files, not super important)
3. Under `# featureCounts`, change GENOME_GTF to a gtf file containing annotations for the target organism

## Setting up script files

The sbatch scripts (0, 1, 3, 4, and 5) have headers starting with #SBATCH that provides instructions to the slurm management software that runs on Discovery.
The #SBATCH headers will need to be adjusted for your project.

For ALL sbatch scripts:

1. Set --output to a file path for saving the log file.  Example: /work/geisingerlab/Mark/rnaSeq/2024-06-12_sRNAs_eg-palethorpe/logs/%x-%j.log
2. Set --error to a file path to save the standard error file (this just refers to a place where some messages are sent; not always errors).  Example: --error=/work/geisingerlab/Mark/rnaSeq/2024-06-12_sRNAs_eg-palethorpe/logs/%x-%j.err
3. Set --mail-user to your email address

The array scripts (scripts 3 bowtie2 align and 4 samtools) run multiple processes simultaneously so that we can process multiple files at the same time.  These require some additional settings tweaks.

Make a note of the number of samples you have (i.e. 12 if you sent 4 strains in triplicate for RNA-seq).  Let's call that N.

1. Set --array to 1-N%(N+1).  For example, `#SBATCH --array=1-12%13`.
This tells the program to create separate subprocesses numbered from 1 to the total number of samples, and allows it to run N+1 processes at the same time (i.e. all of them).
NOTE: If you have >20 samples, instead of N+1, use 20.
2. Set --ntasks to the number of samples, N.  Example: `#SBATCH --ntasks=12`
3. For both --output and --error, I like to change the file names to `%x-%A-%a` instead of `%x-%j`. `%x-%A-%a` uses the array number.

##  Usage
Run scripts as follows.  Execute all commands from BASE_DIR defined in the config.cfg file (i.e. `cd` to that directory).
The commands below assume that all scripts are located in $BASE_DIR/scripts

1. `sbatch scripts/0_sbatch_fastqc.sh`
2. `sbatch scripts/1_sbatch_bowtie2_build_ref.sh`
3. `bash 2_make_sample_sheet.sh`  # After this command, inspect the sample sheet and ensure that files are listed correctly
4. `sbatch 3_sbatch_array_bowtie2_align.sh`
5. `sbatch 4_sbatch_samtools_to_sorted_bam.sh`
6. `sbatch 5_sbatch_featurecounts.sh`
7. `bash 6_run_multiqc.sh`



