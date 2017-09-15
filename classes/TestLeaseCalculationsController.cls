@isTest(SeeAllData=true)
private class TestLeaseCalculationsController {
//Unit tests for the button
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
    
	static testMethod void testLeaseCalculationsConstructor() 
	{
		setup();
		
		newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];
		
		
		LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, true );
				
		Test.startTest();
		
			ApexPages.Standardcontroller stdc = new ApexPages.Standardcontroller(leasePayment);
			LeaseCalculationsController leaseCalculationsController = new LeaseCalculationsController(stdc);
		
		Test.stopTest();
		
		System.assertNotEquals( null, leaseCalculationsController.leasePayment, 'The leasePayment should be set.' );
		System.assertEquals( leasePayment.Id, leaseCalculationsController.leasePayment.Id, 'The leasePayment should be set to the leasePayment created.' );
	}
	
	static testMethod void testRunCalculations()
	{
		setup();
		
		newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

		List<Lease_Schedule__c> leaseSchedules = TestUtils.createLeaseSchedules( newQuote.Id, true );
		
		LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'Lease Payment', newAccount.Id, newQuote.Id, true );
				
		ApexPages.Standardcontroller stdc = new ApexPages.Standardcontroller(leasePayment);
		LeaseCalculationsController leaseCalculationsController = new LeaseCalculationsController(stdc);

		Test.startTest();
		
			PageReference actualPageRef = leaseCalculationsController.runCalculations();
		
		Test.stopTest();
		
		List<Lease_Schedule_Summary__c> actualLeaseSummaries = [SELECT Id FROM Lease_Schedule_Summary__c WHERE Quote__c = :leasePayment.Quote__c];
		
		System.assertEquals(1,actualLeaseSummaries.size(),'There should be one lease schedule summary created');
		
		String actualUrl = actualPageRef.getUrl();
				
		System.assert(actualUrl.contains(actualLeaseSummaries[0].Id),'The page ref should redirect to the newly calculated summary');	
	}
	
}