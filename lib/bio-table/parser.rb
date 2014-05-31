require 'csv'

module BioTable

  module LineParser

    # Converts a string into an array of string fields
    def LineParser::parse(line, in_format, split_on)
      if in_format == :csv
        $stderr.print "WARNING: this looks like a tab delimited file to me!\n" if line =~ /\t/
        CSV.parse_line(line)
      elsif in_format == :split
        line.split(split_on).map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      elsif in_format == :regex
        line.split(/#{split_on}/).map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      else
        $stderr.print "WARNING: this looks like a tab delimited file to me!\n" if line =~ /,"/
        line.split("\t").map { |field| 
          fld = field.strip
          fld = nil if fld == "NA"
          fld
        }
      end
    end
    
  end

end
