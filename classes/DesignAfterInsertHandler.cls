public without sharing class DesignAfterInsertHandler extends TriggerHandlerBase {
    
    private List<Design__c> newList;
    private Map<ID, Design__c> newMap;
    private List<Design__c> finalDesignQualifyList = new List<Design__c>();
    
    public DesignAfterInsertHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Design__c>)newList;
        this.newMap = (Map<ID, Design__c>)newMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Design__c newDesign = this.newList[i];
            finalDesignQualifyList.add(newDesign);
        }
    }
    
    public override void start() {
        if (finalDesignQualifyList.size() > 0) {
            DesignTriggerUtil.setOpportunitySystemSize(finalDesignQualifyList);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}