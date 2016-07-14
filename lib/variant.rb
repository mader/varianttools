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

class Variant

  attr_accessor :specimen_name, :position, :type, :length, :ref, :alt,
                :zygosity, :quality, :calling_type
                
  def initialize(specimen_name,
                 position,
                 type,
                 length,
                 ref,
                 alt,
                 zygosity,
                 quality,
                 calling_type)
    @specimen_name = specimen_name
    @position = position
    @type = type
    @length = length
    @ref = ref
    @alt = alt
    @zygosity = zygosity
    @quality = quality
    @calling_type = calling_type
  end
  
  def to_s
    return @specimen_name + "\t" + @position.to_s + "\t" + @type + "\t" + \
           @length.to_s + "\t" + @ref + "\t" + @alt + "\t" + \
           @quality.to_s
  end
end
