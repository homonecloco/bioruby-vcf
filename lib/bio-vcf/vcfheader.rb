
module BioVcf

  module VcfHeaderParser
    def VcfHeaderParser.get_column_names(lines)
      lines.each do | line |
        if line =~ /^#[^#]/
          # the first line that starts with a single hash 
          names = line.split
          names[0].sub!(/^#/,'')
          return names
        end
      end
      nil
    end
  end

  class VcfHeader

    attr_reader :lines

    def initialize
      @lines = []
    end

    def add line
      @lines << line.strip
    end

    def version
      @version ||= lines[0].scan(/##fileformat=VCFv(\d+\.\d+)/)[0][0]
    end

    def column_names
      @column_names ||= VcfHeaderParser::get_column_names(@lines)
    end

    def columns
      @column ||= column_names.size
    end

    def samples
      @samples ||= column_names[9..-1]
    end

    def sample_index
      index = {}
      @header.samples.each_with_index { |k,i| index[k] = i+9 ; index[k.downcase] = i+9 }
      index
    end
  end

end
