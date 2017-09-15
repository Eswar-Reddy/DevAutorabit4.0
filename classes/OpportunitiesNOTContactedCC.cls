public with sharing class OpportunitiesNOTContactedCC {

    public List<Opportunity> lOpps {get; set;}
    
    //Custom Controller Constructor getting used by DealerAccount VF Page
    public OpportunitiesNOTContactedCC() {
        lOpps = new List<Opportunity>();
        lOpps = [SELECT Id, Name, SLA_Time__c, SLA_Flag__c, 
                        Dealer_Assignment_Date__c, StageName 
                        FROM Opportunity
                        WHERE Lead_Manufacturer__c = 'SunPower' 
                        AND Dealer_Assignment_Date__c != Null                        
                        AND StageName = 'New Opportunity'
                        ORDER BY SLA_Time__c ASC, Dealer_Assignment_Date__c ASC, Name ASC
                        LIMIT 20];
    }
}