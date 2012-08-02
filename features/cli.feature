@cli
Feature: Command-line interface (CLI)

  bio-table has a powerful command line interface. Here we regression test features.

  Scenario: Test the numerical filter by column values
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table --num-filter 'values[3] > 0.05'"
    Then I expect the named output to match "table1-0_05"

  Scenario: Reduce columns
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table test/data/input/table1.csv --columns '#Gene,AJ,B6,Axb1,Axb4,AXB13,Axb15,Axb19'"
    Then I expect the named output to match "table1-columns"

  Scenario: Reduce columns by index number
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table test/data/input/table1.csv --columns 0,1,8,2,4,6"
    Then I expect the named output to match "table1-columns-indexed"

  Scenario: Reduce columns by regex
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table test/data/input/table1.csv --column-filter 'colname !~ /ax/i'"
    Then I expect the named output to match "table1-columns-regex"

  Scenario: Rewrite rownames
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table test/data/input/table1.csv --rewrite 'rowname = field[2]; field[1]=nil if field[2].to_f<0.25'"
    Then I expect the named output to match "table1-rewrite-rownames"

  Scenario: Write RDF format
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table test/data/input/table1.csv --format rdf --transform-ids downcase"
    Then I expect the named output to match "table1-rdf1"

  Scenario: Read from STDIN
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "cat test/data/input/table1.csv|./bin/bio-table test/data/input/table1.csv --rewrite 'rowname = field[2]; field[1]=nil if field[2].to_f<0.25'"
    Then I expect the named output to match "table1-STDIN"


