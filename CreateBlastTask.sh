#!/bin/bash

# Default values
version=0.1
numberOfThreads=1

help()
{
    echo "Usage: ./CreateBlastTask.sh [ -p ] [ -db ] [ -evalue ] [ -num_threads ] [ -input_dir ] [ -outfmt ] [ -blastout_dir ] [ -other_blast_params ] [ -output ] [-v] [-h]"
    echo "Example: ./CreateBlastTask.sh -p blastp -db database -evalue 1e-3 -num_threads 1 -input_dir input -blastout_dir blastout -outfmt \"6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxid ssciname scomname stitle\" -other_blast_params \"-num_descriptions 1 -max_target_seqs 5\" -output blastTaskfile.txt"
    echo "-p: Program Name [String], the value can be blastp, blastx, blastn, tblastn, tblastx"
    echo "-db: Database [String]"
    echo "-evalue: evalue"
    echo "-num_threads: int_value, default=1"
    echo "-input_dir: directory containing fasta files"
    echo "-outfmt: output formats, can be init value, or strings such as \"6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue\""
    echo "-blastout_dir: output directory for blast outputs"
    echo "-other_blast_params: Optional blast parameters, this should be put into quotes, such as \"-num_descriptions 1 -max_target_seqs 5\""
    echo "-output: blasttaskfile"
    echo "-h: Display help inforamtion"
    echo "-v: Display version information"
    exit 2
}

# Process args from command line
args="${*}"
i=1
while [ $i -le ${#} ]; do
	arg=${!i}
	case "${arg}" in
		-h|--help)
			help
			exit 0
			;;
		-v)
            i=$(expr $i + 1 )
            echo "Version number: $version"
            exit 0
			;;
		-p)
            i=$(expr $i + 1 )
			programname=${!i}
			;;
		-db)
            i=$(expr $i + 1 )
			database=${!i}
			;;
        -evalue)
            i=$(expr $i + 1 )
			evalue=${!i}
			;;
        -num_threads)
            i=$(expr $i + 1 )
			numberOfThreads=${!i}
			;;
        -input_dir)
            i=$(expr $i + 1 )
			inputDirectory=${!i}
			;;
        -outfmt)
            i=$(expr $i + 1 )
			outputFormat=${!i}
			;;
        -blastout_dir)
            i=$(expr $i + 1 )
			outputDirectory=${!i}
			;;
		-other_blast_params)
            i=$(expr $i + 1 )
			otherParams=${!i}
			;;
        -output)
            i=$(expr $i + 1 )
			outputFile=${!i}
			;;
		*)
			echo "extra: ${!i}"
			;;
	esac
	i=$(expr $i + 1 )
done 

# Check variable names
# echo "-p = $programname"
# echo "-db = $database"
# echo "-evalue = $evalue"
# echo "-num_threads = $numberOfThreads"
# echo "-input_dir = $inputDirectory"
# echo "-outfmt = $outputFormat"
# echo "-blastout_dir = $outputDirectory"
# echo "-other_blast_params = $otherParams"
# echo "-output = $outputFile"

# If some variables are missing
if [ -z "$programname" ] || [ -z "$database" ] || [ -z "$evalue" ] || [ -z "$inputDirectory" ] || [ -z "$outputFormat" ] || [ -z "$outputDirectory" ] || [ -z "$outputFile" ]
then
    echo "Warning: commandline arguments missing"
    help
fi

# add quotes to $outputFormat
outputFormat="\"$outputFormat\""

# Remove outputFile
rm -f $outputFile

for inputFile in $inputDirectory/*.fasta
 do
    ID="$(basename -- $inputFile .fasta)"
    echo "$programname  -num_threads $numberOfThreads -evalue $evalue -query $inputDirectory/"$ID".fasta, -db $database -out $outputDirectory/ -outfmt $outputFormat $otherParams && echo $ID success" >> $outputFile
 done

# ./CreateBlastTask.sh -p blastp -db database -evalue 1e-3 -num_threads 1 -input_dir input -blastout_dir blastout -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxid ssciname scomname stitle" -other_blast_params "-num_descriptions 1 -max_target_seqs 5" -output blastTaskfile.txt
