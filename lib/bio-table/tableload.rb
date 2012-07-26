module BioTable

  module TableLoader

    # Emit a row at a time, using generator as input (the generator should have
    # an 'each' method) and apply the filters etc. defined in options
    #
    def TableLoader::emit generator, options 
      table_apply = TableApply.new(options)
      column_index = nil, prev_line = nil
      Enumerator.new { |yielder|
        # fields = LineParser::parse(line,options[:in_format])
        generator.each_with_index do |line, line_num|
          if line_num == 0
            header = table_apply.parse_header(line, options)
            # Validator::valid_header?(header, @header)  # compare against older header when merging
            column_index,header = table_apply.column_index(header) # we may rewrite the header
            yielder.yield header
            prev_line = header[1..-1]
          else
            rowname, data_fields = table_apply.parse_row(line_num, line, column_index, prev_line, options)
            if data_fields
              list = []
              list << rowname if not options[:with_rownames] # otherwise doubles rownames
              list << data_fields if data_fields
              yielder.yield list
              prev_line = data_fields
            end
          end
        end
      }
    end

  end
end
