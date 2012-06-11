require 'csv'

module BioTable

  class Table

    attr_reader :header, :table, :rowname

    def initialize
      @header = []
      @table = []
      @rowname = []
    end

    def read_lines lines, options = {}

      @header = CSV.parse(lines[0])[0]
      (lines[1..-1]).each do | line |
        fields = CSV.parse(line)[0]
        @rowname << fields[0]
        @table << fields[1..-1] 
      end
      return self
    end

    def read_file filename, options = {}
    end

    def write options = {}
    end

    def [] row
      @table[row]
    end

  end

  module TableReader
    def TableReader::read_file filename, options = {}
      logger = Bio::Log::LoggerPlus['bio-table']
      logger.info("Parsing #{filename}")
      t = Table.new
      t.read_file(filename, options)
      t
    end
  end

end
