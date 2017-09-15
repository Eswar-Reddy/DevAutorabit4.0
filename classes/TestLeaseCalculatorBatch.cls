@isTest(SeeAllData=true)
private class TestLeaseCalculatorBatch {
	
	static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    static Quote newQuote;
    static Lease_Schedule_Summary__c scheduleSummary;
    
    static void setup()
    {
        newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
        newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
		newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];
		
		LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, false );
		leasePayment.Placed_In_Service__c = Date.today();
		insert leasePayment;
		
		scheduleSummary = TestUtils.createLeaseScheduleSummary( newQuote.Id, leasePayment.Id, true );
    }

	static testMethod void testBatch()
	{
		setup();
			
    	Test.startTest();
	    	
	    	LeaseCalculatorBatch batch = new LeaseCalculatorBatch();
	    	
	    	batch.BATCH_QUERY += ' AND Id = \''+ scheduleSummary.Id +'\'';
	    	
	        Database.executeBatch(batch, 1);
	        
        Test.stoptest();
        
		List<Lease_Schedule_Summary__c> actualLeaseSummaries = [SELECT Id, Date_Of_Last_Calculations_Attempt__c FROM Lease_Schedule_Summary__c WHERE Quote__c = :newQuote.Id];
	
		System.assertEquals(1,actualLeaseSummaries.size(),'There should only be one lease schedule summary created');
		System.assertEquals(Date.today(),actualLeaseSummaries[0].Date_Of_Last_Calculations_Attempt__c,'There should be a time stamp of whenever a calculation is attempted');
	
	}

}