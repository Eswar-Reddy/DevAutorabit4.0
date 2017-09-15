@isTest(seeAllData=true)
public class Testupdatereadytosend{
static testMethod void testupdatereadytosend(){
        //Create Quote
        Quote newQuote;
        Opportunity newOpportunity;
        newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
        
        //Create Agreement
        echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();
        newAgreement.Name = 'test agree';
        newAgreement.Quote__c = newQuote.Id;
        newAgreement.Ready_to_send__c = false;
        insert newAgreement;
        
        newQuote.Lease_Doc_Reviewed__c = true;
        update newQuote;
         
        //Create Agreement
        echosign_dev1__SIGN_Agreement__c newAgreement1 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement1.Name = 'test agree1';
        newAgreement1.Quote__c = newQuote.Id;
        newAgreement1.Ready_to_send__c = true;
        insert newAgreement1;
    }
}