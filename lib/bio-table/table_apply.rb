require 'bio-logger'

module BioTable

  # Apply filters/rewrite etc. to a table, visiting a row at a time. For optimization
  # this class contains some state
  class TableApply
    attr_reader :first_column

    def initialize options
      @logger = Bio::Log::LoggerPlus['bio-table']

      # @skip  = options[:skip]
      # @logger.debug "Skipping #{@skip} lines" if @skip
      @num_filter  = options[:num_filter]
      @logger.debug "Filtering on #{@num_filter}" if @num_filter 
      @filter  = options[:filter]
      @logger.debug "Filtering on #{@filter}" if @filter 
      @rewrite  = options[:rewrite]
      @logger.debug "Rewrite #{@rewrite}" if @rewrite
      @use_columns = options[:columns]
      @logger.debug "Filtering on columns #{@use_columns}" if @use_columns 
      @column_filter = options[:column_filter]
      @logger.debug "Filtering on column names #{@column_filter}" if @column_filter
      @strip_quotes = options[:strip_quotes]
      @logger.debug "Strip quotes #{@strip_quotes}" if @strip_quotes
      @transform_ids = options[:transform_ids]
      @logger.debug "Transform ids #{@transform_ids}" if @transform_ids
      @include_rownames = options[:with_rownames]
      @logger.debug "Include row names" if @include_rownames
      @first_column = (@include_rownames ? 0 : 1)
      @write_header = options[:write_header]
    end

    def parse_header(line, options)  
      header = LineParser::parse(line, options[:in_format], options[:split_on])
      header = Formatter::strip_quotes(header) if @strip_quotes
      # Transform converts the header to upper/lower case
      header = Formatter::transform_header_ids(@transform_ids, header) if @transform_ids
      if options[:unshift_headers]
        header.unshift("ID")
      end
      @logger.info(header) if @logger and @write_header 
      header
    end

    def column_index(header)
      column_idx = Filter::create_column_index(@use_columns,header)
      column_idx = Filter::filter_column_index(column_idx,header,@column_filter)
      new_header = Filter::apply_column_filter(header,column_idx)
      return column_idx, new_header
    end

    def parse_row(line_num, line, header, column_idx, prev_fields, options)
      fields = LineParser::parse(line, options[:in_format], options[:split_on])
      return nil,nil if fields.compact == []
      fields = Formatter::strip_quotes(fields) if @strip_quotes
      fields = Formatter::transform_row_ids(@transform_ids, fields) if @transform_ids
      fields = Filter::apply_column_filter(fields,column_idx) 
      return nil,nil if fields.compact == []
      rowname = fields[0]
      data_fields = fields[@first_column..-1]
      if data_fields.size > 0
        return nil,nil if not Validator::valid_row?(line_num, data_fields, prev_fields)
        return nil,nil if not Filter::numeric(@num_filter,data_fields,header)
        return nil,nil if not Filter::generic(@filter,data_fields,header)
        (rowname, data_fields) = Rewrite::rewrite(@rewrite,rowname,data_fields)
      end
      return rowname, data_fields
    end
  end

end
