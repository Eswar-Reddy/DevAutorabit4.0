@isTest
private class TestFPOOrderRedirect
{
    // NOTE: Partner users don't have permissions to Read/Write the FPO_Order_Line object. Without that,
    // tests running as partner users fail. Only non-partner users are tested here.
	@isTest
	static void testNew()
	{
		FPO_Order_Line__c myDoc = new FPO_Order_Line__c();
		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		FPOOrderNewRedirect redirect = new FPOOrderNewRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}

	@isTest
	static void testDetail()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

		LeasePayment__c lp = new LeasePayment__c();
		lp.Account__c = testPartner.Id;
		insert lp;

		FPO_Order_Line__c myDoc = new FPO_Order_Line__c();
		myDoc.Item_Number__c = 'Item';
		myDoc.Lease_Payment__c = lp.Id;
		insert myDoc;

		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		FPOOrderRedirect redirect = new FPOOrderRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}

	@isTest
	static void testEdit()
	{
		FPO_Order_Line__c myDoc = new FPO_Order_Line__c();
		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		FPOOrderEditRedirect redirect = new FPOOrderEditRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}
}