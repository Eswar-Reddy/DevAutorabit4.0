public class SyncOppProduct{
/**This is to sync products from quote line items to opportunity line items**/
     
  public static void syncOppsProductFromQuote(List<Opportunity> oppTrigger, Map<Id,Opportunity> oppOldMap){  	        
            Set<Id> oppsIds = new Set<Id>();
            Set<Id> quoteIds = new Set<Id>();           
            Map<Id,Opportunity> updateOppsIds = new Map<Id,Opportunity>();
            
            for(Opportunity nextOpp:oppTrigger){
               oppsIds.Add(nextOpp.Id);
               if(nextOpp.SyncedQuoteId != null)  //Moved from trigger for Case #00076063 
               		quoteIds.Add(nextOpp.SyncedQuoteId);
               //Case #00076063
               if(oppOldMap != null && (nextOpp.PV_Cost_Pricing__c != oppOldMap.get(nextOpp.Id).PV_Cost_Pricing__c  || nextOpp.Serengeti_Cost_Pricing__c != oppOldMap.get(nextOpp.Id).Serengeti_Cost_Pricing__c))
               {                	
                	updateOppsIds.put(nextOpp.Id, nextOpp);                	        
               }
            }
            
            if(quoteIds.size()==0 && updateOppsIds.size()==0){
            	return;
            }
            
            List<QuoteLineItem> quoteProducts = [Select Quote.opportunityID,Product_Name__c,Product_Type__c, PriceBookEntryId,PriceBookEntry.Product2Id,PriceBookEntry.Product2.name,Estimate__c,Design__c,Site__c,Cost__c,QuoteId,kWp_Components__c,Design_Link__c,Design_Name__c,Estimate_Link__c,Estimate_Name__c,Quote.status from QuoteLineItem where QuoteId in :quoteIds or Quote.opportunityID in :updateOppsIds.keySet()];
            List<OpportunityLineItem> oppProducts = [Select Id,Opportunity.SyncedQuoteId,Opportunity.stagename,PriceBookEntryId,PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, Product_Type__c,Estimate__c,Design__c,Site__c,Cost__c,opportunityId,kWp_Components__c,Design_Link__c,Design_Name__c,Estimate_Link__c,Estimate_Name__c from OpportunityLineItem where opportunityId in :oppsIds];
                                    
            //Case #00076063
            for(OpportunityLineItem oppItem : oppProducts){
            	if(updateOppsIds.containsKey(oppItem.opportunityID) && oppItem.Product_Type__c == 'PV Module' &&  oppItem.opportunity.stagename != '06 – Closed Won'){
                	if(oppItem.PriceBookEntry.Product2.name.startsWith('SPR-')){
                		oppItem.Cost__c = updateOppsIds.get(oppItem.opportunityID).PV_Cost_Pricing__c;                		
                	}
                	else if(oppItem.PriceBookEntry.Product2.name.startsWith('SER-')){
                		oppItem.Cost__c = updateOppsIds.get(oppItem.opportunityID).Serengeti_Cost_Pricing__c;                		
                	}
                }
            }
            
            List<QuoteLineItem> lstQuoteLIToUpdate = new List<QuoteLineItem>();                                      
            if(quoteProducts.size()>0){
                for(QuoteLineItem quoteItem : quoteProducts){
                    for(OpportunityLineItem oppItem : oppProducts){
                        if( quoteItem.PriceBookEntryId == oppItem.PriceBookEntryId &&
                            oppItem.Opportunity.SyncedQuoteId == quoteItem.QuoteId
                           ){
                            oppItem.Estimate__c = quoteItem.Estimate__c; 
                            oppItem.Design__c = quoteItem.Design__c;
                            oppItem.Site__c = quoteItem.Site__c;
                            oppItem.Cost__c = quoteItem.Cost__c;
                            oppItem.kWp_Components__c = quoteItem.kWp_Components__c;
                            oppItem.Design_Link__c = quoteItem.Design_Link__c;
                            oppItem.Design_Name__c = quoteItem.Design_Name__c;
                            oppItem.Estimate_Link__c = quoteItem.Estimate_Link__c;
                            oppItem.Estimate_Name__c = quoteItem.Estimate_Name__c;
                            oppItem.Quote_Sync_Date__c = DateTime.Now();                                                      
                         }
                  }  
                  
                  //Case #00076063 
                  if(updateOppsIds.containsKey(quoteItem.Quote.opportunityId) && quoteItem.Product_Type__c == 'PV Module' &&  quoteItem.Quote.Status != 'Approved'){
                  	if(quoteItem.PriceBookEntry.Product2.name.startsWith('SPR-')){
                		quoteItem.Cost__c = updateOppsIds.get(quoteItem.Quote.opportunityId).PV_Cost_Pricing__c;
                		lstQuoteLIToUpdate.add(quoteItem);
                	}
                	else if(quoteItem.PriceBookEntry.Product2.name.startsWith('SER-')){
                		quoteItem.Cost__c = updateOppsIds.get(quoteItem.Quote.opportunityId).Serengeti_Cost_Pricing__c;
                		lstQuoteLIToUpdate.add(quoteItem);
                	}
                  }                                                     
               }                    
         }                  
         
	     if(oppProducts.size()>0)
         	update oppProducts;
         if(lstQuoteLIToUpdate.size()>0)
         	update lstQuoteLIToUpdate;
    }         
    
}