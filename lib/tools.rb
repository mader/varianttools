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
require_relative '../lib/clc_variant.rb'
require_relative '../lib/sequinom_variant.rb'
require 'bio'
require 'logger'
require 'byebug'

class VariantTools

  attr_accessor :specimen_names, :ref_seq, :ref_length, :min_flank1,
                :min_flank2, :type, :logger, :mapping_coverages

  def initialize(ref_seq, min_flank1, min_flank2, type, logger)
    @specimen_names = Array.new
    @ref_seq = ref_seq
    @ref_length = Hash.new
    @min_flank1 = min_flank1
    @min_flank2 = min_flank2
    @type = type
    @contig = ""
    @nof_contigs = 0
    @logger = logger
    @mapping_coverages = nil

    logger.info("Read reference file...")
    logger.info("Contig lengths:")

    @ff = Bio::FlatFile.open(Bio::FastaFormat, @ref_seq)

    @ff.each do |entry|
      @ref_length.store(entry.definition, entry.length)
      # if there is only one sequence we can set it here
      @contig = entry.definition
      @nof_contigs += 1
      logger.info(entry.definition + ": " + entry.length.to_s + "bp")
    end

    logger.info("--------------------")

  end

  def read_mapping_coverage(file_path)

    @mapping_coverages = Hash.new

    files = Dir.glob(file_path + '*.csv').sort

    files.each do |file|

      name = File.basename(file).split(".")[0]
      contigs = Hash.new
      pos_and_cov = nil

      File.open(file, "r") do |f|
        f.each_line do |line|
          
            sline = line.chop.split("\t")
            
            contig_name = sline[0]
            pos = sline[1].to_i
            cov = sline[10].to_i

            if(!contigs.key?(contig_name))
              pos_and_cov = Hash.new
              contigs.store(contig_name, pos_and_cov)
            end

            pos_and_cov.store(pos, cov)
        end
      end
      mapping_coverages.store(name, contigs)
    end
  end

  def read_files(file_path)

  contigs = Hash.new

  #Read all variants from all files and store them in an array of variant
  #objects.
  files = Dir.glob(file_path + '*.csv').sort

  files.each do |file|

    logger.info("Process file: " + file)

    is_header = true
    columns = Hash.new
   
    name = File.basename(file).split(".")[0]
    
    @specimen_names.push(name)

    all_variants = nil

    File.open(file, "r") do |f|
      f.each_line do |line|
        
        sline = line.chop.split(";")

        #Associate header names with column ids.
        if(is_header)
          column_id = 0
          sline.each do |entry|
            columns.store(entry.delete("\""), column_id)
            column_id += 1
          end
     
          is_header = false
     
        #Read and store the actual data.
        else

          locus = ""
          
          if(@type.to_s.eql?(SNP))
            locus = MAPPING
          end
          if(@type.to_s.eql?(INDEL))
            locus = CHR
          end

          if(!columns.key?(locus) && @nof_contigs > 1)
            begin
            raise IOError,"Error: Your input data does not specify a contig" \
                  "name. But your fasta file contains more than one" \
                  "sequence. Please use either a fasta file with just one" \
                  "sequence, or specify the contig to use in your csv file(s)."
            end
          end

          if(columns.key?(locus))
            @contig = sline[columns[locus]].delete("\"")
            if(!@ref_length.key?(@contig))
              raise IOError, "Error: your csv file contains contig names " \
                    "that do not match any contig name in your fasta file"
            end
          end
          if(contigs.key?(@contig))
            all_variants = contigs[@contig]
          else
            all_variants = Array.new
            contigs.store(@contig, all_variants)
          end

          seperator = ""
          index = 0
          var_type = sline[columns[TYPE]].delete("\"").gsub("V","P")
          if(var_type.eql?("Insertion"))
            seperator = "^"
            index = 1
          end
          if(var_type.eql?("Deletion"))
            seperator = ".."
          end

          if(columns[REGION])
            refpos = sline[columns[REGION]].delete("\"").split(seperator)[index].to_i
          else
            refpos = sline[columns[REFPOS]].delete("\"").to_i
          end

          length = sline[columns[LENGTH]].delete("\"").to_i
          ref = sline[columns[REF]].delete("\"")
          alt = sline[columns[ALT]].delete("\"")
          zyg = sline[columns[ZYG]].delete("\"")

          #SNP specific
          count = sline[columns[COUNT]].delete("\"").to_i
          cov = sline[columns[COV]].delete("\"").to_i
          freq = sline[columns[FREQ]].delete("\"").gsub(',', '.').to_f
          forrevbal = sline[columns[FORREVBAL]].delete("\"").gsub(',', '.').to_f
          qual = sline[columns[QUAL]].delete("\"").gsub(',', '.').to_f

          #INDEL specific
          if(columns[REPEAT] != nil)
            repeat = sline[columns[REPEAT]].delete("\"")
          end
          if(columns[NOF_READS] != nil)
            nof_reads = sline[columns[NOF_READS]].delete("\"").to_i
          end
          if(columns[SEQ_COMPLEXITY])
            seq_complexity = sline[columns[SEQ_COMPLEXITY]]
            .delete("\"").gsub(',', '.').to_f
          end

          variant = CLCVariant.new(name,
                                   refpos,
                                   var_type,
                                   length,
                                   ref,
                                   alt,
                                   zyg,
                                   count,
                                   cov,
                                   freq,
                                   forrevbal,
                                   qual,
                                   @type)

          variant.repeat = repeat
          variant.nof_reads = nof_reads
          variant.seq_complexity = seq_complexity

          if(@mapping_coverages != nil )
            mapping_coverage = @mapping_coverages[name][@contig][refpos]
            variant.mapping_coverage = mapping_coverage
          end

          all_variants.push(variant)

        end
      end
    end
  end

  return contigs
