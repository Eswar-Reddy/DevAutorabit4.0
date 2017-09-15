/*
Developed:
09-Jul-2014 : Birlasoft : Test Class for UtilQuote Class.
*/
@isTest(SeeAllData=true)
Public Class GPPQuoteCopyEditTest
{
Public Static Account partnerAccount;
Public static Contact partnerContact;
Public static User partnerUser;
Public static Account instAccount;
Public static Contact instContact;
Public static List<Quote> lstQuotes;
Public static Account customerAccount;
Public static List<Contact> lstCustomerContact;
Public static List<Opportunity> lstCustomerOpportunity;

static{
    ///Setting Flags to Skip Triggers
    UserManagement.IS_TEST= true;           
    SFDCSpecialUtilities.isRunningTest=true;
    
    ///Partner Account Creation
    partnerAccount = TestUtils.createAccount('TEST_AU_SALES_PARTNER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
    partnerAccount.Lease2_0_Program_Partner__c= true;
    partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
    partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
    partnerAccount.Oracle_Warehouse__c  = 'WAR'+String.ValueOf(DateTime.Now().getTime()).substring(0, 5);
    partnerAccount.Oracle_County__c='Australia';
    partnerAccount.Oracle_Shipping_County__c='Australia';
    partnerAccount.Theater__c='Australia';   
    insert partnerAccount;
       
    /// Partner Contact Creation
    partnerContact = TestUtilsGPP.createContact('BSLAU', partnerAccount.Id, false);
    partnerContact.Primary__c=true;
    insert partnerContact;
    
    /// Partner User Creation
    partnerUser= TestUtilsGPP.createPartnerPortalUser(partnerContact, false);
    partnerUser.Quote_Creation_Allowed__c=true;
    partnerUser.Lease_doc_creation_allowed__c=true;
    insert partnerUser;
     
    ///Installer Account
    instAccount = TestUtilsGPP.createInstallerAccount('TEST_AU_INSTALLER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
    insert instAccount;
    
    ///Associate Installer with Seller
    TestUtilsGPP.associateInstallerWithSeller(partnerAccount,instAccount,'Installer',true);
    
    ///Partner Contact Creation
    instContact = TestUtilsGPP.createContact('TestInstallerAUCont', partnerAccount.Id, false);
    instContact.Primary__c=true;    
    insert instContact;
   
            
}
    public static testMethod void testGPPQuoteCopyEdit() 
    {        

        Test.StartTest();     
        
        ///Customer Account & Contact Creation
        customerAccount= TestUtilsGPP.createAccount('AUCustomer1' , 
                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, true);          
                        
        lstCustomerContact= TestUtilsGPP.createCustomerContacts(2, 'AUC', customerAccount.Id, 
                                      TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, true);        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                   customerAccount.Id,
                                                   lstCustomerContact[0].Id,
                                                   TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);    
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,customerAccount,lstCustomerOpportunity[0],lstCustomerContact[0],TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,instAccount.ID,false);
        //lstQuotes[0].Installer__c=instAccount.ID;
        insert lstQuotes;
        
        PageReference pageRef = Page.GPPQuoteCopyEdit;
        pageRef.getParameters().put('acc', customerAccount.ID);
        pageRef.getParameters().put('opp', lstCustomerOpportunity[0].ID);
        pageRef.getParameters().put('own', partnerUser.ID);
        pageRef.getParameters().put('id', lstQuotes[0].ID);
        Test.setCurrentPage(pageRef);
        

        ApexPages.StandardController sc = new ApexPages.StandardController(lstQuotes[0]);       
        GPPQuoteCopyEdit controller = new GPPQuoteCopyEdit(sc);
        controller.GPPInstallerSelectionInit();
        controller.GPPQuoteCopyEditInit();
        controller.ChangeSelection();
        controller.getInstallPartners();
        controller.submit();
        controller.cancel();
        pageRef.getParameters().put('act', 'c');
        controller.GPPQuoteCopyEditInit();
        Test.stopTest();        
      
    }
}