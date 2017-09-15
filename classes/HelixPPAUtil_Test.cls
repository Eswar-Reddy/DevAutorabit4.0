@isTest
public class HelixPPAUtil_Test {
    private static Design__c ppaDesign;
    private static Quote ppaQuote;
    public static Annual_Financial__c annualFinancial;
    
    @isTest static void test_savePPA() {
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
        
        annualFinancial = TestFactory_Commercial.getAnnualFinancial(ppaQuote.Id);
        
        HelixPPAUtil.SavePPARequest request = new HelixPPAUtil.SavePPARequest();
        request.quote = ppaQuote;
        request.ExpirationDate = String.valueOf(system.today());
        request.annualFinancialList = new List <Annual_Financial__c>{annualFinancial};
        HelixPPAUtil.SavePPAResponse response = HelixPPAUtil.savePPA(request);
    }

    @isTest static void test_sendDesignValidationEmail() {
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        HelixPPAUtil.EmailResponse response = HelixPPAUtil.sendDesignValidationEmail(new List <Design__c>{ppaDesign});
    }

    @isTest static void test_sendProductionDataValidationEmail() {
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        HelixPPAUtil.EmailResponse response = HelixPPAUtil.sendProductionDataValidationEmail(new List <Design__c>{ppaDesign});
    }

    @isTest static void test_sendMissingDataValidationEmail() {
        ppaDesign = TestFactory_Commercial.createDesignRequest(null, null);
        HelixPPAUtil.EmailResponse response = HelixPPAUtil.sendMissingDataValidationEmail(new Set<Design__c>{ppaDesign});
    }
    
}