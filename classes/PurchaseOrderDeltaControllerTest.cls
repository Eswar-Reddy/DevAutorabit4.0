@isTest(SeeAllData = true)
private class PurchaseOrderDeltaControllerTest {

	@isTest static void init() {
		Quote quoteA = TestFactory_StandardObjects.getProposalQuote();

		Purchase_Order__c po1 = TestFactory_Ordering.createPurchaseOrder();
		po1.Quote__c = quoteA.Id;
		po1.Order_Status__c = 'Processed';
		insert po1;

		Purchase_Order_Line__c po1line = TestFactory_Ordering.createPurchaseOrderLine();
		po1line.Purchase_Order__c = po1.Id;
		insert po1line;

		Purchase_Order__c po2 = TestFactory_Ordering.createPurchaseOrder();
		insert po2;

		Purchase_Order_Line__c po12ine = TestFactory_Ordering.createPurchaseOrderLine();
		po12ine.Purchase_Order__c = po2.Id;
		insert po12ine;

		Test.startTest();
			Test.setCurrentPage(Page.PurchaseOrderDelta);
			ApexPages.currentPage().getParameters().put('newPOId', po2.Id);
            ApexPages.currentPage().getParameters().put('oldPOId', po1.Id);
            PurchaseOrderDeltaController controller = new PurchaseOrderDeltaController();
            String s = PurchaseOrderUtility.getPODeltaURL(po2.Id, quoteA.Id);
		Test.stopTest();
	}
}