/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for GPPServicesPartner Rest Resource Class
Edits  :    
        2014-03-19 : 
********************************************************************************************/

@isTest(SeeAllData=true)
Class GPPServicesPartnerTest
{   
    static Account partnerAccount,partnerAccount1;
    static Contact partnerContact,partnerContact1;
    static User partnerUser;

    private static user getPartnerUser()
    {   
        UserManagement.IS_TEST = true;        
        partnerAccount = TestUtils.createAccount('PartnerAccTest', TestUtils.getPartnerRecordTypeId(), false);
        //make lease enabled partner
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'BWGUY'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Business_Function__c='Lease';
        partnerAccount.Same_as_Cash_Program_Partner__c=true;
        partnerAccount.Can_Sell_SunPower_20yr_Loan__c=true;
        insert partnerAccount;
              
        partnerContact = TestUtils.createContact( 'PartnerConTest', partnerAccount.Id, false );
       // partnerContact.Business_Function__c='Lease';
        //partnerContact.Business_Function__c='Cash';
        //partnerContact.Email=System.now().getTime()+'test1@test.com';
        //partnerContact.Phone='999-888-7770';
        insert partnerContact; 
        
        partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
        partnerUser.ContactId=partnerContact.ID;
        partnerUser.isActive=true;
        partnerUser.Business_Function__c='Create Lease Quote';
        return partnerUser;
    }
 
    static testMethod void testGetPartnerPermissions() 
    {
        Test.startTest();       
        partnerUser = getPartnerUser();        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SPWRPartnerService/GetPartnerPermissions?UserId='+partnerUser.ID;  
        req.httpMethod = 'GET';
        
        //Run the Test Code in Partner User Context       
        System.runAs( partnerUser )
        {       
           
           User usr = [SELECT Id, Name,LanguageLocaleKey, 
                      Country_Domain__c, Type__c, Business_Function__c,
                      ContactId, Contact.Country_Domain__c, Contact.Account_Type__c, 
                      Contact.Account.Id, Contact.Account.name, Contact.Account.type,  
                      Contact.Account.Country_Domain__c, Contact.Account.Theater__c, 
                      Contact.Account.Dealer_Tier__c, Contact.Account.Business_Function__c, 
                      Contact.Account.Line_of_Business__c,
                      Contact.Account.Same_as_Cash_Program_Partner__c,
                      Contact.Account.Can_Sell_SunPower_20yr_Loan__c,
                      Contact.Account.BillingCountry,Contact.Account.Phone,
                      Contact.Account.Email__c, Contact.Account.Partner_facts__c,  
                      Contact.Account.Specialized_Seller__c, Contact.Account.Specialized_Installer__c   
               FROM User 
               WHERE ContactId <> null AND 
                     ID=: partnerUser.ID AND 
                     isActive=true LIMIT 1];
                     
           req.addParameter('UserId',usr.ID);
           RestContext.request = req;
           RestContext.response = res;
           Test.setMock(HttpCalloutMock.class, new GPPServicesCustomerMockHttpResponse());           
           GPPServicesPartner.GetPartnerPermissions(); 

           if(usr != null && usr.Id != null)           
           GPPServicesPartner.PartnerPermissionInformation cWC = new GPPServicesPartner.PartnerPermissionInformation(usr);               
       }
       Test.stopTest();

  }
}