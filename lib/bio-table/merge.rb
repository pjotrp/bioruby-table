module BioTable

  module Merge

    def self.merge_tables(tables, options)
      logger = Bio::Log::LoggerPlus['bio-table']
      logger.info("Merging tables")
      headers = tables.first.header[0..0] + 
        tables.map { |t| t.header[1..-1].map{|n| t.name+'-'+n} }.flatten
      t = Table.new(headers)
      # index tables on rownames
      idxs = []
      tables.each do |t|
        idxs << Indexer::create_index(t,[0])
      end
      # create a full list of rownames
      all_rownames = idxs.map { |idx| idx.keys }.flatten.uniq
      
      # walk the tables and merge fields
      all_rownames.each do | rowname |
        row = TableRow.new(rowname)
        fields = tables.map { |t|
          fields = t.find_fields(rowname) 
          row.append(fields)
        }
        t.push(row)
      end
      t

    end

  end

end
