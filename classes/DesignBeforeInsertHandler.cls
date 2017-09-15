public without sharing class DesignBeforeInsertHandler extends TriggerHandlerBase {
    
    private List<Design__c> newList;
    
    private Map<Integer, Design__c> setFieldsQualifyMap = new Map<Integer, Design__c>();
    private List<Design__c> initialRevisionQualifyList = new List<Design__c>();
    private List<Design__c> finalDesignQualifyList = new List<Design__c>();
    
    private static Id projectRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Project Design').getRecordTypeId();
    
    public DesignBeforeInsertHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Design__c>)newList;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Design__c newDesign = this.newList[i];
            setFieldsQualifyMap.put(i, newDesign); 
            
            if (newDesign.RecordTypeId == projectRecordType && newDesign.Roof_Design__c != null) {
                initialRevisionQualifyList.add(newDesign);
            }
            if (newDesign.Final_Design__c == true) {
                finalDesignQualifyList.add(newDesign);
            }               
        }
    }
    
    public override void start() {
        if (setFieldsQualifyMap.size() > 0) {
            DesignTriggerUtil.setFields(setFieldsQualifyMap);
        }
        DesignTriggerUtil.validateFinalDesign(newList, null);
        if (initialRevisionQualifyList.size() > 0) {
            DesignTriggerUtil.setInitialRevision(initialRevisionQualifyList);
        }
        if (finalDesignQualifyList.size() > 0) {
            DesignTriggerUtil.selectFinalDesign(finalDesignQualifyList);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}