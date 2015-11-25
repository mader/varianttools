### Variant Tools

A tool for generating variant matrices of multiple individuals produced by 
the CLC Genomics Workbench.

For all processing options type ./varianttools -h in the bin directory.

Three input options are mandatory:

* A fasta file containing the reference sequence (option -f).
* A set of csv files containing the called variants of different individuals. (option -i).
* The data type ofthe input data which can either be "SNP" or "INDEL" (Option -t).

The headers of the csv files have to comply to the table header specifications
for called variants of the CLC Genomics Workbench version 7.5 or higher.
