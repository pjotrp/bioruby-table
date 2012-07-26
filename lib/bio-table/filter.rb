module BioTable

  class LazyValues
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
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def Filter::numeric code, fields
      return true if code == nil
      if fields
        # values = fields.map { |field| (valid_number?(field) ? field.to_f : nil ) } # FIXME: not so lazy
        values = LazyValues.new(fields)
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

end
