# bio-table

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-table.png)](http://travis-ci.org/pjotrp/bioruby-table)

Tables of data are often used in bioinformatics. This biogem contains
support for reading tables and manipulation of rows and columns, both
using a command line interface and Ruby library. In time bio-table
should be lazy, be good for big data, and support a functional style
of programming. You don't need to know Ruby to use the command line
interface (CLI).

Note: this software is under active development!

## Installation

```sh
    gem install bio-table
```

## The command line interface (CLI)

Tables can be transformed through the command line. To transform a
comma separated file to a tab delimited one

```
    bio-table test/data/input/test1.csv --in-format csv --format tab > test1.tab
```

Tab is actually the general default. Also, if the file name ends in
csv, it will assume CSV. To convert the table back

```
    bio-table test1.tab --format csv > test1.csv
```

To filter out rows that contain certain values

```
    bio-table test/data/input/test1.csv --filter "row[3] > 0.05" > test1a.tab
```

To reorder columns by name

```
    bio-table test/data/input/test1.csv --columns AJ,B6,Axb1,Axb4,AXB13,Axb15,Axb19 > test1a.tab
```

or use their index numbers

```
    bio-table test/data/input/test1.csv --columns 0,1,2,4,6,8 > test1a.tab
```

To sort a table on column 4 and 2

```
    bio-table test/data/input/test1.csv --sort 4,2 > test1a.tab
```

Note: not all is implemented (just yet). Please check bio-table --help first.

 ## Usage

```ruby
    require 'bio-table'
    include BioTable
```

### Reading, transforming, and writing a table

Tables are two dimensional matrixes, which can be read from a file

```
    t = Table.read_file('test/data/input/test1.csv')
    p t.header              # print the header array
    p t.name[0],t[0]        # print the row name and row row
    p t[0][0]               # print the top corner field
```

The table reader has quite a few options for defining field separator,
which column to use for names etc. More interestingly you can pass a
function to limit the amount of row read into memory:

```
    t = Table.read_file('test/data/input/test1.csv',
      :by_row => { | row | row[0..3] } )
```

will create a table of the column name +row[0]+ and 2 table fields. You can use
the same idea to reformat and reorder table columns when reading data
into the table. E.g.

```
    t = Table.read_file('test/data/input/test1.csv',
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When a header can not be transformed, it may fail. You can test for
the header with row.header?, but in this case you
can pass in a :by_header, which will have :by_row only call on
actual table rows.

```
    t = Table.read_file('test/data/input/test1.csv',
      :by_header => { | header | ["Row name", header[0..3], header[6]].flatten } )
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When by_row returns nil or false, the table row is skipped. One way to
transform a file, and not loading it in memory, is

```
    f = File.new('test.tab','w')
    t = Table.read_file('test/data/input/test1.csv', 
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

