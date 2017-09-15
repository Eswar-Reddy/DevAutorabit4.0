//Test Class for PartnerPermissionREST class
@isTest 
private class TestPartnerPermissionsREST {
    
    static TestMethod void testMethod1(){
        Test.startTest();
        
        Account partnerAccount = new Account();
        partnerAccount.Name = 'Bright Solar' + System.now();
        partnerAccount.Type = 'Other';
        partnerAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        partnerAccount.Dealer_Score_Total__c = 78;
        partnerAccount.Dealer_Locator_Phone__c = '888-888-8888';
        partnerAccount.Phone = '888-888-8888';
        partnerAccount.BillingStreet = '150 Corona St';
        partnerAccount.BillingCity = 'Denver';
        partnerAccount.BillingState = 'CO';
        partnerAccount.BillingCountry = 'United States';
        partnerAccount.BillingPostalCode = '80218';
        partnerAccount.website = 'www.sunpowercorp.com';
        partnerAccount.Oracle_Account_Number__c = '123';
        partnerAccount.Description = 'None';
        partnerAccount.Partner_Facts__c = 'None';
        partnerAccount.Status__c = 'Active';
        partnerAccount.Dealer_Locator_Opt_Out__c = false;
        partnerAccount.Lead_Flow_Opt_Out__c = false;
        partnerAccount.Alliance_Program_Partner__c = true;
        partnerAccount.Geolocation__Latitude__s = 39.718887;
        partnerAccount.Geolocation__Longitude__s = -104.974036;
        partnerAccount.Theater__c = 'North America';
        partnerAccount.Send_PDF_Notification__c = true;
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Sector_Lease__c = 'Residential';
        insert partnerAccount;
        
        Business_Registration__c br = new Business_Registration__c();
        br.Account__c = partnerAccount.Id;
        br.License_Number__c = '123456';
        br.State__c = 'CO';
        insert br;
        
        Contact partnerContact = TestUtils.createContact( 'testPartnerPermssions CONTACT 1', partnerAccount.Id, false );
        
        partnerContact.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert partnerContact;
        
        
        UserManagement.IS_TEST = true;
        
        User partnerUser = TestUtils.createPartnerPortalUser( partnerContact,false);
        partnerUser.Business_Function__c = 'Create Cash Quote';
        insert partnerUser;
        
        PartnerPermissionREST.Response ppRESTResp = new PartnerPermissionREST.Response();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'GET';
        //services/apexrest/getPartnerPermissions?UserId=00580000003Z0MS&State='CO' 
        req.addParameter('userId', partnerUser.Id);
        req.addParameter('state', 'CO');
        
        RestContext.request = req;
        RestContext.response = res;
        
        ppRESTResp = PartnerPermissionREST.doGet();
        Test.stopTest();
    }
}