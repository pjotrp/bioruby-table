module BioTable
  module Count
    # Track rows that have the same column items. Return the last match of the cummalative list
    # with the count attached.
    class CountTracker
      def initialize list
        @list = list.map { |item| item.to_i }
        @rows = []
      end

      # Add a row and if it differs send the last merged edition back
      # type is :header or :row
      def add row, type, flush: false
        return row+["count"] if type == :header
        prev = @rows.last
        if flush
          prev
        else
          # Take the list and compare each item to the previous row
          same = if prev
                   @list.reduce(true) { |memo,i| row[i]==prev[i] }
                 else
                   false
                 end
          if not same
            num = @rows.size
            @rows = []
            @rows << row
            if prev
              return prev+[num]
            end
          else
            @rows << row
          end
          nil
        end
      end
  
    end
  end
end
