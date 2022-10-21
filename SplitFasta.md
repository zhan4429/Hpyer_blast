Create a bash script called `SplitFasta`
## Usage
```
SplitFasta -in seq.fasta -outprefix seq -n 4 
```

Options:
- -in input fasta
- -outprefix prefix for output small fasta files
- -n how many equal size output chunks we want to have
- -l the number of sequences in each outputs
- -h help inforamtion
- -v version 


**warining**: users can only use `-n` or `-v`. If users provide both `-n` and `-v`, only `-n` will be used. 


## Multiline Fasta To Single Line Fasta
The reference is here: https://www.biostars.org/p/9262/
```
awk '/^>/ { if(NR>1) print "";  printf("%s\n",$0); next; } { printf("%s",$0);}  END {printf("\n");}' < input.fasta > seq_singleline.faa
```

## Split fasta based on `-l`

```
# assign the value of -l to a variable called "length", and value of outprefix to a variable "prefix"
awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%$length==0){file=sprintf("$prefix%d.fa",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < seq_singleline.faa|| exit 1
```

## Split fasta based on `-n`
I will leave this to Payas. It should be easy to achieve by modifying the above awk code. 
