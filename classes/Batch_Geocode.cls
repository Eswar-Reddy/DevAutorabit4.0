global class Batch_Geocode implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global final String query;
    global final String runType;
    
    global Batch_Geocode(String batchType) {
        runType = batchType;
        if(batchType.equals('Account')) {
            query = 'SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account where IsAddressUpdated__c = true limit 1';
        } 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        if (runType == 'Account')
        {
            for (Account a : (List<Account>)scope) {
             
                String cleanAddress = GeocodeAsyncHandler.cleanAddress(
                    a.BillingStreet, a.BillingCity, a.BillingState, a.BillingPostalCode, a.BillingCountry);
                
                GeocodeAsyncHandler.GeoCode(cleanAddress, a.Id, 'Geolocation__c');
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()];
   
            if (a.TotalJobItems > 0)
            {
                Batch_Geocode startGeocoding = new Batch_Geocode('Account');
                Database.executeBatch(startGeocoding,1); //MAM 07/10/2014 Quick fix for  Case 00373602
            }
        
    }
}