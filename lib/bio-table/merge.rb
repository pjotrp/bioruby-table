module BioTable

  module Merge

    def self.merge_tables(tables, options)
      logger = Bio::Log::LoggerPlus['bio-table']
      headers = tables.first.header[0..0] + tables.map { |t| t.header[1..-1] }.flatten
      t = Table.new(headers)
      # index tables on rownames
      idxs = []
      tables.each do |t|
        idxs << Indexer::create_index(t,[0])
      end
      # create a full list of rownames
      all_rownames = idxs.map { |idx| idx.keys }.flatten.uniq
      p all_rownames
      exit
      
      # walk the tables
      l1 = t1.map { |row| columns.map { |i| row.all_fields[i] } }
      l2 = t2.map { |row| columns.map { |i| row.all_fields[i] } }
      logger.warn "Not all selected keys are unique!" if l1.uniq.size != l1.size or l2.uniq.size != l2.size
      diff = l2 - l1
      # create index for table 2
      idx2 = Indexer::create_index(t2,columns)
      diff.each do |values|
        t.push(t2.row_by_columns(columns.zip(values),idx2))
      end
      t

    end

  end

end
