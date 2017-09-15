@isTest(SeeAllData=true) 
private class TestCreateLeaseDocsVFController{
    
    //   public static DataDotComUser__c DDUserBypass; 
    public static Account customerAccount;
    public static Contact customerContact;
    public static Account partnerAccount;
    public static Contact partnerContact;
    public static Opportunity customerOpportunity;
    public static creditCheckPageCtrl ccpCtrl;
    public static Loan_Callout_Settings__c lcs;
    public static MosaicJSONUtil.Opportunity opp;
    public static Contact con;
    public static MosaicJSONUtil.Address addr;
    public static Credit_Product__c creditProd1;
    public static Credit_Product__c creditProd2;
    public static User pUser;
    public static List<Credit_Check_Request__c> ccrInsertList;
    public static Credit_Product__c creditProd;
    public static Quote newQuote;
    public static List<Quote_Summary__c>  qtSummary;
    public static System_Production__c sp;
    
    //private static void init() {
    static{
       UserManagement.IS_TEST = true;

       // Code to create the Partner Account 
       Id partnerAccountRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Partner');
       Id customerAccountRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Home_Owner');
       
       partnerAccount = TestUtils.createAccount('Gabi Solar Test Class',partnerAccountRecordTypeId,false);          
       partnerAccount.Cash_Partner__c = true;
       partnerAccount.Loan_Partner__c = true;
       partnerAccount.Lease2_0_Program_Partner__c = true;
       partnerAccount.Sector_Cash__c = 'Residential';
       partnerAccount.Sector_Lease__c = 'Residential';
       partnerAccount.Sector_Loan__c = 'Residential';
       partnerAccount.Channel__c = 'Indirect';
       insert partnerAccount;

       // Code to create the Contact for the Partner Account . and creating the contact for the above Account
       Id partnerContactRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Contact.sobjectType).get('Partner'); 
       partnerContact = TestUtils.createContact('Tom Dowley Test Class',partnerAccount.Id,false);
       partnerContact.RecordTypeId = partnerContactRecordTypeId;
 
       insert partnerContact;

       pUser = TestUtils.createPartnerPortalUser(partnerContact,false);
       pUser.Quote_Creation_Allowed__c = true;
       pUser.Business_Function__c = 'Create Lease Quote;Create Cash Quote;Create Loan Quote;';
       insert pUser;      
       
