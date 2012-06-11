module BioTable

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

