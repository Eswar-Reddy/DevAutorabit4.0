@isTest(SeeAllData = true)
private class QuoteAmendmentDeltaControllerTest {
    @isTest static void init() {
        // create amended quote
        Quote quoteA = TestFactory_StandardObjects.getProposalQuote();
        // update account
        for(Opportunity o : [SELECT AccountId FROM Opportunity WHERE Id = :quoteA.OpportunityId]) {
            quoteA.Account__c = o.AccountId;
        }
        quoteA.QuoteType__c = 'Lease';
        quoteA.Lease_Doc_Signed__c = true;
        update quoteA;
        // create quote
        Quote quoteT = new Quote();
        quoteT.Name = 'Test ' + System.now();
        quoteT.OpportunityId = quoteA.OpportunityId;
        quoteT.Account__c = quoteA.Account__c;
        quoteT.Amended_Lease__c = quoteA.Id;
        quoteT.QuoteType__c = 'Lease';
        quoteT.RecordTypeId = quoteA.RecordTypeId;
        insert quoteT;

        Test.startTest();
            Test.setCurrentPage(Page.QuoteAmendmentDelta);
            ApexPages.currentPage().getParameters().put('NewQuoteId', quoteT.Id);
            ApexPages.currentPage().getParameters().put('OldQuoteId', quoteA.Id);
            QuoteAmendmentDeltaController controller = new QuoteAmendmentDeltaController();
        Test.stopTest();
    }
}