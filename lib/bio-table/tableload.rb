module BioTable

  module TableLoader

    # Emit a row at a time, using generator as input (the generator should have
    # an 'each' method) and apply the filters etc. defined in options
    #
    # Note that this class does not hold data in memory(!)
    #
    # Note that you need to pass in :with_header to get the header row
    def TableLoader::emit generator, options = {}
      table_apply = TableApply.new(options)
      column_index = nil, prev_line = nil
      skip = options[:skip]
      skip = 0 if skip == nil
      header = nil
      Enumerator.new { |yielder|
        # fields = LineParser::parse(line,options[:in_format])
        generator.each_with_index do |line, line_num|
          # p [line_num, line]
          if line_num-skip == 0
            header = table_apply.parse_header(line, options)
            # Validator::valid_header?(header, @header)  # compare against older header when merging
            column_index,header = table_apply.column_index(header) # we may rewrite the header
            yielder.yield header,:header if options[:write_header] != false
            prev_line = header[table_apply.first_column..-1]
            # When a header filter is defined, rewind the generator, note that skip won't work
            # properly (FIXME)
            if options[:with_headers]
              generator.rewind
            end
          elsif line_num-skip < 0
            # do nothing
          else
            rowname, data_fields = table_apply.parse_row(line_num, line, header, column_index, prev_line, options)
            if data_fields
              list = []
              list << rowname if not options[:with_rownames] # otherwise doubles rownames
              list += data_fields if data_fields
              yielder.yield list,:row
              prev_line = data_fields
            end
          end
        end
      }
    end

  end
end
