public without sharing class DesignBeforeDeleteHandler extends TriggerHandlerBase {
    
    private List<Design__c> oldList;
    private Map<ID, Design__c> oldMap;

    public DesignBeforeDeleteHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.oldList = (List<Design__c>)oldList;
        this.oldMap = (Map<ID, Design__c>)oldMap;
        
        for (Integer i=0; i<this.oldList.size(); i++) {
            Design__c oldDesign = this.oldList[i];

        }
    }
    
    public override void start() {
        DesignTriggerUtil.deleteFinalDesign(oldList);
    }
    
    public override void finish(Boolean fromStart) {}

}