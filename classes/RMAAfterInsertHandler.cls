public without sharing class RMAAfterInsertHandler extends TriggerHandlerBase {

    public RMAAfterInsertHandler() {}
    
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
            milestoneQualifyMap.put(i, newRMA);
            if (newRMA.RMA_Owner__c != null) {
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