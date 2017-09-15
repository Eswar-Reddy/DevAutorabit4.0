public without sharing class AccountUtilities {
		// -------- Constants --------
	// None
		
	// -------- Constructor --------
   // None

    // -------- Variables --------
	// None
	//@TestVisible
	//private static Map<Id,Boolean> isChangedMap {get;set;}
	//// -------- Properties --------
	//public static Boolean isIntegrationRunning {get;set;}
	
	// -------- Methods --------
	// Qualify records; partnerAccountToOpportunity stores the one to many relationship for opps belonging 
	// to partner accounts; which is used to build the qualifiedSpectrumSync
	
	// Load accounts base don various criteria - MOVE TO ACCOUNT UTILITIES WHEN GH STARTS
	//private static Map<ID, Account> loadPartnerAccounts(Set<ID> accountIDs)
	//{
	//	Map<ID, Account> result = new Map<ID, Account>();
		
	//	try
	//	{
	//		result = new Map<ID, Account>([SELECT ID, isSpectrumPartner__c FROM Account WHERE ID IN: accountIDs]);
	//	}
	//	catch(QueryException error)
	//	{
	//		SunPowerException.recordError('OpportunityUtilities', 'loadPartnerAccounts', error);
	//	}
		
	//	return result;
	//}
	
	// The following will be moved to the after update handlers
	//public static void qualifySpectrumRecordsAfterUpdate(Map<ID, Account> newMap, Map<ID, Account> oldMap)
	//{
	//	if(isIntegrationRunning != null && isIntegrationRunning == true)
	//		return;
	//	SpectrumJSONServices checkChangedSpectrumData = new SpectrumJSONServices();
		
	//	Set<Id> partnerIds = new Set<Id>();
		
	//	for(Account a: newMap.values()){
	//		if(a.Partner_Account__c != null)
	//			partnerIds.add(a.Partner_Account__c);
	//	}
		
	//	Map<Id,Account> partnerAccountMap = loadPartnerAccounts(partnerIds);
		
	//	//QUALIFY THAT THERE IS AN OPPORTUNITY
	//	Map<Id,Id> accountsWithOpportunities = new Map<Id,Id>();
		
	//	for(Opportunity o : [SELECT Id,AccountId FROM Opportunity WHERE AccountId IN :newMap.keySet()]){
	//		accountsWithOpportunities.put(o.AccountId,o.Id);
	//	}
		
	//	System.debug('partnerAccountMap:' + partnerAccountMap);
		
	//	System.debug('accountsWithOpportunities:' + accountsWithOpportunities);
		
	//	System.debug('accounts:' + newMap.values());
		
	//	//STORE OPP IDS THAT NEED TO BE UPDATED
	//	isChangedMap = new Map<Id,Boolean>();
	//	Set<Id> opportunitySyncIds = new Set<Id>();
	//	for(Account newAcc : newMap.values())
	//	{
	//		try{
	//			if(newAcc.Partner_Account__c != null && partnerAccountMap != null && partnerAccountMap.containsKey(newAcc.Partner_Account__c) &&  partnerAccountMap.get(newAcc.Partner_Account__c).isSpectrumPartner__c
	//			&& accountsWithOpportunities != null && accountsWithOpportunities.containsKey(newAcc.Id)){
	//				Boolean isChanged = checkChangedSpectrumData.evaluateSpectrumChangedDataAccount(newAcc, oldMap.get(newAcc.Id));
	//				isChangedMap.put(newAcc.Id,isChanged);
	//				if(isChanged)
	//					opportunitySyncIds.add(accountsWithOpportunities.get(newAcc.Id));
	//			}
	//		}
	//		catch(Exception e){
	//			System.debug('Spectrum Outbound Synv Check Failure:' + e);
	//		}
	//	}
		
	//	if(opportunitySyncIds != null && !opportunitySyncIds.isEmpty())
	//		OpportunityUtilities.sendOpportunities(opportunitySyncIds);
	//}
	
	
}