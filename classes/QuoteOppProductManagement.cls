global class QuoteOppProductManagement{

webservice static void syncProduct(String quoteID){
    Quote quoteObj = [Select ID,OpportunityID from Quote where ID=:quoteID];
    
    //Do one time sync
    Opportunity opp = new Opportunity(ID=quoteObj.OpportunityID);
    opp.SyncedQuoteId = quoteID;    
    update opp;
    
    //Stop syncing after one time sync
    opp.SyncedQuoteId = null;
    update opp;
}

}