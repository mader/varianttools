#!/bin/sh
../bin/varianttools.rb -f ../data/test.fasta -i ../data/snp_test1/ -t SNP -d 9,5
diff output.tsv ../data/expected_results/snp_test1_clc_results.csv
../bin/varianttools.rb -f ../data/test2.fasta -i ../data/snp_test2/ -t SNP -d 9,5
diff output.tsv ../data/expected_results/snp_test2_clc_results.csv
../bin/varianttools.rb -f ../data/test.fasta -i ../data/indel_test1/ -t INDEL -d 9,5
diff output.tsv ../data/expected_results/indel_test1_clc_results.csv
rm logfile.log
rm output.tsv