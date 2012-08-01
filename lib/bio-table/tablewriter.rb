module BioTable

  module TableWriter

    class Writer
      def initialize format=:tab
        @formatter = FormatFactory::create(format)
      end

      def write row,type 
        @formatter.write(row.all_fields) if row.all_valid?
      end
    end
  end

end
