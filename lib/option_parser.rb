#!/usr/bin/env ruby
=begin
  Copyright (c) 2014-2015 Malte Mader <malte.mader@thuenen.de>
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

require 'optparse'
require 'ostruct'
require_relative '../lib/constants'
require_relative '../lib/version'

class OptionParser

  def self.parse(args)

    options = OpenStruct.new
    options.ref_file = ""
    options.input_folder = ""
    options.coverage_input_folder = ""
    options.type = ""
    options.flanks = [75,50]
    options.discard_empty_fanks = false
    options.verbose = false
    options.freqency_thr = 0.0
    options.mapping_coverage_thr = 0
    options.number_of_alts_thr = 0
    options.number_of_refs_thr = 0
    options.min_cov_for_ref_thr = 3

    optparse = OptionParser.new do |opts|
  
      opts.banner = "Usage: varianttools.rb [options]"

      opts.separator ""
      opts.separator "Options:"

      opts.on('-f', '--file FILE', "FASTA File containing the reference",
               "sequence(s)") do |f|
        options.ref_file = f
      end 

      opts.on('-i', '--input [DIR]', "Specify the input folder containing all",
               "input files. (default is .)") do |f|
      options.input_folder = f
      end

      opts.on('-I', '--coverage-input [DIR]', "Specify the input folder containing all",
               "coverage files.") do |f|
      options.coverage_input_folder = f
      end

      opts.on('-t', '--type OPT', [:SNP, :INDEL], "Specify the data type to be processed.",
               "(Valid values are SNP, INDEL)") do |f|
      options.type = f 
      end

      opts.on('-d', '--dist-flanks x,y ', Array,
              "List of descending numeric distance thresholds to next snps",
              "to determine flanking sequences (default is 75,50)") do |l|
        options.flanks = l
      end 

      opts.on('-e', '--discard-empty-flanks', "If set all SNPs without a",
              "flanking sequence 3' or 5' will be discarded") do
        options.discard_empty_fanks = true
      end

      opts.on( '-F', '--freq [NUM]', Float, "Discard all SNPs below the",
               "provided frequency threshold" ) do |f|
        options.freqency_thr = f
      end

      opts.on( '-m', '--mapping_cov [NUM]', Integer, "Discard all variants below the",
               "provided mapping coverage threshold" ) do |f|
        options.mapping_coverage_thr = f
      end

      opts.on( '-a', '--number-of-called-alts [NUM]', Integer, "Discard all positions with ",
        "less than the provided threshold of called variants" ) do |f|
        options.number_of_alts_thr = f
      end

      opts.on( '-r', '--number-of-called-refs [NUM]', Integer, "Discard all positions with ",
        "less than the provided threshold of called references" ) do |f|
        options.number_of_refs_thr = f
      end

      opts.on( '-c', '--minimum-coverage-for-ref [NUM]', Integer, "Provide a minimum coverage threshold  ",
        "for calling reference bases." ) do |f|
        options.min_cov_for_ref_thr = f
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end

      opts.on_tail("--version", "Show version") do
        puts ""
        puts APP_NAME + " Version: " + VERSION + " " + VDATE
        puts ""
        puts "Copyright (c) 2014-2015 Malte Mader <malte.mader@ti.bund.de>"
        puts "Copyright (c) 2014-2015 Thünen Institute of Forest Genetics"
        exit
      end
    end
  optparse.parse!(args)

  if(options.ref_file.eql?(""))
    puts ""
    puts "A FASTA file containing reference sequence(s) must be provided! (Option -f)"
    puts ""
    puts optparse
    exit
  end

  if(options.type.eql?(""))
    puts ""
    puts "A data type for processing must be provided! (Option -t)"
    puts ""
    puts optparse
    exit
  end

  return options
  end

end