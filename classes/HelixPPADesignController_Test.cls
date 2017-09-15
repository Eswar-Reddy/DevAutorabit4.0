@isTest
private class HelixPPADesignController_Test {
    
    private static Design__c ppaDesign {get;set;}
    private static Quote ppaQuote {get;set;}

    @isTest 
    private static void test_basic_constructor() {
        
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assert(ppaDesign != null);
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designCompleted, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designDelivered, ppaDesign.Dealer_Status__c);
        
        Test.startTest();

            //init constructor      
            PageReference pageRef = Page.HelixPPA;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('opportunityId', ppaDesign.Opportunity__c);

            HelixPPADesignController controller = new HelixPPADesignController();

            System.assertNotEquals(null, controller.opportunity.Id);

            System.assertEquals(controller.hasErrorMessages, false);
            System.assert(String.isBlank(controller.errorMsg));

            System.assertNotEquals(null, controller.quoteWrpr.sizeKW);
            System.assertNotEquals(null, controller.quoteWrpr.production);
            System.assertNotEquals(null, controller.quoteWrpr.utilityBillPostSolar);
            System.assertNotEquals(null, controller.quoteWrpr.year1NetSavings);
            System.assertNotEquals(null, controller.quoteWrpr.sumNetSavings);
            System.assertNotEquals(null, controller.quoteWrpr.npvOfSavings);

        Test.stopTest();
    }

    @isTest 
    private static void test_basic_constructor_withQuote() {
        
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assert(ppaDesign != null);
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designCompleted, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designDelivered, ppaDesign.Dealer_Status__c);

        Set<String> designIds = new Set<String>();
        designIds.add(ppaDesign.Id);
        ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
        System.assertNotEquals(ppaQuote.Id, null, 'PPA QUOTE FAILED TO INSERT');
        
        Test.startTest();

            //init constructor      
            PageReference pageRef = Page.HelixPPA;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('quoteId', ppaQuote.Id);
            ApexPages.currentPage().getParameters().put('opportunityId', ppaDesign.Opportunity__c);
            HelixPPADesignController controller = new HelixPPADesignController();

            System.assertNotEquals(null, controller.quoteWrpr.quote.Id);

        Test.stopTest();
    }
    
    @isTest static void test_updateDesign() {
        // SaveDesignRequest
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assertNotEquals(ppaDesign.Id, null, 'Design ID is null');
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designCompleted, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designDelivered, ppaDesign.Dealer_Status__c);
        
        Test.startTest();

            //null request
            HelixPPADesignController.SaveDesignResponse response1 = HelixPPADesignController.updateDesign(null);
            System.assert(String.isNotBlank(response1.errorMessage));

            //null design
            HelixPPADesignController.SaveDesignRequest request1 = new HelixPPADesignController.SaveDesignRequest();
            HelixPPADesignController.SaveDesignResponse response2 = HelixPPADesignController.updateDesign(request1);
            System.assert(String.isNotBlank(response2.errorMessage));

            //invalid design id
            HelixPPADesignController.SaveDesignRequest request2 = new HelixPPADesignController.SaveDesignRequest();
            request2.design = new Design__c();
            HelixPPADesignController.SaveDesignResponse response3 = HelixPPADesignController.updateDesign(request2);
            System.assert(String.isNotBlank(response3.errorMessage));

            //valid request
            HelixPPADesignController.SaveDesignRequest request3 = new HelixPPADesignController.SaveDesignRequest();
            request3.design = ppaDesign;
            request3.quote = TestFactory_Commercial.getPPAQuote(ppaDesign.Opportunity__c);

            HelixPPADesignController.SaveDesignResponse response4 = HelixPPADesignController.updateDesign(request3);
            System.assertEquals(true, response4.isSuccess, response4.errorMessage);
            System.assert(String.isBlank(response4.errorMessage), response4.errorMessage);

        Test.stopTest();
    }

    @isTest static void test_viewSavings() {
        // SaveDesignRequest
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assertNotEquals(ppaDesign.Id, null, 'Design ID is null');
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignExport(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designExported, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designExported, ppaDesign.Dealer_Status__c);
        
        Test.startTest();

            Set<String> designIds = new Set<String>();
            designIds.add(ppaDesign.Id);
            ppaQuote = TestFactory_Commercial.createPPAQuote(ppaDesign.Opportunity__c); //createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
            HelixPPADesignController.ViewSavingsRequest request1 = new HelixPPADesignController.ViewSavingsRequest();
            request1.quote = ppaQuote;
            request1.designIdList = new List<String>();
            request1.designIdList.addAll(designIds);
            HelixPPADesignController.ViewSavingsResponse response1 = HelixPPADesignController.viewSavings(request1);
            System.assertEquals(response1.isSuccess, true, response1);
            System.assert(String.isBlank(response1.errorMessage), response1.errorMessage);


        Test.stopTest();
    }

    @isTest static void test_viewSavings_Update() {
        // SaveDesignRequest
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assertNotEquals(ppaDesign.Id, null, 'Design ID is null');
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignExport(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designExported, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designExported, ppaDesign.Dealer_Status__c);
        
        Test.startTest();

            Set<String> designIds = new Set<String>();
            designIds.add(ppaDesign.Id);
            ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
            HelixPPADesignController.ViewSavingsRequest request1 = new HelixPPADesignController.ViewSavingsRequest();
            request1.quote = ppaQuote;
            request1.designIdList = new List<String>();
            request1.designIdList.addAll(designIds);
            HelixPPADesignController.ViewSavingsResponse response1 = HelixPPADesignController.viewSavings(request1);
            System.assertEquals(response1.isSuccess, true, response1);
            System.assert(String.isBlank(response1.errorMessage), response1.errorMessage);


        Test.stopTest();
    }

    @isTest static void test_viewSavings_NegativeTest() {
        // SaveDesignRequest
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assertNotEquals(ppaDesign.Id, null, 'Design ID is null');
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');

        //set PPA Required fields
        TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designCompleted, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designDelivered, ppaDesign.Dealer_Status__c);
        
        Test.startTest();
        
            //null request
            HelixPPADesignController.ViewSavingsResponse response1 = HelixPPADesignController.viewSavings(null);
            System.assertEquals(response1.isSuccess, false, response1);

            //null quote
            HelixPPADesignController.ViewSavingsRequest request1 = new HelixPPADesignController.ViewSavingsRequest();
            HelixPPADesignController.ViewSavingsResponse response2 = HelixPPADesignController.viewSavings(request1);
            System.assertEquals(response2.isSuccess, false, response2);

            //no designs selected
            HelixPPADesignController.ViewSavingsRequest request2 = new HelixPPADesignController.ViewSavingsRequest();
            request2.quote = new Quote();
            HelixPPADesignController.ViewSavingsResponse response3 = HelixPPADesignController.viewSavings(request2);
            System.assertEquals(response3.isSuccess, false, response3);
        
            //w/quote and design    
            Set<String> designIds = new Set<String>();
            designIds.add(ppaDesign.Id);
            ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
            HelixPPADesignController.ViewSavingsRequest request3 = new HelixPPADesignController.ViewSavingsRequest();
            request3.quote = ppaQuote;
            request3.designIdList = new List<String>();
            request3.designIdList.addAll(designIds);
            HelixPPADesignController.ViewSavingsResponse response4 = HelixPPADesignController.viewSavings(request3);
            System.assertEquals(response4.isSuccess, false, response4);

        Test.stopTest();
    }
    
}