@isTest(SeeAllData = false)
public class cancelAmendmentControllerTest {

  @isTest public static void init() {
     
    // insert custom setting for the agreement creation
    Lease_2_1_PO_Creation__c LeasePOCreation = TestFactory_Custom_Settings.createLease21POCreation();
    insert LeasePOCreation;
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
     agreement.echosign_dev1__More_Recipients__c = 'someone@email.com';
     agreement.Notes__c = 'Running in Test Class';
     insert agreement;

     Test.startTest();
      Test.setCurrentPage(Page.cancelAmendment);
      ApexPages.StandardController stdController = new ApexPages.StandardController(agreement);
      CancelAmendmentController controller = new CancelAmendmentController(stdController);
      controller.comment = 'Test Comment from Test Class';
      controller.back();
      controller.cancelAmendment();
      controller.reportError();
     Test.stopTest();
   }

 }