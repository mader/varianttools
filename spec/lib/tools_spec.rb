#!/usr/bin/env ruby
=begin
  Copyright (c) 2014-2015 Malte Mader <malte.mader@ti.bund.de>
  Copyright (c) 2014-2015 Thünen Institute of Forest Genetics

  Permission to use, copy, modify, and distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.
  
  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
=end

require 'spec_helper'
require 'option_parser'
require_relative '../support/analysis_helper'

describe VariantTools do
  include AnalysisHelper

  context "read SNP data without contigs" do

    before(:each) do
      result = get_clc_variants_from_file_input("/data/test.fasta",
      	                                        "/data/unit_tests/",
      	                                        4,
      	                                        5,
      	                                        :SNP)
      @clc_variants = result[0]
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
      }.to raise_error(IOError)
    end
  end

  context "read SNP data with contigs" do

  	before(:each) do
      result = get_clc_variants_from_file_input("/data/test2.fasta",
      	                                        "/data/snp_contigs/",
      	                                        4,
      	                                        5,
      	                                        :SNP)
      @clc_variants = result[0]
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
      result = get_clc_variants_from_file_input("/data/test.fasta",
      	                                         "/data/indel_test1/",
      	                                         4,
      	                                         5,
      	                                         :SNP)
      @clc_variants = result[0]
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
  	pending("Do we need this?")
  end
end