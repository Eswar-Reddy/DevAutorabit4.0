//cdevarapalli -- SPD Communications -- Handler Class to create or update Opportunity Design record
public class OpportunityDesignUpdate {
    
    
    public static void opptyAfterUpdate (List<Opportunity> newOppList, List<Opportunity> oldOppList,Map<Id,Opportunity> oldOppMap, Map<Id,Opportunity> newOppMap){
    
        Set<Id> opptyIdSet = new Set<Id>();
        List<Opportunity_Design__c> odsUpdateList = new List<Opportunity_Design__c>();
        List<Opportunity_Design__c> odsinsertList = new List<Opportunity_Design__c>();
        Map<Id,Opportunity_Design__c> odsMap = new Map<Id,Opportunity_Design__c>();
        
        for(Opportunity opp:newOppList){
            if(newOppMap.get(opp.Id).Design_Photo__c!=oldOppMap.get(opp.Id).Design_Photo__c){
                opptyIdSet.add(opp.Id);
            }
        }
        
        List<Opportunity_Design__c> odsList = new List<Opportunity_Design__c>();
        
        if(!opptyIdSet.isEmpty())
            odsList=[select Id,Opportunity__c from Opportunity_Design__c where Opportunity__c in :opptyIdSet];
        
        for(Opportunity_Design__c ods:odsList){
            odsMap.put(ods.Opportunity__c,ods);
        }
        
        for(Opportunity opp:newOppList){
            System.debug('-----'+newOppMap.get(opp.Id).Design_Photo__c+'-----'+oldOppMap.get(opp.Id).Design_Photo__c);
            if(newOppMap.get(opp.Id).Design_Photo__c!=oldOppMap.get(opp.Id).Design_Photo__c){
                if(odsMap.containsKey(opp.Id)){
                    Opportunity_Design__c odsUpdate = odsMap.get(opp.Id);
                    odsUpdate.Design_Photo__c=opp.Design_Photo__c;
                    odsUpdateList.add(odsUpdate);
                }
                else{
                    Opportunity_Design__c odsInsert = new Opportunity_Design__c(Opportunity__c=opp.Id,Design_Photo__c=opp.Design_Photo__c);
                    odsinsertList.add(odsInsert);
                }
            }
        }
        
        if(odsUpdateList!=null && odsUpdateList.size()>0)
            update odsUpdateList;
        
        if(odsInsertList!=null && odsInsertList.size()>0)
            insert odsInsertList;
    }
      
}