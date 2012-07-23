module BioTable

  module TableLoader

    def TableLoader::emit generator, options 
      Enumerator.new { |yielder|
        generator.each do |line|
          fields = LineParser::parse(line,options[:in_format])
          yielder.yield fields
        end
      }
    end

  end
end
