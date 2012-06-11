module BioTable

  module Filter

    def Filter::numeric code, fields
      return true if code == nil
      # p fields
      value = fields[1..-1].map { |field| field.to_f }
      p value
      eval(code)
    end
  end

end
