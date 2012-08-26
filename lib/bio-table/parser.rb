require 'csv'

module BioTable

  module LineParser

    # Converts a string into an array of string fields
    def LineParser::parse(line, in_format, split_on)
      if in_format == :csv
        CSV.parse(line)[0]
      elsif in_format == :split
        line.strip.split(split_on).map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      elsif in_format == :regex
        line.strip.split(/#{split_on}/).map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      else
        line.strip.split("\t").map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      end
    end
    
  end

end
