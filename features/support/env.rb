require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

rootdir = File.dirname(__FILE__) + '/../..'
$LOAD_PATH.unshift(rootdir+'/lib',rootdir+'/../regressiontest/lib')
require 'regressiontest'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'bio-table'

require 'rspec/expectations'
World(RSpec::Matchers)

log = Bio::Log::LoggerPlus.new 'bio-table'
log.level = Bio::Log::DEBUG
