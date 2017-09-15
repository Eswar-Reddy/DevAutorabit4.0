@isTest
private class GoogleVizTest {

    private static testmethod void testAddRow() {

	    GoogleViz gv = new GoogleViz();

		Test.startTest();
			gv.addRow( new GoogleViz.Row() );
	    Test.stopTest();

		System.assertEquals( 1,  gv.rows.size() );

	}

 	private static testmethod void testToJSONString() {

	    GoogleViz gv = new GoogleViz();

	    gv.cols = new list<GoogleViz.Col> { new GoogleViz.Col('A','New A', GoogleViz.COL_STRING ),
	         					  new GoogleViz.Col('B','B label', GoogleViz.COL_NUMBER ) };

	    GoogleViz.Row rr = new GoogleViz.Row();

	    GoogleViz.cell ctmp = new GoogleViz.cell('a');

	    rr.addCell ( ctmp );
	    rr.addCell ( new GoogleViz.cell( 3, '3ish' ) ); // {v: 3.0, f: '3'}

	    rr.addCell ( new GoogleViz.cell( Date.newInstance(2008,3,30), '4/30/08 12:31 AM' ) );

	    gv.addRow( rr );

		String actualJson;

		Test.startTest();
			actualJson = gv.toJSONString() ;
		Test.stopTest();

		System.assertNotEquals(null , actualJson , ' This should be a valid JSON String ' );

	}

 	private static testmethod void testColClass() {

 		final String ID    = 'some_id';
 		final String LABEL = 'some_label';
 		final String CTYPE = 'some_type';

    	Test.startTest();

    		GoogleViz.Col  noParamColumn =  new GoogleViz.Col();

    		GoogleViz.Col  oneParamColumn =  new GoogleViz.Col( ID );

    		GoogleViz.Col  twoParamColumn =  new GoogleViz.Col( ID, LABEL );

    		GoogleViz.Col  threeParamColumn =  new GoogleViz.Col( ID, LABEL, CTYPE );

   		Test.stopTest();

   		System.assertEquals( null       , noParamColumn.id );
   		System.assertEquals( null       , noParamColumn.label );
   		System.assertEquals( GoogleViz.COL_STRING , noParamColumn.type );

   		System.assertEquals( ID         , oneParamColumn.id );
   		System.assertEquals( null       , oneParamColumn.label );
   		System.assertEquals( GoogleViz.COL_STRING , oneParamColumn.type );

   		System.assertEquals( ID         , twoParamColumn.id );
   		System.assertEquals( LABEL      , twoParamColumn.label );
   		System.assertEquals( GoogleViz.COL_STRING , twoParamColumn.type );

   		System.assertEquals( ID    , threeParamColumn.id );
   		System.assertEquals( LABEL , threeParamColumn.label );
   		System.assertEquals( CTYPE , threeParamColumn.type );

	}

	private static testmethod void testRowClass() {

 		final List<GoogleViz.Cell> someCells = new List<GoogleViz.Cell> { new GoogleViz.Cell( null ) };

    	Test.startTest();

    		GoogleViz.Row  noParamRow =  new GoogleViz.Row();

    		GoogleViz.Row  oneParamRow =  new GoogleViz.Row( someCells );

   		Test.stopTest();

   		System.assertNotEquals( null , noParamRow.c, 'The constructor should initialize the cell list ' );

   		System.assertEquals( 1,  oneParamRow.c.size() );

	}

	private static testmethod void testRowClass_addCell() {

    	GoogleViz.Row  aRow =  new GoogleViz.Row();

    	Test.startTest();

    		aRow.addCell( new GoogleViz.Cell( null ) );

   		Test.stopTest();

   		System.assertEquals( 1,  aRow.c.size() , 'The cell should be added');

	}

 	private static testmethod void testCellClass() {

 		final Object VALUE           = Date.today();
 		final String FOMARTTED_VALUE = 'some_formatted_string';

    	Test.startTest();

    		GoogleViz.Cell  oneParamCell =  new GoogleViz.Cell( VALUE );

    		GoogleViz.Cell  twoParamCell =  new GoogleViz.Cell( VALUE, FOMARTTED_VALUE );

   		Test.stopTest();

   		System.assertEquals( VALUE , oneParamCell.v );
   		System.assertEquals( null  , oneParamCell.f );

   		System.assertEquals( VALUE            , twoParamCell.v );
   		System.assertEquals( FOMARTTED_VALUE  , twoParamCell.f );

	}
}