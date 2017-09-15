global class evaluateBatch implements Database.Batchable<sObject>{
    global String Query;
    global Set<String> countryDomains;
    global evaluateBatch(){
        countryDomains = PerformanceEvalCst.countryDomains;
        String Query = 'select Id,Country_Domain__c from Account where Country_Domain__c in (\'rvar-it\',\'rvar-fr\',\'rvar-us\',\'rvar-de\',\'cvar-it\',\'cvar-fr\',\'cvar-us\',\'cvar-de\',\'combo-it\',\'combo-fr\',\'combo-us\',\'combo-de\') and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
        
       this.query = Query;
       System.debug('Query is---->'+query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
      
   }

   global void execute(Database.BatchableContext BC,List<sObject> scope){ 
    Account acct; 
    for(sObject s : scope){
      system.debug('Account ID ==============='+s.Id);
        //current Period
         acct = (Account)s;
          System.debug('================' + acct.Country_Domain__c);
            if(acct.Country_Domain__c.contains('rvar')||acct.Country_Domain__c.contains('combo'))
                new PerformanceEvalController(s.Id);//For Residential Dealers
            if(acct.Country_Domain__c.contains('cvar')||acct.Country_Domain__c.contains('combo'))
                new PerformanceEvalCommController(s.Id);//For Commercial Dealers
         
          //new PerformanceEvaluationPrevious(s.Id);
       }      
   }

   global void finish(Database.BatchableContext BC){

   }
   
   public static testMethod void tst001(){
       String qury = 'select Id,Country_Domain__c from Account where(Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'combo-de\'OR Country_Domain__c=\'rvar-it\'OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'combo-it\'OR Country_Domain__c=\'rvar-us\'OR Country_Domain__c=\'combo-us\') and Status__c =\'Active\' and Type!=null limit 10';
       evaluateBatch bc = new evaluateBatch();
       bc.Query = 'select Id,Country_Domain__c from Account where(Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'combo-de\'OR Country_Domain__c=\'rvar-it\'OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'combo-it\'OR Country_Domain__c=\'rvar-us\'OR Country_Domain__c=\'combo-us\') and Status__c =\'Active\' and Type!=null limit 10';
       Test.startTest();
       Database.executeBatch(bc, 20);
       Test.stopTest();
   }


}