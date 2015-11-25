### Variant Tools

A tool for generating variant matrices of multiple individuals produced by 
the CLC Genomics Workbench.

For all processing options type ./varianttools -h in the bin directory.

Three input options are mandatory:

* A fasta file containing the reference sequence (option -f *file*).
* A directory containing a set of csv files with the called variants
  of different individuals. (option -i *dir*).
* The data type of the input data which can either be "SNP" or "INDEL" (option -t *type*).

The headers of the csv files have to conform to the table header specifications
for called variants of the CLC Genomics Workbench version 7.5 or higher.
