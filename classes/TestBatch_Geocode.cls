@IsTest
public with sharing class TestBatch_Geocode {

    static testMethod void testBatchGeoCode() 
    {       
        Account a = TestClassFactory.testAccount('TestAccountGeo', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        a.BillingCountry = 'United States';
        a.IsAddressUpdated__c = true;
        insert a;
        
        Batch_GeoCode b = new Batch_GeoCode('Account');
        
        Test.startTest();
        String query = 'SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account where IsAddressUpdated__c = true limit 1';
        List<Account> listAccounts = Database.query(query);
        
        Id batchProcessId = Database.executeBatch(b,1);
        b.execute(null, listAccounts); //Strange but I needed this line to actually get coverage
        
        Test.stopTest();

    }
    
}