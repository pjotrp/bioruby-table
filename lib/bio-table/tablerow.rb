module BioTable

  class TableRow
    attr_reader :rowname, :fields
    def initialize rowname, fields
      @rowname = rowname
      @fields = fields
    end

    def all_fields
      ([@rowname] << @fields).flatten
    end

    def valid?
      fields != nil and fields.size > 0
    end
  end

end
