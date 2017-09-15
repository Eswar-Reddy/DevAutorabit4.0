@isTest
private class SpectrumDebugUtilityTest {

	@isTest static void test_method_one() {
		List<SpectrumDebugUtility.debugLog> logList = new List<SpectrumDebugUtility.debugLog>();
		Integer numLogs = 5;
		for(Integer i = 0; i < numLogs; i++) {
			logList.add(createDebugLog());
		}
		Test.startTest();
			SpectrumDebugUtility.generateDebugLog(createDebugLog());
			SpectrumDebugUtility.generateDebugLog(logList);
			SpectrumDebugUtility.createExceptionLog('String errorMessage', 'String stackTrace', 'String type', getFakeId(Account.SObjectType));
			SpectrumDebugUtility.createExceptionLog('String errorMessage', 'String stackTrace', 'String type', getFakeId(Opportunity.SObjectType));
			SpectrumDebugUtility.createExceptionLog('String errorMessage', 'String stackTrace', 'String type', getFakeId(Quote.SObjectType));
			SpectrumDebugUtility.createExceptionLog('String errorMessage', 'String stackTrace', 'String type', getFakeId(Purchase_Order__c.SObjectType));
		Test.stopTest();
	}

	@isTest static void test_method_two() {
		List<Account> a = new List<Account>();
		Integer numAccounts = 5;
		for(Integer i = 0; i < numAccounts; i++) {
			a.add(TestClassFactory.testAccount('Account ' + String.valueOf(i), SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType).get('Partner')));
			a.add(createAccount());
		}

		List<Database.SaveResult> srList = Database.insert(a, false);
		Test.startTest();
			SpectrumDebugUtility.createExceptionLogs(srList, 'String errorMessage', Account.SObjectType);
		Test.stopTest();
	}

	private static SpectrumDebugUtility.debugLog createDebugLog() {
		SpectrumDebugUtility.debugLog dl = new SpectrumDebugUtility.debugLog();
		dl.jsonPayload = 'json';
		dl.service = 'service';
		dl.response = 'response';
		dl.responseCode = 123;
		dl.responseBlob = Blob.valueOf('isBlob');
		dl.opportunityId = getFakeId(Opportunity.SObjectType);
		dl.quoteId = getFakeId(Quote.SObjectType);
		dl.accountId = getFakeId(Account.SObjectType);
		dl.contactId = getFakeId(Contact.SObjectType);
		dl.purchaseOrderId = getFakeId(Purchase_Order__c.SObjectType);
		return dl;
	}

	private static Integer sNum = 1;
	private static String getFakeId(Schema.SObjectType sot) {
		String result = String.valueOf(sNum++);
		return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
	}

	private static Account createAccount() {
		Account a = new Account();
        a.Name = 'DealerName';
        a.Type = 'Premier-Partner-Residential';
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        a.Dealer_Score_Total__c = 78;
        a.Dealer_Locator_Phone__c = '888-888-8888';
        a.Phone = '888-888-8888';
        a.BillingStreet = '150 Corona St';
        a.BillingCity = 'Denver';
        a.BillingState = 'CO';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '80218';
        a.Website = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c = '123';
        a.Description = 'None';
        a.Partner_Facts__c = 'None';
        a.Status__c = 'Active';
        a.Dealer_Locator_Opt_Out__c = false;
        a.Lead_Flow_Opt_Out__c = false;
        a.Alliance_Program_Partner__c = true;
        a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
        a.Theater__c = 'North America';
        a.Primary_PSR__c = UserInfo.getUserId();
        a.RSM__c = UserInfo.getUserId();
        a.Special_Programs__c = 'Storage - Hawaii';
        a.Country_Domain__c = 'combo-us';
        a.Oracle_Operating_Unit__c = 'SPNA OU';
        return a;
	}
}