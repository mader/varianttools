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

require_relative '../lib/variant'

class CLCVariant < Variant

  attr_accessor :count, :coverage, :frequency, :for_rev_balance, :repeat,
                :nof_reads, :seq_complexity, :mapping_coverage
                
  def initialize(specimen_name,
                 position,
                 type,
                 length,
                 ref,
                 alt,
                 zygosity,
                 count,
                 coverage,
                 frequency,
                 for_rev_balance,
                 quality,
                 calling_type)
    super(specimen_name,
          position,
          type,
          length,
          ref,
          alt,
          zygosity,
          quality,
          calling_type)
    #SNP specific values
    @count = count
    @coverage = coverage
    @frequency = frequency
    @for_rev_balance = for_rev_balance
    #INDEL specific values
    @repeat = ""
    @nof_reads = 0
    @seq_complexity = 0.0
    #optional coverage
    @mapping_coverage = -1
  end
  
  def to_s
    return @specimen_name + "\t" + @position.to_s + "\t" + @type + "\t" + \
           @length.to_s + "\t" + @ref + "\t" + @alt + "\t" + \
           @mapping_coverage.to_s + "\t" + @zygosity + "\t" + @count.to_s + "\t" + \
           @coverage.to_s + "\t" + @frequency.to_s + "\t" + \
           @for_rev_balance.to_s + "\t" + @quality.to_s
  end
end