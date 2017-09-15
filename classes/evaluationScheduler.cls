global class evaluationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        execfn();
    }
    
    public void execfn(){
        //String Query = 'select Id,Country_Domain__c from Account where(Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'combo-de\'OR Country_Domain__c=\'rvar-it\'OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'combo-it\'OR Country_Domain__c=\'rvar-us\'OR Country_Domain__c=\'combo-us\') and Status__c =\'Active\' and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
        id batchinstanceid = database.executeBatch(new evaluateBatch(), 5); 
        id batchinstanceid2 = database.executeBatch(new evaluateBatchPrevious(), 5);  // had to be run till july 31st
        system.debug('Batch Id ** '+batchinstanceid);        
    }
     
    public static testMethod void tst001(){
        evaluationScheduler inus = new evaluationScheduler();
        SchedulableContext sc ;
        inus.execute(sc);
      //  inus.execfn();
        
    }
}