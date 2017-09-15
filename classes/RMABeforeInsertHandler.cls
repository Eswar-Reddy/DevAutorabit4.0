public without sharing class RMABeforeInsertHandler extends TriggerHandlerBase {
    
    public RMABeforeInsertHandler () {}
    
    private List<RMA__c> newList;
    private List<RMA__c> oldList;
    private Map<ID, RMA__c> newMap;
    private Map<ID, RMA__c> oldMap;
    private Map<Integer, RMA__c> rmaCaseOwnerUpdateMap= new Map<Integer, RMA__c>(); //Map to get RMA objects for Owner Update 
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<RMA__c>)newList;
        this.oldList = (List<RMA__c>)oldList;
        this.newMap = (Map<ID, RMA__c>)newMap;
        this.oldMap = (Map<ID, RMA__c>)oldMap;
        for (Integer i=0; i<this.newList.size(); i++) {
            RMA__c newRMA = this.newList[i];
            rmaCaseOwnerUpdateMap.put(i, newRMA);
            
        }
        
    }
    
    public override void start() {
        if (rmaCaseOwnerUpdateMap.size() > 0) {
            RMAOwnerUpdate.updateRMAOwnerAsCurrentUser(rmaCaseOwnerUpdateMap);
        }
        
    } 
    
    
    public override void finish(Boolean fromStart) {}
    
}