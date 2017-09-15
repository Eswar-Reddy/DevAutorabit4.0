global class IncentiveBatch implements Database.Batchable<sObject>{
   
   global Set<String> countryDomains;
   global String Query;

   global IncentiveBatch(){
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
         //For Current Period
         acct = (Account)s;
         System.debug('================' + acct.Country_Domain__c);
         if(acct.Country_Domain__c.contains('rvar')||acct.Country_Domain__c.contains('combo')){
                new IncentiveCls(s.Id); //For Current Residential Dealers
         }
         if(acct.Country_Domain__c.contains('cvar')||acct.Country_Domain__c.contains('combo')){  
                new incentiveCommCls(s.Id);//For Current Commercial Dealers
         }
         //For Previous Period 
         String prePeriod = PreviousPerformancePeriod__c.getAll().get('Period').value__c;       
         String preYear = PreviousPerformancePeriod__c.getAll().get('Year').value__c;
         try{
            new IncentiveDetailPrevController(s.Id,prePeriod,preYear);//For Previous Residential Dealers
         }catch(Exception ex){}
         
         try{
            new IncentiveDetailPrevCommController(s.Id,prePeriod,preYear);//For Previous Commercial Dealers
         }catch(Exception ex){}          
        
        
          //new incentivePrevious(s.Id); // had to be run only till July 31
          //new IncentiveDetailPrevController(s.Id,'2','2010');//For Previous Residential Dealers
          //new IncentiveDetailPrevCommController(s.Id,'2','2010');//For Previous Commercial Dealers 
          
       }      
   }

   global void finish(Database.BatchableContext BC){

   }
   
   public static testMethod void tst001(){
       String qury = 'select Id,Country_Domain__c from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null  limit 10'; 
       IncentiveBatch bc = new IncentiveBatch();
       bc.Query = 'select Id,Country_Domain__c from Account where (Country_Domain__c=\'rvar-de\' OR Country_Domain__c=\'cvar-de\'OR Country_Domain__c=\'rvar-it\' OR Country_Domain__c=\'cvar-it\'OR Country_Domain__c=\'rvar-us\') and Type!=null  limit 10'; 
       Test.startTest();
       Database.executeBatch(bc, 20);
       Test.stopTest();
   }

}