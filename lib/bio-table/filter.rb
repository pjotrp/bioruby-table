module BioTable

  module Filter

    def Filter::numeric code, fields
      p fields
      value = fields.map { |field| field.to_f }
      p value
      # eval(code)
    end
  end

end
