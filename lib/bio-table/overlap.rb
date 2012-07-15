# Overlap module
#
module BioTable

  module Overlap

    def self.overlap_tables t1, t2, options 
      logger = Bio::Log::LoggerPlus['bio-table']
      columns = Columns::to_list(options[:overlap])
      t = Table.new(t1.header)
      l1 = t1.map { |row| columns.map { |i| row.all_fields[i] } }
      l2 = t2.map { |row| columns.map { |i| row.all_fields[i] } }
      logger.warn "Not all selected keys are unique!" if l1.uniq.size != l1.size or l2.uniq.size != l2.size
      overlap = l2 & l1
      # p overlap
      # create index for table 2
      idx2 = Indexer::create_index(t2,columns)
      overlap.each do |values|
        t.push(t2.row_by_columns(columns.zip(values),idx2))
      end
      t
    end

  end

end
