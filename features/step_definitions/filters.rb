Given /^I load a CSV table containing$/ do |string|
  # pending # express the regexp above with the code you wish you had
end

When /^I numerically filter the table for$/ do |table|
  # table is a Cucumber::Ast::Table
  @table = table
end

Then /^I should have result$/ do
  @table.hashes.each do |h|
    p h
    result = eval(h['result'])
    options = {}
    options[:num_filter] = h['num_filter']
  
    p options
    p result
  end
end

