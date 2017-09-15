@isTest(seeAllData=true)
public class TestFranceQuote {
	
    static Account partnerAccount;
    static Account customerAccount;
	static List<Contact> lstCustomerContact;
    static List<Opportunity> lstCustomerOpportunity;
    static Account installerAccount;
    
    private static void setupData(){
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
        CustomerAccount.BillingState = 'Paris';//45 Avenue des Ternes 
   		CustomerAccount.BillingPostalCode='75008';
        CustomerAccount.BillingCountry= 'France';
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
    
    
    public static testMethod void testFranceQuote1(){
        
        setupData();
        
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
        qot.RecordTypeId='01280000000QA1K';
        insert qot;
        
        qot.Lease_Doc_Signed__c=true;
        qot.Is_Locked__c=true;
        update qot;
        test.stopTest();
    }
    
    
}