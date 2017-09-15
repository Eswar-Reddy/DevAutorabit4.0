@isTest
private class TestContactUtilities {
	
	
	//static testMethod void testContactSyncIsChanged(){
		
	//	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
 //   	u.Division = 'Test';
 //   	u.Country = 'United States';
 //   	insert u;
 //   	System.runAs(u){
 //   		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
 //   		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
 //   		credential.Username__c = 'Nothing';
 //   		credential.Password__c = 'Nothing';
 //   		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
 //   		insert credential;
 //   	}
		
	//	Account partnerAccount = TestUtils.createAccount('Partner Account 1', false);
	//	partnerAccount.isSpectrumPartner__c =  true;
	//	insert partnerAccount;
		
	//	Account mainAccount = TestUtils.createAccount('Test Account 1', false);
	//	mainAccount.Partner_Account__c = partnerAccount.Id;
	//	insert mainAccount;
		
	//	Contact contactToTest = TestUtils.createContact('Test Testerson', mainAccount.Id, false);
	//	contactToTest.email = 'test1@email.com';
	//	insert contactToTest;
		
	//	Contact contactToTest1 = TestUtils.createContact('Test1 Testerson1',mainAccount.Id,false);
	//	contactToTest1.email = 'test2@email.com';
	//	insert contactToTest1;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, contactToTest.Id, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Contact> newMap = new Map<Id,Contact>();
	//	newMap.put(contactToTest.Id,contactToTest);
		
	//	Map<Id,Contact> oldMap = new Map<Id,Contact>();
	//	oldMap.put(contactToTest.Id,contactToTest1);
		
	//	Test.startTest();
	//		ContactUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	System.assertEquals(ContactUtilities.isChangedMap.get(contactToTest.Id),true);
		
	//}
	
	//static testMethod void testContactSyncNotChanged(){
		
	//	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
 //   	u.Division = 'Test';
 //   	u.Country = 'United States';
 //   	insert u;
 //   	System.runAs(u){
 //   		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
 //   		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
 //   		credential.Username__c = 'Nothing';
 //   		credential.Password__c = 'Nothing';
 //   		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
 //   		insert credential;
 //   	}
		
	//	Account partnerAccount = TestUtils.createAccount('Partner Account 1', false);
	//	partnerAccount.isSpectrumPartner__c =  true;
	//	insert partnerAccount;
		
	//	Account mainAccount = TestUtils.createAccount('Test Account 1', false);
	//	mainAccount.Partner_Account__c = partnerAccount.Id;
	//	insert mainAccount;
		
	//	Contact contactToTest = TestUtils.createContact('Test Testerson', mainAccount.Id, false);
	//	contactToTest.email = 'test1@email.com';
	//	insert contactToTest;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, contactToTest.Id, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Contact> newMap = new Map<Id,Contact>();
	//	newMap.put(contactToTest.Id,contactToTest);
		
	//	Map<Id,Contact> oldMap = new Map<Id,Contact>();
	//	oldMap.put(contactToTest.Id,contactToTest);
		
	//	Test.startTest();
	//		ContactUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	System.assertEquals(ContactUtilities.isChangedMap.get(contactToTest.Id),false);
		
	//}
	
	//static testMethod void testContactSyncNotSpectrumPartner(){
		
	//	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
 //   	u.Division = 'Test';
 //   	u.Country = 'United States';
 //   	insert u;
 //   	System.runAs(u){
 //   		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
 //   		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
 //   		credential.Username__c = 'Nothing';
 //   		credential.Password__c = 'Nothing';
 //   		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
 //   		insert credential;
 //   	}
		
	//	Account partnerAccount = TestUtils.createAccount('Partner Account 1', false);
	//	insert partnerAccount;
		
	//	Account mainAccount = TestUtils.createAccount('Test Account 1', false);
	//	mainAccount.Partner_Account__c = partnerAccount.Id;
	//	insert mainAccount;
		
	//	Contact contactToTest = TestUtils.createContact('Test Testerson', mainAccount.Id, false);
	//	contactToTest.email = 'test1@email.com';
	//	insert contactToTest;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, contactToTest.Id, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Contact> newMap = new Map<Id,Contact>();
	//	newMap.put(contactToTest.Id,contactToTest);
		
	//	Map<Id,Contact> oldMap = new Map<Id,Contact>();
	//	oldMap.put(contactToTest.Id,contactToTest);
		
	//	Test.startTest();
	//		ContactUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	System.assertEquals(ContactUtilities.isChangedMap.get(contactToTest.Id),null);
		
	//}
	
}