Given /^I want to iterate a comma separated table$/ do |string|
  @lines = string.split(/\n/).map { |s| s.strip }
end

When /^I iterate through the table$/ do
  BioTable::TableLoader.emit(@lines)
end


