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

    def Filter::numeric code, fields, column_name_index
      return true if code == nil
      if fields
        filter = NumericFilter.new
        filter.numeric code, fields
      else
        false
      end
    end

    def Filter::generic code, tablefields
      return true if code == nil
      if tablefields
        field = tablefields.dup
        fields = field # alias
        begin
          eval(code)
        rescue Exception
          $stderr.print "Failed to evaluate ",fields," with ",code,"\n"
          raise 
        end
      else
        false
      end
    end
  end

  # FIXME: we should have a faster version too
  class NumericFilter
    def initialize column_name_index = { :num => 2 }
      @column_name_index = column_name_index
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
      # p @column_name_index
      # p m
      if @column_name_index[m]
        # p @values[@column_name_index[m]] 
        @values[@column_name_index[m]] 
      else
        raise "Unknown value (can not find column name '#{m}')"
      end
    end

  end
end