     /*  lcs = new Loan_Callout_Settings__c(Name='Mosaic',SalesRepEmail__c = 'test@mosaic.com', Endpoint_URL__c ='httpendpoint',Client_ID__c='clientID',Client_Secret__c='clientSecret',Grant_Type__c='grantType');
       insert lcs;  */
       System.runAs(pUser){  
         customerAccount = TestUtils.createAccount('Test Lease Quickquote',customerAccountRecordTypeId,false);
         customerAccount.ShippingCity = 'San Jose';
         customerAccount.ShippingStreet = 'Rio Robles';
         customerAccount.ShippingCountry = 'United States';
         customerAccount.ShippingState='CA';
         customerAccount.ShippingPostalCode ='95134';
         customerAccount.BillingCity = 'San Jose';
         customerAccount.BillingStreet = 'Rio Robles';
         customerAccount.BillingCountry = 'United States';
         customerAccount.BillingState='CA';
         customerAccount.BillingPostalCode ='95134';
         customerAccount.Sales_Tax_Rate__c = 2;
         customerAccount.Filing_Status__c = 'Single';
         customerAccount.Income__c = 100000.00;
         insert customerAccount;
         Attachment a = new Attachment(Name ='test attachment',Body = Blob.valueOf('test'),ParentId = customerAccount.Id);
         insert a;
         customerContact = TestUtils.createContact('Test Lease', customerAccount.Id, false );   
         customerContact.MailingCity = 'San Jose';
         customerContact.MailingStreet = 'Rio Robles';
         customerContact.MailingCountry = 'United States';
         customerContact.MailingState='CA';
         customerContact.MailingPostalCode ='95134';
         customerContact.MailingCountry = 'United States';
         customerContact.Primary__c = true;  
         insert customerContact;
         customerOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0); 
         con = [select Id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Phone,Email,AccountId from Contact where Id=:customerContact.Id];
         addr = new MosaicJSONUtil.Address(con.MailingStreet,'',con.MailingCity,con.MailingState,con.MailingPostalCode);
         opp = new MosaicJSONUtil.Opportunity(con.FirstName,con.LastName,con.Phone.replaceAll('\\D',''),con.Email,addr,con.Email,null); 
         ccrInsertList = new List<Credit_Check_Request__c>();     
         ccrInsertList.add(new Credit_Check_Request__c(Account__c = customerContact.AccountId, Application_Type__c = 'LOAN', Application_Id__c = String.valueOf(opp.Id), Contact__c = con.Id, Credit_Beureu__c ='Mosaic', First_Name__c = customerContact.FirstName, Last_Name__c = customerContact.LastName, Status__c ='Approved',Email__c=customerContact.Email, Credit_Check_Submission_Date__c = Date.today(), Phone__c = '2341234567'));
         ccrInsertList.add(new Credit_Check_Request__c(Account__c = customerContact.AccountId, Application_Type__c = 'LEASE', Contact__c = customerContact.Id, Credit_Beureu__c ='LoanPath', First_Name__c = customerContact.FirstName, Last_Name__c = customerContact.LastName, Status__c ='Approved',Email__c=customerContact.Email, Credit_Check_Submission_Date__c =Date.today(), Phone__c = '2341234567'));
          insert ccrInsertList;
         creditProd = TestUtils.createCreditProduct(ccrInsertList.get(0).Id,10000,100000,false);  
         creditProd.Loan_Month__c = 120;
         creditProd.Product_Display_Name__c = 'prodDispName';
         insert creditProd; 
         List<Dealer_Compliance_Requirement__c>  dealerList =new List<Dealer_Compliance_Requirement__c>();
            Dealer_Compliance_Requirement__c  dealer =new Dealer_Compliance_Requirement__c();
            dealer.Account__c=partnerAccount.Id;
            dealer.Name='Verbally Notified Customer of Right to Cancel';
            dealer.Compliance_Completed__c=false;
            dealer.Status__c='Open';
            dealer.Opportunity__c = customerOpportunity.Id;
            dealerList.add(dealer);
            Dealer_Compliance_Requirement__c  dealer1 =new Dealer_Compliance_Requirement__c();
            dealer1.Account__c=partnerAccount.Id;
            dealer1.Name='Verified Customer’s ID';
            dealer1.Compliance_Completed__c=false;
            dealer1.Status__c='Open';
            dealer1.Opportunity__c=customerOpportunity.Id;
            dealerList.add(dealer1);
            insert dealerList;


           newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', customerOpportunity.Id, false).get(0);
           newQuote.Account__c = customerAccount.Id;
           newQuote.Name = 'Test';
           newQuote.Sector__c = 'Residential';
           newQuote.Loan_Term__c = '10';
           newQuote.QuoteType__c = 'Loan';
           newQuote.installDate__c = 'December 2017';
           newQuote.Description__c = 'dec Test';
           newQuote.Optional_Incentives__c = 'Use All';
           newQuote.Design_Factor__c = 'Automatic';
           newQuote.System_Cost__c =30000;
           newQuote.System_Price__c = 22000.00;
           newQuote.Modules_Per_String_Roof1__c = 8;
           newQuote.Total_Parallel_Strings_Roof1__c = 2;
           newQuote.Inverter_Quantity__c = 2;
           newQuote.Inverter_Model__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
           newQuote.Inverter_Manufacturer_Roof1__c = 'Sunpower';
           newQuote.Modules_Per_String_Roof2__c = 8;
           newQuote.Total_Parallel_Strings_Roof2__c = 2;
           newQuote.Inverter_Model_2__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
           newQuote.Inverter_Manufacturer_Roof2__c = 'Sunpower';
           newQuote.Inverter_Quantity_2__c = 2;
           newQuote.Modules_Per_String_Roof3__c = 8;
           newQuote.Total_Parallel_Strings_Roof3__c = 2;
           newQuote.Inverter_Model_3__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
           newQuote.Inverter_Manufacturer_Roof3__c = 'Sunpower';
           newQuote.Inverter_Quantity_3__c = 2;
           newQuote.Modules_Per_String_Roof4__c = 8;
           newQuote.Total_Parallel_Strings_Roof4__c = 2;
           newQuote.Inverter_Model_4__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
           newQuote.Inverter_Manufacturer_Roof4__c = 'Sunpower';
           newQuote.Inverter_Quantity_4__c = 2;
           newQuote.Monitoring_System__c = 'PVS5 production Monitoring';
           newQuote.Mounting_Description__c = 'InvisiMount';
           newQuote.System_Model__c = '327W (Model SPR-327NE-WHT-D)';
           newQuote.Is_Locked__c = true;
           newQuote.Loan_Contract_Status__c = null;
           newQuote.Monthly_Power_Bill_After_Solar__c = '90';
           newQuote.System_Production_Year_1__c = 1000.00;
           newQuote.Financed_Amount__c = 20000.00;
           newQuote.Total_Contract_Price__c = 250000;
           insert newQuote;
           // creating Quote Summary record
           List<Quote_Summary__c> qtSummary = TestUtils.createQuoteSummaries(1,'Test',customerOpportunity.Id,partnerAccount.Id,false);
           qtSummary.get(0).Locked_Scenario__c = newQuote.id;
           qtSummary.get(0).Module1_AC_rating__c = 8987.34;
           qtSummary.get(0).Module2_AC_rating__c = 8987.34;
           qtSummary.get(0).Module3_AC_rating__c = 8987.34;
           qtSummary.get(0).Module4_AC_rating__c = 8987.34;
           insert qtSummary;
           //Check Dealer compliance Testing for Popup windoe implementation


