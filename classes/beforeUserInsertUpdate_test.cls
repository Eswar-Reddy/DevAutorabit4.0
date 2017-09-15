@isTest
private class beforeUserInsertUpdate_test{       
    static testmethod void createPartnerUser() {
        User pu = TestUtils.createLeasePartnerInfo();        
    }   
/*    static testmethod void createInvalidBelgiumPartnerUser1() {
        User pu = TestUtils.createLeasePartnerInfo();
        
        pu.country_domain__c = 'combo-be';
        
        pu.languagelocalekey = 'es';
        pu.localesidkey = 'es';
        
        test.startTest();
        update pu;
        test.stopTest();
        
        System.assertNotEquals(pu.languagelocalekey, 'es', 'Portal User\'s language is incorrect.  Please check Account Country Domain custom setting entry for combo-be.');
        System.assertNotEquals(pu.localesidkey, 'es', 'Portal User\'s locale is incorrect.  Please check Account Country Domain custom setting entry for combo-be.');
    }*/   
}