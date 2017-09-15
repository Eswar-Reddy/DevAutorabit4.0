//Test Class for code coverage of RMAAfterInsert Trigger
@isTest
private class RMAAfterInsertTriggerTest{

    static testmethod void testrmainsert1(){
    
            Account accAccount = new Account(Name = 'testrmainsert1TestClass',
            Phone = '4567865999',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Status__c = 'Active');
        insert accAccount;
        
        
        Case case1 = new Case(
            AccountId=accAccount.Id
        );
        insert case1;
        
        
        RMA__c rma1 = new RMA__c(
            Case__c=case1.Id, Attention_To_Email__c = 'testxyz@testspwr.com'  
        );
        insert rma1;
    }
    
}