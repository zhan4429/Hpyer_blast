#!/bin/bash
# This script takes in an input fasta file, puts all the sequences in one line, and splits it into multiple files based on input parameters 

version=0.1
help()
{
    echo "This script takes in an input fasta file, puts all the sequences in one line, and splits it into multiple files based on input parameters"
    echo "Usage: ./SplitFasta.sh [ -in ] [ -outprefix ] [ -n ] [ -l ] [-v] [-h]"
    echo "Example: ./SplitFasta.sh -in seq.fasta -outprefix seqaa -n 5"
    echo "-in: Input fasta file"
    echo "-outprefix: Prefix for output files names"
    echo "-n: Number of files to split into"
    echo "-l: Max number of sequences per output file"
    echo "-h: Display help inforamtion"
    echo "-v: Display version information"
    exit 2
}

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
		-n)
            i=$(expr $i + 1 )
			number=${!i}
			;;
		-l)
            i=$(expr $i + 1 )
			length=${!i}
			;;
		-in)
            i=$(expr $i + 1 )
			input=${!i}
			;;
		-outprefix)
            i=$(expr $i + 1 )
			prefix=${!i}
			;;
		*)
			echo "extra: ${!i}"
			;;
	esac
	i=$(expr $i + 1 )
done 

# Check variable names
# echo "-n = $number"
# echo "-l = $length"
# echo "-in = $input"
# echo "-outprefix = $prefix"


# If -outprefix or -in missing
if [ -z $prefix ] || [ -z $input ]
then
    echo "Warning: commandline arguments missing"
    help
fi


# If both -l and -n missing 
if [ -z $length ] && [ -z $number ]
then
    echo "Warning: commandline arguments missing"
    help
fi


# Generate singleline file
awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < $input > seq_singleline.faa


# If only -l given
if [ $length ] && [ -z $number ]
then
    awk -v lengths=$length -v prefix=$prefix 'BEGIN {n_seq=0; number2=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, number2); number2++;} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
fi


# If both -n and -l given
if [ $length ] && [ $number ]
then
    echo "Warning: Both -n and -l given in command line, only using -n value"
    
    number_of_lines=$(wc -l < seq_singleline.faa)
    number_of_sequences=$((number_of_lines / 2))

    if [ $((number_of_sequences % number)) == 0 ] # If equal split
    then
        number_of_sequences_per_file=$((number_of_sequences / number))
        awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0; number2=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, number2); number2++;} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
    else # If not equal split
        number_of_sequences_per_file=$((number_of_sequences / number))
        number=$((number-1))
        calculated_number=$((number_of_sequences_per_file * number))
        last_file_number_of_sequences=$((number_of_sequences - calculated_number))
        number_of_lines=$((last_file_number_of_sequences * 2))
        tail -n $number_of_lines seq_singleline.faa > temp.faa
        head --lines=-$number_of_lines seq_singleline.faa > seq_singleline2.faa
        awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0; number2=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, number2); number2++;} print > file; n_seq++; next;} { print >> file; }' < seq_singleline2.faa
        mv temp.faa $prefix$number.fa
        rm seq_singleline2.faa
    fi
    
fi


# If only -n given
if [ -z $length ] && [ $number ]
then
    number_of_lines=$(wc -l < seq_singleline.faa)
    number_of_sequences=$((number_of_lines / 2))
    
    if [ $((number_of_sequences % number)) == 0 ] # If equal split
    then
        number_of_sequences_per_file=$((number_of_sequences / number))
        awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0; number2=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, number2); number2++;} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
    else # If not equal split
        number_of_sequences_per_file=$((number_of_sequences / number))
        number=$((number-1))
        calculated_number=$((number_of_sequences_per_file * number))
        last_file_number_of_sequences=$((number_of_sequences - calculated_number))
        number_of_lines=$((last_file_number_of_sequences * 2))
        tail -n $number_of_lines seq_singleline.faa > temp.faa
        head --lines=-$number_of_lines seq_singleline.faa > seq_singleline2.faa
        awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0; number2=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, number2); number2++;} print > file; n_seq++; next;} { print >> file; }' < seq_singleline2.faa
        mv temp.faa $prefix$number.fa
        rm seq_singleline2.faa # rm singleline2 file
    fi
     
fi


# rm singleline file
rm seq_singleline.faa
