@filter
Feature: Filter input table

  bio-table should read input line by line as an iterator, and emit
  filtered/transformed output, filtering for number values etc.

  Scenario: Filter a table by value
    Given I load a CSV table containing
        """
        bid,cid,length,num
        1,a,4658,4
        1,b,12060,6
        2,c,5858,7
        2,d,5626,4
        3,e,18451,8
        """
    When I numerically filter the table for 
      | num_filter       | result        |
      | values[1] > 6000 | [12060,18451] |
      | value[1] > 6000  | [12060,18451] |
    Then I should have result
    # we can use column names
    # When I filter the table for "length>6000"
    # Then I should have [12060,18451]
    # When I filter the table for "num==4"
    # Then I should have [4658,5626]
