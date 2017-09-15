public without sharing class QuoteBeforeInsertHandler extends TriggerHandlerBase {

    public QuoteBeforeInsertHandler() {}
    
    private Map<ID, Quote> oldMap;
    private Map<ID, Quote> newMap;
    private List<Quote> newList;
    private List<Quote> oldList;
    
  
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newMap = (Map<ID, Quote>)newMap;
        this.oldMap = (Map<ID, Quote>)oldMap;
        this.newList = (List<Quote>)newList;
        this.oldList = (List<Quote>)oldList;
    }
  
    public override void start() { 
        // Call function to update the OppLineItems
             QuoteTriggerUtility.UpdateLineItems(newList);
       //  Call function "If Sales Analyst/Oppty Owner Manager field blank on qoute creation then populate from Oppty.Populate Opportunity 'Proposal Due Date' on Quote"
             QuoteManagement.beforeQuoteInsert(newList);
      // Calling the function to update Invertervalues on Quote.
             QuoteTriggerUtility.UpdateQuoteInverterValues(newList);                   
    }
    
    public override void finish(Boolean fromStart) {}

}