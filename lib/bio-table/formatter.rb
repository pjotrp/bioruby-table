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

  module FormatFactory
    def self.create format
      # @logger.info("Formatting to #{format}")
      return CsvFormatter.new if format == :csv
      return TabFormatter.new
    end
  end
end

