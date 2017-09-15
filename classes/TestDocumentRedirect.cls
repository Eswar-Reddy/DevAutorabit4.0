@isTest
private class TestDocumentRedirect
{
	@isTest
	static void testNew()
	{
		Document__c myDoc = new Document__c();
		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		DocumentNewRedirect redirect = new  DocumentNewRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}

	@isTest
	static void testNewPartner()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

    	Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(currentUser) 
        {
			Test.startTest();

			Document__c myDoc = new Document__c();
			myDoc.Account__c=testPartner.Id;
			ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

			DocumentNewRedirect redirect = new  DocumentNewRedirect(sc);
			PageReference pr = redirect.redirect();
			System.assert(pr != null);

			Test.stopTest();
		}
	}

	@isTest
	static void testDetail()
	{
		Document__c myDoc = new Document__c();
		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		DocumentRedirect redirect = new  DocumentRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}

	@isTest
	static void testDetailPartner()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

    	Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(currentUser) 
        {
			Test.startTest();

			Document__c myDoc = new Document__c();
			ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

			DocumentRedirect redirect = new  DocumentRedirect(sc);
			PageReference pr = redirect.redirect();
			System.assert(pr != null);

			Test.stopTest();
		}
	}

	@isTest
	static void testEdit()
	{
		Document__c myDoc = new Document__c();
		ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

		DocumentEditRedirect redirect = new  DocumentEditRedirect(sc);
		PageReference pr = redirect.redirect();
		System.assert(pr != null);
	}

	@isTest
	static void testEditPartner()
	{
		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

    	Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(currentUser) 
        {
			Test.startTest();

			Document__c myDoc = new Document__c();
			ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

			DocumentEditRedirect redirect = new  DocumentEditRedirect(sc);
			PageReference pr = redirect.redirect();
			System.assert(pr != null);

			Test.stopTest();
		}
	}
}