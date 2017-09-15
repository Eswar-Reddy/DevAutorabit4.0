global class evaluateBatchPrevious implements Database.Batchable<sObject>{
    global String Query;
    global Set<String> countryDomains;
    global evaluateBatchPrevious(){
        countryDomains = PerformanceEvalCst.countryDomains;
        //Added UK domain in query for Case 00072314
        //Start 00105774
        //String Query = 'select Id,Country_Domain__c from Account where Country_Domain__c in (\'rvar-it\',\'rvar-fr\',\'rvar-uk\',\'rvar-us\',\'rvar-de\',\'cvar-it\',\'cvar-fr\',\'cvar-uk\',\'cvar-us\',\'cvar-de\',\'combo-it\',\'combo-fr\',\'combo-uk\',\'combo-us\',\'combo-de\') and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
        String Query = 'select Id,Country_Domain__c from Account where Country_Domain__c in (\'rvar-it\',\'rvar-fr\',\'rvar-uk\',\'rvar-us\',\'rvar-de\',\'cvar-it\',\'cvar-fr\',\'cvar-uk\',\'cvar-us\',\'cvar-de\',\'combo-it\',\'combo-fr\',\'combo-uk\',\'combo-us\',\'combo-de\',\'rvar-au\',\'cvar-au\',\'combo-au\') and Type!=null'; // (Country_Domain__c=:'+'rvar-de'+')
		//End 00105774
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
	      System.debug('===============s.Id============' + s.Id);          
          acct = (Account)s;
          String prePeriod = PreviousPerformancePeriod__c.getAll().get('Period').value__c;       
          String preYear = PreviousPerformancePeriod__c.getAll().get('Year').value__c;
          System.debug('================' + acct.Country_Domain__c);
          //For Previous
          // if(acct.Country_Domain__c.contains('rvar')||acct.Country_Domain__c.contains('combo'))
          try{
                // new PerformanceEvalPreviousController(s.Id,'2','2010'); //For Residential Dealers                  
                new PerformanceEvalPreviousController(s.Id,prePeriod,preYear); //For Residential Dealers
          }catch(Exception ex){}
           //if(acct.Country_Domain__c.contains('cvar')||acct.Country_Domain__c.contains('combo'))      
          try{
                // new PerformanceEvalPreviousCommController(s.Id,'2','2010'); //For Commercial Dealers
                new PerformanceEvalPreviousCommController(s.Id,prePeriod,preYear); //For Commercial Dealers
          }catch(Exception ex){}
                
                 
      } 
   }

   global void finish(Database.BatchableContext BC){

   }
   
   public static testMethod void tst001(){
       String qury = 'select Id,Country_Domain__c from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\' OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null limit 10'; 
       evaluateBatchPrevious bc = new evaluateBatchPrevious();
       bc.Query = 'select Id,Country_Domain__c from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null limit 10';
       Test.startTest();
       Database.executeBatch(bc, 20);
       Test.stopTest();
   }


}