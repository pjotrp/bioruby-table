module BioTable

  class Table

    include Enumerable

    attr_reader :filename, :name
    attr_reader :header, :rows, :rownames

    def initialize header=nil
      @header = header if header
      @logger = Bio::Log::LoggerPlus['bio-table']
      @rows = []
      @rownames = []
    end

    def set_name fn
      @filename = fn
      @name = File.basename(fn,File.extname(fn))
    end

    # Read lines (list of string) and add them to the table, setting row names 
    # and row fields. The first row is assumed to be the header and ignored if the
    # header has been set.

    def read_lines lines, options = {}
      # get all the options
      num_filter  = options[:num_filter]
      @logger.debug "Filtering on #{num_filter}" if num_filter 
      rewrite  = options[:rewrite]
      @logger.debug "Rewrite #{rewrite}" if rewrite
      use_columns = options[:columns]
      @logger.debug "Filtering on columns #{use_columns}" if use_columns 
      column_filter = options[:column_filter]
      @logger.debug "Filtering on column names #{column_filter}" if column_filter
      include_rownames = options[:with_rownames]
      @logger.debug "Include row names" if include_rownames
      first_column = (include_rownames ? 0 : 1)

      # parse the header
      header = LineParser::parse(lines[0], options[:in_format])
      Validator::valid_header?(header, @header)
      @header = header if not @header

      column_index = Filter::create_column_index(use_columns,header)
      column_index = Filter::filter_column_index(column_index,header,column_filter)
      @header = Filter::apply_column_filter(header,column_index)

      # parse the rest
      (lines[1..-1]).each do | line |
        fields = LineParser::parse(line, options[:in_format])
        fields = Filter::apply_column_filter(fields,column_index) 
        rownames = fields[0]
        data_fields = fields[first_column..-1]
        next if not Validator::valid_row?(data_fields,@header,@rows)
        next if not Filter::numeric(num_filter,data_fields)

        @rownames << rownames if not include_rownames # otherwise doubles rownames
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

    # Find a record by rowname and return the fields. Empty fields are nils.
    def find_fields rowname
      row = row_by_name(rowname)
      fields = (row ? row.fields : [])
      # fill fields with nil to match header length
      # say header=5 fields=2 fill=2 (skip rowname)
      fields.fill(nil,fields.size,header.size-1-fields.size)
    end

    def row_by_name name
      self[rownames.index(name)]
    end

    def row_by_columns zip,idx=nil
      index = zip.first[0]
      value = zip.first[1]
      if idx 
        row = idx[zip.transpose[1]]
        return row if row.match_all_fields?(zip)
      else
        each do | row | 
          fields = row.all_fields
          if fields[index] == value
            return row if row.match_all_fields?(zip)
          end
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
