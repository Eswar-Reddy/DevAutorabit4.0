@isTest
private class DealerLocatorControllerTests {
    private static Account customer;
    private static Location__c baseLocation;
    
    testMethod static void testOnSearch() {
        setUp();
        
        DealerLocatorController target = new DealerLocatorController();
        target.radius = 5;
        target.baseLocation = '94306';
        target.accType = 'Home';
        target.onSearch();
    }
    
    private static void setUp() {
        customer = new Account(Name='DealerLocatorTest',ShippingPostalCode='94306');
        customer.BillingCountry='Test1';
        customer.BillingState='Test2';
        customer.BillingCity='Test3';
        customer.BillingStreet='Test4';
        customer.BillingPostalCode='1234';
        customer.ShippingCountry='Test1';
        customer.ShippingState='Test2';
        customer.ShippingCity='Test3';
        customer.ShippingStreet='Test4';
        customer.ShippingPostalCode='1234';
        insert customer;
        
        baseLocation = new Location__c(Name='94306101',Latitude__c=37.418009,Longitude__c=-122.127375);
        insert baseLocation;
    }
}