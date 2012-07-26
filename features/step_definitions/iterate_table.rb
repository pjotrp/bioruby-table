Given /^I want to iterate a comma separated table$/ do |string|
  @lines = string.split(/\n/).map { |s| s.strip }
end

When /^I iterate through the table$/ do
  res = []
  BioTable::TableLoader.emit(@lines, :in_format => :csv).each { |row| res << row }
  p res
  res[3][5].should == "0.07"
end


