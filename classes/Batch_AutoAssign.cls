global class Batch_AutoAssign implements Database.Batchable<sObject>, Database.AllowsCallouts {
  
  global final String query;

  global Batch_AutoAssign() {
			system.debug('@@@@@Batch_AutoAssign;');
			
		     query = 'select id, Name, AccountId, CampaignId, Dealer_Selection__c, OwnerId, Partner_Account_Id__c, Account.Geolocation__Latitude__s, Account.Geolocation__Longitude__s, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.Theater__c, RecordTypeId, Requires_Manual_Assignment__c, Lead_Manufacturer__c from Opportunity where IsAutoAssign__c = true LIMIT 1';
			
			system.debug('@@@@@Batch_AutoAssign query: '+query);
  }  

/*
  global Batch_AutoAssign(Id OpportunityId) {
			system.debug('@@@@@Batch_AutoAssign Id: '+OpportunityId);
			
		     query = 'select id, Name, AccountId, CampaignId, Dealer_Selection__c, OwnerId, Partner_Account_Id__c, Account.Geolocation__Latitude__s, Account.Geolocation__Longitude__s, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.Theater__c, RecordTypeId, Requires_Manual_Assignment__c from Opportunity where id = \'' + OpportunityId + '\' LIMIT 1';
			
			system.debug('@@@@@Batch_AutoAssign query: '+query);
  }  
*/  
  global Database.QueryLocator start(Database.BatchableContext BC){
    return Database.getQueryLocator(query);
  } 
      
  global void execute(Database.BatchableContext BC, List<sObject> scope) {
   	 
	     	for (Opportunity o : (List<Opportunity>)scope) {
				if (o.Account.Geolocation__Latitude__s == null ) {
					system.debug('@@@@@Batch_AutoAssign; The Latitude on the Account of the Opportunity was null so GeoCoding');
					String cleanAddress = GeocodeAsyncHandler.cleanAddress(o.Account.BillingStreet, o.Account.BillingCity, o.Account.BillingState, o.Account.BillingPostalCode, o.Account.BillingCountry);
					system.debug('@@@@@Batch_AutoAssign; Address cleaned: ' + cleanAddress + '; Raw: ' + o.Account.BillingStreet + ', ' + o.Account.BillingCity + ', ' + o.Account.BillingState + ', ' + o.Account.BillingPostalCode + ', ' + o.Account.BillingCountry);
					
					GeocodeAsyncHandler.GeoCode(cleanAddress, o.AccountId, 'Geolocation__c');
					system.debug('@@@@@Batch_AutoAssign; GeoCode complete');
				}
				
				system.debug('@@@@@Batch_AutoAssign; AutoAssign');
				if (o.Lead_Manufacturer__c == 'SunPower')  DealerUtility.AutoAssign(o.id); 
				
	     	} 

   }
  
  global void finish(Database.BatchableContext BC) {

	    //Is the ALR process active?
	    DealerGeneral__c dg = DealerGeneral__c.getInstance();
	    if (dg.Enable_ALR_Process__c == false) return;
    
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
      					  FROM AsyncApexJob WHERE Id = :BC.getJobId()];
   
	        if (a.TotalJobItems > 0)
	        {
	            Batch_AutoAssign startBatch = new Batch_AutoAssign();
				Database.executeBatch(startBatch);
	        }        	
   }
   


}