require 'spec_helper'
require 'byebug'

describe VariantTools do

  context "read SNP data without contigs" do

    before(:each) do
  	  @ref_seq = Dir.pwd + "/data/test.fasta"
      logger = Logger.new(STDOUT)
      logger.level = Logger::ERROR
      @variant_tool = VariantTools.new(@ref_seq, 5, 4, :SNP, logger)
      @clc_variants = @variant_tool.read_files(Dir.pwd + "/data/unit_tests/")
      #@sequinom_variants = @variant_tool.make_report_for_sequinom(@clc_variants)
    end

    it "contains one contig" do
    	expect(@clc_variants.size).to be(1)
    end

    it "contains two variants" do
      expect(@clc_variants["test1"].size).to be(2)
    end

    it "displays first SNP" do
      expect(@clc_variants["test1"][0].to_s).to eql("snp_unittest_clc\t5\t" \
      "SNP\t1\tA\tG\tHomozygous\t10\t10\t100.0\t0.066\t34.036")
    end

    it "displays first MNP" do
      expect(@clc_variants["test1"][1].to_s).to eql("snp_unittest_clc\t11\t" \
      "MNP\t2\tTG\tGA\tHomozygous\t15\t15\t100.0\t0.292\t37.508")
    end

    it "raises exeption on > 2 fasta sequences" do
      r_seq = Dir.pwd + "/data/test2.fasta"
      log = Logger.new(STDOUT)
      log.level = Logger::ERROR
      v_tool = VariantTools.new(r_seq, 5, 4, :SNP, log)
      expect{
      	v_tool.read_files(Dir.pwd + "/data/unit_tests/")
      }.to raise_error(Exception)
    end
  end

  context "read SNP data with contigs" do

  	before(:each) do
  	  @ref_seq = Dir.pwd + "/data/test2.fasta"
      logger = Logger.new(STDOUT)
      logger.level = Logger::ERROR
      @variant_tool = VariantTools.new(@ref_seq, 5, 4, :SNP, logger)
      @clc_variants = @variant_tool.read_files(Dir.pwd + "/data/snp_contigs/")
    end

    it "contains 2 contigs" do
      expect(@clc_variants.size).to be(2)
    end

    it "contig 'test1' displays one SNP" do
      expect(@clc_variants["test1"][0].to_s).to eql("snp_test4_clc\t7\t" \
      "SNP\t1\tG\tA\tHomozygous\t10\t10\t100.0\t0.066\t34.036")
    end

    it "contig 'test2' displays one SNP" do
      expect(@clc_variants["test2"][0].to_s).to eql("snp_test5_clc\t7\t" \
      "SNP\t1\tT\tC\tHomozygous\t10\t10\t100.0\t0.066\t34.036")
    end

  end

  context "read INDEL data" do

  	before(:each) do
  	  @ref_seq = Dir.pwd + "/data/test.fasta"
      logger = Logger.new(STDOUT)
      logger.level = Logger::ERROR
      @variant_tool = VariantTools.new(@ref_seq, 5, 4, :INDEL, logger)
      @clc_variants = @variant_tool.read_files(Dir.pwd + "/data/indel_test1/")
    end

    it "contains 1 contig" do
      expect(@clc_variants.size).to be(1)
    end
    
    it "contains 8 variants" do
      expect(@clc_variants["test1"].size).to be(8)
    end

     it "displays first INDEL" do
      expect(@clc_variants["test1"][0].to_s).to eql("indel_test1_clc\t11\t" \
      "Deletion\t5\tTGGCG\t-\tHomozygous\t0\t0\t0.0\t0.0\t0.0")
    end

  end

  context "make sequinom report" do
    it "make report for sequinom"
  end

end