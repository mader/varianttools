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

module AnalysisHelper

  def get_clc_variants_from_file_input(fasta_file,
                                       input_dir,
                                       cov_input_dir,
                                       min_flank1,
                                       min_flank2,
                                       calling_type)
    variant_tool = create_variant_tools(fasta_file,
                                        min_flank1,
                                        min_flank2,
                                        calling_type)
    if(!cov_input_dir.eql?(""))
      variant_tool.read_mapping_coverage(Dir.pwd + cov_input_dir)
    end
    return variant_tool.read_files(Dir.pwd + input_dir), variant_tool
  end

  def get_sequinom_variants_from_file_input(fasta_file,
                                            input_dir,
                                            cov_input_dir,
                                            min_flank1,
                                            min_flank2,
                                            calling_type)
    clc_variants, variant_tool = get_clc_variants_from_file_input(fasta_file,
                                                                   input_dir,
                                                                   cov_input_dir,
                                                                   min_flank1,
                                                                   min_flank2,
                                                                   calling_type)
    return variant_tool.make_report_for_sequinom(clc_variants)
  end

  def compare_results(expected_result_path, options, sequinom_variants)
    expected_result = File.open(
        Dir.pwd + expected_result_path) do |f|
      f.read
    end

    file_output = FileOutput.new
    file_output.write_table(options, sequinom_variants)  

    output_result = File.open(Dir.pwd + '/output.tsv') do |f|
      f.read
    end

    return expected_result, output_result
  end

  def create_variant_tools(fasta_file,
                           min_flank1,
                           min_flank2,
                           calling_type)
    ref_seq = Dir.pwd + fasta_file
    logger = Logger.new(STDOUT)
    logger.level = Logger::ERROR
    return variant_tool = VariantTools.new(ref_seq,
                                           min_flank1,
                                           min_flank2,
                                           calling_type,
                                           logger)
  end
end