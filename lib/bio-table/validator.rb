module BioTable

  module Validator
    def Validator::valid_header? header, old_header
      if old_header
        if header - old_header != []
          $stderr.print old_header,"\n"
          $stderr.print header,"\n"
          raise "Headers do not compare!"
        end
      end
      true
    end

    def Validator::valid_row? line_number, fields, last_fields
      return false if fields == nil or fields.size == 0
      if last_fields and last_fields.size>0 and (fields.size != last_fields.size)
        $stderr.print last_fields,"\n"
        $stderr.print fields,"\n"
        throw "Number of fields diverge in line #{line_number} (size #{fields.size}, expected #{last_fields.size})"
      end
      true
    end
  end

end
