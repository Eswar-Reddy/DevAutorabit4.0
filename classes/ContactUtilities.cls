public without sharing class ContactUtilities {
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
	
	//// -------- Methods --------
	//// Qualify records; partnerAccountToOpportunity stores the one to many relationship for opps belonging 
	//// to partner accounts; which is used to build the qualifiedSpectrumSync
	
	//// Load accounts base don various criteria - MOVE TO CONTACT UTILITIES WHEN GH STARTS
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
	
	//// The following will be moved to the after update handlers
	//public static void qualifySpectrumRecordsAfterUpdate(Map<ID, Contact> newMap, Map<ID, Contact> oldMap)
	//{
	//	if(isIntegrationRunning != null && isIntegrationRunning == true)
	//		return;
	//	SpectrumJSONServices checkChangedSpectrumData = new SpectrumJSONServices();
		
	//	Map<Id,Id> partnerIdMap = new Map<Id,Id>();
	//	Set<Id> accountIds = new Set<Id>();
		
	//	for(Contact c: newMap.values()){
	//		accountIds.add(c.AccountId);
	//	}
		
	//	for(Account a : [SELECT Id,Partner_Account__c FROM Account WHERE Id IN :accountIds]){
	//		if(a.Partner_Account__c != null)
	//			partnerIdMap.put(a.Id,a.Partner_Account__c);
	//	}
	//	Set<Id> partnerIds = new Set<Id>();
		
	//	partnerIds.addAll(partnerIdMap.values());
	//	Map<Id,Account> partnerAccountMap = loadPartnerAccounts(partnerIds);
		
	//	//QUALIFY THAT THERE IS AN OPPORTUNITY
	//	Map<Id,Id> accountsWithOpportunities = new Map<Id,Id>();
		
	//	for(Opportunity o : [SELECT Id,AccountId FROM Opportunity WHERE AccountId IN :partnerIdMap.keySet()]){
	//		accountsWithOpportunities.put(o.AccountId,o.Id);
	//	}
		
	//	//STORE OPP IDS THAT NEED TO BE UPDATED
	//	isChangedMap = new Map<Id,Boolean>();
	//	Set<Id> opportunitySyncIds = new Set<Id>();
	//	for(Contact newCon : newMap.values())
	//	{
	//		try{
	//		if(newCon.AccountId != null && partnerIdMap.containsKey(newCon.AccountId) && partnerIdMap.get(newCon.AccountId) != null &&
	//		partnerAccountMap != null && partnerAccountMap.containsKey(partnerIdMap.get(newCon.AccountId)) &&  partnerAccountMap.get(partnerIdMap.get(newCon.AccountId)).isSpectrumPartner__c
	//		&& accountsWithOpportunities != null && accountsWithOpportunities.containsKey(newCon.AccountId)){
	//			Boolean isChanged = checkChangedSpectrumData.evaluateSpectrumChangedDataContact(newCon, oldMap.get(newCon.Id));
	//			isChangedMap.put(newCon.Id,isChanged);
	//			if(isChanged)
	//				opportunitySyncIds.add(accountsWithOpportunities.get(newCon.AccountId));
	//		}
	//		}
	//		catch(Exception e){
	//			System.debug('Spectrum Outbound Synv Check Failure:' + e);
	//		}
	//	}
		
	//	if(opportunitySyncIds != null && !opportunitySyncIds.isEmpty())
	//		OpportunityUtilities.sendOpportunities(opportunitySyncIds);
	//}
	
}