public without sharing class Roof_DesignBeforeInsertHandler extends TriggerHandlerBase {
    
    private List<Roof_Design__c> newList;
    private List<Roof_Design__c> oldList;
    private Map<ID, Roof_Design__c> newMap;
    private Map<ID, Roof_Design__c> oldMap;
    private Map<Integer, Roof_Design__c> inverterQualifyMap = new Map<Integer, Roof_Design__c>();
    public Map<String, String> roofToAccountMap = new Map<String, String>();
    public Set<String> accountIds = new Set<String>();
    public Map<String, String> accountToGeoMap = new Map<String, String>();
    
    // Qualified records for actions
    private Map<Integer, Roof_Design__c> qualifiedRoofDesigns;

    public Roof_DesignBeforeInsertHandler() {}
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Roof_Design__c>)newList;
        this.oldList = (List<Roof_Design__c>)oldList;
        this.newMap = (Map<ID, Roof_Design__c>)newMap;
        this.oldMap = (Map<ID, Roof_Design__c>)oldMap;
        qualifiedRoofDesigns = new Map<Integer, Roof_Design__c>();
        for (Integer i=0; i<this.newList.size(); i++) {
            Roof_Design__c newRoofDesign = this.newList[i];
            if(newRoofDesign.Account_Name__c !=null){
                accountIds.add(newRoofDesign.Account_Name__c); 
                qualifiedRoofDesigns.put(i,newRoofDesign);
            }
            
        }
    }
    
    public override void start() {
        
        String Geo;
        for(Account acc : [SELECT Id, Lat__c, Log__c, Google_Pin_Adjusted__c 
                                          FROM Account WHERE Id IN: accountIds and Google_Pin_Adjusted__c=true]) {
                  Geo = acc.Lat__c + ' '+ acc.Log__c;
                  accountToGeoMap.put(acc.Id,Geo);
        }
        
        if(qualifiedRoofDesigns!=null && !qualifiedRoofDesigns.isEmpty() && accountToGeoMap!=null && !accountToGeoMap.isEmpty()){
            for(Integer i : qualifiedRoofDesigns.keySet()) {
                Roof_Design__c design= qualifiedRoofDesigns.get(i);
                if(accountToGeoMap.Keyset().Contains(design.Account_Name__c)){
                    design.Notes_for_Design_Team__c = 'This home\'s address was manually updated by the user. Please use the following Latitude & Longitude to find home -' + accountToGeoMap.get(design.Account_Name__c) +'<br/>'+((design.Notes_for_Design_Team__c != null) ? design.Notes_for_Design_Team__c : '');
                }
            }
        }
    }
    
    public override void finish(Boolean fromStart) {}

}