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

require_relative "../lib/tools.rb"

require "minitest/autorun"

class TestTools < MiniTest::Test

  def setup

    @ref_seq = "../data/test2.fasta"

    logger = Logger.new(STDOUT)

    @var = SNPTools.new(@ref_seq, 5, 4, :SNP, logger)

    @clc_variants = @var.read_files("../data/unit_tests/")

    @sequinom_variants = @var.make_report_for_sequinom(@clc_variants)

  end

  def test_tools_field
    assert_equal(@ref_seq, @var.ref_seq)

  end

  def test_tools_read_files

    assert_equal(1, @clc_variants.length)

    v = @clc_variants.shift()

    assert_equal(1, @v.size)

    assert_equal(5, v[0].position)
    assert_equal("SNP", v[0].type)
    assert_equal(1, v[0].length)
    assert_equal("A", v[0].ref)
    assert_equal("G", v[0].alt)
    assert_equal("Homozygous", v[0].zygosity)
    assert_equal(10, v[0].count)
    assert_equal(10, v[0].coverage)
    assert_equal(100, v[0].frequency)
    assert_in_delta(0.066, v[0].for_rev_balance, 0.001)
    assert_in_delta(34.036, v[0].quality, 0.001)

  end

  def test_tools_make_report_for_sequinom
    assert_equal(5, @sequinom_variants[0][0].position)
    assert_equal("SNP", @sequinom_variants[0].type)
    assert_equal(1, @sequinom_variants[0].length)
    assert_equal("A", @sequinom_variants[0].ref)
    assert_equal("[A/G]", @sequinom_variants[0].shared_alt)
    assert_equal(1, @sequinom_variants[0].number_of_alts)
    assert_equal("", @sequinom_variants[0].crit_poly_strech_to_s)
    assert_equal("0.066", @sequinom_variants[0].crit_for_rev_bal_to_s)
    assert_equal(5, @sequinom_variants[0].dist_next_variant_left)
    assert_equal(6, @sequinom_variants[0].dist_next_variant_right)
    assert_equal("ATCG", @sequinom_variants[0].left_flank)
    assert_equal("TGCAT", @sequinom_variants[0].right_flank)
    assert_equal(1, @sequinom_variants[0].specimen_alts.size)
    assert_equal("snp_unittest_clc",
                 @sequinom_variants[0].specimen_alts_to_s("keys"))
    assert_equal("C\tT\tC", @sequinom_variants[0].specimen_alts_to_s("values"))


  end
end