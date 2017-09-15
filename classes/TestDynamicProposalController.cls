@isTest
public class TestDynamicProposalController {
    
    public static Account customerAccount;
    public static Contact customerContact;
    public static DynamicProposalController dpCtrl;
    public static Opportunity customerOpportunity;
    public static Quote newQuote;
    static{
        CustomerAccount = TestUtils.createAccount( 'TestCPRDCustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        customerContact = TestUtils.createContact('CustomerContact', CustomerAccount.Id, false);
        customerContact.Primary__c = true;
        insert customerContact;
        
        customerOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0);
        
        newQuote = TestUtils.createQuotes( 1, 'Test Dynamic Proposal Quote', customerOpportunity.Id, false).get(0);
        newQuote.Account__c = customerAccount.Id;
        newQuote.Dynamic_Proposal__c = true;
        insert newQuote;
    }
    
    public static testMethod void TestDynamicProposalController1(){
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(customerOpportunity);
        Test.setCurrentPageReference(Page.DynamicProposal);
        ApexPages.currentPage().getParameters().put('oppId', customerOpportunity.Id);
        ApexPages.currentPage().getParameters().put('action', 'insert');
        dpCtrl = new DynamicProposalController(sc);
        DynamicProposalController.forwardtoequinox();
        
        ApexPages.currentPage().getParameters().put('oppId', null);
        ApexPages.currentPage().getParameters().put('quoteId', newQuote.Id);
        ApexPages.currentPage().getParameters().put('action', 'edit');
        dpCtrl = new DynamicProposalController(sc);
        DynamicProposalController.forwardtoequinox();

        ApexPages.currentPage().getParameters().put('oppId', null);
        ApexPages.currentPage().getParameters().put('quoteId', newQuote.Id);
        ApexPages.currentPage().getParameters().put('action', 'copy');
        dpCtrl = new DynamicProposalController(sc);
        DynamicProposalController.forwardtoequinox();
        Test.stopTest();
    }
    
}