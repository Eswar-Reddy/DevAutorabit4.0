@isTest(seeAllData=true)
public class TestNewHomesQuote{
    
    static Account partnerAccount;
    static Account customerAccount;
	static List<Contact> lstCustomerContact;
    static List<Opportunity> lstCustomerOpportunity;
    static Account installerAccount;
    
    private static void setupInitData(){
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = accSchema.getRecordTypeInfosByName();
        Id idPartnerRecordId = AccountRecordTypeInfo.get('Partner').getRecordTypeId();
        Id idCustomerRecordId = AccountRecordTypeInfo.get('Residential Customer').getRecordTypeId();
        
        partnerAccount = new Account();
        
        partnerAccount = TestUtils.createAccount( 'Test1NewHomesPartner1', idPartnerRecordId, false );
        partnerAccount.BillingState = 'CA';
        partnerAccount.BillingCountry= 'United States';
        insert partnerAccount;
        
  		customerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        customerAccount.Partner_Account__c=partnerAccount.Id;
        insert CustomerAccount;
        
        lstCustomerContact = new List<Contact>();
        lstCustomerContact.add(TestUtils.createContact('CustomerContact', CustomerAccount.Id, true));
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        //lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
        
        installerAccount = new Account();
        installerAccount = TestUtils.createAccount( 'Test1NewHomesInstPartnr1', idPartnerRecordId, false );
        installerAccount.BillingState = 'CA';
        installerAccount.BillingCountry= 'United States';
        insert installerAccount;
    }
    
    
    public static testMethod void testNewHomesQuote1(){
        
        setupInitData();
        
        test.startTest();
        //// Quote Creation
        Quote qot = TestUtils.createQuotes(1, 'NYLeaseQuoteDWCT1', lstCustomerOpportunity[0].id, false)[0];
        qot.Account__c=customerAccount.Id;
        qot.OpportunityId=lstCustomerOpportunity[0].Id;
        qot.ContactID=lstCustomerContact[0].Id;
        qot.System_Cost__c=25000.00;
        qot.Module_Quantity__c =16;
        qot.Dealer_Fees__c =13000;
        qot.QuoteType__c ='Lease';
        qot.Quote_type__c = 'Residential New Homes Lease Quotation';
        insert qot;
        
        qot.Lease_Doc_Signed__c=true;
        qot.Is_Locked__c=true;
        update qot;
        test.stopTest();
    }
    
    public static testMethod void testNewHomesQuote2(){
        
        setupInitData();
        lstCustomerOpportunity[0].Installer__c =installerAccount.Id;
        update lstCustomerOpportunity;
        
        test.startTest();
        //// Quote Creation
        Quote qot = TestUtils.createQuotes(1, 'NYLeaseQuoteDWCT1', lstCustomerOpportunity[0].id, false)[0];
        qot.Account__c=customerAccount.Id;
        qot.OpportunityId=lstCustomerOpportunity[0].Id;
        qot.ContactID=lstCustomerContact[0].Id;
        qot.System_Cost__c=25000.00;
        qot.Module_Quantity__c =16;
        qot.Dealer_Fees__c =13000;
        qot.QuoteType__c ='Lease';
        qot.Quote_type__c = 'Residential New Homes Lease Quotation';
        qot.Installer__c=installerAccount.Id;
        insert qot;
        
        qot.Lease_Doc_Signed__c=true;
        qot.Is_Locked__c=true;
        update qot;
        test.stopTest();
    }
    
    public static testMethod void testNewHomesQuote3(){
        setupInitData();
        
        lstCustomerOpportunity[0].Installer__c =installerAccount.Id;
        update lstCustomerOpportunity;
        
        Ship_to_Site__c sts = new Ship_to_Site__c(Dealer_Account__c =installerAccount.Id,Address1__c ='North First St',City__c ='San Jose',State__c='CA',Country__c ='United States',Zip__c='95134',Type__c='Dealer Warehouse',RecordTypeId='012800000003Z5NAAU');
    	insert sts;
        
        installerAccount.Default_Dealer_Warehouse_Shipping_Site__c=sts.Id;
        update installerAccount;
        
        test.startTest();
        Quote qot = TestUtils.createQuotes(1, 'NYLeaseQuoteDWCT1', lstCustomerOpportunity[0].id, false)[0];
        qot.Account__c = customerAccount.Id;
        qot.OpportunityId = lstCustomerOpportunity[0].Id;
        qot.ContactID = lstCustomerContact[0].Id;
        qot.System_Cost__c = 25000.00;
        qot.Module_Quantity__c = 16;
        qot.Dealer_Fees__c = 13000;
        qot.QuoteType__c ='Lease';
        qot.Quote_type__c = 'Residential New Homes Lease Quotation';
        qot.Installer__c = installerAccount.Id;
        insert qot;
        
        qot.Lease_Doc_Signed__c = true;
        qot.Is_Locked__c = true;
        update qot;
        test.stopTest();
    }   
    
    
}