           sp = new System_Production__c();
           sp.Quote__c = newQuote.id;
           sp.System_Size_AC__c = 5;
           sp.Monthly_Electric_Bill_Without_PV_year1__c = 2000;
           Insert sp;
       }    
    }

    static testmethod void unitTest0(){

        System.runAs (pUser) {
            Test.startTest();
            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            //  ApexPages.StandardController quoteController = new ApexPages.StandardController(newQuote);
            System.currentPageReference().getParameters().put('QuoteId',newQuote.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuote.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            controller.checkAgreementClick='updateValue';
            controller.pageCall();
            Test.stopTest();
        }

    }

    static testmethod void unitTest1(){//Success Loan

        System.runAs (pUser) {
            Test.startTest();
            String JSONString = JSON.serialize(opp);
            TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      JSONString,
                                                                                      null);
        
            Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);


            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            System.currentPageReference().getParameters().put('QuoteId',newQuote.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuote.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            //controller.checkAgreementClick='updateValue';
            //controller.pageCall();
            controller.redirect();
            Test.stopTest();
        }

    }

    static testmethod void unitTest2(){

        System.runAs (pUser) {
            Test.startTest();
            String JSONString = JSON.serialize(opp);
            TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                    'Complete',
                    JSONString,
                    null);

            Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);


            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            System.currentPageReference().getParameters().put('QuoteId',newQuote.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuote.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            controller.checkAgreementClick='updateValue';
            controller.pageCall();
            controller.redirect();
            Test.stopTest();
        }

    }

    static testmethod void unitTest3(){//Failure Loan

        System.runAs (pUser) {
            Test.startTest();
            String JSONString = JSON.serialize(opp);
            TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(400,
                    'Complete',
                    JSONString,
                    null);

            Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);


            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            System.currentPageReference().getParameters().put('QuoteId',newQuote.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuote.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            //controller.checkAgreementClick='updateValue';
            //controller.pageCall();
            controller.redirect();
            Test.stopTest();
        }

    }



    // Loan and LendingAgreementCreated
    static testmethod void secondTest(){ //Loan

        Test.startTest();

        System.runAs (pUser) {
            Quote newQuoteLoan = TestUtils.createQuotes( 1, 'Quick Quote Test ', customerOpportunity.Id, false).get(0);
            newQuoteLoan.Account__c = customerAccount.Id;
            newQuoteLoan.Name = 'Test';
            newQuoteLoan.Sector__c = 'Residential';
            newQuoteLoan.Loan_Term__c = '10';
            newQuoteLoan.QuoteType__c = 'Loan';
            newQuoteLoan.installDate__c = 'December 2017';
            newQuoteLoan.Description__c = 'dec Test';
            newQuoteLoan.Optional_Incentives__c = 'Use All';
            newQuoteLoan.Design_Factor__c = 'Automatic';
            newQuoteLoan.System_Cost__c =30000;
            newQuoteLoan.System_Price__c = 22000.00;
            newQuoteLoan.Modules_Per_String_Roof1__c = 8;
            newQuoteLoan.Total_Parallel_Strings_Roof1__c = 2;
            newQuoteLoan.Inverter_Quantity__c = 2;
            newQuoteLoan.Inverter_Model__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLoan.Inverter_Manufacturer_Roof1__c = 'Sunpower';
            newQuoteLoan.Modules_Per_String_Roof2__c = 8;
            newQuoteLoan.Total_Parallel_Strings_Roof2__c = 2;
            newQuoteLoan.Inverter_Model_2__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLoan.Inverter_Manufacturer_Roof2__c = 'Sunpower';
            newQuoteLoan.Inverter_Quantity_2__c = 2;
            newQuoteLoan.Modules_Per_String_Roof3__c = 8;
            newQuoteLoan.Total_Parallel_Strings_Roof3__c = 2;
            newQuoteLoan.Inverter_Model_3__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLoan.Inverter_Manufacturer_Roof3__c = 'Sunpower';
            newQuoteLoan.Inverter_Quantity_3__c = 2;
            newQuoteLoan.Modules_Per_String_Roof4__c = 8;
            newQuoteLoan.Total_Parallel_Strings_Roof4__c = 2;
            newQuoteLoan.Inverter_Model_4__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLoan.Inverter_Manufacturer_Roof4__c = 'Sunpower';
            newQuoteLoan.Inverter_Quantity_4__c = 2;
            newQuoteLoan.Monitoring_System__c = 'PVS5 production Monitoring';
            newQuoteLoan.Mounting_Description__c = 'InvisiMount';
            newQuoteLoan.System_Model__c = '327W (Model SPR-327NE-WHT-D)';
            newQuoteLoan.Is_Locked__c = true;
            newQuoteLoan.Loan_Contract_Status__c = 'Lending Agreement Created';
            insert newQuoteLoan;
            // creating Quote Summary record
            List<Quote_Summary__c> qtSummary = TestUtils.createQuoteSummaries(1,'Test',customerOpportunity.Id,partnerAccount.Id,false);
            qtSummary.get(0).Locked_Scenario__c = newQuoteLoan.id;
            qtSummary.get(0).Module1_AC_rating__c = 8987.34;
            qtSummary.get(0).Module2_AC_rating__c = 8987.34;
            qtSummary.get(0).Module3_AC_rating__c = 8987.34;
            qtSummary.get(0).Module4_AC_rating__c = 8987.34;
            insert qtSummary;
            //Check Dealer compliance Testing for Popup windoe implementation


            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
          //  ApexPages.StandardController quoteController = new ApexPages.StandardController(newQuoteLoan);
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLoan.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLoan.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            controller.checkAgreementClick='updateValue';
            controller.pageCall();
            controller.redirect();
        }
        Test.stopTest();  
    }


    // Lease and Residential
    static testmethod void thirdTest(){

        Test.startTest();

        System.runAs (pUser) {
            Quote newQuoteLease = TestUtils.createQuotes( 1, 'Quick Quote Test ', customerOpportunity.Id, false).get(0);
            newQuoteLease.Account__c = customerAccount.Id;
            newQuoteLease.Name = 'Test';
            newQuoteLease.Sector__c = 'Residential';
            newQuoteLease.Loan_Term__c = '10';
            newQuoteLease.QuoteType__c = 'Lease';
            newQuoteLease.installDate__c = 'December 2017';
            newQuoteLease.Description__c = 'dec Test';
            newQuoteLease.Optional_Incentives__c = 'Use All';
            newQuoteLease.Design_Factor__c = 'Automatic';
            newQuoteLease.System_Cost__c =30000;
            newQuoteLease.System_Price__c = 22000.00;
            newQuoteLease.Modules_Per_String_Roof1__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof1__c = 2;
            newQuoteLease.Inverter_Quantity__c = 2;
            newQuoteLease.Inverter_Model__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof1__c = 'Sunpower';
            newQuoteLease.Modules_Per_String_Roof2__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof2__c = 2;
            newQuoteLease.Inverter_Model_2__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof2__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_2__c = 2;
            newQuoteLease.Modules_Per_String_Roof3__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof3__c = 2;
            newQuoteLease.Inverter_Model_3__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof3__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_3__c = 2;
            newQuoteLease.Modules_Per_String_Roof4__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof4__c = 2;
            newQuoteLease.Inverter_Model_4__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof4__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_4__c = 2;
            newQuoteLease.Monitoring_System__c = 'PVS5 production Monitoring';
            newQuoteLease.Mounting_Description__c = 'InvisiMount';
            newQuoteLease.System_Model__c = '327W (Model SPR-327NE-WHT-D)';
            newQuoteLease.Is_Locked__c = true;
            newQuoteLease.Loan_Contract_Status__c = 'Lending Agreement Created';
            insert newQuoteLease;
            // creating Quote Summary record
            List<Quote_Summary__c> qtSummary = TestUtils.createQuoteSummaries(1,'Test',customerOpportunity.Id,partnerAccount.Id,false);
            qtSummary.get(0).Locked_Scenario__c = newQuoteLease.id;
            qtSummary.get(0).Module1_AC_rating__c = 8987.34;
            qtSummary.get(0).Module2_AC_rating__c = 8987.34;
            qtSummary.get(0).Module3_AC_rating__c = 8987.34;
            qtSummary.get(0).Module4_AC_rating__c = 8987.34;
            insert qtSummary;
            //Check Dealer compliance Testing for Popup windoe implementation



            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
          //  ApexPages.StandardController quoteController = new ApexPages.StandardController(newQuoteLease);
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            controller.checkAgreementClick='updateValue';
            controller.pageCall();
            controller.redirect();
            newQuoteLease.Sector__c = 'New Homes';
            update newQuoteLease;
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            controller = new CreateLeaseDocsVFController();
            controller.redirect();
            newQuoteLease.Sector__c = 'Residential';
            newQuoteLease.QuoteType__c = 'Cash';
            update newQuoteLease;
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            controller = new CreateLeaseDocsVFController();
            controller.redirect();
        }
        Test.stopTest();  
    }

    static testmethod void testLeasewithNoCreditApps(){

        List<Credit_Check_Request__c> ccrList = new List<Credit_Check_Request__c>([SELECT Id from Credit_Check_Request__c where Account__c = :customerAccount.Id]);
        delete ccrList;

        Test.startTest();

        System.runAs (pUser) {
            Quote newQuoteLease = TestUtils.createQuotes( 1, 'Quick Quote Test ', customerOpportunity.Id, false).get(0);
            newQuoteLease.Account__c = customerAccount.Id;
            newQuoteLease.Name = 'Test';
            newQuoteLease.Sector__c = 'Residential';
            newQuoteLease.Loan_Term__c = '10';
            newQuoteLease.QuoteType__c = 'Lease';
            newQuoteLease.installDate__c = 'December 2017';
            newQuoteLease.Description__c = 'dec Test';
            newQuoteLease.Optional_Incentives__c = 'Use All';
            newQuoteLease.Design_Factor__c = 'Automatic';
            newQuoteLease.System_Cost__c =30000;
            newQuoteLease.System_Price__c = 22000.00;
            newQuoteLease.Modules_Per_String_Roof1__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof1__c = 2;
            newQuoteLease.Inverter_Quantity__c = 2;
            newQuoteLease.Inverter_Model__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof1__c = 'Sunpower';
            newQuoteLease.Modules_Per_String_Roof2__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof2__c = 2;
            newQuoteLease.Inverter_Model_2__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof2__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_2__c = 2;
            newQuoteLease.Modules_Per_String_Roof3__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof3__c = 2;
            newQuoteLease.Inverter_Model_3__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof3__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_3__c = 2;
            newQuoteLease.Modules_Per_String_Roof4__c = 8;
            newQuoteLease.Total_Parallel_Strings_Roof4__c = 2;
            newQuoteLease.Inverter_Model_4__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
            newQuoteLease.Inverter_Manufacturer_Roof4__c = 'Sunpower';
            newQuoteLease.Inverter_Quantity_4__c = 2;
            newQuoteLease.Monitoring_System__c = 'PVS5 production Monitoring';
            newQuoteLease.Mounting_Description__c = 'InvisiMount';
            newQuoteLease.System_Model__c = '327W (Model SPR-327NE-WHT-D)';
            newQuoteLease.Is_Locked__c = true;
            newQuoteLease.Loan_Contract_Status__c = 'Lending Agreement Created';
            insert newQuoteLease;
            // creating Quote Summary record
            List<Quote_Summary__c> qtSummary = TestUtils.createQuoteSummaries(1,'Test',customerOpportunity.Id,partnerAccount.Id,false);
            qtSummary.get(0).Locked_Scenario__c = newQuoteLease.id;
            qtSummary.get(0).Module1_AC_rating__c = 8987.34;
            qtSummary.get(0).Module2_AC_rating__c = 8987.34;
            qtSummary.get(0).Module3_AC_rating__c = 8987.34;
            qtSummary.get(0).Module4_AC_rating__c = 8987.34;
            insert qtSummary;
            //Check Dealer compliance Testing for Popup windoe implementation



            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            //  ApexPages.StandardController quoteController = new ApexPages.StandardController(newQuoteLease);
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            controller.checkAgreementClick='updateValue';
            controller.pageCall();
            controller.redirect();
            newQuoteLease.Sector__c = 'New Homes';
            update newQuoteLease;
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            controller = new CreateLeaseDocsVFController();
            controller.redirect();
            newQuoteLease.Sector__c = 'Residential';
            newQuoteLease.QuoteType__c = 'Cash';
            update newQuoteLease;
            System.currentPageReference().getParameters().put('QuoteId',newQuoteLease.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuoteLease.id);
            controller = new CreateLeaseDocsVFController();
            controller.redirect();
        }
        Test.stopTest();
    }

    static testmethod void loanSuccessnoCreditApps(){//Success Loan
        List<Credit_Check_Request__c> ccrList = new List<Credit_Check_Request__c>([SELECT Id from Credit_Check_Request__c where Account__c = :customerAccount.Id]);
        delete ccrList;
        System.runAs (pUser) {
            Test.startTest();
            String JSONString = JSON.serialize(opp);
            TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                    'Complete',
                    JSONString,
                    null);

            Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);


            PageReference p = Page.CreateLeaseDocsVF;
            Test.setCurrentPage(p);
            System.currentPageReference().getParameters().put('QuoteId',newQuote.id);
            System.currentPageReference().getParameters().put('show','true');
            System.currentPageReference().getParameters().put('Id',newQuote.id);
            CreateLeaseDocsVFController controller = new CreateLeaseDocsVFController();
            //controller.checkAgreementClick='updateValue';
            //controller.pageCall();
            controller.redirect();
            controller.customerPage();
            Test.stopTest();
        }

    }

}