require 'csv'

module BioTable

  class Table

    attr_reader :header, :table, :rowname

    def read_lines lines, options = {}
      @header = CSV.parse(lines[0])[0]
      @rowname = []
      @table = []
      (lines[1..-1]).each do | line |
        fields = CSV.parse(line)[0]
        @rowname << fields[0]
        @table << fields[1..-1] 
      end
    end

    def read_file filename, options = {}
    end

    def [] row
      @table[row]
    end
  end

end
