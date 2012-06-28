module BioTable

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
