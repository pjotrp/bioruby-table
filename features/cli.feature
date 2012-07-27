@cli
Feature: Command-line interface (CLI)

  bio-table has a powerful comman line interface. Here we regression test features.

  Scenario: Test the numerical filter by column values
    Given I have input file(s) named "test/data/input/table1.csv"
    When I execute "./bin/bio-table --num-filter 'values[3] > 0.05'"
    Then I expect the named output to match "table1-0_05"
