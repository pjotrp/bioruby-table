module BioTable

  module Rewrite

    # Rewrite fields. Both field and fields can be used, but not at the same time.
    def Rewrite::rewrite code, rowname, field
      fields = field.dup
      original = field.dup
      values = LazyValues.new(field)
      return rowname,field if not code or code==""
      begin
        eval(code)
      rescue Exception
        $stderr.print "Failed to evaluate ",rowname," ",field," with ",code,"\n"
        raise 
      end
      if (fields & original != fields.uniq) and (field & original != field.uniq)
        p [:original,original]
        p [:fields,fields]
        p [:field,field]
        raise "You can not rewrite both field and fields!"
      end
      exit
      field = fields if fields != original
      return rowname,field
    end
  end
end
