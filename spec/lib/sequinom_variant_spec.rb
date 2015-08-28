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

  describe SequinomVariant do

    before(:each) do
      @s_variant = SequinomVariant.new("5",
                       "SNV",
                       1,
                       "A",
                       :SNP)

  	  @s_alts = Hash.new
      @s_alts.store("SP1","A")
      @s_alts.store("SP2","T")
      @s_alts.store("SP3","G")
      @s_variant.specimen_alts = @s_alts

      @s_variant.create_shared_alt

      @s_variant.number_of_alts = 3

      @s_variant.crit_poly_strech = false
      @s_variant.critical_for_rev_balance = true
      @s_variant.for_rev_balance = 0.5

      @s_variant.dist_next_variant_left = 5
      @s_variant.dist_next_variant_right = 5

      @s_variant.left_flank = "ATTA"
      @s_variant.right_flank = "GCCG"

    end

    it "prints critical poly strech" do
      @s_variant.crit_poly_strech = true

      string = @s_variant.crit_poly_strech_to_s
      expect(string).to eql("x")
    end

    it "prints critical forward reverse balance" do
      @s_variant.for_rev_balance = 0.12345
      @s_variant.critical_for_rev_balance = true
      string = @s_variant.crit_for_rev_bal_to_s
      expect(string).to eql("0.123")
    end

    it "prints shared alt" do
      string = @s_variant.shared_alt
      expect(string).to eql("[A/T/G]")
    end

    it "prints specimen names" do
      string = @s_variant.specimen_alts_to_s("keys")
      expect(string).to eql("SP1\tSP2\tSP3")
    end

  	it "prints out its SNP contents" do
  	  expect(@s_variant.to_s).to eql("5\tSNV\t1\tA\tA\tT\tG\t3\t0.5" \
  	  	                              "\tATTA\t[A/T/G]\tGCCG")
  	end
  end