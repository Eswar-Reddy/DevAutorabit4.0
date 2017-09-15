public without sharing class Roof_DesignAfterUpdateHandler extends TriggerHandlerBase {
    
    private List<Roof_Design__c> newList;
    private List<Roof_Design__c> oldList;
    private Map<ID, Roof_Design__c> newMap;
    private Map<ID, Roof_Design__c> oldMap;
    private Map<Integer, Roof_Design__c> inverterQualifyMap = new Map<Integer, Roof_Design__c>();

    public Roof_DesignAfterUpdateHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Roof_Design__c>)newList;
        this.oldList = (List<Roof_Design__c>)oldList;
        this.newMap = (Map<ID, Roof_Design__c>)newMap;
        this.oldMap = (Map<ID, Roof_Design__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Roof_Design__c newRoofDesign = this.newList[i];
            Roof_Design__c oldRoofDesign;
            if (this.oldMap != null && newRoofDesign.Id != null && this.oldMap.containsKey(newRoofDesign.Id)) {
                oldRoofDesign = this.oldMap.get(newRoofDesign.Id);
            }
            
            if (oldRoofDesign != null && oldRoofDesign.Integration_Message__c != newRoofDesign.Integration_Message__c &&
                (newRoofDesign.Integration_Message__c == 'Update-Aurora Design imported successfully' ||
                 newRoofDesign.Integration_Message__c == 'Aurora Design imported successfully')) {
                
                inverterQualifyMap.put(i, newRoofDesign);                
            }    
        }
    }
    
    public override void start() {
        if (inverterQualifyMap.size() > 0) {
            RoofDesignInverter.createDesignInverters(inverterQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}