public without sharing class CaseAfterInsertHandler extends TriggerHandlerBase {

    public CaseAfterInsertHandler() {}
    
    private List<Case> newList;
    private List<Case> oldList;
    private Map<ID, Case> newMap;
    private Map<ID, Case> oldMap;
    private Map<Integer, Case> spvtCaseNotificationQualifyMap = new Map<Integer, Case>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Case>)newList;
        this.oldList = (List<Case>)oldList;
        this.newMap = (Map<ID, Case>)newMap;
        this.oldMap = (Map<ID, Case>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Case newCase = this.newList[i];
            if (newCase.SPVT_Case__c) {
                spvtCaseNotificationQualifyMap.put(i, newCase);
            }
        }
        
    }
    
    public override void start() {
        if (spvtCaseNotificationQualifyMap.size() > 0) {
            SPVTCaseNotification.sendEmail(spvtCaseNotificationQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}