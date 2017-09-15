@isTest(SeeAllData = true)
private class QuoteAmendmentControllerTest {

	@isTest static void init() {
		// create quote
		Quote quoteT = TestFactory_StandardObjects.getProposalQuote();
		// update account
		for(Opportunity o : [SELECT AccountId FROM Opportunity WHERE Id = :quoteT.OpportunityId]) {
			quoteT.Account__c = o.AccountId;
		}
		update quoteT;
		// create agreement
		echosign_dev1__SIGN_Agreement__c agreement = TestFactory_Ordering.createAgreement(quoteT);
		agreement.Account__c = quoteT.Account__c;
		agreement.Change_Order_Type__c = 'Economic Amendment';
		agreement.RecordTypeId = AgreementUtility.amendmentRecTypeId;
		insert agreement;

		Test.startTest();
			Test.setCurrentPage(Page.QuoteAmendment);
			ApexPages.currentPage().getParameters().put('QuoteId', quoteT.Id);
			ApexPages.currentPage().getParameters().put('AgreementId', agreement.Id);
			QuoteAmendmentController controller = new QuoteAmendmentController();
			controller.init();
			controller.viewAmendment();
			controller.back();
			controller.requestHelp();
			controller.reportError();
		Test.stopTest();
	}

	@isTest static void pendingAgreement() {
		// create quote
		Quote quoteT = TestFactory_StandardObjects.getProposalQuote();
		// update account
		for(Opportunity o : [SELECT AccountId FROM Opportunity WHERE Id = :quoteT.OpportunityId]) {
			quoteT.Account__c = o.AccountId;
		}
		quoteT.Lease_Doc_Signed__c = true;
		update quoteT;
		// create agreement
		echosign_dev1__SIGN_Agreement__c agreement = TestFactory_Ordering.createAgreement(quoteT);
		agreement.Account__c = quoteT.Account__c;
		agreement.Quote__c = quoteT.Id;
		agreement.Change_Order_Type__c = 'Economic Amendment';
		agreement.RecordTypeId = AgreementUtility.amendmentRecTypeId;
		insert agreement;
		agreement.Name = 'Amendment';
		agreement.Agreement_Name__c = 'Amendment';
		update agreement;
		// create second quote
		Quote quote2 = new Quote();
		quote2.Name = 'Test ' + System.now();
		quote2.OpportunityId = quoteT.OpportunityId;
		quote2.Account__c = quoteT.Account__c;
		quote2.Amended_Lease__c = quoteT.Id;
		quote2.RecordTypeId = quoteT.RecordTypeId;
		insert quote2;
		// create second agreement
		echosign_dev1__SIGN_Agreement__c agreement2 = TestFactory_Ordering.createAgreement(quote2);
		agreement2.Account__c = quote2.Account__c;
		agreement2.Quote__c = quote2.Id;
		agreement2.Change_Order_Type__c = 'Economic Amendment';
		agreement2.RecordTypeId = AgreementUtility.amendmentRecTypeId;
		insert agreement2;
		agreement2.Name = 'Amendment 2';
		agreement2.Agreement_Name__c = 'Amendment 2';
		update agreement2;

		Test.startTest();
			Test.setCurrentPage(Page.QuoteAmendment);
			ApexPages.currentPage().getParameters().put('QuoteId', quoteT.Id);
			ApexPages.currentPage().getParameters().put('AgreementId', agreement.Id);
			QuoteAmendmentController controller = new QuoteAmendmentController();
			controller.init();
			agreement2.echosign_dev1__Status__c = 'Signed';
			update agreement2;
		Test.stopTest();
	}

	@isTest static void placedInService() {
		// create quote
		Quote quoteT = TestFactory_StandardObjects.getProposalQuote();
		// update account
		for(Opportunity o : [SELECT AccountId FROM Opportunity WHERE Id = :quoteT.OpportunityId]) {
			quoteT.Account__c = o.AccountId;
		}
		quoteT.QuoteType__c = 'Lease';
		quoteT.Is_Locked__c = true;
		quoteT.Sector__c = 'Residential';
		update quoteT;
		// create agreement
		echosign_dev1__SIGN_Agreement__c agreement = TestFactory_Ordering.createAgreement(quoteT);
		agreement.Account__c = quoteT.Account__c;
		agreement.Change_Order_Type__c = 'Economic Amendment';
		agreement.RecordTypeId = AgreementUtility.amendmentRecTypeId;
		insert agreement;
		agreement.echosign_dev1__DateSigned__c = System.now();
		update agreement;
		// update fpo
		for(LeasePayment__c fpo : [SELECT Placed_In_Service__c FROM LeasePayment__c WHERE Account__c = :quoteT.Account__c]) {
			fpo.Placed_In_Service__c = System.today();
			update fpo;
		}
		Test.startTest();
			Test.setCurrentPage(Page.QuoteAmendment);
			ApexPages.currentPage().getParameters().put('QuoteId', quoteT.Id);
			ApexPages.currentPage().getParameters().put('AgreementId', agreement.Id);
			QuoteAmendmentController controller = new QuoteAmendmentController();
			controller.init();
		Test.stopTest();
	}
}