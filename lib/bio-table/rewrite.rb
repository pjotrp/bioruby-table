module BioTable

  module Rewrite

    def Rewrite::rewrite code, rowname, field
      return rowname,field if not code or code==""
      begin
        eval(code)
      rescue Exception
        $stderr.print "Failed to evaluate ",rowname," ",field," with ",code,"\n"
        raise 
      end
      return rowname,field
    end
  end
end
