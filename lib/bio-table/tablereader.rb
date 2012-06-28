module BioTable

  module TableReader
    def TableReader::read_file filename, options = {}
      logger = Bio::Log::LoggerPlus['bio-table']
      logger.info("Parsing #{filename}")
      t = Table.new
      t.set_name(filename)
      t.read_file(filename, options)
      t
    end
  end

end
