# require 'bio-table'

Given /^a comma separated table$/ do |string|
  @lines = string.split(/\n/)
end

When /^I read the multi\-line string$/ do
end

Then /^I should correctly parse the comma\-separated headers into "(.*?)","(.*?)","(.*?)"$/ do |arg1, arg2, arg3|
  @t = BioTable::Table.new
  @t.read_lines(@lines)
  @t.header[0].should == arg1
  @t.header[1].should == arg2
  @t.header[2].should == arg3
end

And /^I should correctly parse the first line into$/ do |string|
  line1 = @t[0]
  s = eval(string);
  line1.should == s
end

And /^it should have the rowname "(.*?)"$/ do |arg1|
  @t.rowname[0].should == "105853"
end


