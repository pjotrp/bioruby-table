module BioTable

  # Apply filters/rewrite etc. to a table, visiting a row at a time. For optimization
  # this class contains some state
  class TableApply

    def initialize options
      @logger = Bio::Log::LoggerPlus['bio-table']

      @num_filter  = options[:num_filter]
      @logger.debug "Filtering on #{@num_filter}" if @num_filter 
      @rewrite  = options[:rewrite]
      @logger.debug "Rewrite #{@rewrite}" if @rewrite
      @use_columns = options[:columns]
      @logger.debug "Filtering on columns #{@use_columns}" if @use_columns 
      @column_filter = options[:column_filter]
      @logger.debug "Filtering on column names #{@column_filter}" if @column_filter
      @include_rownames = options[:with_rownames]
      @logger.debug "Include row names" if @include_rownames
      @first_column = (@include_rownames ? 0 : 1)
    end

    def parse_header(line, options)  
      LineParser::parse(line, options[:in_format])
    end

    def column_index(header)
      column_idx = Filter::create_column_index(@use_columns,header)
      column_idx = Filter::filter_column_index(column_idx,header,@column_filter)
      new_header = Filter::apply_column_filter(header,column_idx)
      return column_idx, new_header
    end

    def parse_row(line_num, line, column_idx, last_fields, options)
      fields = LineParser::parse(line, options[:in_format])
      fields = Filter::apply_column_filter(fields,column_idx) 
      rowname = fields[0]
      data_fields = fields[@first_column..-1]
      if data_fields.size > 0
        return nil,nil if not Validator::valid_row?(line_num, data_fields, last_fields)
        return nil,nil if not Filter::numeric(@num_filter,data_fields)
        (rowname, data_fields) = Rewrite::rewrite(@rewrite,rowname,data_fields)
      end
      return rowname, data_fields
    end
  end

end
