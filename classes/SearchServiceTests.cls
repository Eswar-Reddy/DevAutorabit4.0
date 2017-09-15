@isTest
private class SearchServiceTests {
    private static Account customer;
    private static Account customer1;
    private static Account customer2;
    private static Account customer3;
    
    testMethod static void testFindRecords() {
        setUp();
        
        SearchService target = new SearchService();
        Map <String, String> filters = new Map <String, String>{'State' => 'CA'};
        /*
        target.findRecords(new Set<String>{customer.ShippingPostalCode}, filters, null);
        target.findRecords(new Set<String>{customer.ShippingPostalCode}, filters, 'Home');
        target.findRecords(new Set<String>{customer.ShippingPostalCode}, filters, 'Commercial');
        target.findRecords(new Set<String>{customer.ShippingPostalCode}, filters, 'Both');
        */
    }
    
    private static void setUp() {
        List<Account> AccList = new List<Account>();
        customer = new Account(Name='Testaccservice',ShippingPostalCode='94306');
        customer.BillingCountry='Test1';
        customer.BillingState='Test2';
        customer.BillingCity='Test3';
        customer.BillingStreet='Test4';
        customer.BillingPostalCode='1234';
        customer.ShippingCountry='Test1';
        customer.ShippingState='Test2';
        customer.ShippingCity='Test3';
        customer.ShippingStreet='Test4';
        AccList.add(customer);
        
        customer1 = new Account(Name='Testaccservice1',ShippingPostalCode='94306');
        customer1.BillingCountry='Test1';
        customer1.BillingState='Test2';
        customer1.BillingCity='Test3';
        customer1.BillingStreet='Test4';
        customer1.BillingPostalCode='1234';
        customer1.Type='Authorized-Partner-Combo';
        customer1.ShippingCountry='Test1';
        customer1.ShippingState='Test2';
        customer1.ShippingCity='Test3';
        customer1.ShippingStreet='Test4';
        AccList.add(customer1);
        
        customer2 = new Account(Name='Testaccservice2',ShippingPostalCode='94306');
        customer2.BillingCountry='Test1';
        customer2.BillingState='Test2';
        customer2.BillingCity='Test3';
        customer2.BillingStreet='Test4';
        customer2.BillingPostalCode='1234';
        customer2.Type='Authorized-Partner-Residential';
        customer2.ShippingCountry='Test1';
        customer2.ShippingState='Test2';
        customer2.ShippingCity='Test3';
        customer2.ShippingStreet='Test4';
        AccList.add(customer2);
        
        customer3 = new Account(Name='Testaccservice3',ShippingPostalCode='94306');
        customer3.BillingCountry='Test1';
        customer3.BillingState='Test2';
        customer3.BillingCity='Test3';
        customer3.BillingStreet='Test4';
        customer3.BillingPostalCode='1234';
        customer3.Type='Partner-Commercial';
        customer3.ShippingCountry='Test1';
        customer3.ShippingState='Test2';
        customer3.ShippingCity='Test3';
        customer3.ShippingStreet='Test4';
        AccList.add(customer3);
        
        insert AccList;
    }
}