public without sharing class QuoteAfterInsertHandler extends TriggerHandlerBase {

    public QuoteAfterInsertHandler(){
    }
    private Map<ID, Quote> newMap;
    private List<Quote> newList;
    private List<Quote_Summary__c> lstTemp = new List<Quote_Summary__c>();
    private Map<Id, Set<Quote_Summary__c>> mapQS = new Map<Id, Set<Quote_Summary__c>>();
    private List<Id> lstQSId = new List<Id>();
    public override void qualifyStartingRecords(List<sObject> newList, List< sObject > oldList, Map<ID, sObject > newMap, Map<ID, sObject > oldMap) {
        this.newMap = (Map<ID, Quote>)newMap;
        this.newList = (List<Quote>)newList;
        
        
         for (Integer i=0; i<this.newList.size(); i++) { 
            Id recId = this.newList[i].Id;
            Quote newRec = this.newMap.get(recId);                    
            if(newRec.Is_Locked__c) {
                lstQSId.add(newRec.Quote_Summary__c);
            }
         }
         
    }
    
    public override void start() {
      QuoteTriggerUtility.QuoteSummaryIsLocked(lstQSId);
    }    
        
    
    public override void finish(Boolean fromStart) {}

}