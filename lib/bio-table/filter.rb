module BioTable

  module Filter

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
