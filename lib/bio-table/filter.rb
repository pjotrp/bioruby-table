module BioTable

  module Filter

    # Create an index to the column headers, so header A,B,C,D with columns
    # C,A returns [2,0]
    #
    def Filter::column_index columns, header
      return nil if not columns 

      index = []
      columns.each do | name |
        pos = header.index(name)
        raise "Column name #{name} not found!" if pos == nil
        index << pos 
      end
      return index
    end

    def Filter::apply_column_filter fields, index
      if index
        index.map { |idx| fields[idx] }
      else
        fields
      end
    end

    def Filter::valid_number?(s)
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def Filter::numeric code, fields
      return true if code == nil
      range = fields[1..-1]
      if range 
        values = range.map { |field| (valid_number?(field) ? field.to_f : nil ) } # FIXME: not so lazy
        begin
          eval(code)
        rescue
          $stderr.print "Failed to evaluate ",fields," with ",code,"\n"
          raise 
        end
      else
        false
      end
    end
  end

end
