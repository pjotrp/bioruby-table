require 'csv'

Given /^a comma separated table$/ do |string|
  @lines = string.split(/\n/)
end

When /^I read the multi\-line string$/ do
end

Then /^I should correctly parse the comma\-separated headers into "(.*?)","(.*?)","(.*?)"$/ do |arg1, arg2, arg3|
  # parse the headers
  @headers = CSV.parse(@lines[0])[0]
  @headers[0].should == arg1
  @headers[1].should == arg2
  @headers[2].should == arg3
end

Then /^I should correctly parse the first line into$/ do |string|
  @line1 = CSV.parse(@lines[1])[0]
  s = eval(string);
  @line1.should == s
end

