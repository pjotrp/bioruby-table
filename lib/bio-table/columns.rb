module BioTable

  module Columns

    # Returns a list of selected columns, [0] if none set
    def self.to_list list
      return [0] if list == nil or list == ""
      list.map { |item| item.to_i }
    end
  end
end
