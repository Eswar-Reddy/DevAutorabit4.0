/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for CreditCheckController Controller Class
Edits  :    
        2014-04-07 : 
********************************************************************************************/

@isTest(SeeAllData=True)        // Set SeeAllData=True so that custom setting's values can be retrieved in the Opportunity's Trigger
public class CreditCheckControllerTest
{    
    static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    static Quote q;
    private static Id proposalQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Proposal Quote').getRecordTypeId();
    
    public static testMethod void TM1()
    {
        String postFix = String.valueOf(Datetime.now().getTime());
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        q=new Quote(Name='TQuote1'+postFix, RecordTypeId=proposalQuoteRecordTypeId, OpportunityId=newOpportunity.ID);
        insert q;
         
        PageReference pageRef = Page.CreditCheck;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', newOpportunity.Id);
        ApexPages.currentPage().getParameters().put('act', 'ncr');
        CreditCheckController controller = new CreditCheckController(new ApexPages.StandardController(newOpportunity));
        controller.propMockVal = 1;
        controller.propSelectedRecord=q.ID;
        controller.propValue='true';
        controller.redirect();
        controller.ChangeSelection();
        controller.SubmitToLoanPath();
        controller.propMockVal = 2;
        controller.SubmitToLoanPath();
        controller.propMockVal = 3;
        controller.SubmitToLoanPath();
        
    }//End Func TM1  
    
    public static testMethod void TM2()
    {
        String postFix = String.valueOf(Datetime.now().getTime());
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, false).get(0);
        newOpportunity.Credit_Application_Status__c='Pending - Application Sent';
        newOpportunity.Credit_Application_ID__c='12345';
        insert newOpportunity;
        Quote q1=new Quote(Name='TQuote1'+postFix, RecordTypeId=proposalQuoteRecordTypeId, OpportunityId=newOpportunity.ID);
        insert q1;
         
        PageReference pageRef = Page.CreditCheck;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', newOpportunity.Id);
        ApexPages.currentPage().getParameters().put('act', '');
        CreditCheckController controller = new CreditCheckController(new ApexPages.StandardController(newOpportunity));
        controller.propMockVal = 3;
        controller.redirect();
        controller.ChangeSelection();
        controller.SubmitToLoanPath();
        CreditCheckController.statusForTestCode='Error:Testing..';
        controller.redirect();
    }//End Func TM2
}