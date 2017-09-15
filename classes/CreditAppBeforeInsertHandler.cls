public class CreditAppBeforeInsertHandler extends TriggerHandlerBase{

    // -------- Constants --------
    
    // -------- Constructor --------
    public void CreditAppBeforeInsertHandler(){
        
    }
    // -------- Variables --------
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id,Credit_Check_Request__c> qualifiedCreditApps;
    private Set<Id> opportunityIds;
    private Map<Id,Id> opportunityIdCreditAppIdMap;         
        
        
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Map<ID, Credit_Check_Request__c> newCreditAppMap = (Map<ID, Credit_Check_Request__c>)newMap;
        Map<ID, Credit_Check_Request__c> oldCreditAppMap = (Map<ID, Credit_Check_Request__c>)oldMap;
        List<Credit_Check_Request__c> newCreditAppList = (List<Credit_Check_Request__c>)newList;
        List<Credit_Check_Request__c> oldCreditAppList = (List<Credit_Check_Request__c>)oldList;
        qualifiedCreditApps = new Map<Id, Credit_Check_Request__c>();
        opportunityIds = new Set<Id>();
        opportunityIdCreditAppIdMap = new Map<Id, Id>();
        
        
    }
    
    public override void start() {
            
    }
    
    public override void finish(Boolean fromSmart){
        if(fromSmart){
            
        }
    }
}