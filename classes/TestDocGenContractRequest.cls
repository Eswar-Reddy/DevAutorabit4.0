@isTest(seeAllData = true)
public class TestDocGenContractRequest {

    public static Contact newContact;
    public static Contact customerContact;
    public static Opportunity newOpportunity;
    public static Account partnerAccount;
    public static Contact partnerContact;
    public static User partnerPortalUser;
    public static User sysAdmin;
    public static Account customerAccount;
    public static Quote newQuote;
    public static List<Lease_Schedule__c> leasePaymentList;
    public static System_Production__c systemProd;
    public static testmethod void unitTest(){
        init();
        Business_Registration__c br = new Business_Registration__c();
        br.Name                 = customerAccount.billingstate;
        br.Account__c       = customerAccount.id;
        br.License_Number__c = '12345';
        br.Country__c           = customerAccount.billingCountry;
        br.State__c             = customerAccount.billingstate;
        insert br;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Account__c = customerAccount.Id;
        newQuote.Name = 'Test';
        newQuote.Sector__c = 'Residential';
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2017';
        newQuote.Description__c = 'dec Test';
        newQuote.Optional_Incentives__c = 'Use All';
        newQuote.Design_Factor__c = 'Automatic';
        newQuote.System_Cost__c =30000;
        newQuote.System_Price__c = 22000.00;
        newQuote.Modules_Per_String_Roof2__c = 8;
        newQuote.Total_Parallel_Strings_Roof2__c = 2;
        newQuote.Inverter_Quantity__c = 2;
        newQuote.Inverter_Model__c = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))';
        newQuote.Inverter_Manufacturer_Roof1__c = 'Sunpower';
        newQuote.Monitoring_System__c = 'PVS5 production Monitoring';
        newQuote.Mounting_Description__c = 'InvisiMount';
        newQuote.System_Model__c = '327W (Model SPR-327NE-WHT-D)';
        newQuote.Is_Locked__c = true;
        insert newQuote;
        leasePaymentList = TestUtils.createLeaseSchedules(newQuote.Id, true);
        systemProd = new System_Production__c(Quote__c = newQuote.Id);
        insert systemProd;

        DocGenContractRequest docGen = new DocGenContractRequest();
        docGen.sendDataToDocGen(Null,newQuote.Id, '01280000000Q534', 'yes', 'Test Agreement', 'test@test.com','','Agreement');
    }

    private static void init(){
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
       partnerAccount.Contractors_License__c = '12345';
       insert partnerAccount;

       // Code to create the Contact for the Partner Account . and creating the contact for the above Account
       Id partnerContactRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Contact.sobjectType).get('Partner');
       partnerContact = TestUtils.createContact('Tom Dowley Test Class',partnerAccount.Id,false);
       partnerContact.RecordTypeId = partnerContactRecordTypeId;
       insert partnerContact;

       partnerPortalUser = TestUtils.createPartnerPortalUser(partnerContact,false);
       partnerPortalUser.Quote_Creation_Allowed__c = true;
       partnerPortalUser.Business_Function__c = 'Create Lease Quote;Create Cash Quote;Create Loan Quote;';
       insert partnerPortalUser;

       System.runAs(partnerPortalUser){
         Test.startTest();
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
         customerAccount.partner_account__c = partnerAccount.Id;
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
         newContact = TestUtils.createContact('Second Contact', customerAccount.Id, false);
         newContact.MailingCity = 'San Jose';
         newContact.MailingStreet = 'Rio Robles';
         newContact.MailingCountry = 'United States';
         newContact.MailingState='CA';
         newContact.MailingPostalCode ='95134';
         newContact.MailingCountry = 'United States';
         newContact.Primary__c = false;
         newContact.Include_in_Lease_Doc__c = true;
         insert newContact;

         newOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0);
          Test.stopTest();
       }


    }
}