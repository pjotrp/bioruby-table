require 'csv'

module BioTable

  class Table

    attr_reader :header, :table

    def read_lines lines, options = {}
      @header = CSV.parse(lines[0])[0]
      @table = []
      (lines[1..-1]).each do | line |
        @table << CSV.parse(line)[0]
      end
    end

    def read_file filename, options = {}
    end

    def [] row
      @table[row]
    end
  end

end
