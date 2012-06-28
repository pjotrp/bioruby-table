# bio-table

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-table.png)](http://travis-ci.org/pjotrp/bioruby-table)

Tables of data are often used in bioinformatics, especially in
conjunction with Excel spreadsheets and DB queries. This biogem
contains support for reading tables, writing tables, and manipulation
of rows and columns, both using a command line interface and through a
Ruby library. If you don't like R dataframes, maybe you like this.
Also, because bio-table is command line driven, it easily fits in a
pipe-line setup. 

Quick example, say we want to filter out rows that contain certain
p-values listed in the 4th column:

```
    bio-table test/data/input/table1.csv --num-filter "values[3] <= 0.05"
```

bio-table should be lazy, be good for big data, and the library
support a functional style of programming. You don't need to know Ruby
to use the command line interface (CLI).

Note: this software is under active development!

## Installation

```sh
    gem install bio-table
```

## The command line interface (CLI)

### Transforming a table

Tables can be transformed through the command line. To transform a
comma separated file to a tab delimited one

```
    bio-table test/data/input/table1.csv --in-format csv --format tab > test1.tab
```

Tab is actually the general default. Still, if the file name ends in
csv, it will assume CSV. To convert the table back

```
    bio-table test1.tab --format csv > table1.csv
```

To filter out rows that contain certain values

```
    bio-table test/data/input/table1.csv --num-filter "values[3] <= 0.05" > test1a.tab
```

The filter ignores the header row, and the row names. If you need
either, use the switches --with-header and --with-rownames. With math, list all rows 

```
    bio-table test/data/input/table1.csv --num-filter "values[3]-values[6] >= 0.05" > test1a.tab
```

or, list all rows that have a least a field with values >= 1000.0

```
    bio-table test/data/input/table1.csv --num-filter "values.max >= 1000.0" > test1a.tab
```

Produce all rows that have at least 3 values above 3.0 and 1 one value
above 10.0:

```
    bio-table test/data/input/table1.csv --num-filter "values.max >= 10.0 and values.count{|x| x>=3.0} > 3"
```

How is that for expressiveness? Looks like Ruby to me.

The --num-filter will convert fields lazily to numerical values (only
valid numbers are converted). If there are NA (nil) values in the table, you
may wish to remove them, like this

```
    bio-table test/data/input/table1.csv --num-filter "values[0..12].compact.max >= 1000.0" > test1a.tab
```

which takes the first 13 fields and compact removes the nil values.

Also string comparisons and regular expressions can be used. E.g.
filter on rownames and a row field both containing 'BGT'

```
    # not yet implemented
    bio-table test/data/input/table1.csv --filter "rowname =~ /BGT/ and field[1] =~ /BGT/" > test1a.tab
```

To reorder/reduce table columns by name

```
    bio-table test/data/input/table1.csv --columns AJ,B6,Axb1,Axb4,AXB13,Axb15,Axb19 > test1a.tab
```

or use their index numbers

```
    bio-table test/data/input/table1.csv --columns 0,1,8,2,4,6 > test1a.tab
```

### Sorting a table

To sort a table on column 4 and 2

```
    # not yet implemented
    bio-table test/data/input/table1.csv --sort 4,2 > test1a.tab
```

Note: not all is implemented (just yet). Please check bio-table --help first.

### Combining/merging tables

You can combine/concat two or more tables by passing in multiple file names

    bio-table test/data/input/table1.csv test/data/input/table2.csv

this will append table2 to table1, assuming they have the same headers
(you can use the --columns switch!)

To combine tables side by side use the --merge switch:

    bio-table --merge table1.csv table2.csv

all rownames will be matched (i.e. the input table order do not need
to be sorted). For non-matching rownames the fields will be filled
with NA's, unless you add a filter, e.g.

    bio-table --merge table1.csv table2.csv --num-filter "values.count{|x| x==nil} > 0"

Note that you may need to check/edit the column names after a merge.

### Splitting a table

Splitting a table by column is possible by named or indexed columns,
see the --columns switch.

### Diffing and overlapping tables

With two tables it may be interesting to see the differences, or
overlap, based on shared columns. The bio-table diff command shows the
difference between two tables using the row names (i.e. those rows
with rownames that appear in table2, but not in table1)

    bio-table --diff 0 table1.csv table2.csv 

To find it the other way, switch the file names

    bio-table --diff 0 table1.csv table2.csv 

To diff on something else

    bio-table --diff 0,3 table2.csv table1.csv 

creates a (hopefully unique) key using columns 0 and 3 (0 is the rownames column).

Similarly

    bio-table --overlap 2 table1.csv table2.csv

finds the overlapping rows, based on column 2 (NYI)

### Different parsers

more soon

## Usage

```ruby
    require 'bio-table'
    include BioTable
```

### Reading, transforming, and writing a table

Note: the Ruby API below is a work in progress.

Tables are two dimensional matrixes, which can be read from a file

```
    t = Table.read_file('test/data/input/table1.csv')
    p t.header              # print the header array
    p t.name[0],t[0]        # print the row name and row row
    p t[0][0]               # print the top corner field
```

The table reader has quite a few options for defining field separator,
which column to use for names etc. More interestingly you can pass a
function to limit the amount of row read into memory:

```
    t = Table.read_file('test/data/input/table1.csv',
      :by_row => { | row | row[0..3] } )
```

will create a table of the column name +row[0]+ and 2 table fields. You can use
the same idea to reformat and reorder table columns when reading data
into the table. E.g.

```
    t = Table.read_file('test/data/input/table1.csv',
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When a header can not be transformed, it may fail. You can test for
the header with row.header?, but in this case you
can pass in a :by_header, which will have :by_row only call on
actual table rows.

```
    t = Table.read_file('test/data/input/table1.csv',
      :by_header => { | header | ["Row name", header[0..3], header[6]].flatten } )
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When by_row returns nil or false, the table row is skipped. One way to
transform a file, and not loading it in memory, is

```
    f = File.new('test.tab','w')
    t = Table.read_file('test/data/input/table1.csv', 
      :by_row => { | row | 
        TableRow::write(f,[row.rowname,row[0..3],row[6].to_i].flatten, :separator => "\t") 
        nil   # don't create a table in memory, effectively a filter
      })
```

Another function is :filter which only acts on rows, but can not
transform them.

To write a full table from memory to file use

```
    t.write_file('test1a.csv')
```

again columns can be reordered/transformed using a function. Another
option is by passing in an list of column numbers or header names, so
only those get written, e.g.

```
    t.write_file('test1a.csv', columns: [0,1,2,4,6,8])
    t.write_file('test1b.csv', columns: ["AJ","B6","Axb1","Axb4","AXB13","Axb15","Axb19"] )
```

other options are available for excluding row names (rownames: false), etc.

To sort a table file, the current routine is to load the file in
memory and sort according to table columns. In the near future we aim
to have a low-memory version, by reading only the sorting columns in
memory, and indexing them before writing output. That means reading a
file twice, but being able to handle much larger data.

### Loading a numerical matrix

Coming soon

### More...

The API doc is online. For more code examples see the test files in
the source tree.

       
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/pjotrp/bioruby-table

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at [#bio-table](http://biogems.info/index.html)

## Copyright

Copyright (c) 2012 Pjotr Prins. See LICENSE.txt for further details.

