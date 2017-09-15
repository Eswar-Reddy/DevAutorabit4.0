@isTest(SeeAllData = true)
private class AgreementReviewRequestControllerTest {

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
        // create agreement
        echosign_dev1__SIGN_Agreement__c agreement = TestFactory_Ordering.createAgreement(quoteT);
        agreement.Account__c = quoteT.Account__c;
        agreement.Change_Order_Type__c = 'Economic Amendment';
        agreement.RecordTypeId = AgreementUtility.amendmentRecTypeId;
        insert agreement;

        Test.startTest();
            Test.setCurrentPage(Page.AgreementReviewRequest);
            ApexPages.currentPage().getParameters().put('AgreementId', agreement.Id);
            AgreementReviewRequestController controller = new AgreementReviewRequestController();
            controller.back();
            controller.requestHelp();
            controller.reportError();
        Test.stopTest();
    }
}