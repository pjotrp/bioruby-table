require 'csv'

module BioTable

  module LineParser

    def LineParser::parse(line, in_format)
      if in_format == :csv
        CSV.parse(line)[0]
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
