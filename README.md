# bio-table

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-table.png)](http://travis-ci.org/pjotrp/bioruby-table)

Tables of data are often used in bioinformatics. This biogem contains
support for reading tables and manipulation of rows and columns, both
using a command line interface and Ruby library. In time it should be
good for big data, and support a functional style of programming.

Note: this software is under active development!

## Installation

```sh
    gem install bio-table
```

## Usage

```ruby
    require 'bio-table'
```

### Loading a table

Tables are two dimensional matrixes, which can be read from a file

```
    t = BioTable::Table.read_file('test/data/input/test1.csv')
    p t.header              # print the header array
    p t.name[0],t[0]        # print the row name and row fields
    p t[0][0]               # print the top corner field
```

The table reader has quite a few options for defining field separator,
which column to use for names etc. More interestingly you can pass a
function to limit the amount of fields read into memory:

```
    t = BioTable::Table.read_file('test/data/input/test1.csv',
      :by_row => { | fields | fields[0..3] } )
```

will create a table of the column name and 2 table fields. You can use
the same idea to reformat and reorder table columns when reading data
into the table. E.g.

```
    t = BioTable::Table.read_file('test/data/input/test1.csv',
      :by_row => { | fields | [fields[0..3],fields[6].to_i].flatten } )
```


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

