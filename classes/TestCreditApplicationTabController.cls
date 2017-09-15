@isTest
private class TestCreditApplicationTabController {
    @isTest
    public static void testClass() {
        User user = [select id from User where Profile.Name = 'EU Partner Executive' and isActive = true and Contact.Country_Domain__c like '%fr' Limit 1];
        
        Test.setCurrentPage(Page.CreditApplicationTab);
        CreditApplicationTabController controller = new CreditApplicationTabController();
        controller.redirectInternalUser();
        controller.newCreApp();
        
        System.runAs(user){
        	controller = new CreditApplicationTabController();
        }
    }
}