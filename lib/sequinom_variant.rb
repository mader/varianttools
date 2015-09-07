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

require_relative '../lib/clc_variant.rb'
require_relative '../lib/constants.rb'

class SequinomVariant < CLCVariant

  attr_accessor :specimen_alts, :shared_alt, :number_of_alts,
                :specimen_zygs, :specimen_covs, :specimen_freqs,
                :specimen_mapping_cov, :crit_poly_strech,
                :critical_for_rev_balance,
                :dist_next_variant_left, :dist_next_variant_right,
                :left_flank, :right_flank, :clc_variants

  def initialize(position,
                 type,
                 length,
                 ref,
                 calling_type)
    super("",
          position,
          type,
          length,
          ref,
          "",
          "",
           0,
           0,
           0,
           0,
           0,
           calling_type)
    @left_flank = ""
    @right_flank = ""
    @shared_alt = ""
    @number_of_alts = 0
    crit_poly_strech = false
    critical_for_rev_balance = false
    @dist_next_variant_left = 0
    @dist_next_variant_right = 0
  end

  def crit_poly_strech_to_s
    return @crit_poly_strech ? "x" : ""
  end

  def crit_for_rev_bal_to_s
    crit_avg_bal = ""
    if(calling_type.to_s.eql?(SNP))
      crit_avg_bal = @critical_for_rev_balance ? @for_rev_balance.round(3).to_s : ""
    end
    #what about INDELs?
    return crit_avg_bal
  end
  
  #Make a string representging the alts of all specimen
  def create_shared_alt
    shared_alts = Array.new
    
    @specimen_alts.values.each do |a|
      if(!shared_alts.include?(a) && !a.eql?(@ref))
        shared_alts.push(a)
      end
    end

    alt_str =  "[" + @ref + "/"
    alts_without_nc = shared_alts.reject{ |entry| entry.eql?("nc") }
    alts_without_nc.each_with_index do |sa, i|
        if (i < alts_without_nc.size-1)
          alt_str += sa + "/"
        else
          alt_str += sa
        end
    end
    alt_str += "]"

    @shared_alt = alt_str
  end

  def specimen_alts_and_cov_to_s(type)
    str = ""
    @specimen_alts.each_with_index do |(k,v),i|
      if(type == "keys")
        entry = k + " (alt)" + "\t" + k + " (coverage)"
      else
        entry = v + "\t" + @specimen_mapping_cov[k].to_s
      end
      if (i < specimen_alts.size-1)
        str += entry + "\t"
      else
        str += entry
      end
    end
    return str
  end

  #maybe depricated...
  def specimen_alts_to_s(type)
    str = ""
    alt_data = nil

    if(type == "keys")
      alt_data = @specimen_alts.keys
    elsif(type == "values")
      alt_data = @specimen_alts.values
    end

    alt_data.each_with_index do |d,i|
      if (i < alt_data.size-1)
        str += d + "\t"
      else
        str += d
      end
    end
    return str
  end

  def to_s
    str = @position.to_s + "\t" + @type + "\t" + @length.to_s + "\t" + \
          @ref + "\t" + specimen_alts_and_cov_to_s("values") + "\t" + \
          @number_of_alts.to_s + "\t" + \
          crit_for_rev_bal_to_s + "\t" + @left_flank  + "\t" + \
          @shared_alt + "\t" + @right_flank

    return str
  end
end