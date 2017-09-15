@isTest
public with sharing class ResidentialProjectTPS_Test {
    
    static testMethod void testChangeIM(){
        // Create test account
        Account a = new Account(Name = 'TestAcct' , BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
        insert a;

        // Create test opportunity
        Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed');
        insert o;

        // Create test Quote
        Quote q = new Quote(OpportunityId = o.Id, Name = 'Test Quote');
        insert q;

        // Create Installation Models
        List<Installation_Model__c> imToInsert = new List<Installation_Model__c>();
        Installation_Model__c ipim = new Installation_Model__c(Name = 'TPS CA Loan', Financing_Option__c = 'Cash', Roles__c='IP', State__c = 'CA', Type__c='Manual');
        imToInsert.add(ipim);

        Installation_Model__c ipdripim = new Installation_Model__c(Name = 'TPS CA Loan', Financing_Option__c = 'Cash', Roles__c='IP;DRIP', State__c = 'CA', Type__c='Manual');
        imToInsert.add(ipdripim);

        insert imToInsert;

        Test.startTest();
        Residential_Project__c testProject = new Residential_Project__c();
        testProject.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
        testProject.Account__c = a.Id;
        testProject.Opportunity__c = o.Id;
        testProject.Quote__c = q.Id;
        testProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        testProject.Name = 'TestResidentialProject';
        testProject.Installation_Model__c = ipim.Id;
        testProject.CurrencyIsoCode = 'USD';
        insert testProject;

        Residential_Project__c forAssert = [SELECT Id, (SELECT Id, Role__c FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(forAssert.Alliance_Partners__r.size(), 1);
        system.assertEquals(forAssert.Alliance_Partners__r[0].Role__c, 'IP');


        testProject.Installation_Model__c = ipdripim.Id;
        update testProject;

        forAssert = [SELECT Id, (SELECT Id, Role__c FROM Alliance_Partners__r ORDER BY CreatedDate ) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(forAssert.Alliance_Partners__r.size(), 2);
        Boolean foundIP = false;
        Boolean foundDRIP = false;
        for(Alliance_Partner__c ap : forAssert.Alliance_Partners__r){
            if(ap.Role__c == 'IP') foundIP = true;
            if(ap.Role__c == 'DRIP') foundDRIP = true;
        }
        system.assertEquals(foundIP, true);
        system.assertEquals(foundDRIP, true);

        testProject.Installation_Model__c = ipim.Id;
        update testProject;

        forAssert = [SELECT Id, (SELECT Id, Role__c FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(forAssert.Alliance_Partners__r.size(), 1);
        system.assertEquals(forAssert.Alliance_Partners__r[0].Role__c, 'IP');

        Test.stopTest();

    }

    static testMethod void testTPSAPAssignment(){
        // Create test account
        Account a = new Account(Name = 'TestAcct' , BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
        insert a;

        // Create Partner Account
        Account partner = new Account(Name = 'SPRI - Fremont', BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId());
        insert partner;

        // Create test opportunity
        Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed', Partner_Account_Id__c = partner.Id);
        insert o;

        // Create test Quote
        Quote q = new Quote(OpportunityId = o.Id, Name = 'Test Quote');
        insert q;

        Test.startTest();
        Residential_Project__c testProject = new Residential_Project__c();
        testProject.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
        testProject.Account__c = a.Id;
        testProject.Opportunity__c = o.Id;
        testProject.Quote__c = q.Id;
        testProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        testProject.Name = 'TestResidentialProject';
        testProject.CurrencyIsoCode = 'USD';
        insert testProject;

        Residential_Project__c forAssert = [SELECT Id, (SELECT Id, Role__c, Partner_Account__c FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id =: testProject.Id];
        system.assertEquals(forAssert.Alliance_Partners__r.size(), 1);
        system.assertEquals(forAssert.Alliance_Partners__r[0].Role__c, 'TPS');
        system.assertEquals(forAssert.Alliance_Partners__r[0].Partner_Account__c, partner.Id);

    }

}