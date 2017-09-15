public class CreditAppAfterInsertHandler extends TriggerHandlerBase{

    // -------- Constants --------
    
    // -------- Constructor --------
    public void CreditAppAfterInsertHandler(){
        
    }
    // -------- Variables --------
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id,Credit_Check_Request__c> qualifiedCreditApps;
    private Set<Id> accountIds;
    private Map<Id,Credit_Check_Request__c> accountIdCreditAppMap;

        
        
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Map<ID, Credit_Check_Request__c> newCreditAppMap = (Map<ID, Credit_Check_Request__c>)newMap;
        Map<ID, Credit_Check_Request__c> oldCreditAppMap = (Map<ID, Credit_Check_Request__c>)oldMap;
        List<Credit_Check_Request__c> newCreditAppList = (List<Credit_Check_Request__c>)newList;
        List<Credit_Check_Request__c> oldCreditAppList = (List<Credit_Check_Request__c>)oldList;
        qualifiedCreditApps = new Map<Id, Credit_Check_Request__c>();
        accountIds = new Set<Id>();
        accountIdCreditAppMap = new Map<Id, Credit_Check_Request__c>();
        
        // looping through the Triggered data to add the CreditApps to qualifying Map
        for(Id i : newCreditAppMap.keySet()){
            Credit_Check_Request__c ccr = newCreditAppMap.get(i);
            qualifiedCreditApps.put(i, ccr);
        }
    }
    
    public override void start() {
        if(qualifiedCreditApps.isEmpty())
            return;
        for(Id i : qualifiedCreditApps.keySet()){
            Credit_Check_Request__c ccr = qualifiedCreditApps.get(i);
            accountIdCreditAppMap.put(ccr.Account__c,ccr);
            accountIds.add(ccr.Account__c);
        }
        
        // calling a method that will update Quotes related to the Opportunity of Credit Check Application to associate those quotes to Credit Check Application as part of Loan project by Ganesh Chedella
        if(accountIds != null){
            assignCreditAppToQuotes();
        }
    }
    
    public override void finish(Boolean fromSmart){
        if(fromSmart){
            
        }
    }
    
    public void assignCreditAppToQuotes(){
        List<Quote> quotesToBeUpdated = new List<Quote>();
        for(Quote q : [select id,Account__c,Credit_Check_Application__c,QuoteType__c from Quote where Account__c IN :accountIds]){
            if(accountIdCreditAppMap != null && accountIdCreditAppMap.get(q.Account__c) !=null){
                if(q.QuoteType__c == accountIdCreditAppMap.get(q.Account__c).Application_Type__c){
                   q.Credit_Check_Application__c = accountIdCreditAppMap.get(q.Account__c).Id;
                   quotesToBeUpdated.add(q);
                }
                
            }
        }
        
        if(quotesToBeUpdated != null && !quotesToBeUpdated.isEmpty()){
            try{
                List<Database.SaveResult> quoteUpdateResults = Database.update(quotesToBeUpdated,false);
                try{
                    SpectrumDebugUtility.createExceptionLogs(quoteUpdateResults,'associating Quote with Credit Check Application',Quote.sObjectType);
                }
                catch(Exception ex){
                    
                }
            }
            catch(Exception e){
                
            }
        }
    }
}