#!/usr/bin/env ruby

=begin
  Copyright (c) 2017 Malte Mader <malte.mader@thuenen.de>
  Copyright (c) 2017 Thünen Institute of Forest Genetics

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

class VariantStats

  # coverage, frequency and quality are arrays of size 4. They store min, max,
  # sum, and average values in this order.
  attr_accessor :specimen, :nof_variants, :coverage, :frequency, :quality,
                :nof_reads, :var_type, :type
                
  def initialize(specimen,
                 coverage,
                 frequency,
                 quality,
                 nof_reads,
                 var_type,
                 type)
    @specimen = specimen
    if(coverage == 0)
      @nof_variants = 0
    else
      @nof_variants = 1
    end
    if(type.to_s.eql?(INDEL) && nof_reads > 0)
      @nof_variants = 1
    end
    @coverage = Array.new
    @coverage[0] = coverage
    @coverage[1] = coverage
    @coverage[2] = coverage
    @frequency = Array.new
    @frequency[0] = frequency
    @frequency[1] = frequency
    @frequency[2] = frequency
    @quality = Array.new
    @quality[0] = quality
    @quality[1] = quality
    @quality[2] = quality
    @var_type = Hash.new
    if(!var_type.eql?(""))
      @var_type.store(var_type, 1)
    end
    @type = type
  end
  
  def calc_average(arr)
    if(@nof_variants > 0)
      arr[3] = arr[2].to_f/@nof_variants.to_f
    else
      arr[3] = 0
    end
  end

  def set_values(value, type)
    arr = case type
      when "coverage" then @coverage
      when "frequency" then @frequency
      when "quality" then @quality
      else "invalid"
    end

    if(arr[0] > value)
      arr[0] = value
    end

    if(arr[1] < value)
      arr[1] = value
    end

    arr[2] += value

  end

  def to_s(type)
    if(type.to_s.eql?(SNP))
      str = "#{@specimen}\t#{@nof_variants}\t#{@coverage[0]}\t" \
          "#{@coverage[1]}\t" \
          "#{@coverage[3].round(2)}\t#{@frequency[0].round(2)}\t" \
          "#{@frequency[1].round(2)}\t" \
          "#{@frequency[3].round(2)}\t#{@quality[0].round(2)}\t" \
          "#{@quality[1].round(2)}\t" \
          "#{@quality[3].round(2)}\t#{@var_type["SNP"]}\t#{@var_type["MNP"]}\t" \
          "#{@var_type["Insertion"]}\t#{@var_type["Deletion"]}\n"
    end
    if(type.to_s.eql?(INDEL))
      str = "#{@specimen}\t#{@nof_variants}\t" \
            "#{@var_type["Insertion"]}\t#{@var_type["Deletion"]}\n"
    end
    return str
  end
end