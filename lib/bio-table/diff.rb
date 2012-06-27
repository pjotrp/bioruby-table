# Diff module
#

module BioTable

  module Diff

    def self.diff_tables t1, t2, options 
      logger = Bio::Log::LoggerPlus['bio-table']
      t = Table.new(t1.header)
      # t.push(t1[0])
      # Read all fields into lists, and find the difference
      l1 = t1.rownames
      l2 = t2.rownames
      diff1 = l1 - l2
      diff2 = l2 - l1
      diff1.each do |n|
        t.push(t1.row_by_name(n))
      end
      diff2.each do |n|
        t.push(t2.row_by_name(n))
      end
      return t
    end

  end

end
