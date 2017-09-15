@isTest
global class TestLaunchAuroraController {
    
    private static TestMethod void testAuroraAPI_1() {

        UserManagement.IS_TEST = true;
        Loan_Callout_Settings__c  acs = new Loan_Callout_Settings__c(Name='Aurora', Endpoint_URL__c ='http://www.aurora.com', Endpoint_URL_Sandbox__c='http://www.aurora.com',Key__c ='key',Tenant_Id__c='tenantId',Client_Secret__c='clientSecret',Redirect_URI_Sandbox__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F', Redirect_URI_Production__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F');
        insert acs;

        Account partnerAccount = TestClassFactory.CreateDealer('Test Dealer1', 'North America');
        partnerAccount.Design_Tool_Organization_Id__c = '12345-67890-12345-67890';


        Contact partnerContact = TestClassFactory.testContact('Test Contact', 'testaurora1@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = partnerAccount.Id;
        insert partnerContact;

        Opportunity customerOpportunity = TestUtils.createOpportunities(1, partnerAccount.id, partnerContact.Id, false)[0];
        customerOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Commercial');
        customerOpportunity.StageName = '12% - Qualified Opportunity';
        insert customerOpportunity;

        Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
        Roof_Design__c roofDesign = TestUtils.createRoofDesign(partnerAccount.Id, rdMaxFitRecordTypeId, 'Request', 'Pending',true); 

        Test.startTest();
         //set mock
        Test.setMock(HttpCalloutMock.class, new AuroraMockProject());

        PageReference pageRef = Page.LaunchAurora;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('accountId', partnerAccount.Id);
        ApexPages.currentPage().getParameters().put('action', 'CreateProject');
        LaunchAuroraController laCtrl = new launchAuroraController();
        laCtrl.forwardtoAurora();

        Test.stopTest();

    }

    private static TestMethod void testAuroraAPI_2() {

        UserManagement.IS_TEST = true;
        Loan_Callout_Settings__c  acs = new Loan_Callout_Settings__c(Name='Aurora', Endpoint_URL__c ='http://www.aurora.com', Endpoint_URL_Sandbox__c='http://www.aurora.com',Key__c ='key',Tenant_Id__c='tenantId',Client_Secret__c='clientSecret',Redirect_URI_Sandbox__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F', Redirect_URI_Production__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F');
        insert acs;

        Account partnerAccount = TestClassFactory.CreateDealer('Test Dealer1', 'North America');
        partnerAccount.Design_Tool_Organization_Id__c = '12345-67890-12345-67890';
        partnerAccount.Design_ProjectId__c ='12345-67890-12345-67890';
        update partnerAccount;

        Contact partnerContact = TestClassFactory.testContact('Test Contact', 'testaurora1@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = partnerAccount.Id;
        insert partnerContact;

        Opportunity customerOpportunity = TestUtils.createOpportunities(1, partnerAccount.id, partnerContact.Id, false)[0];
        customerOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Commercial');
        customerOpportunity.StageName = '12% - Qualified Opportunity';
        insert customerOpportunity;

        Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
        Roof_Design__c roofDesign = TestUtils.createRoofDesign(partnerAccount.Id, rdMaxFitRecordTypeId, 'Request', 'Pending',true); 

        Test.startTest();
         //set mock
        Test.setMock(HttpCalloutMock.class, new AuroraMockDesign());

        PageReference pageRef = Page.LaunchAurora;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('roofDesignId', roofDesign.Id);
        ApexPages.currentPage().getParameters().put('action', 'CreateDesign');
        LaunchAuroraController laCtrl = new launchAuroraController();
        laCtrl.forwardtoAurora();

        Test.stopTest();

    }

    private static TestMethod void testAuroraAPI_Negative() {

        UserManagement.IS_TEST = true;
        Loan_Callout_Settings__c  acs = new Loan_Callout_Settings__c(Name='Aurora', Endpoint_URL__c ='http://www.aurora.com', Endpoint_URL_Sandbox__c='http://www.aurora.com',Key__c ='key',Tenant_Id__c='tenantId',Client_Secret__c='clientSecret',Redirect_URI_Sandbox__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F', Redirect_URI_Production__c='https%3A%2F%2Fsandbox.aurorasolar.com%2F');
        insert acs;

        Account partnerAccount = TestClassFactory.CreateDealer('Test Dealer1', 'North America');
        partnerAccount.Design_Tool_Organization_Id__c = '12345-67890-12345-67890';
        partnerAccount.Design_ProjectId__c ='12345-67890-12345-67890';
        update partnerAccount;

        Contact partnerContact = TestClassFactory.testContact('Test Contact', 'testaurora1@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = partnerAccount.Id;
        insert partnerContact;

        Opportunity customerOpportunity = TestUtils.createOpportunities(1, partnerAccount.id, partnerContact.Id, false)[0];
        customerOpportunity.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Commercial');
        customerOpportunity.StageName = '12% - Qualified Opportunity';
        insert customerOpportunity;

        Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
        Roof_Design__c roofDesign = TestUtils.createRoofDesign(partnerAccount.Id, rdMaxFitRecordTypeId, 'Request', 'Pending',true); 

        Test.startTest();
        //Don't set mock to throw error

        PageReference pageRef = Page.LaunchAurora;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('roofDesignId', roofDesign.Id);
        ApexPages.currentPage().getParameters().put('action', 'CreateDesign');
        LaunchAuroraController laCtrl = new launchAuroraController();
        laCtrl.forwardtoAurora();

        Test.stopTest();

    }


    global class AuroraMockProject implements HttpCalloutMock {
        String responseStringProject = '{"project":{"id":"db0791db-444c-44e5-b50c-e5e649118c0d","external_provider_id":"YourId123","name":"Special project at Solar Street 1 for Jane Doe",' +
        '"customer_salutation":"Mrs.","customer_first_name":"Jane","customer_last_name":"Doe","customer_address":"123 Main Street, Unit #12, City, CA, 93120",' +
        '"address":"123 Main Street, Unit #12, City, CA, 93120","latitude": 0.0,"longitude": 0.0}}';

        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseStringProject);
            res.setStatusCode(200);
            return res;
        }
    }

    global class AuroraMockDesign implements HttpCalloutMock {
        String responseStringDesign = '{"design":{"id": "db0791db-444c-44e5-b50c-e5e649118c0e","external_provider_id": "YourId123ForThisDesign","project_id": "db0791db-444c-44e5-b50c-e5e649118c0e","name": "New Design"}}';

        Boolean isDesign {get;set;}
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseStringDesign);
            res.setStatusCode(200);
            return res;
        }
    }
}