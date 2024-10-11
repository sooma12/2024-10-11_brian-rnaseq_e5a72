#!/bin/bash

# File containing the list of accession numbers (one per line)
ACCESSION_FILE="ref_accessions.txt"

# Base URLs for downloading FASTA and GenBank files
BASE_URL_FASTA="https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=%s&db=nuccore&report=fasta&retmode=text"
BASE_URL_GENBANK="https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=%s&db=nuccore&report=genbank&retmode=text"

# Function to download a file using wget
download_file() {
    local url=$1
    local output_file=$2
    echo "Downloading $output_file..."
    wget -q -O "$output_file" "$url"
}

# Check if the accession file exists
if [ ! -f "$ACCESSION_FILE" ]; then
    echo "Error: Accession file '$ACCESSION_FILE' not found!"
    exit 1
fi

# Loop through each accession number in the file
while IFS= read -r accession; do
    if [ -n "$accession" ]; then
        # Generate URLs for FASTA and GenBank
        fasta_url=$(printf "$BASE_URL_FASTA" "$accession")
        genbank_url=$(printf "$BASE_URL_GENBANK" "$accession")

        # Output file names
        fasta_output="${accession}.fasta"
        genbank_output="${accession}.gb"

        # Download FASTA and GenBank files
        download_file "$fasta_url" "$fasta_output"
        download_file "$genbank_url" "$genbank_output"
    fi
done < "$ACCESSION_FILE"

echo "Download completed!"