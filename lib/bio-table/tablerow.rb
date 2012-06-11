module BioTable

  class TableRow
    attr_reader :rowname, :fields
    def initialize rowname, fields
      @rowname = rowname
      @fields = fields
    end
  end

end
