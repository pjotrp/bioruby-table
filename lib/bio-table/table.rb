module BioTable

  class Table

    attr_reader :header, :rows, :rowname

    def initialize
      @logger = Bio::Log::LoggerPlus['bio-table']
      @rows = []
      @rowname = []
    end

    # Read lines (list of string) and add them to the table, setting row names 
    # and row fields. The first row is assumed to be the header and ignored if the
    # header has been set.

    def read_lines lines, options = {}
      num_filter = options[:num_filter]
      @logger.debug "Filtering on #{num_filter}" if num_filter 
      header = LineParser::parse(lines[0], options[:in_format])
      Validator::valid_header?(header, @header)
      @header = header if not @header

      (lines[1..-1]).each do | line |
        fields = LineParser::parse(line, options[:in_format])
        rowname = fields[0]
        data_fields = fields[1..-1]
        next if not Validator::valid_row?(data_fields,@header,@rows)
        next if not Filter::numeric(num_filter,fields)
        @rowname << rowname
        @rows << data_fields
      end
    end

    def read_file filename, options = {}
      lines = []
      if not options[:in_format] and filename =~ /\.csv$/
        @logger.debug "Autodetected CSV file"
        options[:in_format] = :csv
      end
      @logger.debug(options)
      File.open(filename).each_line do | line |
        lines.push line
      end
      read_lines(lines, options)
    end

    def write options = {}
      format = options[:format]
      format = :tab if not format
      formatter = FormatFactory::create(format)
      formatter.write(@header) if options[:write_header]
      each do | tablerow |
        # p tablerow
        formatter.write(tablerow.all_fields) if tablerow.valid?
      end
    end

    def [] row
      TableRow.new(@rowname[row],@rows[row])
    end

    def each 
      @rows.each_with_index do | row,i |
        yield TableRow.new(@rowname[i], row)
      end
    end

  end


end
