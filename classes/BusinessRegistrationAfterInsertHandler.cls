public with sharing class BusinessRegistrationAfterInsertHandler extends TriggerHandlerBase {
    public BusinessRegistrationAfterInsertHandler() {
        
    }

    // -------- Variables --------
    
 public static Id objresidentialAccountRecordType = AccountHandlerUtilities.ResidentialRecTypeId;
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Business_Registration__c> qualifiedBusinessRegs;
    private List<Id> partnerAccountIds;
    private List<String> billingStates;
    private Map<Id,Id> partnerIdBusinessRegMap;
   // private List<Account> customerAccountList;


    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('BusinessRegistartionAfterInsert qualifyStartingRecords');

        Map<ID, Business_Registration__c> newBusinessRegMap = (Map<ID, Business_Registration__c>)newMap;
        Map<ID, Business_Registration__c> oldBusinessRegMap = (Map<ID, Business_Registration__c>)oldMap;
        List<Business_Registration__c> newBusinessRegList = (List<Business_Registration__c>)newList;
        List<Business_Registration__c> oldBusinessRegList = (List<Business_Registration__c>)oldList;

        qualifiedBusinessRegs = new Map<Id, Business_Registration__c>();
        /* code for Multi-state project by Ganesh Chedella when Business Registration is inserted, all the related Customer Accounts will be tied to BR */   
        // Creating Lists to collect Partner Account and Billing State from Business Registartion records
        partnerAccountIds = new List<Id>();
        billingStates = new List<String>();
        partnerIdBusinessRegMap = new Map<Id,Id>(); // this map contains Partner Account ID and Buiness Registration record Id
        // Creating an Account list if there are any customer accounts to update
        
        // Looping through Business Registartion's to add partner Accounts , billig States and PartnerId,Business Reg Id to the Map
        for(Business_Registration__c br : newBusinessRegList){
            partnerAccountIds.add(br.Account__c);
            billingStates.add(br.State__c);
            partnerIdBusinessRegMap.put(br.Account__c,br.Id);
        }
        system.debug('partnerIdBusinessRegMap is '+partnerIdBusinessRegMap);
        
        
        
    }


    public override void start(){
        if(partnerIdBusinessRegMap.isEmpty() || billingStates.isEmpty()) return;
        
        // calling the below future method to update Customer Accounts
        BusinessRegistrationHandlerUtilities.updateCustomerAccounts(partnerIdBusinessRegMap,partnerAccountIds,billingStates,objresidentialAccountRecordType);
        
        
       /* Done writing code for Multi-state project by Ganesh Chedella when Business Registration is inserted, all the related Customer Accounts will be tied to BR */   
    }

    public override void finish(Boolean fromStart){
        if(fromStart){

        }
        Diagnostics.pop();
    }

   /* @future
    public static void updateCustomerAccounts(Map<Id,Id> pIdBRegIdMap,List<Id> partnerAccIds,List<String> billingSts){
       List<Account> customerAccountList = new List<Account>();
        // Querying all the Customer Accounts those belong to the Partner Account in the Business Reg. and also those belong to the state in Business reg. and looping through them 
        for(Account a : [select id,Business_Registration__c,Partner_Account__c from Account where RecordTypeId = :objresidentialAccountRecordType AND Partner_Account__c IN :partnerAccIds AND BillingState IN :billingSts AND Business_Registration__c = null]){
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
    }  */
}