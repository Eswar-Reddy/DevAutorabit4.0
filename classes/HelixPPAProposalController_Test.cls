@isTest
private class HelixPPAProposalController_Test {
    private static Design__c ppaDesign;
    private static Quote ppaQuote;
    
    @isTest
    private static void test_basic_constructor() {
        Test.startTest();

        HelixPPAProposalController controller = new HelixPPAProposalController();

        Test.stopTest();
    }

    @isTest
    private static void test_save_proposal() {
        Test.startTest();

        HelixPPAProposalController.SaveProposalRequest request = new HelixPPAProposalController.SaveProposalRequest();

        HelixPPAProposalController.SaveProposalResponse response = HelixPPAProposalController.saveProposal(request);
        System.assertEquals(response.isSuccess, true, response);

        Test.stopTest();
    }

    @isTest
    private static void test_save_proposal_negative() {
        Test.startTest();

        HelixPPAProposalController.SaveProposalResponse response = HelixPPAProposalController.saveProposal(null);
        System.assertEquals(response.isSuccess, false, response);

        Test.stopTest();
    }

    @isTest
    private static void test_downloadTermSheet() {
        DocGen_Callout_Settings__c setting_1 = new DocGen_Callout_Settings__c(Name='DocGen', EndPoint_Contract__c='test');
        insert new List <DocGen_Callout_Settings__c>{setting_1};
        
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
        
        Test.setMock(HttpCalloutMock.class, new HelixPPATermSheetHttpCalloutMock());
        Test.startTest();

        HelixPPAProposalController.DownloadTermSheetRequest request = new HelixPPAProposalController.DownloadTermSheetRequest();
        request.quoteId = ppaQuote.Id;
        HelixPPAProposalController.DownloadTermSheetResponse response = HelixPPAProposalController.downloadTermSheet(request);
        
        system.assertEquals('', response.errorMessage);
        
        Test.stopTest();
    }

    @isTest
    private static void test_downloadProposal() {
        DocGen_Callout_Settings__c setting_1 = new DocGen_Callout_Settings__c(Name='DocGen', EndPoint_Contract__c='test');
        insert new List <DocGen_Callout_Settings__c>{setting_1};
        
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
        
        Test.setMock(HttpCalloutMock.class, new HelixPPAProposalHttpCalloutMock());
        Test.startTest();

        HelixPPAProposalController.DownloadProposalRequest request = new HelixPPAProposalController.DownloadProposalRequest();
        request.quoteId = ppaQuote.Id;
        HelixPPAProposalController.DownloadProposalResponse response = HelixPPAProposalController.downloadProposal(request);
        
        system.assertEquals('', response.errorMessage);
        
        Test.stopTest();
    }
    
}