module BioTable

  # In memory table representation - note that the default parser/emitter does not
  # use this class as this class expects all data to be in memory.
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

    # Read lines (list/array of string) and add them to the table, setting row
    # names and row fields. The first row is assumed to be the header and
    # ignored if the header has been set (the case with merge/concat tables).

    def read_lines lines, options = {}
      table_apply = TableApply.new(options)

      header = table_apply.parse_header(lines[0], options)
      Validator::valid_header?(header, @header)  # compare against older header when merging
      column_index,header = table_apply.column_index(header) # we may rewrite the header
      @header = header if not @header
 
      newheader = @header[1..-1]
      # parse the rest
      prev_line = newheader
      (lines[1..-1]).each_with_index do | line, line_num |
        rowname, data_fields = table_apply.parse_row(line_num, line, newheader, column_index, prev_line, options)
        if data_fields
          @rownames << rowname if not options[:with_rownames] # otherwise doubles rownames
          @rows << data_fields if data_fields
        end
        prev_line = data_fields
      end
      return @rownames,@rows
    end

    def read_file filename, options = {}
      lines = []
      if not options[:in_format] and filename =~ /\.csv$/
        @logger.debug "Autodetected CSV file"
        options[:in_format] = :csv
      end
      # Read the file lines into an Array, not lazy FIXME 
      File.open(filename).each_line do | line |
        lines.push line
      end
      read_lines(lines, options)
    end

    def write options = {}
      format = options[:format]
      format = :tab if not format
      evaluate = nil
      if format == :eval
        evaluate = options[:evaluate]
      end
      formatter = FormatFactory::create(format,evaluate)
      formatter.write(@header) if options[:write_header]
      each do | tablerow,num |
        # p tablerow
        formatter.write(tablerow.all_fields) if tablerow.all_valid?
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
