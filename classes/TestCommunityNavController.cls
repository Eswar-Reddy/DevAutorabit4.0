@isTest
private class TestCommunityNavController
{
	@isTest
	static void testController()
	{
		Community_Tab_Configuration__c tab = new Community_Tab_Configuration__c();
		tab.Name = 'Test Tab';
		tab.View_Order__c = 0;
		tab.Enabled_Profiles__c = 'Partner Executive';
		tab.URL__c = '/apex/OrderDetailsRedirect';
		insert tab;

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

			CommunityNavController nav = new CommunityNavController();

			List<List<CommunityNavController.NavObject>> objs = CommunityNavController.getTabs(new List<String>{'Test Tab'});
			System.assert(objs!=null);
			Test.stopTest();
		}
	}
}