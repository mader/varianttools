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

require_relative '../lib/tools.rb'
require_relative '../lib/constants.rb'
require_relative '../lib/version.rb'
require_relative '../lib/clc_variant.rb'
require_relative '../lib/sequinom_variant.rb'
require_relative '../lib/option_parser.rb'
require_relative '../lib/file_output.rb'
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
if(!options.coverage_input_folder.eql?(""))
logger.info("Input coverage folder: " + options.coverage_input_folder)
end
logger.info("Data type: " + options.type.to_s)
logger.info("Flanking length: " + options.flanks[0].to_s + ", " + \
                                  options.flanks[1].to_s)
logger.info("Discard empty flanks: " + options.discard_empty_fanks.to_s)
if(options.freqency_thr > 0)
  logger.info("Frequency threshold: " + options.freqency_thr.to_s)
end
if(options.mapping_coverage_thr > 0)
  logger.info("Coverage threshold: " + options.mapping_coverage_thr.to_s)
end


logger.info("-----------")

snp_tools = VariantTools.new(options.ref_file,
                         options.flanks[0].to_i,
                         options.flanks[1].to_i,
                         options.type,
                         logger)

if(!options.coverage_input_folder.eql?(""))
  logger.info("Read coverage files...")
  snp_tools.read_mapping_coverage(options.coverage_input_folder)
end

logger.info("Read variant files...")

variants = nil

begin
  variants = snp_tools.read_files(options.input_folder)
rescue IOError => e
  puts e.message
  logger.error(e.message)
  exit(1)
end

logger.info("Generate summary table...")
s_variants = snp_tools.make_report_for_sequinom(variants)

logger.info("Write data to file...")

file_output = FileOutput.new
file_output.write_table(options, s_variants)

logger.info("")
