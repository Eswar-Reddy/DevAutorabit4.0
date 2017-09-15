public class DocumentTriggerHandler 
{
    
    public static void afterDocumentInsert (List<Document__c> documentList)
    {
        updateOpportunitySPWRDealType(documentList);  
        
    }
    public static void afterDocumentUpdate (List<Document__c> documentList, 
                                             List<Document__c> oldDocumentList)
    {
        updateOpportunitySPWRDealType(documentList);
        
    }
    
    private static void updateOpportunitySPWRDealType(List<Document__c> docList){
    
        Set<Id> opportunityIdSet = new Set<Id>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        List<Opportunity> opportunityUpdateList = new List<Opportunity>();
        for(Document__c doc:docList){
            if(doc.Document_Type__c=='Signed-NTS')
                opportunityIdSet.add(doc.Opportunity__c);
        }
        
        if(!opportunityIdSet.isEmpty())
            opportunityList = [select Id,Contract_Type__c FROM Opportunity where Id in :opportunityIdSet and Partner_Account_text__c='SunPower New Homes'];
        
        system.debug('-----'+opportunityList);        
        for(Opportunity opp:opportunityList){
            opp.Contract_Type__c='NH - Cash';
            opportunityUpdateList.add(opp);
        }
        
        if(!opportunityUpdateList.isEmpty()){
            update opportunityUpdateList;
        }
    
    }

}