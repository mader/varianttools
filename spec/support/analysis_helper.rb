module AnalysisHelper

  def get_clc_variants_from_file_input(fasta_file,
                                       input_dir,
                                       min_flank1,
                                       min_flank2,
                                       calling_type)
    variant_tool = create_variant_tools(fasta_file,
                                        input_dir,
                                        min_flank1,
                                        min_flank2,
                                        calling_type)
    return variant_tool.read_files(Dir.pwd + input_dir), variant_tool
  end

  def get_sequinom_variants_from_file_input(fasta_file,
                                            input_dir,
                                            min_flank1,
                                            min_flank2,
                                            calling_type)
    clc_variants, variant_tool = get_clc_variants_from_file_input(fasta_file,
                                                                   input_dir,
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

  private

  def create_variant_tools(fasta_file,
                           input_dir,
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