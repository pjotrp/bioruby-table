module BioTable

  module Indexer

    # Create an index (Hash) of column field contents, pointing
    # to a TableRow
    def self.create_index table, columns
      idx = {}
      table.each do | row |
        idx[make_key(row,columns)] = row
      end
      idx
   end

   def self.make_key row, columns
      columns.map { |i| row.all_fields[i] }
   end

  end

end
