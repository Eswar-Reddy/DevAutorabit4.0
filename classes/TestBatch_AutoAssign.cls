@IsTest
public with sharing class TestBatch_AutoAssign {
   
    static testMethod void testBatchAutoAssign() 
    {       
        
        Batch_AutoAssign b = new Batch_AutoAssign();
        
        Test.startTest();
        String query = 'select id, Name, AccountId, CampaignId, Dealer_Selection__c, OwnerId, Partner_Account_Id__c, Account.Geolocation__Latitude__s, Account.Geolocation__Longitude__s, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.Theater__c, RecordTypeId, Requires_Manual_Assignment__c, Lead_Manufacturer__c from Opportunity where IsAutoAssign__c = true LIMIT 1';
        List<Opportunity> listOpps = Database.query(query);
        
        Id batchProcessId = Database.executeBatch(b,1);
        b.execute(null, listOpps); //Strange but I needed this line to actually get coverage
        
        Test.stopTest();

    }
    
}