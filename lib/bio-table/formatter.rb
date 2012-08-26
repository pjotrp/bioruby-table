module BioTable

  module Formatter
    def Formatter::transform_header_ids modify, list
      l = list.dup
      case modify
        when :downcase then l.map { |h| h.downcase }
        when :upcase   then l.map { |h| h.upcase }
        else                l
      end
    end
    def Formatter::transform_row_ids modify, list
      l = list.dup
      case modify
        when :downcase then l[0].downcase!
        when :upcase   then l[0].upcase!
      end
      l
    end
    def Formatter::strip_quotes list
      list.map { |field| 
        if field == nil
          nil
        else
          first = field[0,1]
          if first == "\"" or first == "'"
            last = field[-1,1]
            if first == last
              field = field[1..-2]
            end
          end
          field 
        end
      }
    end
  end

  class TabFormatter
    def write list
      print list.map{|field| (field==nil ? "NA" : field)}.join("\t"),"\n"
    end
  end

  class CsvFormatter
    def write list
      csv_string = CSV.generate do |csv|
        csv << list
      end
      print csv_string
    end
  end

  class EvalFormatter
    def initialize evaluate
      @evaluate = evaluate
    end
    def write list
      field = list.dup.map { |e| (e==nil ? "" : e) }
      print eval(@evaluate)
      print "\n"
    end
  end


  module FormatFactory
    def self.create format, evaluate
      # @logger.info("Formatting to #{format}")
      return EvalFormatter.new(evaluate) if evaluate
      return CsvFormatter.new if format == :csv
      return TabFormatter.new
    end
  end
end

