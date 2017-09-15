@isTest
private class AngularUtilities_Test {

	static TestMethod void testConstructors() {

		Test.startTest();

		AngularUtilities util = new AngularUtilities();

		PageReference ref = Page.StatementOfAccount;
		Test.setCurrentPageReference(ref);

		AngularUtilities utilSOA = new AngularUtilities(new StatementOfAccounts());

		Test.stopTest();
	}

	static TestMethod void testGetPartners() {

		Account partner = TestClassFactory.createDealer('testParnter', 'North America');

		Test.startTest();

		ResultMessage message = AngularUtilities.getPartners();
		System.assert(message.payloadMap.size() > 0);

		Test.stopTest();

	}

	static TestMethod void testGetSFAccountId() {

		Account partner = TestClassFactory.createDealer('testParnter', 'North America');

		Test.startTest();

		ResultMessage message = AngularUtilities.getSalesforceAccountId(partner.Oracle_Account_Number__c);

		Test.stopTest();

	}

	static TestMethod void testGetPartnerInfo() {

		Account partner = TestClassFactory.createDealer('testParnter', 'North America');
		partner.isPartner = true;
		update partner;

		Contact partnerContact = TestClassFactory.testContact('testContact', 'test_soa@noemail.com', TestClassFactory.retrieveRecordTypeId('Contact', 'Partner'));
		partnerContact.AccountId = partner.Id;
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

		System.runAs(currentUser) {
			Test.startTest();
			ResultMessage message = AngularUtilities.getPartnerInfo();
			Test.stopTest();
		}
	}

	static TestMethod void testGenerateLogging1() {

		Test.startTest();

		AngularUtilities.generateLogging('Test Logging', 'outboundReq', 'inboundRes');

		Test.stopTest();
	}

	static TestMethod void testGenerateLogging2() {

		Account partner = TestClassFactory.createDealer('testParnter', 'North America');

		Test.startTest();

		AngularUtilities.generateLogging('Test Logging', 'outboundReq', 'inboundRes', partner.Id);

		Test.stopTest();

	}

	static TestMethod void testGenerateLogging3() {

		Test.startTest();

		AngularUtilities.generateLogging('Test Logging', null, null);

		Test.stopTest();
	}

	static TestMethod void testGenerateLogging4() {

		Test.startTest();

		AngularUtilities.generateLogging('Test Logging', 'outboundReq', 'inboundRes', '123456789101213');

		Test.stopTest();

	}

}