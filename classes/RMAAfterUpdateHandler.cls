public without sharing class RMAAfterUpdateHandler extends TriggerHandlerBase {

    public RMAAfterUpdateHandler() {}
    
    private List<RMA__c> newList;
    private List<RMA__c> oldList;
    private Map<ID, RMA__c> newMap;
    private Map<ID, RMA__c> oldMap;
    private Map<Integer, RMA__c> milestoneQualifyMap = new Map<Integer, RMA__c>();
    private Map<Integer, RMA__c> caseTeamQualifyMap = new Map<Integer, RMA__c>();
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<RMA__c>)newList;
        this.oldList = (List<RMA__c>)oldList;
        this.newMap = (Map<ID, RMA__c>)newMap;
        this.oldMap = (Map<ID, RMA__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            RMA__c newRMA = this.newList[i];
            RMA__c oldRMA = this.oldMap.get(newRMA.Id);
            milestoneQualifyMap.put(i, newRMA);
            if (newRMA.RMA_Owner__c != null && newRMA.RMA_Owner__c != oldRMA.RMA_Owner__c) {
                caseTeamQualifyMap.put(i, newRMA);
            }
        }
        
    }
    
    public override void start() {
        if (milestoneQualifyMap.size() > 0) {
            RMAMilestone.createMilestones(milestoneQualifyMap);
        }
        if (caseTeamQualifyMap.size() > 0) {
            RMACaseTeam.addToCaseTeamOnRMAOwnerChange(caseTeamQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}