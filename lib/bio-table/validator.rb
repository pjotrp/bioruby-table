module BioTable

  module Validator
    def Validator::valid_row? fields, header, rows
      return false if fields == nil or fields.size == 0
      if rows.size>0 and (fields.size != rows.last.size)
        p rows.last
        p fields
        throw "Number of fields diverge in line #{rows.size + 1} (size #{fields.size}, expected #{rows.last.size})"
      end
      true
    end
  end

end
