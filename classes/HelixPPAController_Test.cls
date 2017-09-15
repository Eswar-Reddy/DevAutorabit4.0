@isTest
private class HelixPPAController_Test {
	
	private static Design__c ppaDesign {get;set;}
	
	@isTest 
	private static void test_basic_constructor() {
		
		ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
		System.assert(ppaDesign != null);
		System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
		System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

		//set PPA Required fields
		TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
		update ppaDesign;
		System.assertEquals(ppaDesign.Status__c, 'Completed', ppaDesign.Status__c);
		System.assertEquals(ppaDesign.Dealer_Status__c, 'Design Delivered', ppaDesign.Dealer_Status__c);
		
		Test.startTest();

			//init constructor		
			PageReference pageRef = Page.HelixPPA;
            Test.setCurrentPage(pageRef);
      		ApexPages.currentPage().getParameters().put('opportunityId', ppaDesign.Opportunity__c);

      		ApexPages.StandardController sc = new ApexPages.StandardController(new Quote());
            HelixPPAController controller = new HelixPPAController(sc);

            System.assertNotEquals(null, controller.opportunity.Id);

            String quarter = controller.quarter;
            System.assertNotEquals(null, quarter);

		Test.stopTest();
	}
	
	@isTest 
	private static void test_closeDesign() {
		ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
		System.assert(ppaDesign != null);
		System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
		System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

		//set PPA Required fields
		TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
		update ppaDesign;
		System.assertEquals(ppaDesign.Status__c, 'Completed', ppaDesign.Status__c);
		System.assertEquals(ppaDesign.Dealer_Status__c, 'Design Delivered', ppaDesign.Dealer_Status__c);
		
		Test.startTest();

			//init constructor		
			PageReference pageRef = Page.HelixPPA;
            Test.setCurrentPage(pageRef);
      		ApexPages.currentPage().getParameters().put('opportunityId', ppaDesign.Opportunity__c);

      		ApexPages.StandardController sc = new ApexPages.StandardController(new Quote());
            HelixPPAController controller = new HelixPPAController(sc);

            PageReference oppPageRef = controller.closeDesign();
            System.assertNotEquals(null, oppPageRef);
            System.assertNotEquals(null, oppPageRef.getParameters());

		Test.stopTest();
	}
	
}