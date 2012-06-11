module BioTable

  class Table

    attr_reader :header, :table, :rowname

    def initialize
      @table = []
      @rowname = []
    end

    # Read lines (list of string) and add them to the table, setting row names 
    # and row fields. The first row is assumed to be the header and ignored if the
    # header has been set.

    def read_lines lines, options = {}
      header = LineParser::parse(lines[0])

      @header = header if not @header
      (lines[1..-1]).each do | line |
        fields = LineParser::parse(line)
        @rowname << fields[0]
        @table << fields[1..-1] 
      end
      return self
    end

    def read_file filename, options = {}
      lines = []
      File.open(filename).each_line do | line |
        lines << line
      end
      read_lines(lines)
    end

    def write options = {}
      print @header.join("\t")
      @table.each_with_index do | row,i |
        print rowname[i],"\t",row.join("\t"),"\n" if row
      end
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
