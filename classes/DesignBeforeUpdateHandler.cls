public without sharing class DesignBeforeUpdateHandler extends TriggerHandlerBase {
    
    private List<Design__c> newList;
    private List<Design__c> oldList;
    private Map<ID, Design__c> newMap;
    private Map<ID, Design__c> oldMap;

    private Map<Id, Design__c> awaitingApprovalQualifyMap = new Map<Id, Design__c>();
    private List<Design__c> initialRevisionQualifyList = new List<Design__c>();
    private List<Design__c> finalDesignQualifyList = new List<Design__c>();
    
    private static Id proposalRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
    private static Id projectRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Project Design').getRecordTypeId();
    
    public DesignBeforeUpdateHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Design__c>)newList;
        this.oldList = (List<Design__c>)oldList;
        this.newMap = (Map<ID, Design__c>)newMap;
        this.oldMap = (Map<ID, Design__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Design__c newDesign = this.newList[i];
            if (this.oldMap != null && newDesign.Id != null && this.oldMap.containsKey(newDesign.Id)) {
                Design__c oldDesign = this.oldMap.get(newDesign.Id); 

                if (!Util.bypassValidation() &&
                    //KCM_07112017: Commercial #147972591 
                    ((newDesign.Status__c == 'Completed' && oldDesign.Status__c != 'Completed') ||
                     (newDesign.Status__c == 'Awaiting Approval' && oldDesign.Status__c != 'Awaiting Approval'))) {
                    awaitingApprovalQualifyMap.put(newDesign.Id, newDesign);    
                }                 
                if (newDesign.RecordTypeId == projectRecordType && newDesign.Roof_Design__c != null && oldDesign.Roof_Design__c == null) {
                    initialRevisionQualifyList.add(newDesign);
                } 
                if (newDesign.Final_Design__c == true && (oldDesign.Final_Design__c == false || newDesign.Site__c != oldDesign.Site__c || 
                        newDesign.RecordTypeId != oldDesign.RecordTypeId || newDesign.Technology_System__c != oldDesign.Technology_System__c)) {
                    finalDesignQualifyList.add(newDesign);
                }    
            }
        }
    }
    
    public override void start() {

        if (awaitingApprovalQualifyMap.size() > 0) {
            DesignTriggerUtil.validateStatusCompletedFields(awaitingApprovalQualifyMap);
        }
        DesignTriggerUtil.validateFinalDesign(newList, oldMap);
        if (initialRevisionQualifyList.size() > 0) {
            DesignTriggerUtil.setInitialRevision(initialRevisionQualifyList);
        }
        if (finalDesignQualifyList.size() > 0) {
            DesignTriggerUtil.selectFinalDesign(finalDesignQualifyList);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}