module BioTable
  module RDF

    # Write a table header as Turtle RDF. 
    #
    # If we have a column name 'AXB1' the following gets written:
    #
    # [:AXB1 rdf:label "AXB1"; a :colname; :index 3 ].
    #
    # This method returns a list of these.
    def RDF::header(row)
      list = []
      row.each_with_index do | field,i |
        s = "biotable:#{field} rdf:label \"#{field}\"; a biotable:colname; biotable:index #{i}."
        list << s
      end
      list
    end

    # Write a table row as Turtle RDF
    #
    # If we have a row, each row element gets written with the header colname as an id, e.g.
    #
    # [:rs13475701 rdf:label "rs13475701"; a :rowname; :Chromosome 1 ; :Pos 0 ; :AXB1 "AA"].
    #
    # The method returns a String.

    def RDF::row(row, header)
      list = []
      rowname = row[0]
      list << "biotable:#{rowname} rdf:label \"#{rowname}\"; a biotable:colname;"
      row.each_with_index do | field,i |
        list << ":#{header[i]} \"#{field}\";"
      end
      list.join(" ")
    end
  end
end