end

def make_report_for_sequinom(contigs)

  sv_contigs = Hash.new
  contigs.each do |k,v|

     logger.info("Process variants for contig " + k)

    #find and merge redundant snps
    logger.info("--> Merge redundant variants...")
    all_seqinom_variants = Hash.new

    v.each do |va|

      all_seqinom_variants_key = va.position.to_s + va.type.to_s
  
      if(sequinom_variant = all_seqinom_variants[all_seqinom_variants_key])
        sequinom_variant.specimen_alts[va.specimen_name] = va.alt
        sequinom_variant.specimen_zygs[va.specimen_name] = va.zygosity
        sequinom_variant.specimen_covs[va.specimen_name] = va.coverage
        sequinom_variant.specimen_mapping_cov[va.specimen_name] = va.mapping_coverage
        sequinom_variant.specimen_freqs[va.specimen_name] = va.frequency
        sequinom_variant.number_of_alts += 1
        sequinom_variant.clc_variants.push(va)
  
      else
        sequinom_variant = SequinomVariant.new(va.position,
                                               va.type,
                                               va.length,
                                               va.ref,
                                               va.calling_type)
        specimen_alts = Hash.new

        @specimen_names.each do |n|
          specimen_alts.store(n, "nc")
        end

        sequinom_variant.specimen_mapping_cov = Hash.new

        @specimen_names.each do |n|
           sequinom_variant.specimen_mapping_cov.store(n, -1)
        end

        sequinom_variant.clc_variants = Array.new().push(va)
        sequinom_variant.specimen_alts = specimen_alts
        sequinom_variant.specimen_alts[va.specimen_name] = va.alt
        sequinom_variant.specimen_zygs = Hash.new
        sequinom_variant.specimen_zygs[va.specimen_name] = va.zygosity
        sequinom_variant.specimen_covs = Hash.new
        sequinom_variant.specimen_covs[va.specimen_name] = va.coverage
        sequinom_variant.specimen_freqs = Hash.new
        sequinom_variant.specimen_freqs[va.specimen_name] = va.frequency
        sequinom_variant.specimen_mapping_cov[va.specimen_name] = va.mapping_coverage
        sequinom_variant.number_of_alts = 1
        sequinom_variant.length = va.length

        all_seqinom_variants.store(all_seqinom_variants_key, sequinom_variant)
      end
    end

    sequinom_variants = all_seqinom_variants.values.sort {|x,y|
      x.position <=> y.position
    }

    #calculate distances to neighbouring snps
    logger.info("--> Calculate flanking sequences...")
    i = 0
    sequinom_variants.each do |sv|

      if(i-1 >= 0)
        pred = nil
        if(sequinom_variants[i-1].position == sv.position && i > 1)
          pred = sequinom_variants[i-2]
        else
          pred = sequinom_variants[i-1]
        end
        if(i > 1 && sequinom_variants[i-1].position == sequinom_variants[i-2].position)
          pred = sequinom_variants[i-1].length > sequinom_variants[i-2].length ?
         sequinom_variants[i-1] : sequinom_variants[i-2]
        end
        if(pred.type.eql?("Insertion"))
          length = 0
        else
          length = pred.length
        end
        sv.dist_next_variant_left = sv.position - pred.position - length+1
      else 
        sv.dist_next_variant_left = sv.position
      end

      length = sv.length
      if(sv.type.eql?("Insertion"))
        length = 0
      end

      if(i+1 < sequinom_variants.size)

        succ = sequinom_variants[i+1]
        succ_pos = succ.position

        if(sequinom_variants[i+1].position == sv.position)
          if((i+2 < sequinom_variants.size))
            succ = sequinom_variants[i+2]
            succ_pos = succ.position
          else
            succ_pos = @ref_length[k]
          end
        end

        sv.dist_next_variant_right = succ_pos - sv.position - length+1
      else
        sv.dist_next_variant_right = @ref_length[k] - sv.position - length+1
      end

      #calculate and mark critical for_ref_balance and avg frequency
      average_forrevbal = 0
      sum_forrevbal = 0

      average_freq = 0
      sum_freq = 0
      sv.clc_variants.each do |cv|
        sum_forrevbal += cv.for_rev_balance
        sum_freq += cv.frequency
      end
      average_freq = sum_freq / sv.clc_variants.size
      sv.frequency = average_freq
      average_forrevbal = sum_forrevbal / sv.clc_variants.size
      sv.for_rev_balance = average_forrevbal
      if (average_forrevbal < 0.2 || average_forrevbal > 0.8)
        sv.critical_for_rev_balance = true
      end

      #Make a string representging the alts of all specimen
      sv.create_shared_alt

      #calc left and right flanks using bioruby
      Bio::FlatFile.open(Bio::FastaFormat, @ref_seq) do |ff|
        ff.each do |entry|
          if(entry.definition.eql?(k))
            if(sv.dist_next_variant_left > @min_flank1)
             sv.left_flank = entry.seq[sv.position-1-@min_flank1..sv.position-2]
            elsif(sv.dist_next_variant_left > @min_flank2)
              sv.left_flank = entry.seq[sv.position-1-@min_flank2..sv.position-2]
            end
            pos = 0
            if(sv.type.eql?("MNP") || sv.type.eql?("Deletion"))
              pos = sv.position + sv.length-1
            elsif(sv.type.eql?("Insertion"))
              pos = sv.position - 1
            else
              pos = sv.position
            end
            if(sv.dist_next_variant_right > @min_flank1)
              sv.right_flank = entry.seq[pos..pos-1 + @min_flank1]
            elsif(sv.dist_next_variant_right > @min_flank2)
              sv.right_flank = entry.seq[pos..pos-1 + @min_flank2]
            end
          end
        end
      end 
      i += 1
    end
  
  sv_contigs.store(k,sequinom_variants)
  end
  logger.info("--------------------")
  return sv_contigs

end
end