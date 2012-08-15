# bio-table

[![Build Status](https://secure.travis-ci.org/pjotrp/bioruby-table.png)](http://travis-ci.org/pjotrp/bioruby-table)

bio-table is the swiss knife of tabular data.  Tables of data are
often used in bioinformatics, especially in conjunction with Excel
spreadsheets and DB queries. This biogem contains support for reading
tables, writing tables, and manipulation of rows and columns, both
using a command line interface and through a Ruby library. If you
don't like R dataframes, maybe you like this.  Also, because bio-table
is command line driven, and can use STDIN and STDOUT, it easily fits
in a pipe-line setup. 

Quick example, say we want to filter out rows that contain certain
p-values listed in the 4th column:

```
    bio-table test/data/input/table1.csv --num-filter "values[3] <= 0.05"
```

bio-table should be lazy. And be good for big data, bio-table is
designed so that most important functions do not load the data in
memory. The library supports a functional style of programming, but
you don't need to know Ruby to use the command line interface (CLI).

Features:

* Support for reading and writing TAB and CSV files
* Filter on data
* Transform table and data by column or row
* Recalculate data
* Diff between tables, selecting on specific column values
* Merge tables side by side on column value/rowname
* Split/reduce tables by column
* Write formatted tables, e.g. HTML, LaTeX
* Read from STDIN, write to STDOUT
* Convert table to RDF 
* Convert table to JSON/YAML/XML (nyi)
* etc. etc.

and bio-table is pretty fast. To convert a 3Mb file of 18670 rows
takes 0.87 second. Adding a filter makes it parse at 0.95 second on
my 3.2 GHz desktop (with preloaded disk cache).

Note: this software is under active development, though what is
documented here should just work.

## Installation

```sh
    gem install bio-table
```

## The command line interface (CLI)

### Transforming a table

Tables can be transformed through the command line. To transform a
comma separated file to a tab delimited one

```sh
    bio-table test/data/input/table1.csv --in-format csv --format tab > test1.tab
```

Tab is actually the general default. Still, if the file name ends in
csv, it will assume CSV. To convert the table back

```sh
    bio-table test1.tab --format csv > table1.csv
```

To filter out rows that contain certain values

```sh
    bio-table test/data/input/table1.csv --num-filter "values[3] <= 0.05" > test1a.tab
```

The filter ignores the header row, and the row names. If you need
either, use the switches --with-header and --with-rownames. With math, list all rows 

```sh
    bio-table test/data/input/table1.csv --num-filter "values[3]-values[6] >= 0.05" > test1a.tab
```

or, list all rows that have a least a field with values >= 1000.0

```sh
    bio-table test/data/input/table1.csv --num-filter "values.max >= 1000.0" > test1a.tab
```

Produce all rows that have at least 3 values above 3.0 and 1 one value
above 10.0:

```sh
    bio-table test/data/input/table1.csv --num-filter "values.max >= 10.0 and values.count{|x| x>=3.0} > 3"
```

How is that for expressiveness? Looks like Ruby to me.

The --num-filter will convert fields lazily to numerical values (only
valid numbers are converted). If there are NA (nil) values in the table, you
may wish to remove them, like this

```sh
    bio-table test/data/input/table1.csv --num-filter "values[0..12].compact.max >= 1000.0" > test1a.tab
```

which takes the first 13 fields and compact removes the nil values.

Also string comparisons and regular expressions can be used. E.g.
filter on rownames and a row field both containing 'BGT'

```sh
    # not yet implemented
    bio-table test/data/input/table1.csv --filter "rowname =~ /BGT/ and field[1] =~ /BGT/" > test1a.tab
```

To reorder/reduce table columns by name

```sh
    bio-table test/data/input/table1.csv --columns AJ,B6,Axb1,Axb4,AXB13,Axb15,Axb19 > test1a.tab
```

or use their index numbers (the first column is zero)

```sh
    bio-table test/data/input/table1.csv --columns 0,1,8,2,4,6 > test1a.tab
```


To filter for columns using a regular expression

```sh
    bio-table table1.csv --column-filter 'colname !~ /infected/i'
```

will drop all columns with names containing 'infected', ignoring
case.

Finally we can rewrite the content of a table using rowname and fields
again

```sh
    bio-table table1.csv --rewrite 'rowname.upcase!; field[1]=nil if field[2].to_f<0.25'
```

where we rewrite the rowname in capitals, and set the second field to
empty if the third field is below 0.25. 

### Sorting a table

To sort a table on column 4 and 2

```sh
    # not yet implemented
    bio-table test/data/input/table1.csv --sort 4,2 > test1a.tab
```

Note: not all is implemented (just yet). Please check bio-table --help first.

### Combining/merging tables

You can combine/concat two or more tables by passing in multiple file names

```sh
    bio-table test/data/input/table1.csv test/data/input/table2.csv
```

this will append table2 to table1, assuming they have the same headers
(you can use the --columns switch!)

To combine tables side by side use the --merge switch:

```sh
    bio-table --merge table1.csv table2.csv
```

all rownames will be matched (i.e. the input table order do not need
to be sorted). For non-matching rownames the fields will be filled
with NA's, unless you add a filter, e.g.

```sh
    bio-table --merge table1.csv table2.csv --num-filter "values.compact.size == values.size"
```

### Splitting a table

Splitting a table by column is possible by named or indexed columns,
see the --columns switch.

### Diffing and overlapping tables

With two tables it may be interesting to see the differences, or
overlap, based on shared columns. The bio-table diff command shows the
difference between two tables using the row names (i.e. those rows
with rownames that appear in table2, but not in table1)

```sh
    bio-table --diff 0 table1.csv table2.csv 
```

bio-table --diff is different from the standard Unix diff tool. The
latter shows insertions and deletions. bio-table --diff shows what is
in one file, and not in the other (insertions). To see deletions,
reverse the file order, i.e. switch the file names

```sh
    bio-table --diff 0 table1.csv table2.csv 
```

To diff on something else

```sh
    bio-table --diff 0,3 table2.csv table1.csv 
```

creates a key using columns 0 and 3 (0 is the rownames column).

Similarly

```sh
    bio-table --overlap 2 table1.csv table2.csv
```

finds the overlapping rows, based on the content of column 2.


### Different parsers

bio-table currently reads comma separated files and tab delimited
files.

(more soon)

### Using STDIN

bio-table can read data from STDIN, by simply assuming that the data
piped in is the first input file

```sh
    cat test1.tab | bio-table table1.csv --num-filter "values[3] <= 0.05" > test1a.tab
```

will filter both files test1.tab and test1.csv and output to
test1a.tab.

### Formatted output

bio-table has built-in formatters - for CSV and TAB, and for RDF
(and soon for JSON/YAML and perhaps even XML). The RDF format is
discussed in 'Output table to RDF'.

Another flexible option for formatting a table is to create programmatic output
through a formatter.  If you set the --format switch to *eval*, you
can add the -e 'command' that is evaluated to print to STDOUT. For
example, bio-table does not support HTML output directly, but if we
were to create an HTML table, we could run

```sh
    bio-table --format eval -e '"<tr><td>"+field.join("</td><td>")+"</td></tr>"' table1.csv 
```

likewise to create a LaTeX table we could

```sh
    bio-table --columns gene_symbol,gene_desc --format eval -e 'field.join(" & ")+" \\\\"' table1.csv
```

Since fields can be accessed independently, you can add any markup for
fields, e.g.

```sh
    bio-table --columns ID,Description,Date --format eval -e'"\\emph{"+field[0]+"} & "+ field[1..-1].join(" & ")+"\\\\"' table1.csv
```

Because of the evaluation formatter bio-table does not need to implement the machinery for
every output format on the planet!

### Output table to RDF

bio-table can write a table into turtle RDF triples (part of the semantic
web!), so you can put the data directly into a triple-store. 

```sh
    bio-table --format rdf table1.csv
```

The table header is stored with predicate :colname using the header
values both as subject and label, with the :index:

```rdf
  :header3 rdf:label "Header3" ; a :colname; :index 4 .
```

Rows are stored with rowname as subject and label, followed by the
columns referring to the header triples, and the values. E.g.

```rdf
   :row13475701 rdf:label "row13475701" ; a :rowname ; ; :Id "row13475701" ; :header1 "1" ; :header2 "0" ; :header3 "3" .
```

To unify identifier names you may want to transform ids:

```sh
    bio-table --format rdf --transform-ids "downcase" table1.csv
```

Another interesting option is --blank-nodes. This causes rows to be
written as blank nodes, and allows for duplicate row names. E.g.

```rdf
   :row13475701 [ rdf:label "row13475701" ; a :rowname ; ; :Id "row13475701" ; :header1 "1" ; :header2 "0" ; :header3 "3" ] .
```
The bio-rdf gem actually uses this bio-table biogem to parse data into a
triple store and query the data through SPARQL. For examples see the
features, e.g. the
[genotype to RDF feature](https://github.com/pjotrp/bioruby-rdf/blob/master/features/genotype-table-to-rdf.feature).


## bio-table API (for Ruby programmers)

```ruby
    require 'bio-table'
    include BioTable
```

### Reading, transforming, and writing a table

Note: the Ruby API below is a work in progress.

Tables are two dimensional matrixes, which can be read from a file

```ruby
    t = Table.read_file('test/data/input/table1.csv')
    p t.header              # print the header array
    p t.name[0],t[0]        # print the row name and row row
    p t[0][0]               # print the top corner field
```

The table reader has quite a few options for defining field separator,
which column to use for names etc. More interestingly you can pass a
function to limit the amount of row read into memory:

```ruby
    t = Table.read_file('test/data/input/table1.csv',
      :by_row => { | row | row[0..3] } )
```

will create a table of the column name +row[0]+ and 2 table fields. You can use
the same idea to reformat and reorder table columns when reading data
into the table. E.g.

```ruby
    t = Table.read_file('test/data/input/table1.csv',
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When a header can not be transformed, it may fail. You can test for
the header with row.header?, but in this case you
can pass in a :by_header, which will have :by_row only call on
actual table rows.

```ruby
    t = Table.read_file('test/data/input/table1.csv',
      :by_header => { | header | ["Row name", header[0..3], header[6]].flatten } )
      :by_row => { | row | [row.rowname, row[0..3], row[6].to_i].flatten } )
```

When by_row returns nil or false, the table row is skipped. One way to
transform a file, and not loading it in memory, is

```ruby
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

```ruby
    t.write_file('test1a.csv')
```

again columns can be reordered/transformed using a function. Another
option is by passing in an list of column numbers or header names, so
only those get written, e.g.

```ruby
    t.write_file('test1a.csv', columns: [0,1,2,4,6,8])
    t.write_file('test1b.csv', columns: ["AJ","B6","Axb1","Axb4","AXB13","Axb15","Axb19"] )
```

other options are available for excluding row names (rownames: false), etc.

To sort a table file, the current routine is to load the file in
memory and sort according to table columns. In the near future we aim
to have a low-memory version, by reading only the sorting columns in
memory, and indexing them before writing output. That means reading a
file twice, but being able to handle much larger data.

In above examples we loaded the whole table in memory. It is also
possible to execute functions without using RAM by using the emit
function. This is what the bio-table CLI does to convert a CSV table
to tab delimited:

```ruby
ARGV.each do | fn |
  f = File.open(fn)
  writer = BioTable::TableWriter::Writer.new(format: :tab)
  BioTable::TableLoader.emit(f, in_format: :csv).each do |row,type| 
    writer.write(TableRow.new(row[0],row[1..-1]),type)
  end
end
```

Essentially you can pass in any object that has the *each* method to
iterate through rows as String (f's each method reads in a line at a
time). The emit function yields the parsed row object as a simple
array of fields (each field a String). The type is used to distinguish 
the header row.

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

