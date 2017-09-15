global class BatchCalculateTimeForCRMCases implements Database.Batchable<sObject>{

   //Global variables
   global String Query;
   global Set<Id> AppirioOwners = CaseMetricManagment.BirlasoftOwners ;
   global Id CRMCaseRecTypeId = CaseMetricManagment.CRMCaseRecTypeId ;
   
   global BatchCalculateTimeForCRMCases(){
        
        Query='Select Id,BusinessHoursId, (Select Id,Start_Date__c, Time_With_Support__c From Case_metrics__r where End_Date__c = null) From Case Where RecordTypeId =:CRMCaseRecTypeId And OwnerId In:AppirioOwners AND Status != \'Closed\'';
        system.debug('kkkkkkkk Query kkkkkkkkk'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
       system.debug('kkkk query kkkk'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<Case> cases){
        List<Case_metric__c> caseMetricToUpdate = new List<Case_metric__c>();
        List<Case> caseToUpdate = new List<Case>();
        
        for(Case cs : cases){  
          if(cs.Case_metrics__r.size() > 0){
              //metric update will automatically update case Time_With_Customer__c
              for(Case_metric__c caseMetric : cs.Case_metrics__r){
                  caseMetric.Time_With_Support__c = CaseMetricManagment.getBusinessHoursInBetween(cs.BusinessHoursId,caseMetric.Start_Date__c, datetime.now());
              }
              caseMetricToUpdate.addAll(cs.Case_metrics__r);          
          }else{
              //update Time_With_Customer__c for the cases pending at user side for the complete day
              caseToUpdate.add(cs);        
          }
        } 
        
        if(caseMetricToUpdate.size() > 0){
            update caseMetricToUpdate;
        }
        if(caseToUpdate.size() > 0){
            update caseToUpdate;
        }
    }

   global void finish(Database.BatchableContext BC){
   }
   
   

}