module BioTable

  module TableWriter

    class Writer
      def initialize format=:tab, evaluate=nil
        @formatter = FormatFactory::create(format,evaluate)
      end

      def write row,type 
        @formatter.write(row.all_fields) if row.all_valid?
      end
    end

    class EvalWriter
    end
  end

end
