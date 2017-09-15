@isTest
private class AccountManagementTempTest {
	
	static TestMethod void testAcctManagementCreateContact() {

		SIC__c sic = TestClassFactory.testSIC();
		sic.First_Level__c = 'Level1'; 
        sic.Second_Level__c = 'Level2';
        sic.Third_Level__c = 'Level3';     
        sic.SPWR_Industry_Type__c = 'Other';
        sic.Sic_Code__c = '2345';
		insert sic;

		Account a = TestClassFactory.testAccount('testacctmgt', TestClassFactory.retrieveRecordTypeId('Account', 'Residential Customer'));
		insert a;

		a.AccountNumber = null;
		a.Integration_ID__c = null;
		a.SIC = '2345';
		List<Account> accts = new List<Account>();
		accts.add(a);

		Test.startTest();
		AccountManagement.afterAccountInsert(accts);
		AccountManagement.createContact(accts);
		Test.stopTest();

	}

	static TestMethod void testAcctMgmtcreateTaskOnAccountStatusChange() {

		List<Account> newAccts = new List<Account>();
		List<Account> oldAccts = new List<Account>();

		Account a = TestClassFactory.testAccount('testnewpartner', TestClassFactory.retrieveRecordTypeId('Account', 'Partner'));
		a.Status__c = 'Contract Pending';
		insert a;
		oldAccts.add(a);

		Test.startTest();
		
		a.Status__c = 'Active';
		a.Primary_PSR__c = UserInfo.getUserId();
		a.Country_Domain__c = 'combo-au';
		newAccts.add(a);

		
		AccountManagement.afterAccountUpdate(newAccts, oldAccts);
		Test.stopTest();

	}

	static TestMethod void testAcctMgmtCountryDomain() {


		List<Account> newAccts = new List<Account>();
		List<Account> oldAccts = new List<Account>();
		Map<Id, Account> oldAcctMap = new Map<Id, Account>();
		Map<Id, Account> newAcctMap = new Map<Id, Account>();

		Account dealer = TestClassFactory.createDealer('testdealeracct', 'North America');

		Account a = TestClassFactory.testAccount('testnewpartner', TestClassFactory.retrieveRecordTypeId('Account', 'Partner'));
		a.Status__c = 'Contract Pending';
		insert a;
		oldAccts.add(a);
		oldAcctMap.putAll(oldAccts);


		User testUser = TestClassFactory.testAndInsertPortalUser('testuserman@noemail.com', 'tstgrl66', dealer.Id);
		System.runAs(testUser) {
			a.OwnerId = testUser.Id;
			newAccts.add(a);
			newAcctMap.putAll(newAccts);

			Test.startTest();
			AccountManagement.updateUserCountryDomain(newAcctMap, newAccts, oldAcctMap);
			AccountManagement.updateContactCountryDomain(newAcctMap, newAccts, oldAcctMap);
			Test.stopTest();
		}

	}

	
	
}