public with sharing class BusinessRegistrationHandlerUtilities {
	public BusinessRegistrationHandlerUtilities() {
		
	}

	@future
    public static void updateCustomerAccounts(Map<Id,Id> pIdBRegIdMap,List<Id> partnerAccIds,List<String> billingSts,Id resCustomerRecordTypeId){
       List<Account> customerAccountList = new List<Account>();
        // Querying all the Customer Accounts those belong to the Partner Account in the Business Reg. and also those belong to the state in Business reg. and looping through them 
        for(Account a : [select id,Business_Registration__c,Partner_Account__c from Account where RecordTypeId = :resCustomerRecordTypeId AND Partner_Account__c IN :partnerAccIds AND BillingState IN :billingSts AND Business_Registration__c = null]){
            if(pIdBRegIdMap.containsKey(a.Partner_Account__c) && pIdBRegIdMap.get(a.Partner_Account__c) != null){
                a.Business_Registration__c = pIdBRegIdMap.get(a.Partner_Account__c);
                customerAccountList.add(a);
            }
        }
        if(!customerAccountList.isEmpty()){
          List<Database.SaveResult> customerAccountSaveresults = new List<Database.SaveResult>();  
          try{
               customerAccountSaveresults = Database.update(customerAccountList,false); 
          }  
          catch(Exception e){
                
          }
          
        }
    }
}