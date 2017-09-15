@isTest
private class DealerLocator2ControllerTest {
    
    testMethod static void testOnSearch() {
        
        DealerLocator2Controller target = new DealerLocator2Controller();
        target.doGetDealers();
        target.doGetAllDealers();
        target.doCreateTestLead();
    }
}