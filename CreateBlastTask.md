Script called CreateBlastTask, it can be a bash script.

Usage: 

```
CreateBlastTask -p blastp -evalue 1e-3 -num_threads 1 -input_dir input -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue" -other_blast_params "-num_descriptions 1 -max_target_seqs 5" -output blastTaskfile.txt
```

For `-other_blast_params`, even if users add quotes, we should remove quotes in the final output. 


Options::

	-h help 
	-v version
	-p  Program Name [String], the value can be blastp, blastx, blastn, tblastn, tblastx
	-db  Database [String]
	-query Query File 
	-evalue evalue
	-num_threads int_value,  default=1
	-input_dir directory containing fasta files
	-outfmt output formats, can be init value, or strings such as "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue"
	-other_blast_params Optional blast parameters, this should be put into quotes, such as "-num_descriptions 1 -max_target_seqs 5"


This is my orginal bash codes
```
for FILE in input/*.fasta
 do
    ID="$(basename -- $FILE .fasta)"
    Output=$ID"_blastxout"
    echo "/group/bioinfo/apps/apps/blast-2.12.0+/bin/blastx  -num_threads 1 -evalue 1e-3 -query "/tmp/$USER/blastx/input/"$ID".fasta" -db "/tmp/$USER/blastx/database/"Lophotrochozoa_model -out $RCAC_SCRATCH"/blast_kw/${myseqID}_blastoutput/"$Output -outfmt \"6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxid ssciname scomname stitle\" && echo $ID success" >> ${tempdir}/blastTaskfile.txt
 done || exit 1

```
