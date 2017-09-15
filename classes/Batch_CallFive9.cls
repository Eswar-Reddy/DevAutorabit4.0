//Batch class to make webservice callouts to Five9 and send phone number and OpportunityID
global class Batch_CallFive9 implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Set<Id> oppIdSet;
    
    global Database.querylocator start(Database.BatchableContext BC){
        
        String query = 'select Primary_Phone__c, Campaign.Name,Opportunity_Number1__c,Not_Sent_To_Five9__c from Opportunity where Id in :oppIdSet or Not_Sent_To_Five9__c =true';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Opportunity> toUpdate = new List<Opportunity>();
        for(sObject s : scope){             
            Opportunity opp = (Opportunity)s;
            
            boolean calloutSuccess=Five9CallHandler.callfive9addtoList(opp);
            
            
            if(calloutSuccess==false){
                toUpdate.add(new Opportunity
                                (Id=opp.Id
                                ,Not_Sent_To_Five9__c=true));
            }
            else if(calloutSuccess==true && opp.Not_Sent_To_Five9__c==true){
                toUpdate.add(new Opportunity
                                (Id=opp.Id
                                ,Not_Sent_To_Five9__c=false));
            }
        }
        
        try{
            if(!toUpdate.isEmpty())
                update toUpdate;
        } catch(DMLException e){
            ExLog.log(e);
            throw e;
        }
    }
    
    global void finish(Database.BatchableContext BC){

    }
    
}