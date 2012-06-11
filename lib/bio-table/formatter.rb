module BioTable

  class TabFormatter
    def write list
      print list.join("\t"),"\n"
    end

  end

  class CsvFormatter

    def write list
      list.join(separator)
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

