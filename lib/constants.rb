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

#CLC Genomics Workbench v7.5 variant columns
MAPPING           = "Mapping"
CHR               = "Chromosome"
REFPOS            = "Reference Position"
REGION            = "Region"
TYPE              = "Type"
LENGTH            = "Length"
REF               = "Reference"
ALT               = "Allele"
ZYG               = "Zygosity"
COUNT             = "Count"
COV               = "Coverage"
FREQ              = "Frequency"
FORREVBAL         = "Forward/reverse balance"
QUAL              = "Average quality"
REPEAT            = "Repeat"
NOF_READS         = "# Reads"
SEQ_COMPLEXITY    = "Sequence complexity"

#Own Header definitions
NOF_DEV_FROM_REF  = "Number Of Individual Allels Deviating From Reference"
CRIT_POLY_STECH   = "Crtitical Poly Strech"
CRIT_FORREVBAL    = "Critical Forward Reverse Balance"
LEFT_FLANK        = "Left Flank"
RIGHT_FLANK       = "Right Flank"

#Data types
SNP       = "SNP"
INDEL     = "INDEL"
SV        = "CNV"

#Meta values
APP_NAME = "Variant Tools"
VERSION = "1.0"
VDATE = "28-08-2015"