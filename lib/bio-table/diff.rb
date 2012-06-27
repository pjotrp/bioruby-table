# Diff module
#

module BioTable

  module Diff

    def self.diff_tables t1, t2, options 
      logger = Bio::Log::LoggerPlus['bio-table']
      columns = Columns::to_list(options[:diff])
      t = Table.new(t1.header)
      l1 = t1.map { |row| columns.map { |i| row.all_fields[i] } }
      l2 = t2.map { |row| columns.map { |i| row.all_fields[i] } }
      logger.warn "Not all selected keys are unique!" if l1.uniq.size != l1.size or l2.uniq.size != l2.size
      diff = l2 - l1
      diff.each do |values|
        t.push(t2.row_by_columns(columns.zip(values)))
      end
      t
    end

  end

end
