Feature: Read CSV table

  bio-table should read multiple table formats. 

  Scenario: Read a comma separated table
    Given a comma separated table
        """
        #Gene,AJ,B6,Axb1,Axb2,Axb4,Axb12,AXB13,Axb15,Axb19,Axb23,Axb24,Bxa1,Bxa2,Bxa4,Bxa7,Bxa8,Bxa12,Bxa11,Bxa13,Bxa15,Bxa16,Axb5,Axb6,Axb8,Axb1,Bxa24,Bxa25,Bxa26,gene_symbol,gene_desc
        105853,0.06,0,0,0,0,0,0.11,0,0,0,,,0,0,0,0,0,0,0,0,0,0,0,0,,0,,,Mal2,"MAL2 proteolipid protein"
        105855,236.88,213.95,213.15,253.49,198,231.56,200.96,255.2,214.04,231.46,,,233.23,241.26,237.53,171.87,237.13,162.3,252.13,284.85,188.76,253.43,220.15,305.52,,217.42,,,Nckap1l,"NCK associated protein 1 like,NCK associated protein 1 like,"
        105859,0,0.14,0,0,0.07,0.04,0,0,0,0,,,0.02,0,0,0,0,0,0.06,0,0,0,0.02,0,,0,,,Csdc2,"RNA-binding protein pippin"
        105866,0,0,0,0,0,0,0,0,0,0,,,0,0,0,0,0,0,0,0,0,0,0,0,,0,,,Krt72,"keratin 72"
        """
    When I read the multi-line string
    Then I should correctly parse the comma-separated headers into "#Gene","AJ","B6"
    And I should correctly parse the first line into 
      """
      ["0.06", "0", "0", "0", "0", "0", "0.11", "0", "0", "0", nil, nil, "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", nil, "0", nil, nil, "Mal2", "MAL2 proteolipid protein"]
      """
    And it should have the field name "105853"


