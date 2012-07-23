module BioTable

  module TableLoader

    def TableLoader::emit generator
      generator.each do |line|
        p line
      end
    end

    def TableLoader::load by_line
      by_line.call do | line |
        p line
      end
    end

  end
end
