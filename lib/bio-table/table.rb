module BioTable

  class Table

    include Enumerable

    attr_reader :header, :rows, :rownames

    def initialize header=nil
      @header = header if header
      @logger = Bio::Log::LoggerPlus['bio-table']
      @rows = []
      @rownames = []
    end

    # Read lines (list of string) and add them to the table, setting row names 
    # and row fields. The first row is assumed to be the header and ignored if the
    # header has been set.

    def read_lines lines, options = {}
      num_filter  = options[:num_filter]
      @logger.debug "Filtering on #{num_filter}" if num_filter 
      use_columns = options[:columns]
      @logger.debug "Filtering on columns #{use_columns}" if use_columns 
      include_rownamess = options[:with_rownamess]
      @logger.debug "Include row names" if include_rownamess
      first_column = (include_rownamess ? 0 : 1)

      # parse the header
      header = LineParser::parse(lines[0], options[:in_format])
      Validator::valid_header?(header, @header)
      @header = header if not @header

      column_index = Filter::create_column_index(use_columns,header)
      @header = Filter::apply_column_filter(header,column_index)

      (lines[1..-1]).each do | line |
        fields = LineParser::parse(line, options[:in_format])
        fields = Filter::apply_column_filter(fields,column_index) 
        rownames = fields[0]
        data_fields = fields[first_column..-1]
        next if not Validator::valid_row?(data_fields,@header,@rows)
        next if not Filter::numeric(num_filter,data_fields)
        @rownames << rownames if not include_rownamess # otherwise doubles rownamess
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
      # Read the file lines into an Array, not lazy FIXME 
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

    def push rownames,fields = nil
      if fields == nil and rownames.kind_of?(TableRow)
        @rownames << rownames.rowname
        @rows << rownames.fields
      else
        @rownames << rownames
        @rows << fields
      end
    end

    def [] row
      if row
        TableRow.new(@rownames[row],@rows[row])
      else
        nil
      end
    end

    def row_by_name name
      self[rownames.index(name)]
    end

    def row_by_columns zip
      index = zip.first[0]
      value = zip.first[1]
      each do | row | 
        fields = row.all_fields
        if fields[index] == value
          return row if row.match_all_fields?(zip)
        end
      end
      nil
    end

    def each 
      @rows.each_with_index do | row,i |
        yield TableRow.new(@rownames[i], row)
      end
    end

  end

end
