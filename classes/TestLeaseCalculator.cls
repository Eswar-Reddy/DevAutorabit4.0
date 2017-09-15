@isTest
private class TestLeaseCalculator 
{

	static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    static Quote newQuote;
    
    static void setup()
    {
        newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
        newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
    }
    
	static testMethod void testCalculatorConstructor() 
	{
		setup();
		
		newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];
		
		LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, true );
		
		Lease_Schedule_Summary__c scheduleSummary = TestUtils.createLeaseScheduleSummary( newQuote.Id, leasePayment.Id, true );
		
		Test.startTest();
		
			LeaseCalculator calculator = new LeaseCalculator( new List< Lease_Schedule_Summary__c >{ scheduleSummary } );
		
		Test.stopTest();
		
		System.assertNotEquals( null, calculator.leaseCalcModels, 'The leasecalcmodel list should be set.' );
		System.assertEquals( 1, calculator.leaseCalcModels.size(), 'The leasecalcmodel list should contain 1 element.' );
	}
	
	
	static testMethod void testCalculatorExceptionHandler() 
	{
		setup();
		
		newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];
		
		LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, true );
		
		Lease_Schedule_Summary__c scheduleSummary = TestUtils.createLeaseScheduleSummary( newQuote.Id, leasePayment.Id, true );
		
		LeaseCalculator calculator = new LeaseCalculator( new List< Lease_Schedule_Summary__c >{ scheduleSummary } );
		
		Test.startTest();
		
			//an exception is forced here because there is a required field check on the LeaseCalcModel
			// an exception should always be forced	
			calculator.recordCalculations();
		
		Test.stopTest();	
		
		Lease_Schedule_Summary__c erroredSummary = [SELECT Id, Error_Message__c FROM Lease_Schedule_Summary__c WHERE Id = :scheduleSummary.Id ];
		
		System.assertNotEquals( null, erroredSummary.Error_Message__c, 'The lease schedule summary error message should be set.' );
		System.assert( erroredSummary.Error_Message__c.contains('Line Number'), 'The lease schedule summary error message should be set.' );
		
	}
		
}