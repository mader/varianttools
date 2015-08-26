require 'spec_helper'

  describe CLCVariant do
  	it "prints out its SNP contents" do
  	  clc_variant = CLCVariant.new("case1",
                       "5",
                       "SNV",
                       1,
                       "A",
                       "G",
                       "Homozygous",
                       10,
                       10,
                       100,
                       0.5,
                       37.5,
                       :SNP)
  	  expect(clc_variant.to_s).to eql("case1\t5\tSNV\t1\tA\tG\tHomozygous\t10" \
  	  	                              "\t10\t100\t0.5\t37.5")
  	end
  end