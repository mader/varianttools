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

require_relative "../lib/sequinom_variant.rb"

require "minitest/autorun"

class TestSequinomVariant < MiniTest::Test

  def setup
    @position = "5"
    @type = "SNV"
    @length = 1
    @ref = "A"
    @calling_type = :SNP
    
    @var = SequinomVariant.new(@position,
                 @type,
                 @length,
                 @ref,
                 @calling_type)

    @s_alts = Hash.new
    @s_alts.store("SP1","A")
    @s_alts.store("SP2","T")
    @s_alts.store("SP3","G")
    @var.specimen_alts = @s_alts

    @var.create_shared_alt

    @var.number_of_alts = 3
    @var.crit_poly_strech = false
    @var.critical_for_rev_balance = false
    @var.for_rev_balance = 0.5

    @var.dist_next_variant_left = 5
    @var.dist_next_variant_right = 5

    @var.left_flank = "ATTA"
    @var.right_flank = "GCCG"

  end

  def test_sequinom_variant_fields
    assert_equal(@position, @var.position)
    assert_equal(@type, @var.type)
    assert_equal(@length, @var.length)
    assert_equal(@ref, @var.ref)
    assert_equal(@calling_type, @var.calling_type)

    assert_equal(@s_alts.size, @var.specimen_alts.size)
    assert_equal(@s_alts.keys[1], @var.specimen_alts.keys[1])
    assert_equal(@s_alts.values[1], @var.specimen_alts.values[1])

    assert_equal("[A/T/G]", @var.shared_alt)
    assert_equal(3, @var.number_of_alts)

    assert_equal("", @var.crit_poly_strech_to_s)
    assert_equal("", @var.crit_for_rev_bal_to_s)

    @var.crit_poly_strech = true
    @var.for_rev_balance = 0.1
    @var.critical_for_rev_balance = true

    assert_equal("x", @var.crit_poly_strech_to_s)
    assert_equal("0.1", @var.crit_for_rev_bal_to_s)

    assert_equal(5, @var.dist_next_variant_left)
    assert_equal(5, @var.dist_next_variant_right)

    assert_equal("ATTA", @var.left_flank)
    assert_equal("GCCG", @var.right_flank)

    assert_equal("SP1\tSP2\tSP3", @var.specimen_alts_to_s("keys"))
    assert_equal("A\tT\tG", @var.specimen_alts_to_s("values"))

  end

  def test_sequinom_variant_to_s
    assert_equal(@position.to_s + "\t" + \
                 @type + "\t" + \
                 @length.to_s + "\t" + \
                 @ref + \
                 "\tA\tT\tG\t3\t\tATTA\t[A/T/G]\tGCCG", @var.to_s)
  end
end