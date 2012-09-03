module BioTable

  class LazyValues
    include Enumerable

    def initialize fields
      @fields = fields
      @values = []  # cache values
    end

    def [] index
      if not @values[index]
        field = @fields[index]
        @values[index] = (Filter::valid_number?(field) ? field.to_f : nil )
      end
      @values[index]
    end

    def each
      @fields.each_with_index do | field, i |
        yield self[i]
      end
    end

    def compact
      a = []
      each do | e |
        a << e if e != nil
      end
      a
    end
  end

  module Filter

    # Create an index to the column headers, so header A,B,C,D with columns
    # C,A returns [2,0]. It can be the column index is already indexed, return
    # it in that case.
    #
    def Filter::create_column_index columns, header
      return nil if not columns 
      # check whether columns is already a list of numbers
      numbers = columns.dup.delete_if { |v| not valid_int?(v) }
      if numbers.size == columns.size
        return columns.map { |v| v.to_i }
      end

      # create the index from names
      index = []
      columns.each do | name |
        pos = header.index(name)
        raise "Column name #{name} not found!" if pos == nil
        index << pos 
      end
      return index
    end

    # Filter on (indexed) column names, using an expression and return
    # a new index
    def Filter::filter_column_index index, header, expression
      return index if not expression or expression == ""
      index = (0..header.size-1).to_a if index == nil
      index.map { |idx| 
        colname = header[idx]
        (idx==0 || eval(expression) ? idx : nil)
      }.compact
    end
    
    def Filter::apply_column_filter fields, index
      if index
        index.map { |idx| fields[idx] }
      else
        fields
      end
    end

    def Filter::valid_int?(s)
      s.to_i.to_s == s
    end

    def Filter::valid_number?(s)
      # s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
      begin Float(s) ; true end rescue false
    end

    def Filter::numeric code, fields, header
      return true if code == nil
      if fields
        filter = NumericFilter.new(header)
        filter.numeric(code, fields)
      else
        false
      end
    end

    def Filter::generic code, fields, header
      return true if code == nil
      if fields
        filter = TextualFilter.new(header)
        filter.textual(code, fields)
      else
        false
      end
    end
  end

  # FIXME: we should have a faster version too
  class TextualFilter
    def initialize header
      @header = header.map { |name| name.downcase }
    end

    def textual code, tablefields
      field = tablefields.dup
      fields = field # alias
      @fields = fields
      begin
        eval(code)
      rescue Exception
        $stderr.print "Failed to evaluate ",fields," with ",code,"\n"
        raise 
      end
    end
    def method_missing m, *args, &block
      if @header 
        i = @header.index(m.to_s)
        if i != nil
          # p @header,i
          return @fields[i] 
        end
        raise "Unknown field (can not find column name '#{m}') in list '#{@header}'"
      end
      raise "Unknown method '#{m}'"
    end

  end

  # FIXME: we should have a faster version too
  class NumericFilter
    def initialize header
      @header = header.map { |name| name.downcase }
    end

    def numeric code, fields
      values = LazyValues.new(fields)
      value = values  # alias
      @values = values
      begin
        eval(code)
      rescue Exception
        $stderr.print "Failed to evaluate ",fields," with ",code,"\n"
        raise 
      end
    end
    def method_missing m, *args, &block
      if @header 
        i = @header.index(m.to_s)
        if i != nil
          # p @header,i
          return @values[i] 
        end
        raise "Unknown value (can not find column name '#{m}') in list '#{@header}'"
      end
      raise "Unknown method '#{m}'"
    end

  end
end
