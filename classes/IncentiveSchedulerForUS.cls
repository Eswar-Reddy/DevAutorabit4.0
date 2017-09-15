global class IncentiveSchedulerForUS implements Schedulable
{  
    global void execute(SchedulableContext sc)
    {     
       /* String Query = 'select Id from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
        id batchinstanceid = database.executeBatch(new IncentiveBatch(Query), 5); 
        system.debug('Batch Id ** '+batchinstanceid);*/
        execfn();
    }
    
    public void execfn(){
        
        //String Query = 'select Id,Country_Domain__c from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
        id batchinstanceid = database.executeBatch(new IncentiveBatch(), 2); 
        system.debug('Batch Id ** '+batchinstanceid);        
    }
    
    public static testMethod void tst001(){
        IncentiveSchedulerForUS inus = new IncentiveSchedulerForUS();
        SchedulableContext sc;
        inus.execute(sc);
       // inus.execfn();
        
    }
}