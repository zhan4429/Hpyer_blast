#!/bin/bash

help()
{
    echo "Usage: SplitFasta [ -in ] [ -outprefix] [ -n ] [ -l ]"
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
			version=${!i}
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
echo "-n = $number"
echo "-l = $length"
echo "-in = $input"
echo "-v = $version"
echo "-outprefix = $prefix"


# If -outprefix or -in missing
if [ -z $prefix ] || [ -z $input ]
then
    help
fi


# If both -l and -n missing 
if [ -z $length ] && [ -z $number ]
then
    help
fi


# Generate singleline file
awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < $input > seq_singleline.faa


# If only -l given
if [ $length ] && [ -z $number ]
then
    echo "Only -l given in command line"
    awk -v lengths=$length -v prefix=$prefix 'BEGIN {n_seq=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, n_seq);} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
fi


# If both -n and -l given
if [ $length ] && [ $number ]
then
    echo "Both -n and -l given in command line, using -n value"
    
    number_of_lines=$(wc -l < seq_singleline.faa)
    number_of_sequences=$((number_of_lines / 2))
    echo "number of sequences = $number_of_sequences"

    if [ $((number_of_sequences % number)) == 0 ]
    then
        echo "equal split"
        number_of_sequences_per_file=$((number_of_sequences / number))
    else
        echo "not equal split"
        # echo $((number - number_of_sequences % number))
        number_of_sequences_per_file=$((number_of_sequences / number))
        # echo $number_of_sequences_per_file
        calculated_number=$((number_of_sequences_per_file * number))
        # echo $calculated_number
        difference=$((number_of_sequences - calculated_number))
        # echo $difference
        number_of_sequences_per_file=$((number_of_sequences_per_file + difference))
        # echo $number_of_sequences_per_file
        # echo $((number_of_sequences_per_file * number))
    fi
    
    echo "Max number of sequences per file: $number_of_sequences_per_file"
    awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, n_seq);} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
fi


# If only -n given
if [ -z $length ] && [ $number ]
then
    echo "Only -n given in command line"
    
    number_of_lines=$(wc -l < seq_singleline.faa)
    number_of_sequences=$((number_of_lines / 2))
    echo "number of sequences = $number_of_sequences"

    if [ $((number_of_sequences % number)) == 0 ]
    then
        echo "equal split"
        number_of_sequences_per_file=$((number_of_sequences / number))
    else
        echo "not equal split"
        # echo $((number - number_of_sequences % number))
        number_of_sequences_per_file=$((number_of_sequences / number))
        # echo $number_of_sequences_per_file
        calculated_number=$((number_of_sequences_per_file * number))
        # echo $calculated_number
        difference=$((number_of_sequences - calculated_number))
        # echo $difference
        number_of_sequences_per_file=$((number_of_sequences_per_file + difference))
        # echo $number_of_sequences_per_file
        # echo $((number_of_sequences_per_file * number))
    fi
    
    echo "Max number of sequences per file: $number_of_sequences_per_file"
    awk -v lengths=$number_of_sequences_per_file -v prefix=$prefix 'BEGIN {n_seq=0;} /^>/ {if(n_seq%lengths==0){file=sprintf("%s%d.fa",prefix, n_seq);} print > file; n_seq++; next;} { print >> file; }' < seq_singleline.faa
fi


# rm singleline file
rm seq_singleline.faa
