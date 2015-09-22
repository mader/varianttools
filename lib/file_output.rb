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

require_relative '../lib/constants.rb'
require_relative '../lib/sequinom_variant.rb'
require_relative '../lib/option_parser.rb'
require 'logger'

class FileOutput

  attr_accessor :v1, :v2

  def initialize()
  end

  def write_table(options, variants)
    
    ref_name = File.basename(options.ref_file)
    header = true

    #write all sequinome variants to file
    open('output.tsv', 'w') do |f|
      variants.each do |k,v|
        if(header)
          f.puts MAPPING + "\t" + REFPOS + "\t" + TYPE + "\t" + LENGTH + "\t" + REF + " (#{ref_name})" + "\t" + \
          v[0].specimen_alts_and_cov_to_s("keys") + "\t" + \
          NOF_DEV_FROM_REF + "\t" + NOF_CALLED_REFS + "\t" +\
          CRIT_FORREVBAL + "\t" + LEFT_FLANK + "\t" + \
          ALT + "\t" + RIGHT_FLANK
          header = false
        end
        v.each do |sq|

          filter = true
          conditions = Array.new()
    
          if(options.discard_empty_fanks)
            conditions.push(!sq.left_flank.eql?("") && !sq.right_flank.eql?(""))
          end
          if(options.mapping_coverage_thr > 0)
            conditions.push(sq.mapping_coverage > options.mapping_coverage_thr)
          end
          if(options.number_of_alts_thr > 0)
            conditions.push(sq.number_of_alts > options.number_of_alts_thr)
          end
          if(options.freqency_thr > 0)
            conditions.push(sq.frequency > options.freqency_thr)
          end

          conditions.each do |c|
            filter = filter && c
          end

          if(filter)
            f.puts k + "\t" + sq.to_s
          end
        end
      end
    end
  end

end