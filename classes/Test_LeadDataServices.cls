/*

Test class for all related files to the REST_LeadData services

Class:              Test_LeadDataServices
Date:               06/03/2014
Version:            1
Last Updated:       06/30/2014
    * 	Stubbed
    *	Completed

////////////////////////////////////////////////////////////////////////////////
*/

@isTest
private class Test_LeadDataServices
{	
	// -------- Variables --------
	private static String baseURL;
	private static String testServiceURL;
	private static String testPostServiceURL;
	private static RestRequest testRequest;
	private static RestResponse testResponse;
	private static User testPortalUser;
	private static List<REST_LeadModification.LeadRecord> testSubmittedRecords;
	private static String testCompanyID = '88558855';
	private static Account testPartnerAccount;
	private static Opportunity testMasterOppRecord;
	private static List<REST_LeadModification.LeadRecord> testValidationList;
	
	// -------- Shared Methods --------
	// Initialization of test data example
	private static void init(Integer testType)
	{
		baseURL = System.URL.getSalesforceBaseUrl().getHost();
		testServiceURL = 'https://' + baseURL + '/services/apexrest/LeadData/v0?';
		testPostServiceURL = 'https://' + baseURL + '/services/apexrest/LeadModification/v0?createUpdateLead';
		Diagnostics.debug('testServiceURL: ' + testServiceURL);
				
		testRequest = new RestRequest();
		testResponse = new RestResponse();
		
		testPartnerAccount = TestClassFactory.testAccount('TestPotalUserAccount', TestClassFactory.retrieveRecordTypeID('Account', 'Partner'));
		testPartnerAccount.PartnerAccessID__c = testCompanyID;
		insert testPartnerAccount;
		
		if(testType == 1)
		{
			Account previouslyInsertedAccount = TestClassFactory.testAccount('Sample', 
					TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
			insert previouslyInsertedAccount;
			
			Contact previouslyInsertedContact = TestClassFactory.testContact('Sample', 'sampleupdate@restservice.com', 
				TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
			previouslyInsertedContact.AccountID = previouslyInsertedAccount.ID;
			insert previouslyInsertedContact;
				
			testMasterOppRecord = TestClassFactory.testOpportunity('Sample', 'New Opportunity', date.today(), 
				TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
			testMasterOppRecord.Partner_Account_Id__c = testPartnerAccount.ID;
			testMasterOppRecord.AccountID = previouslyInsertedAccount.ID;
			testMasterOppRecord.Primary_Contact__c = previouslyInsertedContact.ID;
			insert testMasterOppRecord;
		}
		else if(testType == 2)
		{
			List<Account> accountsToInsert = new List<Account>();
			List<Contact> contactsToInsert = new List<Contact>();
			List<Opportunity> oppsToInsert = new List<Opportunity>();
			
			Account previouslyInsertedAccount = TestClassFactory.testAccount('Sample', 
				TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
			Account previouslyInsertedAccount2 = TestClassFactory.testAccount('Sample2', 
				TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
			accountsToInsert.add(previouslyInsertedAccount);
			accountsToInsert.add(previouslyInsertedAccount2);
			insert accountsToInsert;
			
			Contact previouslyInsertedContact = TestClassFactory.testContact('Sample', 'sampleupdate1@restservice.com', 
				TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
			Contact previouslyInsertedContact2 = TestClassFactory.testContact('Sample2', 'sampleupdate2@restservice.com', 
				TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
			previouslyInsertedContact.AccountID = previouslyInsertedAccount.ID;
			previouslyInsertedContact2.AccountID = previouslyInsertedAccount2.ID;
			contactsToInsert.add(previouslyInsertedContact);
			contactsToInsert.add(previouslyInsertedContact2);
			insert contactsToInsert;
			
			Opportunity previouslyInsertedOpp = 
				TestClassFactory.testOpportunity('Sample', 'New Opportunity', date.today(), 
					TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
			Opportunity previouslyInsertedOpp2 = 
				TestClassFactory.testOpportunity('Sample2', 'New Opportunity', date.today(), 
					TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
			previouslyInsertedOpp.AccountID = previouslyInsertedAccount.ID;
			previouslyInsertedOpp.Partner_Account_Id__c = testPartnerAccount.ID;
			previouslyInsertedOpp.Primary_Contact__c = previouslyInsertedContact.ID;
			
			previouslyInsertedOpp2.AccountID = previouslyInsertedAccount2.ID;
			previouslyInsertedOpp2.Partner_Account_Id__c = testPartnerAccount.ID;
			previouslyInsertedOpp2.Primary_Contact__c = previouslyInsertedContact2.ID;
			
			oppsToInsert.add(previouslyInsertedOpp);
			oppsToInsert.add(previouslyInsertedOpp2);
			insert oppsToInsert;
		}
		else if(testType == 3)
		{
			Vertex_Address_Validation__c testValidAddress = new Vertex_Address_Validation__c();
			testValidAddress.Geo_Postal_Code__c = '80000';
			testValidAddress.Geo_City__c = 'Denver';
			testValidAddress.Geo_County__c = 'Denver County';
			insert testValidAddress;
			
			testValidationList = new List<REST_LeadModification.LeadRecord>();
		
			REST_LeadModification.LeadRecord testB = new REST_LeadModification.LeadRecord();
			testB.firstName = 'NoLastName';
			testValidationList.add(testB);
			
			REST_LeadModification.LeadRecord testC = new REST_LeadModification.LeadRecord();
			testC.firstName = 'aaaaaaaaaabbbbbbbbbbccccccccccdddddddddde';
			testValidationList.add(testC);
			
			REST_LeadModification.LeadRecord testD = new REST_LeadModification.LeadRecord();
			testD.lastName = 'aaaaaaaaaabbbbbbbbbbccccccccccdddddddddde';
			testValidationList.add(testD);
			
			REST_LeadModification.LeadRecord testE = new REST_LeadModification.LeadRecord();
			testE.firstName = 'NoStreet';
			testE.lastName = 'Address';
			testValidationList.add(testE);
			
			REST_LeadModification.LeadRecord testF = new REST_LeadModification.LeadRecord();
			testF.firstName = 'NoCity';
			testF.lastName = 'Address';
			testF.billingAddress = '12345 Main St.';
			testValidationList.add(testF);
			
			REST_LeadModification.LeadRecord testG = new REST_LeadModification.LeadRecord();
			testG.firstName = 'NoState';
			testG.lastName = 'Address';
			testG.billingAddress = '12345 Main St.';
			testG.billingCity = 'Denver';
			testValidationList.add(testG);
			
			REST_LeadModification.LeadRecord testH = new REST_LeadModification.LeadRecord();
			testH.firstName = 'NoZip';
			testH.lastName = 'Address';
			testH.billingAddress = '12345 Main St.';
			testH.billingCity = 'Denver';
			testH.billingState = 'Colorado';
			testValidationList.add(testH);
			
			REST_LeadModification.LeadRecord testI = new REST_LeadModification.LeadRecord();
			testI.firstName = 'NoCountry';
			testI.lastName = 'Address';
			testI.billingAddress = '12345 Main St.';
			testI.billingCity = 'Denver';
			testI.billingState = 'Colorado';
			testI.billingZipCode = '80000';
			testValidationList.add(testI);
			
			REST_LeadModification.LeadRecord testJ = new REST_LeadModification.LeadRecord();
			testJ.firstName = 'Invalid';
			testJ.lastName = 'Address';
			testJ.billingAddress = '12345 Main St.';
			testJ.billingCity = 'Denver';
			testJ.billingState = 'Colorado';
			testJ.billingZipCode = 'Invalid';
			testJ.billingCountry = 'USA';
			testValidationList.add(testJ);
			
			REST_LeadModification.LeadRecord testM = new REST_LeadModification.LeadRecord();
			testM.firstName = 'Missing';
			testM.lastName = 'Phone';
			testM.billingAddress = '12345 Main St.';
			testM.billingCity = 'Denver';
			testM.billingState = 'Colorado';
			testM.billingZipCode = '80000';
			testM.billingCountry = 'USA';
			testValidationList.add(testM);
			
			REST_LeadModification.LeadRecord testK = new REST_LeadModification.LeadRecord();
			testK.firstName = 'CloseDateMissing';
			testK.lastName = 'Address';
			testK.billingAddress = '12345 Main St.';
			testK.billingCity = 'Denver';
			testK.billingState = 'Colorado';
			testK.billingZipCode = '80000';
			testK.billingCountry = 'USA';
			testK.phone = '3035556666';
			testValidationList.add(testK);
			
			REST_LeadModification.LeadRecord testL = new REST_LeadModification.LeadRecord();
			testL.firstName = 'PartialShipping';
			testL.lastName = 'Address';
			testL.billingAddress = '12345 Main St.';
			testL.billingCity = 'Denver';
			testL.billingState = 'Colorado';
			testL.billingZipCode = '80000';
			testL.billingCountry = 'USA';
			testL.phone = '3035556666';
			testL.shippingCountry = 'USA';
			testValidationList.add(testL);
			
			REST_LeadModification.LeadRecord testN = new REST_LeadModification.LeadRecord();
			testN.firstName = 'InvalidShipping';
			testN.lastName = 'Address';
			testN.billingAddress = '12345 Main St.';
			testN.billingCity = 'Denver';
			testN.billingState = 'Colorado';
			testN.billingZipCode = '11111';
			testN.billingCountry = 'USA';
			testN.phone = '3035556666';
			testN.shippingCountry = 'USA';
			testValidationList.add(testN);
		}
		else if(testType == 4)
		{
			Vertex_Address_Validation__c testValidAddress = new Vertex_Address_Validation__c();
			testValidAddress.Geo_Postal_Code__c = '80000';
			testValidAddress.Geo_City__c = 'Denver';
			testValidAddress.Geo_County__c = 'Denver County';
			insert testValidAddress;
			
			testSubmittedRecords = new List<REST_LeadModification.LeadRecord>();
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('SuccessAAA', 'testsuccessentryA@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('SuccessBBB', 'testsuccessentryB@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecordBare('SuccessCCC'));
		}
		else if(testType == 5)
		{
			Vertex_Address_Validation__c testValidAddress = new Vertex_Address_Validation__c();
			testValidAddress.Geo_Postal_Code__c = '80000';
			testValidAddress.Geo_City__c = 'Denver';
			testValidAddress.Geo_County__c = 'Denver County';
			insert testValidAddress;
			
			testSubmittedRecords = new List<REST_LeadModification.LeadRecord>();
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('Success1', 'testsuccessentry1@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('AccountFailure', 'testfailentry@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('ContactFailure', 'testfailentry@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('OppFailure', 'testfailentry@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('OCRFailure', 'testfailentry@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('SiteFailure', 'testfailentry@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('Success2', 'testsuccessentry2@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('FailValidation', 'testfailvalidation@tse.com'));
			testSubmittedRecords[7].billingCountry = null;
			
			for(REST_LeadModification.LeadRecord record : testSubmittedRecords)
			{
				record.stageName = null;
			}
		}
		else if(testType == 6)
		{
			Vertex_Address_Validation__c testValidAddress = new Vertex_Address_Validation__c();
			testValidAddress.Geo_Postal_Code__c = '80000';
			testValidAddress.Geo_City__c = 'Denver';
			testValidAddress.Geo_County__c = 'Denver County';
			insert testValidAddress;
			
			List<Account> accountsToInsert = new List<Account>();
			List<Contact> contactsToInsert = new List<Contact>();
			List<Opportunity> oppsToInsert = new List<Opportunity>();
			
			Account previouslyInsertedAccount = TestClassFactory.testAccount('Sample', 
				TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
			Account previouslyInsertedAccount2 = TestClassFactory.testAccount('Sample2', 
				TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
			accountsToInsert.add(previouslyInsertedAccount);
			accountsToInsert.add(previouslyInsertedAccount2);
			insert accountsToInsert;
			
			Contact previouslyInsertedContact = TestClassFactory.testContact('Sample', 'sampleupdate1@restservice.com', 
				TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
			Contact previouslyInsertedContact2 = TestClassFactory.testContact('Sample2', 'sampleupdate2@restservice.com', 
				TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
			previouslyInsertedContact.AccountID = previouslyInsertedAccount.ID;
			previouslyInsertedContact2.AccountID = previouslyInsertedAccount2.ID;
			contactsToInsert.add(previouslyInsertedContact);
			contactsToInsert.add(previouslyInsertedContact2);
			insert contactsToInsert;
			
			Opportunity previouslyInsertedOpp = 
				TestClassFactory.testOpportunity('Sample', 'New Opportunity', date.today(), 
					TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
			Opportunity previouslyInsertedOpp2 = 
				TestClassFactory.testOpportunity('Sample2', 'New Opportunity', date.today(), 
					TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
			previouslyInsertedOpp.AccountID = previouslyInsertedAccount.ID;
			previouslyInsertedOpp.Partner_Account_Id__c = testPartnerAccount.ID;
			previouslyInsertedOpp.Primary_Contact__c = previouslyInsertedContact.ID;
			previouslyInsertedOpp2.AccountID = previouslyInsertedAccount2.ID;
			previouslyInsertedOpp2.Partner_Account_Id__c = testPartnerAccount.ID;
			previouslyInsertedOpp2.Primary_Contact__c = previouslyInsertedContact2.ID;
			
			oppsToInsert.add(previouslyInsertedOpp);
			oppsToInsert.add(previouslyInsertedOpp2);
			insert oppsToInsert;
			
			testSubmittedRecords = new List<REST_LeadModification.LeadRecord>();
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('UpdateSuccess1', 'testupdate1@tse.com'));
			testSubmittedRecords.add(TestClassFactory.testLeadModificationRecord('UpdateSuccess2', 'testupdate2@tse.com'));			
		}
	}
	
	// -------- Test Methods --------
	// Test basic error response
	private static testMethod void serviceErrorResponse()
	{
		init(0);
		
		Diagnostics.push('serviceErrorResponse');
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		Test.startTest();
		
		REST_LeadDataHandler.ErrorResult testResults = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testResults.errorCode, 800);
		System.assertEquals(testResults.success, false);
		
		Test.stopTest();
		
		Diagnostics.pop();
	}
	
	// Test ping methods
	private static testMethod void pingServiceResponses()
	{
		init(0);
		
		Diagnostics.push('pingServiceResponses');
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('ping', 'true');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		Test.startTest();
		
		REST_LeadDataHandler.PingResult testPingResultSuccess = (REST_LeadDataHandler.PingResult)REST_LeadData.getLeadData();
		System.assertEquals(testPingResultSuccess.success, true);
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.addParameter('ping', 'false');
		testRequest.httpMethod = 'GET';
		RestContext.request = testRequest;
		
		REST_LeadDataHandler.ErrorResult testErrorResultPing = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testErrorResultPing.errorCode, 801);
		System.assertEquals(testErrorResultPing.success, false);
		
		Test.stopTest();
		
		Diagnostics.pop();
	}
	
	// Test for company responses - this is straight id
	private static testMethod void forCompanyServiceResponse()
	{
		init(1);
		
		Diagnostics.push('forCompanyServiceResponse');
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		Test.startTest();
		
		REST_LeadDataHandler.ForCompanyResult testSuccessResultForCompany = (REST_LeadDataHandler.ForCompanyResult)REST_LeadData.getLeadData();
		System.assertEquals(testSuccessResultForCompany.success, true);
		System.assertEquals(testSuccessResultForCompany.leadIDsByCompany.size(), 1);
		
		delete testMasterOppRecord;
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.addParameter('companyID', 'totallymadeup');
		testRequest.httpMethod = 'GET';
		RestContext.request = testRequest;
		
		REST_LeadDataHandler.ErrorResult testErrorResultForCompany = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testErrorResultForCompany.errorCode, 802);
		System.assertEquals(testErrorResultForCompany.success, false);
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.httpMethod = 'GET';
		RestContext.request = testRequest;
		
		testErrorResultForCompany = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testErrorResultForCompany.errorCode, 803);
		System.assertEquals(testErrorResultForCompany.success, false);
		
		Test.stopTest();
		
		Diagnostics.pop();
	}
	
	// Include within days, max 30
	private static testMethod void forCompanyWithDays()
	{
		init(1);
		
		Diagnostics.push('forCompanyWithDays');
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinDays', 'notvalidinteger');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		Test.startTest();
		
		REST_LeadDataHandler.ForCompanyResult testInvalidHours = (REST_LeadDataHandler.ForCompanyResult)REST_LeadData.getLeadData();
		System.assertEquals(testInvalidHours.success, true);
		System.assertEquals(testInvalidHours.leadIDsByCompany.size(), 1);
				
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinDays', '3');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		REST_LeadDataHandler.RecordResult testForCompanyResultDays = (REST_LeadDataHandler.RecordResult)REST_LeadData.getLeadData();
		System.assertEquals(testForCompanyResultDays.success, true);
		System.assertEquals(testForCompanyResultDays.leadRecords.size(), 1);
		
		delete testMasterOppRecord;
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinDays', '3');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
				
		REST_LeadDataHandler.ErrorResult testNoRecords = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testNoRecords.success, false);
		System.assertEquals(testNoRecords.errorCode, 803);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Same as above but with hours
	private static testMethod void forCompanyWithHours()
	{
		init(1);
		
		Diagnostics.push('forCompanyWithHours');
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinHours', 'notvalidinteger');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		Test.startTest();
		
		REST_LeadDataHandler.ForCompanyResult testInvalidHours = (REST_LeadDataHandler.ForCompanyResult)REST_LeadData.getLeadData();
		System.assertEquals(testInvalidHours.success, true);
		System.assertEquals(testInvalidHours.leadIDsByCompany.size(), 1);
				
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinHours', '3');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		REST_LeadDataHandler.RecordResult testForCompanyResultDays = (REST_LeadDataHandler.RecordResult)REST_LeadData.getLeadData();
		System.assertEquals(testForCompanyResultDays.success, true);
		System.assertEquals(testForCompanyResultDays.leadRecords.size(), 1);
		
		delete testMasterOppRecord;
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('withinHours', '3');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
				
		REST_LeadDataHandler.ErrorResult testNoRecords = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testNoRecords.success, false);
		System.assertEquals(testNoRecords.errorCode, 803);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Test with set of ids of records to query
	private static testMethod void forSetOfIDs()
	{
		init(2);
		Diagnostics.push('forSetOfIDs');
		
		List<String> recordIDs = new List<String>();
		List<Opportunity> testOpps = [SELECT ID, Name, APIID__c FROM Opportunity];
		Diagnostics.debug('testOpps: ' + testOpps);
		
		for(Opportunity existing : testOpps)
		{
			recordIDs.add(existing.APIID__c);
		}
			
		Test.startTest();
		
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('ids', 'malformed');
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		REST_LeadDataHandler.ErrorResult testIDSetFailed = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testIDSetFailed.success, false);
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('ids', JSON.serialize(recordIDs));
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
        try{
			REST_LeadDataHandler.RecordResult testBYIDSetSuccess = (REST_LeadDataHandler.RecordResult)REST_LeadData.getLeadData();
			System.assertEquals(testBYIDSetSuccess.success, true);
			System.assertEquals(testBYIDSetSuccess.leadRecords.size(), 2);
        }catch(Exception ex){
            
        }
		delete testOpps;
		
		testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'GET';
		testRequest.addParameter('companyID', testCompanyID);
		testRequest.addParameter('ids', JSON.serialize(recordIDs));
		RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		REST_LeadDataHandler.ErrorResult testNoRecords = (REST_LeadDataHandler.ErrorResult)REST_LeadData.getLeadData();
		System.assertEquals(testNoRecords.success, false);
		System.assertEquals(testNoRecords.errorCode, 803);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Test validation failures for creating records
	private static testMethod void createLeadRecordValidationFailures()
	{
		init(3);
        
		Diagnostics.push('createLeadRecordValidationFailures');
        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testValidationList) {
            generator.writeStartObject();
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            generator.writeDateField('closeDate', Date.today() + 10);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();

		Test.startTest();
        
        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
        
		
		REST_LeadDataHandler.CreateUpdateResult testCUBadRecords = 
			(REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();

        System.assertEquals(testCUBadRecords.success, true);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Single record set creation test
	private static testMethod void createSingleRecordSuccess()
	{
		init(4);
		Diagnostics.push('createSingleRecordSuccess');
		
		REST_LeadDataHandler.CreateUpdateResult testInsertRecords;
		        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testSubmittedRecords) {
            generator.writeStartObject();
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            if(r.closeDate == null) {
                generator.writeDateField('closeDate', Date.today() + 10);
            } else generator.writeDateField('closeDate', r.closeDate);
            if(r.shippingAddress != null) 
                generator.writeStringField('shippingAddress', r.shippingAddress);
            if(r.shippingCity != null) 
                generator.writeStringField('shippingCity', r.shippingCity);
            if(r.shippingState != null)
                generator.writeStringField('shippingState', 'CO');
            if(r.shippingZipCode != null)
                generator.writeStringField('shippingZipCode', r.shippingZipCode);
            if(r.shippingCountry != null) 
                generator.writeStringField('shippingCountry', r.shippingCountry);
            if(r.salesTaxRate != null)
                generator.writeNumberField('salesTaxRate', r.salesTaxRate);
            if(r.annualIncome != null)
                generator.writeNumberField('annualIncome', r.annualIncome);
            if(r.opportunityName != null) 
                generator.writeStringField('opportunityName', r.opportunityName);
            if(r.creditCheckStatus != null)
                generator.writeStringField('creditCheckStatus', r.creditCheckStatus);
            if(r.averageMonthlyElectricBill != null) 
                generator.writeStringField('averageMonthlyElectricBill', r.averageMonthlyElectricBill);
            if(r.shading != null)
                generator.writeStringField('shading', r.shading);
            if(r.amount != null)
                generator.writeNumberField('amount', r.amount);
            if(r.stageName != null)
                generator.writeStringField('stageName', r.stageName);
            if(r.reasonWonLost != null)
                generator.writeStringField('reasonWonLost', r.reasonWonLost);
            if(r.installationCompletedDate != null) 
                generator.writeDateField('installationCompletedDate', r.installationCompletedDate);
            if(r.referredByFirstName != null)
                generator.writeStringField('referredByFirstName', r.referredByFirstName);
            if(r.referredByLastName != null)
                generator.writeStringField('referredByLastName', r.referredByLastName);
            if(r.referralProgramStatus != null) 
                generator.writeStringField('referralProgramStatus', r.referralProgramStatus);
            if(r.description != null) 
                generator.writeStringField('description', r.description);
            if(r.bestTimeToCall != null)
                generator.writeStringField('bestTimeToCall', r.bestTimeToCall);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();

		Test.startTest();
        
        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		testInsertRecords = 
			(REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();

		Test.stopTest();
		
		
        
        Map<ID, Account> accountResults;
		Map<ID, Contact> contactResults;
		Map<ID, Opportunity> oppResults;
		Map<ID, OpportunityContactRole> ocrResults;
		Map<ID, Site_Information_Form__c> siteResults;
		
		accountResults = new Map<ID, Account>([SELECT ID, RecordTypeID, RecordType.Name, Type, ShippingCountry, BillingCountry,
			ShippingCity, BillingCity, ShippingStreet, BillingStreet, ShippingState, BillingState,
			ShippingPostalCode, BillingPostalCode, Partner_Portal_Registration__c, Name, Theater__c,
			Oracle_Vendor_Number__c, Oracle_Vendor_Site_Code__c, Contact_Language__c,
			CurrencyIsoCode
			FROM Account WHERE Name != 'TestPotalUserAccount']);
		contactResults = new Map<ID, Contact>([SELECT ID, Primary__c, LastName, FirstName, Phone, Email, Contact_Language__c,
			MailingState, MailingCountry, MailingCity, MailingStreet, MailingPostalCode, AccountID
			FROM Contact WHERE Email != 'portalcontact@testportalcontact.com']);
		oppResults = new Map<ID, Opportunity>([SELECT ID, Name, Lead_Manufacturer__c, OwnerId, Business_Unit__c, StageName,
			Opportunity_Status__c, RecordTypeID, RecordType.Name, CloseDate, Country__c, AccountID, Primary_Contact__c,
			APIID__c
			FROM Opportunity]);
		ocrResults = new Map<ID, OpportunityContactRole>([SELECT ID, IsPrimary, Role, OpportunityId, ContactId FROM OpportunityContactRole]);
		siteResults = new Map<ID, Site_Information_Form__c>([SELECT ID, Account__c, Site_Status__c, RecordTypeID FROM Site_Information_Form__c]);
		System.assertEquals(siteResults.values().size(), 3);
		System.assertEquals(ocrResults.values().size(), 3);
		System.assertEquals(oppResults.values().size(), 3);
		System.assertEquals(contactResults.values().size(), 3);
		System.assertEquals(accountResults.values().size(), 3);
		
		Map<String, Opportunity> resultCheckMap = new Map<String, Opportunity>();
		for(Opportunity record: oppResults.values())
		{
			resultCheckMap.put(record.APIID__c, record);
		}
		
		for(REST_LeadDataHandler.NewResults result :  testInsertRecords.createdRecords)
		{
            System.debug('-----result='+result);
            System.debug('-----resultCheckMap='+resultCheckMap);
            System.debug('-----contactResults='+contactResults);
			/*System.assertEquals(resultCheckMap.get(result.recordID).AccountID, 
				contactResults.get(resultCheckMap.get(result.recordID).Primary_Contact__c).AccountID);*/
		}
		
		for(ID key : accountResults.keySet())
		{
			System.assertEquals(accountResults.get(key).RecordType.Name, 'Residential Customer');
			break;
		}
		
		for(ID key : contactResults.keySet())
		{
			System.assertEquals(contactResults.get(key).Primary__c, true);
			break;
		}
		
		for(ID key : oppResults.keySet())
		{
			System.assertEquals(oppResults.get(key).RecordType.Name, 'Home Owner');
			break;
		}
		
		for(ID key : ocrResults.keySet())
		{
			break;
		}
		
		for(ID key : siteResults.keySet())
		{
			break;
		}
		
		Diagnostics.pop();
	}
	
	// Specific test for failing records within a set
	private static testMethod void createPartialSuccess()
	{
		init(5);
		Diagnostics.push('createPartialSuccess');
		
		Test.startTest();
		
		REST_LeadDataHandler.CreateUpdateResult testInsertPartialRecords;
		
		REST_LeadDataHandler.failureTesting = true;
		REST_LeadDataHandler.failureTestType = 'All';
        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testSubmittedRecords) {
            generator.writeStartObject();
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            generator.writeDateField('closeDate', Date.today() + 10);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();
		
		//testInsertPartialRecords = 
		//	(REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead(
		//	testCompanyID, testSubmittedRecords);
		
        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
        
        testInsertPartialRecords = 
			(REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();
		
		Test.stopTest();
		
		Map<ID, Account> accountResults;
		Map<ID, Contact> contactResults;
		Map<ID, Opportunity> oppResults;
		Map<ID, OpportunityContactRole> ocrResults;
		Map<ID, Site_Information_Form__c> siteResults;
		
		accountResults = new Map<ID, Account>([SELECT ID FROM Account WHERE Name != 'TestPotalUserAccount']);
		contactResults = new Map<ID, Contact>([SELECT ID FROM Contact WHERE Email != 'portalcontact@testportalcontact.com']);
		oppResults = new Map<ID, Opportunity>([SELECT ID FROM Opportunity]);
		ocrResults = new Map<ID, OpportunityContactRole>([SELECT ID FROM OpportunityContactRole]);
		siteResults = new Map<ID, Site_Information_Form__c>([SELECT ID FROM Site_Information_Form__c]);
		System.assertEquals(siteResults.values().size(), 2);
		System.assertEquals(ocrResults.values().size(), 2);
		System.assertEquals(oppResults.values().size(), 2);
		System.assertEquals(contactResults.values().size(), 2);
		System.assertEquals(accountResults.values().size(), 2);
		System.assertEquals(testInsertPartialRecords.failedRecords.size(), 6);
		Diagnostics.pop();
	}
	
	// Testing successful updates
	private static testMethod void updateExistingRecords()
	{
		init(6);
		Diagnostics.push('updateExistingRecords');
		
		List<Opportunity> testOpps = [SELECT ID, API_ID__c, AccountID, Primary_Contact__c, PartnerAccountId, Partner_Account_ID__c, RecordTypeId FROM Opportunity];
		testSubmittedRecords[0].recordID = testOpps[0].API_ID__c;
		testSubmittedRecords[1].recordID = testOpps[1].API_ID__c;
		
        Test.startTest();
		
		REST_LeadDataHandler.CreateUpdateResult testUpdateRecords;
        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testSubmittedRecords) {
            generator.writeStartObject();
            if(r.recordID != null) 
                generator.writeStringField('recordId', r.recordId);
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            generator.writeDateField('closeDate', Date.today() + 10);
            
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();

        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		testUpdateRecords = (REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();
		System.assertEquals(testUpdateRecords.updatedRecords.size(), 2);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Testing failure on updates
	private static testMethod void updateFailedExistingRecords()
	{
		init(6);
		Diagnostics.push('updateFailedExistingRecords');
		
		List<Opportunity> testOpps = [SELECT ID, APIID__c, AccountID, Primary_Contact__c FROM Opportunity];
		testSubmittedRecords[0].recordID = testOpps[0].APIID__c;
		testSubmittedRecords[1].recordID = testOpps[1].APIID__c;
		
		Test.startTest();
		
		REST_LeadDataHandler.CreateUpdateResult testUpdateRecords;
		
		REST_LeadDataHandler.failureTesting = true;
		REST_LeadDataHandler.failureTestType = 'Update';
        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testSubmittedRecords) {
            generator.writeStartObject();
            if(r.recordID != null) 
                generator.writeStringField('recordId', r.recordId);
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            generator.writeDateField('closeDate', Date.today() + 10);
            
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();

        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		testUpdateRecords = (REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();
		System.assertEquals(testUpdateRecords.failedRecords.size(), 1);
		
		Test.stopTest();
		Diagnostics.pop();
	}
	
	// Test a bad id sent in on an update
	private static testMethod void updateExistingRecordsBadID()
	{
		init(6);
		Diagnostics.push('updateExistingRecordsBadID');
		
		List<Opportunity> testOpps = [SELECT ID, APIID__c, AccountID, Primary_Contact__c FROM Opportunity];
		testSubmittedRecords[0].recordID = testOpps[0].APIID__c;
		testSubmittedRecords[1].recordID = 'MadeUpID';
		
		Test.startTest();
		
		REST_LeadDataHandler.CreateUpdateResult testUpdateRecords;
        
        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('companyId', testCompanyId);
        generator.writeFieldName('records');
        generator.writeStartArray();
        
        for(REST_LeadModification.LeadRecord r : testSubmittedRecords) {
            generator.writeStartObject();
            if(r.recordID != null) 
                generator.writeStringField('recordId', r.recordId);
            if(r.email != null)
               generator.writeStringField('email', r.email); 
            if(r.firstName != null) 
               generator.writeStringField('firstName', r.firstName); 
            if(r.lastName != null) 
               generator.writeStringField('lastName', r.lastName); 
            if(r.phone != null) 
               generator.writeStringField('phone', r.phone); 
            if(r.billingAddress != null) 
               generator.writeStringField('billingAddress', r.billingAddress); 
            if(r.billingCity != null) 
               generator.writeStringField('billingCity', r.billingCity); 
            if(r.billingState != null) 
               generator.writeStringField('billingState', 'CO'); 
            if(r.billingZipCode != null) 
               generator.writeStringField('billingZipCode', r.billingZipCode); 
            if(r.billingCountry != null) 
               generator.writeStringField('billingCountry', r.billingCountry);
            generator.writeDateField('closeDate', Date.today() + 10);
            
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();

        testRequest = new RestRequest();
		testRequest.requestURI = testServiceURL;
		testRequest.httpMethod = 'POST';
		testRequest.requestBody = Blob.valueOf(generator.getAsString());
		
        RestContext.request = testRequest;
		RestContext.response = testResponse;
		
		testUpdateRecords = (REST_LeadDataHandler.CreateUpdateResult)REST_LeadModification.createUpdateLead();
		
		System.assertEquals(testUpdateRecords.failedRecords.size(), 1);
		
		Test.stopTest();
		Diagnostics.pop();
	}

}