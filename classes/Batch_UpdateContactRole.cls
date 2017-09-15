global without sharing class Batch_UpdateContactRole implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful,Schedulable
{
    global final String query;
    
    global Batch_UpdateContactRole () 
    {
        query = 'SELECT id,name FROM Opportunity where id NOT IN (Select OpportunityId From OpportunityContactRole where role = \'%Borrower%\') and id IN (Select OpportunityId From OpportunityContactRole where role = null)';
    } 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('--------query'+query);
        return Database.getQueryLocator(query);        
        
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        set<ID> setOpportunityid = new set<ID>();
        for (Opportunity objOpportunity : (List<Opportunity>)scope) {
            setOpportunityid.add(objOpportunity.id);
        }
        System.debug('-------------------setOpportunityid'+setOpportunityid);
        ID homeOwnerRecordTypeId = util.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType).get('Home_Owner');
        list<OpportunityContactRole> listOpportunityContactRole = new list<OpportunityContactRole>();
        for(OpportunityContactRole objOpportunityContactRole :[Select id,IsPrimary,Role from OpportunityContactRole where OpportunityId in: setOpportunityid and Role = null AND isPrimary = true AND Opportunity.recordtypeid =:homeOwnerRecordTypeId]){
            System.debug('-------------------objOpportunityContactRole1='+objOpportunityContactRole);
            //objOpportunityContactRole.IsPrimary= true;
            objOpportunityContactRole.Role= 'Borrower';
            listOpportunityContactRole.add(objOpportunityContactRole);
            System.debug('-------------------objOpportunityContactRole2='+objOpportunityContactRole);
        }
         System.debug('-------------------listOpportunityContactRole='+listOpportunityContactRole);
        update listOpportunityContactRole;
    }
    global void finish(Database.BatchableContext BC) 
    {
      
    }
    global void execute(SchedulableContext sc)
    {
         Batch_UpdateContactRole batch = new Batch_UpdateContactRole();
         Database.executeBatch(batch,200);
    }
}