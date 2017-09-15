public without sharing class RMA_MilestoneBeforeUpdateHandler extends TriggerHandlerBase {

    public RMA_MilestoneBeforeUpdateHandler() {}
    
    private List<RMA_Milestone__c> newList;
    private List<RMA_Milestone__c> oldList;
    private Map<ID, RMA_Milestone__c> newMap;
    private Map<ID, RMA_Milestone__c> oldMap;
    private Map<Integer, RMA_Milestone__c> milestoneQualifyMap = new Map<Integer, RMA_Milestone__c>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<RMA_Milestone__c>)newList;
        this.oldList = (List<RMA_Milestone__c>)oldList;
        this.newMap = (Map<ID, RMA_Milestone__c>)newMap;
        this.oldMap = (Map<ID, RMA_Milestone__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            RMA_Milestone__c newmilestone = this.newList[i];
            RMA_Milestone__c oldmilestone = this.oldMap.get(newmilestone.Id);
            if (newmilestone.Status__c != oldmilestone.Status__c) {
                milestoneQualifyMap.put(i, newmilestone);
            }
        }
        
    }
    
    public override void start() {
        if (milestoneQualifyMap.size() > 0) {
            RMAMilestone.setDate(milestoneQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}