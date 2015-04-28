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

require_relative "../lib/clc_variant.rb"

require "minitest/autorun"

class TestCLCVariant < MiniTest::Test

  def setup
    @specimen_name = "Testo"
    @position = "5"
    @type = "SNV"
    @length = 1
    @ref = "A"
    @alt = "G"
    @zygosity = "Homozygous"
    @count = 10
    @coverage = 10
    @frequency = 100.0
    @for_rev_balance = 0.5
    @quality = 37.5
    @calling_type = :SNP

    @var = CLCVariant.new(@specimen_name,
                 @position,
                 @type,
                 @length,
                 @ref,
                 @alt,
                 @zygosity,
                 @count,
                 @coverage,
                 @frequency,
                 @for_rev_balance,
                 @quality,
                 @calling_type)
  end

  def test_clc_variant_fields
    assert_equal(@specimen_name, @var.specimen_name)
    assert_equal(@position, @var.position)
    assert_equal(@type, @var.type)
    assert_equal(@length, @var.length)
    assert_equal(@ref, @var.ref)
    assert_equal(@alt, @var.alt)
    assert_equal(@zygosity, @var.zygosity)
    assert_equal(@count, @var.count)
    assert_equal(@coverage, @var.coverage)
    assert_in_delta(@frequency, @var.frequency, 0.001)
    assert_in_delta(@for_rev_balance, @var.for_rev_balance, 0.001)
    assert_in_delta(@quality, @var.quality, 0.001)
    assert_equal(@calling_type, @var.calling_type)
  end

  def test_clc_variant_to_s
    assert_equal(@specimen_name + "\t" + @position.to_s + "\t" + @type + "\t" + \
           @length.to_s + "\t" + @ref + "\t" + @alt + "\t" + \
           @zygosity + "\t" + @count.to_s + "\t" + @coverage.to_s + "\t" + \
           @frequency.to_s + "\t" + @for_rev_balance.to_s + "\t" + \
           @quality.to_s,
           @var.to_s)
  end
end