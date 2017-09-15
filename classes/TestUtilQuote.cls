/*
Developed:
09-Jul-2014 : Birlasoft : Test Class for UtilQuote Class.
*/
@isTest(SeeAllData=true) 
Public Class TestUtilQuote
{
    
    Public Static Account partnerAccount;
    Public static Contact partnerContact;
    Public static User partnerUser;
    Public static Account instAccount;
    Public static Contact instContact;
    Public static List<Quote> lstQuotes;
    Public static Account customerAccount;
    Public static Account customerAccountUS;
    Public static Account customerAccountFR;
    Public static List<Contact> lstCustomerContact;
    Public static List<Contact> lstCustomerContactUS;
    Public static List<Contact> lstCustomerContactFR;
    Public static List<Opportunity> lstCustomerOpportunity;
    
    
    public static List<User> lstPartnerUser;
    public static List<Account> lstPartner;
    public static List<Contact> lstContact;
    public static String tpsPartnerUserId;
    public static String dripPartnerUserId;
    public static String ipPartnerUserId;
    public static String tpsContactId;
    public static String dripContactId;
    public static String ipContactId;    
    public static String TPSAccountId;
    public static String DRIPAccountId;
    public static String IPAccountId;
    
    static{
        ///Setting Flags to Skip Triggers        
        UserManagement.IS_TEST= true;           
        SFDCSpecialUtilities.isRunningTest=true;
        List<Account> lstAccs=new List<Account>();
        List<Contact> lstCons=new List<Contact>();
        
        ///Partner Account Creation
        partnerAccount = TestUtils.createAccount('TEST_AU_SALES_PARTNER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
        partnerAccount.Lease2_0_Program_Partner__c= true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'WAR'+String.ValueOf(DateTime.Now().getTime()).substring(0, 5);
        partnerAccount.Oracle_County__c='Australia';
        partnerAccount.Oracle_Shipping_County__c='Australia';
        partnerAccount.Theater__c='Australia';       
        lstAccs.add(partnerAccount); //insert partnerAccount;
        
        ///Installer Account
        instAccount = TestUtilsGPP.createInstallerAccount('TEST_AU_INSTALLER', TestUtilsGPP.RECORDTYPE_ACCOUNT_PARTNER, false);
        lstAccs.add(instAccount); //insert instAccount;
        
        if(!lstAccs.isEmpty())  insert lstAccs;
        
        ///Associate Installer with Seller
        TestUtilsGPP.associateInstallerWithSeller(partnerAccount,instAccount,'Installer',true);
        
        /// Partner Contact Creation
        partnerContact = TestUtilsGPP.createContact('BSLAU', partnerAccount.Id, false);
        partnerContact.Primary__c=true;    
        lstCons.add(partnerContact); //insert partnerContact;
        
        ///Installer Partner Contact Creation
        instContact = TestUtilsGPP.createContact('TestInstallerAUCont', instAccount.Id, false);
        instContact.Primary__c=true;
        instContact.Email='testinstallerAUCont@au.com';    
        lstCons.add(instContact); //insert instContact;
        
        if(!lstCons.isEmpty()) insert lstCons;
        
        /// Partner User Creation
        partnerUser= TestUtilsGPP.createPartnerPortalUser(partnerContact, false);
        partnerUser.Quote_Creation_Allowed__c=true;
        partnerUser.Lease_doc_creation_allowed__c=true;
        insert partnerUser;   
        
        ///Customer Account & Contact Creation
        customerAccount= TestUtilsGPP.createAccount('AUCustomer1' , 
                                                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, false);
        customerAccount.Partner_Account__c=partnerAccount.Id;
        insert customerAccount;
        //US
        customerAccountUS = TestUtilsGPP.createAccountUS('USCustomer1' , 
                                                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, false);
        customerAccountUS.Partner_Account__c=partnerAccount.Id;
        insert customerAccountUS;
        //FRANCE
        customerAccountFR = TestUtilsGPP.createAccountFR('FRCustomer1' , 
                                                    TestUtilsGPP.RECORDTYPE_ACCOUNT_RESIDENTIAL_CUSTOMER, false);
        customerAccountFR.Partner_Account__c=partnerAccount.Id;
        insert customerAccountFR;
        
        
        lstCustomerContact= TestUtilsGPP.createCustomerContacts(2, 'AUC', customerAccount.Id, 
                                                                TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, true); 
        lstCustomerContactUS= TestUtilsGPP.createCustomerUSContacts(2, 'USC', customerAccountUS.Id, 
                                                                TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, true); 
        lstCustomerContactFR= TestUtilsGPP.createCustomerFRContacts(2, 'FRC', customerAccountFR.Id, 
                                                                TestUtilsGPP.RECORDTYPE_CONTACT_CUSTOMER, true); 
                
        
    }
    
    Public Static testMethod void TestUtilQuoteClass1()
    { 
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccount.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                                    customerAccount,
                                                    lstCustomerOpportunity[0],
                                                    lstCustomerContact[0],
                                                    TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                                    instAccount.ID,false);
        
        lstQuotes[0].Installer__c=instAccount.ID;
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        Test.StartTest();
        insert lstQuotes;        
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    
    Public Static testMethod void TestUtilQuoteClass2()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c = sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccount.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        
        
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,customerAccount,lstCustomerOpportunity[0],lstCustomerContact[0],TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        insert lstQuotes;
        
        String sQuoteNumber= '';               
        if(!lstQuotes.isEmpty())
            sQuoteNumber= [SELECT Id, QuoteNumber FROM Quote WHERE id=: lstQuotes[0].Id].QuoteNumber;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SPWRQuote/UpdateQuoteDetails';  
        req.httpMethod = 'POST'; 
        
        GPPServicesUpdateQuoteDetailsMock fakeUQDResponse = new GPPServicesUpdateQuoteDetailsMock(sQuoteNumber);
        
        String sJSON= fakeUQDResponse.sPayLoad;
        GPPUpdateQuoteAPIPayloadParser obj= GPPUpdateQuoteAPIPayloadParser.parse(sJSON);
        Test.setMock(HttpCalloutMock.class, fakeUQDResponse); 
        RestContext.request = req;
        RestContext.response = res;
        
        req.requestBody=Blob.valueOf(sJSON);                 
        
        //GPPServicesUpdateQuoteDetails.WResponse gppUQDWResponse= GPPServicesUpdateQuoteDetails.UpdateQuote();
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        update lstQuotes;
        
        
        // List<Quote_Line__c> Qlines=TestUtilsGPP.createQuoteLines(1,lstQuotes[0], true);
        
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    
    Public Static testMethod void TestUtilQuoteClass3()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountUS.Id,
                                                                         lstCustomerContactUS[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        AccountContactRole acr = new AccountContactRole(AccountId = customerAccountUS.Id,
                                                        ContactId = lstCustomerContactUS[0].Id,
                                                        Role = 'Shipping Contact'
                                                        );
        insert acr;
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createNHQuotes(1,
                                              customerAccountUS,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactUS[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID; 
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        insert lstQuotes;
        
        
        utilQuote objUtilQuote=new utilQuote();        
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass4()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountFR.Id,
                                                                         lstCustomerContactFR[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccountFR,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactFR[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Dealer_Fees__c = 100;
        update lstQuotes;  
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.CreateLeaseSchedule(new Set<ID>{lstQuotes[0].Id});
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass5()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        customerAccountFR.Multiple_Meters__c = true;
        update customerAccountFR;
        
        Test.StartTest();
                
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountFR.Id,
                                                                         lstCustomerContactFR[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccountFR,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactFR[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              partnerAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Dealer_Fees__c = 100;
        update lstQuotes;  
        
        list<LeasePayment__c> lstLP = new List<LeasePayment__c>(); 
        lstLP.add(new LeasePayment__c(name= 'lptest1003',       
                                  Quote__c= lstQuotes[0].Id,
                                  Opportunity__c = lstCustomerOpportunity[0].ID,
                                  Account__c = customerAccountFR.ID, 
                                  End_Customer_Account__c = customerAccountUS.ID,
                                  RecordTypeId ='01280000000QA1GAAW',
                                  Contact__c = lstCustomerContactFR[0].ID,
                                  Date_Lease_Document_signed__c = Date.Today(),
                                  Partner_Account__c = partnerAccount.ID
                                 ));
        insert lstLP;
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.CreateLeaseSchedule(new Set<ID>{lstQuotes[0].Id});
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass6()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        customerAccountUS.Multiple_Meters__c = true;
        update customerAccountUS;
        
        Test.StartTest();
                
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountUS.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccountUS,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactUS[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              partnerAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Spectrum_Partner_Quote__c = false;
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        update lstQuotes;        
        
        
        list<LeasePayment__c> lstLP = new List<LeasePayment__c>(); 
        lstLP.add(new LeasePayment__c(name= 'lptest1003',       
                                  Quote__c= lstQuotes[0].Id,
                                  Opportunity__c = lstCustomerOpportunity[0].ID,
                                  Account__c = customerAccount.ID, 
                                  End_Customer_Account__c = customerAccountUS.ID,
                                  RecordTypeId ='01280000000QA1GAAW',
                                  Contact__c = lstCustomerContact[0].ID,
                                  Date_Lease_Document_signed__c = Date.Today(),
                                  Partner_Account__c = partnerAccount.ID
                                 ));
        insert lstLP;
        
        utilQuote objUtilQuote=new utilQuote();        
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    
    Public Static testMethod void TestUtilQuoteClass7()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountUS.Id,
                                                                         lstCustomerContactUS[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccountUS,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactUS[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        insert lstQuotes;
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.CreateLeaseSchedule(new Set<ID>{lstQuotes[0].Id});
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
        
    }
    
    Public Static testMethod void TestUtilQuoteClass8()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountUS.Id,
                                                                         lstCustomerContactUS[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        AccountContactRole acr = new AccountContactRole(AccountId = customerAccountUS.Id,
                                                        ContactId = lstCustomerContactUS[0].Id,
                                                        Role = 'Shipping Contact'
                                                        );
        insert acr;
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createNHQuotes(1,
                                              customerAccountUS,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactUS[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Spectrum_Partner_Quote__c = true;
        update lstQuotes;   
        
        Annual_Financial__c objAF= new Annual_Financial__c(Quote__c= lstQuotes[0].Id);
        objAF.Row_Number__c = 0;
        objAF.Annual_Base__c = 0.0;
        objAF.Annual_Sales_Tax__c = 0.0;
        objAF.Annual_Fees__c = 0.0;
        objAF.Monthly_Base__c = 0.0;
        objAF.Monthly_Fees__c = 0.0;
        objAF.Monthly_Sales_Tax__c = 0.0;
        objAF.Monthly_Base_Plus_Tax__c= 0.0;                                   
        objAF.Annual_Termination_Amount__c = 0.0;
        objAF.CurrencyISOCode =  lstQuotes[0].CurrencyISOCode;                    
        insert objAF;
        utilQuote objUtilQuote=new utilQuote();
        try{
                    
            objUtilQuote.CreateLeaseSchedule(new Set<ID>{lstQuotes[0].Id});
        }
        catch(exception e){}        
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass9()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        List<Account> lstAccs=new List<Account>();
        
        Ship_to_Site__c sts2 = new Ship_to_Site__c(Dealer_Account__c =instAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts2;
        
        Test.StartTest();
        partnerAccount.Default_Dealer_warehouse_Shipping_Site__c=sts.Id;
        lstAccs.add(partnerAccount);
        instAccount.Default_Dealer_warehouse_Shipping_Site__c=sts2.Id;
        lstAccs.add(instAccount);
        update lstAccs;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccountUS.Id,
                                                                         lstCustomerContactUS[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        AccountContactRole acr = new AccountContactRole(AccountId = customerAccountUS.Id,
                                                        ContactId = lstCustomerContactUS[0].Id,
                                                        Role = 'Shipping Contact'
                                                        );
        insert acr;
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createNHQuotes(1,
                                              customerAccountUS,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContactUS[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              partnerAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID; 
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        insert lstQuotes;
        
        
        utilQuote objUtilQuote=new utilQuote();        
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass10()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccount.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccount,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContact[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Spectrum_Partner_Quote__c=false;
        lstQuotes[0].Dealer_Fee_Installation_Partner_Total__c = 100;
        lstQuotes[0].Dealer_Fees_Sales_Partner_Total__c = 200;
        update lstQuotes;  
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    
    Public Static testMethod void TestUtilQuoteClass11()
    {   
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =partnerAccount.Id,
                                                  Address1__c ='North First St',
                                                  City__c ='San Jose',
                                                  State__c='CA',
                                                  Country__c ='United States',
                                                  Zip__c='95134',
                                                  Type__c='Dealer Warehouse',
                                                  RecordTypeId='012800000003Z5NAAU');
        insert sts;
        Test.StartTest();
        partnerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update partnerAccount;
        
        lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
                                                                         customerAccount.Id,
                                                                         lstCustomerContact[0].Id,
                                                                         TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);
        //// Quote Creation
        lstQuotes=TestUtilsGPP.createCustomerQuotes(1,
                                              customerAccount,
                                              lstCustomerOpportunity[0],
                                              lstCustomerContact[0],
                                              TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,
                                              instAccount.ID,false);
        lstQuotes[0].Installer__c=instAccount.ID;
        
        lstQuotes[0].Lease_Doc_Signed__c=false;
        insert lstQuotes;
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Spectrum_Partner_Quote__c=false;
        lstQuotes[0].Dealer_Fee_Installation_Partner_Total__c = 100;
        lstQuotes[0].Dealer_Fees_Sales_Partner_Total__c = 200;        
        lstQuotes[0].QuoteType__c = '';
        update lstQuotes;  
        
        utilQuote objUtilQuote=new utilQuote();
        objUtilQuote.createPOLines(new List<ID>{lstQuotes[0].Id});  
        Test.stopTest();
    }
    /*
    public static testMethod void testAgreementManagement()
    {
    Test.StartTest();            
    lstCustomerOpportunity= TestUtilsGPP.createCustomerOpportunities(1,
    customerAccount.Id,
    lstCustomerContact[0].Id,
    TestUtilsGPP.RECORDTYPE_OPPORTUNITY_HOME_OWNER,true);            
    //// Quote Creation
    lstQuotes=TestUtilsGPP.createCustomerQuotes(1,customerAccount,lstCustomerOpportunity[0],lstCustomerContact[0],TestUtilsGPP.RECORDTYPE_QUOTE_PROPOSAL_QUOTE,instAccount.ID, false);
    // lstQuotes[0].Installer__c=instAccount.ID;
    insert lstQuotes;
    echosign_dev1__SIGN_Agreement__c agg=new echosign_dev1__SIGN_Agreement__c(Name='TestAUAgreement',echosign_dev1__Status__c='Draft',Account__c=customerAccount.ID,Quote__c=lstQuotes[0].Id);
    insert agg;
    
    agg.echosign_dev1__Status__c='Waiting for Counter-Signature';
    update agg;
    
    Map<Id,quote> mapQot=new Map<Id,quote>();
    mapQot.put(lstQuotes[0].ID,lstQuotes[0]);
    Map<ID,echosign_dev1__SIGN_Agreement__c> mapQIDVsAg=new Map<ID,echosign_dev1__SIGN_Agreement__c>();
    mapQIDVsAg.put(lstQuotes[0].ID,agg);        
    AgreementManagement.createSharingWithInstaller( mapQot);
    AgreementManagement.createLeasePayment( mapQIDVsAg);
    AgreementManagement.createLeaseScheduleSummary(new Set<Id>{ lstQuotes[0].Id});
    Test.stopTest();
    }*/
    
    
    
}