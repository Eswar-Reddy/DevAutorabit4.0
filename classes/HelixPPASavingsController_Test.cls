@isTest
private class HelixPPASavingsController_Test {
    
    private static Design__c ppaDesign;
    private static Quote ppaQuote;
    private static Cost_Matrix__c costMatrix;
    private static Product2 product;

    @isTest 
    private static void test_basic_constructor() {
        Test.startTest();
            HelixPPASavingsController controller = new HelixPPASavingsController();
            System.assertNotEquals(null, controller.creditRatingPicklist);
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
            HelixPPASavingsController controller = new HelixPPASavingsController();

            System.assertNotEquals(null, controller.creditRatingPicklist);

        Test.stopTest();
    }
    
    @isTest static void test_fetch_utility() {
        Test.startTest();

        List<Utility_Code__c> codes = HelixPPASavingsController.fetchUtilityCodes(null);
        System.assert(codes.size() == 0);

        codes = HelixPPASavingsController.fetchUtilityCodes(SmartFactory.DefaultState);
        System.assert(codes.size() == 0);

        Utility_Code__c u = (Utility_Code__c)SmartFactory.createSObject('Utility_Code__c');
        u.State_Code__c = SmartFactory.DefaultState;
        insert u;

        codes = HelixPPASavingsController.fetchUtilityCodes(SmartFactory.DefaultState);
        System.assertEquals(codes.size(), 1);

        Test.stopTest();
    }
    
    @isTest static void test_calculateSavings() {
        costMatrix = TestFactory_Commercial.createCostMatrix(null);
        costMatrix.Technology_System_Category__c = 'Helix Carport';
        costMatrix.Available_Technology_Systems__c = 'P-Helix Carport V1.0';
        costMatrix.Active__c = true;
        insert costMatrix;
        
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assert(ppaDesign != null);
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');
    
        //set PPA Required fields
        TestFactory_Commercial.closeDesignRequest(ppaDesign,true);
        ppaDesign.HelixDesignType__c = 'Helix Carport';
        ppaDesign.Technology_System__c = 'P-Helix Carport V1.0';
        ppaDesign.ModuleTypeandWattage__c = 'SPR-E20-435-COM';
        update ppaDesign;
        System.assertEquals(ppaDesign.Status__c, TestFactory_Commercial.designCompleted, ppaDesign.Status__c);
        System.assertEquals(ppaDesign.Dealer_Status__c, TestFactory_Commercial.designDelivered, ppaDesign.Dealer_Status__c);
    
        Set<String> designIds = new Set<String>();
        designIds.add(ppaDesign.Id);
        ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
        System.assertNotEquals(ppaQuote.Id, null, 'PPA QUOTE FAILED TO INSERT');
        
        Loan_Callout_Settings__c setting_1 = new Loan_Callout_Settings__c(Name='FinEng', Username__c='un_1', Password__c='pw_1',
            Endpoint_URL__c='url_1', Client_Secret__c='secret_1');
        insert new List <Loan_Callout_Settings__c>{setting_1};
        
        product = TestFactory_Commercial.createProduct();
        Opportunity oppty_1 = [SELECT Id, Installation_Date__c FROM Opportunity WHERE Id = :ppaQuote.OpportunityId]; 
        integer q = (Math.floor(((oppty_1.Installation_Date__c.Month()-1)/3)+1)).intValue(); 
        String quarter = 'Q' + String.valueOf(q);
        String year = String.valueOf(oppty_1.Installation_Date__c).left(4).right(2);
        product.CurrencyISOCode = 'USD';
        product.Family = 'PV Module';
        product.Name = quarter + year + '-SPR-E20-435-COM';
        insert product;

        Test.setMock(HttpCalloutMock.class, new HelixPPAFinEngHttpCalloutMock());
        Test.startTest();
        
        HelixPPASavingsController.CalculateSavingsRequest request = new HelixPPASavingsController.CalculateSavingsRequest();
        request.quoteId = ppaQuote.Id;
        request.designIdList = new List <String>{ppaDesign.Id};
        request.finEngRequest = new HelixPPAFinEng.Request();
        HelixPPAFinEng.Batch batch_1 = new HelixPPAFinEng.Batch('1');
        batch_1.inputCommand = new HelixPPAFinEng.InputCommand('inputCommand_1');
        batch_1.outputCommand = new HelixPPAFinEng.OutputCommand('outputCommand_1');
        
        request.finEngRequest.batches = new List <HelixPPAFinEng.Batch>{batch_1};
        
        HelixPPASavingsController.CalculateSavingsResponse response = HelixPPASavingsController.calculateSavings(request);
    
        Test.stopTest();
    }

    @isTest static void test_viewProposal() {
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assert(ppaDesign != null);
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');
    
        Set<String> designIds = new Set<String>();
        designIds.add(ppaDesign.Id);
        ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
        System.assertNotEquals(ppaQuote.Id, null, 'PPA QUOTE FAILED TO INSERT');

        Test.startTest();
        
        HelixPPAUtil.SavePPARequest request = new HelixPPAUtil.SavePPARequest();
        request.quote = ppaQuote;
        HelixPPAUtil.SavePPAResponse response = HelixPPASavingsController.viewProposal(request);
        system.assertEquals(true, response.isSuccess);
        
        Test.stopTest();
    }

    @isTest static void test_viewDesign() {
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        System.assert(ppaDesign != null);
        System.assertNotEquals(ppaDesign.Opportunity__c, null, 'NO Opportunity found on this design');
        System.assertNotEquals(ppaDesign.Site__c, null, 'NO Site found on this design');
    
        Set<String> designIds = new Set<String>();
        designIds.add(ppaDesign.Id);
        ppaQuote = TestFactory_Commercial.createPPAQuoteWithJunctions(designIds, ppaDesign.Opportunity__c);
        System.assertNotEquals(ppaQuote.Id, null, 'PPA QUOTE FAILED TO INSERT');

        Test.startTest();
        
        HelixPPAUtil.SavePPARequest request = new HelixPPAUtil.SavePPARequest();
        request.quote = ppaQuote;
        HelixPPAUtil.SavePPAResponse response = HelixPPASavingsController.viewDesign(request);
        system.assertEquals(true, response.isSuccess);
        
        Test.stopTest();
    }

    @isTest static void test_calculateSavings_request_null() {
        Test.setMock(HttpCalloutMock.class, new HelixPPAFinEngHttpCalloutMock());
        Test.startTest();
        
        HelixPPASavingsController.CalculateSavingsRequest request;
        HelixPPASavingsController.CalculateSavingsResponse response = HelixPPASavingsController.calculateSavings(request);
        system.assertEquals(false, response.isSuccess);
    
        Test.stopTest();
    }

    @isTest static void test_calculateSavings_quoteId_null() {
        Test.setMock(HttpCalloutMock.class, new HelixPPAFinEngHttpCalloutMock());
        Test.startTest();
        
        HelixPPASavingsController.CalculateSavingsRequest request = new HelixPPASavingsController.CalculateSavingsRequest();
        request.quoteId = null;
        HelixPPASavingsController.CalculateSavingsResponse response = HelixPPASavingsController.calculateSavings(request);
        system.assertEquals(false, response.isSuccess);
    
        Test.stopTest();
    }
    
}