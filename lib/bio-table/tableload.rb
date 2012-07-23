module BioTable

  module TableLoader

    def TableLoader::load by_line
      by_line.call do | line |
        p line
      end
    end

  end
end
