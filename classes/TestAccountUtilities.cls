/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAccountUtilities {

 //   static testMethod void testAccountSyncChanged(){
    	
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
	//	mainAccount.BillingStreet = '44 Rio Robles';
	//	mainAccount.BillingPostalCode = '95134';
	//	mainAccount.BillingCity = 'San Jose';
	//	mainAccount.BillingState = 'Ca';
	//	mainAccount.BillingCountry = 'United States';
	//	insert mainAccount;
		
	//	Account mainAccount1 = TestUtils.createAccount('Test Account 2', false);
	//	mainAccount1.Partner_Account__c = partnerAccount.Id;
	//	mainAccount1.BillingStreet = '77 Rio Robles';
	//	mainAccount1.BillingPostalCode = '95134';
	//	mainAccount1.BillingCity = 'San Jose';
	//	mainAccount1.BillingState = 'Ca';
	//	mainAccount1.BillingCountry = 'United States';
	//	insert mainAccount1;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, null, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Account> newMap = new Map<Id,Account>();
	//	newMap.put(mainAccount.Id,mainAccount);
		
	//	Map<Id,Account> oldMap = new Map<Id,Account>();
	//	oldMap.put(mainAccount.Id,mainAccount1);
		
	//	Test.startTest();
	//		AccountUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	System.assertEquals(AccountUtilities.isChangedMap.get(mainAccount.Id),true);
		
	//}
	
	//static testMethod void testAccountSyncUnchanged(){
    	
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
	//	mainAccount.BillingStreet = '77 Rio Robles';
	//	mainAccount.BillingPostalCode = '95134';
	//	mainAccount.BillingCity = 'San Jose';
	//	mainAccount.BillingState = 'CA';
	//	mainAccount.BillingCountry = 'United States';
	//	insert mainAccount;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, null, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Account> newMap = new Map<Id,Account>();
	//	newMap.put(mainAccount.Id,mainAccount);
		
	//	Map<Id,Account> oldMap = new Map<Id,Account>();
	//	oldMap.put(mainAccount.Id,mainAccount);
		
	//	Test.startTest();
	//		AccountUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	System.assertEquals(AccountUtilities.isChangedMap.get(mainAccount.Id),false);
		
	//}
	
	//static testMethod void testAccountSyncNonSpectrum(){
    	
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
	//	mainAccount.BillingStreet = '77 Rio Robles';
	//	mainAccount.BillingPostalCode = '95134';
	//	mainAccount.BillingCity = 'San Jose';
	//	mainAccount.BillingState = 'Ca';
	//	mainAccount.BillingCountry = 'United States';
	//	insert mainAccount;
		
	//	Account mainAccount1 = TestUtils.createAccount('Test Account 2', false);
	//	mainAccount1.Partner_Account__c = partnerAccount.Id;
	//	mainAccount1.BillingStreet = '77 Rio Robles';
	//	mainAccount1.BillingPostalCode = '95134';
	//	mainAccount1.BillingCity = 'San Jose';
	//	mainAccount1.BillingState = 'Ca';
	//	mainAccount1.BillingCountry = 'United States';
	//	insert mainAccount1;
		
	//	Opportunity opp = TestUtils.createOpportunities(1, mainAccount.Id, null, false)[0];
	//	opp.Partner_Account_Id__c = partnerAccount.Id;
	//	insert opp;
		
	//	Map<Id,Account> newMap = new Map<Id,Account>();
	//	newMap.put(mainAccount.Id,mainAccount);
		
	//	Map<Id,Account> oldMap = new Map<Id,Account>();
	//	oldMap.put(mainAccount.Id,mainAccount1);
		
	//	Test.startTest();
	//		AccountUtilities.qualifySpectrumRecordsAfterUpdate(newMap, oldMap);
	//	Test.stopTest();
		
	//	//Should be null as the check never happens
	//	System.assertEquals(AccountUtilities.isChangedMap.get(mainAccount.Id),null);
		
	//}
}