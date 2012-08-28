# Please require your code below, respecting the naming conventions in the
# bioruby directory tree.
#
# For example, say you have a plugin named bio-plugin, the only uncommented
# line in this file would be 
#
#   require 'bio/bio-plugin/plugin'
#
# In this file only require other files. Avoid other source code.

require 'bio-logger'
require 'bio-table/indexer.rb'
require 'bio-table/columns.rb'
require 'bio-table/validator.rb'
require 'bio-table/filter.rb'
require 'bio-table/rewrite.rb'
require 'bio-table/parser.rb'
require 'bio-table/formatter.rb'
require 'bio-table/tablerow.rb'
require 'bio-table/table.rb'
require 'bio-table/tableload.rb'
require 'bio-table/tablereader.rb'
require 'bio-table/tablewriter.rb'
require 'bio-table/table_apply.rb'
require 'bio-table/diff.rb'
require 'bio-table/overlap.rb'
require 'bio-table/merge.rb'
require 'bio-table/rdf.rb'

module BioTable
  autoload :Statistics,'bio-table/statistics'
end

