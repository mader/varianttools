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

require '../lib/tools.rb'
require '../lib/constants.rb'
require '../lib/clc_variant.rb'
require '../lib/sequinom_variant.rb'
require '../lib/option_parser.rb'
require '../lib/file_output.rb'
require 'logger'

options = OptionParser.parse(ARGV)

logger = Logger.new('logfile.log')

logger.info(APP_NAME + " Version: "  + VERSION + " " + VDATE)
logger.info("")
logger.info("Parameters:")
logger.info("-----------")

folder = ""
if(options.input_folder.eql?(""))
  folder = Dir.pwd
else
  folder = options.input_folder
end

logger.info("Reference file: " + options.ref_file)
logger.info("Input folder: " + folder)
logger.info("Data type: " + options.type.to_s)
logger.info("Flanking length: " + options.flanks[0].to_s + ", " + \
                                  options.flanks[1].to_s)
logger.info("Discard empty flanks: " + options.discard_empty_fanks.to_s)
if(options.freqency_thr > 0)
  logger.info("Frequency threshold: " + options.freqency_thr.to_s)
end

logger.info("-----------")

snp_tools = VariantTools.new(options.ref_file,
                         options.flanks[0].to_i,
                         options.flanks[1].to_i,
                         options.type,
                         logger)

logger.info("Read Files...")
variants = snp_tools.read_files(options.input_folder)

#variants.each do |k,v|
#  v.each do |v2|
#    puts k + "\t" + v2.to_s
#  end
#end
#puts "\n\n"

logger.info("Generate summary table...")
s_variants = snp_tools.make_report_for_sequinom(variants)

#s_variants.each do |k,v|
#  v.each do |v2|
#    puts k + "\t" + v2.to_s
#  end
#end

logger.info("Write data to file...")

#ref_name = File.basename(options.ref_file)
#header = true

file_output = FileOutput.new

file_output.write_table(options, s_variants)

#write all sequinome variants to file
=begin
open('output.tsv', 'w') do |f|
  s_variants.each do |k,v|
    if(header)
      f.puts MAPPING + "\t" + REFPOS + "\t" + TYPE + "\t" + LENGTH + "\t" + REF + " (#{ref_name})" + "\t" + \
      v[0].specimen_alts_to_s("keys") + "\t" + \
      NOF_DEV_FROM_REF + "\t" + \
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
=end


logger.info("")

#end
