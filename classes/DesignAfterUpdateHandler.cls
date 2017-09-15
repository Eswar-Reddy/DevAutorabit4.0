public without sharing class DesignAfterUpdateHandler extends TriggerHandlerBase {
    
    private List<Design__c> newList;
    private List<Design__c> oldList;
    private Map<ID, Design__c> newMap;
    private Map<ID, Design__c> oldMap;
    private List<Design__c> finalDesignQualifyList = new List<Design__c>();
    
    public DesignAfterUpdateHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Design__c>)newList;
        this.oldList = (List<Design__c>)oldList;
        this.newMap = (Map<ID, Design__c>)newMap;
        this.oldMap = (Map<ID, Design__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Design__c newDesign = this.newList[i];
            if (this.oldMap != null && newDesign.Id != null && this.oldMap.containsKey(newDesign.Id)) {
                Design__c oldDesign = this.oldMap.get(newDesign.Id); 
                if (newDesign.Final_Design__c != oldDesign.Final_Design__c || newDesign.Actual_System_Size__c != oldDesign.Actual_System_Size__c || newDesign.RecordTypeId != oldDesign.RecordTypeId) {
                    finalDesignQualifyList.add(newDesign);
                }
            }
        }
    }
    
    public override void start() {
        if (finalDesignQualifyList.size() > 0) {
            DesignTriggerUtil.setOpportunitySystemSize(finalDesignQualifyList);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}