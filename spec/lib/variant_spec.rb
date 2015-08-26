require 'spec_helper'

  describe Variant do
  	it "prints out its SNP contents" do
  	  variant = Variant.new("case1",
                 "5",
                 "SNV",
                 1,
                 "A",
                 "G",
                 "Homozygous",
                 37.5,
                 :SNP)

  	  expect(variant.to_s).to eql("case1\t5\tSNV\t1\tA\tG\t37.5")
  	end

  	it "prints out its INDEL contents" do
  	  variant = Variant.new("case2",
                 "10",
                 "Deletion",
                 6,
                 "TGGCGA",
                 "-",
                 "Homozygous",
                 30,
                 :INDEL)

  	  expect(variant.to_s).to eql("case2\t10\tDeletion\t6\tTGGCGA\t-\t30")
  	end
  end