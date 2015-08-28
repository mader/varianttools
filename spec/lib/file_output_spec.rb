require 'spec_helper'
require 'option_parser'
require 'file_output'
require_relative '../support/analysis_helper'

describe FileOutput do
  include AnalysisHelper

    shared_examples_for "any analysis written to file" do
      it "writes to file" do
        expect(@output_result).to eql(@expected_result)
        FileUtils.rm(Dir.pwd + '/output.tsv')
     end
    end

  context "processes SNP data without contigs" do

    before(:each) do
      fasta_file = "/data/test.fasta"
      input_dir = "/data/snp_one_refseq/"

      sequinom_variants = get_sequinom_variants_from_file_input(fasta_file,
      	                                             input_dir,
      	                                             9,
      	                                             5,
      	                                             :SNP)
      options = OptionParser.parse(["-f",
      	                             fasta_file,
      	                             "-i",
      	                             input_dir,
      	                             "-t",
      	                             "SNP"])
      @expected_result, @output_result = compare_results(
      	                     '/data/expected_results/snp_test1_clc_results.csv',
      	                     options,
      	                     sequinom_variants)
    end

      it_behaves_like "any analysis written to file"
  end

  context "processes SNP data with contigs" do

    before(:each) do
      fasta_file = "/data/test2.fasta"
      input_dir = "/data/snp_contigs/"

      sequinom_variants = get_sequinom_variants_from_file_input(fasta_file,
      	                                             input_dir,
      	                                             9,
      	                                             5,
      	                                             :SNP)
      options = OptionParser.parse(["-f",
      	                             fasta_file,
      	                             "-i",
      	                             input_dir,
      	                             "-t",
      	                             "SNP"])
      @expected_result, @output_result = compare_results(
      	                     '/data/expected_results/snp_test2_clc_results.csv',
      	                     options,
      	                     sequinom_variants)

    end

      it_behaves_like "any analysis written to file"
  end

  context "processes INDEL data" do

    before(:each) do
      fasta_file = "/data/test.fasta"
      input_dir = "/data/indel_test1/"

      sequinom_variants = get_sequinom_variants_from_file_input(fasta_file,
                                                     input_dir,
                                                     9,
                                                     5,
                                                     :INDEL)
      options = OptionParser.parse(["-f",
                                     fasta_file,
                                     "-i",
                                     input_dir,
                                     "-t",
                                     "INDEL"])
      @expected_result, @output_result = compare_results(
                             '/data/expected_results/indel_test1_clc_results.csv',
                             options,
                             sequinom_variants)

    end

      it_behaves_like "any analysis written to file"
  end
end