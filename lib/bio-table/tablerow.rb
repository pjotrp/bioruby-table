module BioTable

  # Abstraction of a parsed table row (validation mostly)
  class TableRow
    attr_reader :rowname, :fields
    def initialize rowname, fields = []
      @rowname = rowname
      @fields = fields
    end

    def append values
      @fields += values
    end

    def all_fields
      ([@rowname] << @fields).flatten
    end

    def all_valid?
      all_fields != nil and all_fields.size > 0
    end
  
    def valid?
      fields != nil and fields.size > 0
    end
  
    def match_all_fields? zip
      row_fields = all_fields
      zip.each do | a |
        index = a[0]
        value = a[1]
        return false if row_fields[index] != value
      end
      true
    end
  end

end
