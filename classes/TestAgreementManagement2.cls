/*
Developed:
09-Jul-2014 : Birlasoft : Test Class for UtilQuote Class.
*/
@isTest //(SeeAllData=true)
Public Class TestAgreementManagement2
{

    Public Static Account partnerAccount;
    Public static Contact partnerContact;
    Public static User partnerUser;
    Public static Account instAccount;
    Public static List<Quote> lstQuotes;
    Public static Account customerAccount;
    Public static List<Contact> lstCustomerContact;
    Public static List<Opportunity> lstCustomerOpportunity;
    
    static{
        ///Setting Flags to Skip Triggers
        UserManagement.IS_TEST= true;           
        SFDCSpecialUtilities.isRunningTest=true;
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
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
        
        UsersToSkipTrigger__c ob=new  UsersToSkipTrigger__c(Name=partnerUser.ID);
        insert ob;
        
        ///Installer Account
        instAccount = TestUtilsGPP.createInstallerAccount('TEST_AU_INSTALLER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
        insert instAccount;
        
        ///Associate Installer with Seller
        TestUtilsGPP.associateInstallerWithSeller(partnerAccount,instAccount,'Installer',true);
           
        
    }
    
    public static testMethod void testAgreementManagement2()
    {
        
        
        ///Customer Account & Contact Creation
        customerAccount= TestUtilsGPP.createAccount('AUCustomer1' , 
                                                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, true);              
        lstCustomerContact= TestUtilsGPP.createCustomerContacts(2, 'AUCustCon', customerAccount.Id, 
                                                                TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, true);
        
        
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccount.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        
        Test.StartTest();
        SavePoint sp = Database.setSavepoint();

        try {
            Trigger_By_Pass__c tbp = [SELECT Id, Is_Active__c FROM Trigger_By_Pass__c WHERE Name = 'AgreementTrigger'];
            tbp.Is_Active__c = false;
            update tbp;
        } catch(Exception e) { }

        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,customerAccount,lstCustomerOpportunity[0],lstCustomerContact[0],TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,String.valueOf(instAccount.ID), false);
        // lstQuotes[0].Installer__c=instAccount.ID;
        insert lstQuotes;
        
        echosign_dev1__SIGN_Agreement__c agg=new echosign_dev1__SIGN_Agreement__c(Name='TestAUAgreement',echosign_dev1__Status__c='Waiting for Counter-Signature',Account__c=customerAccount.ID,Quote__c=lstQuotes[0].Id);
        insert agg;
        
        Map<Id,quote> mapQot=new Map<Id,quote>();
        mapQot.put(lstQuotes[0].ID,lstQuotes[0]);
        Map<ID,echosign_dev1__SIGN_Agreement__c> mapQIDVsAg=new Map<ID,echosign_dev1__SIGN_Agreement__c>();
        mapQIDVsAg.put(lstQuotes[0].ID,agg);        
        //AgreementManagement.createSharingWithInstaller( mapQot);
        AgreementManagement.createLeasePayment( mapQIDVsAg);
        // AgreementManagement.createLeaseScheduleSummary(new Set<Id>{ lstQuotes[0].Id});
        

        Database.Rollback(sp);
        Test.stopTest();
    }
}