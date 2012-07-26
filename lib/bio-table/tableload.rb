module BioTable

  module TableLoader

    # Emit a row at a time, using generator as input (the generator should have
    # an 'each' method) and apply the filters etc. defined in options
    #
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
