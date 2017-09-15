public without sharing class RMA_Line_ItemBeforeUpdateHandler extends TriggerHandlerBase {

    public RMA_Line_ItemBeforeUpdateHandler() {}
    
    private List<RMA_Line_Item__c> newList;
    private List<RMA_Line_Item__c> oldList;
    private Map<ID, RMA_Line_Item__c> newMap;
    private Map<ID, RMA_Line_Item__c> oldMap;
    private Map<Integer, RMA_Line_Item__c> partQualifyMap = new Map<Integer, RMA_Line_Item__c>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<RMA_Line_Item__c>)newList;
        this.oldList = (List<RMA_Line_Item__c>)oldList;
        this.newMap = (Map<ID, RMA_Line_Item__c>)newMap;
        this.oldMap = (Map<ID, RMA_Line_Item__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            RMA_Line_Item__c newPart = this.newList[i];
            RMA_Line_Item__c oldPart = this.oldMap.get(newPart.Id);
            if (newPart.Name != oldPart.Name) {
                partQualifyMap.put(i, newPart);
            }
        }
    }
    
    public override void start() {
        if (partQualifyMap.size() > 0) {
            RMALineItem.setItem(partQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}