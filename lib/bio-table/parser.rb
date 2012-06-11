require 'csv'

module BioTable

  module LineParser


    def LineParser::parse(line)
      CSV.parse(line)[0]
    end
    
  end

end
