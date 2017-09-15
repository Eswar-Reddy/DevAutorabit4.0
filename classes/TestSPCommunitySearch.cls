@isTest
private class TestSPCommunitySearch
{
	static Account testAcct;
	static Opportunity testOpp;

    static void setup()
    {
       	Community_Search_Object__c cso1 = new Community_Search_Object__c();
       	cso1.Name = 'Account';
       	insert cso1;

       	Community_Search_Object__c cso2 = new Community_Search_Object__c();
       	cso2.Name = 'Opportunity';
       	insert cso2;

       	Community_Search_Field__c csAccount1 = new Community_Search_Field__c();
       	csAccount1.Name = 'BillingCity';
       	csAccount1.Search_Object__c = cso1.Id;
       	csAccount1.Search_Order__c = 1;
       	insert csAccount1;

       	Community_Search_Field__c csAccount2 = new Community_Search_Field__c();
       	csAccount2.Name = 'BillingState';
       	csAccount2.Search_Object__c = cso1.Id;
       	csAccount2.Search_Order__c = 2;
       	insert csAccount2;

       	Community_Search_Field__c csOpp1 = new Community_Search_Field__c();
       	csOpp1.Name = 'StageName';
       	csOpp1.Search_Object__c = cso2.Id;
       	csOpp1.Search_Order__c = 1;
       	insert csOpp1;

       	testAcct = new Account();
       	testAcct.Name = 'Test Account';
       	testAcct.BillingStreet = '123 First St';
       	testAcct.BillingCity = 'Denver';
       	testAcct.BillingState = 'CO';
       	testAcct.BillingCountry = 'United States';
       	testAcct.BillingPostalCode = '55555';
       	insert testAcct;

       	testOpp = new Opportunity();
       	testOpp.Name = 'Test Opp';
       	testOpp.AccountId = testAcct.Id;
       	testOpp.StageName = '12% - Qualified Opportunity';
       	testOpp.CloseDate = System.today();
       	insert testOpp;
    }

	@isTest
	static void testEmptyResults()
	{
		setup();

		PageReference pageRef = new PageReference('/apex/SPCommunitySearch');
		pageRef.getParameters().put('searchString','Test');
	    Test.setCurrentPage(pageRef);

		SPCommunitySearch spSearch = new SPCommunitySearch();
		spSearch.search();

		System.assert(spSearch.resultsWrapper == null);

	}

	@isTest
	static void testResults()
	{
		setup();

		PageReference pageRef = new PageReference('/apex/SPCommunitySearch');
		pageRef.getParameters().put('searchString','Test');
	    Test.setCurrentPage(pageRef);

	    Id [] fixedSearchResults= new Id[2];
   		fixedSearchResults[0] = testAcct.Id;
   		fixedSearchResults[1] = testOpp.Id;
   		Test.setFixedSearchResults(fixedSearchResults);

		SPCommunitySearch spSearch = new SPCommunitySearch();
		spSearch.search();

		System.assert(spSearch.resultsWrapper.size() > 0);

	}

}