global without sharing class AsyncConvertLead implements Queueable, Database.AllowsCallouts, Database.Stateful
{
    
    Set<Id> recordids;
    public AsyncConvertLead(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }
    public void execute(QueueableContext context) {   
        LeadDealerUtility.futureLeadAutoConvert(recordIds);   
    }
}