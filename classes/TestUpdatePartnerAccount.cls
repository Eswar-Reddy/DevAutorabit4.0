@isTest
private class TestUpdatePartnerAccount {

  static testMethod void Test_UpdatePartnerAccount(){
          
        //execute batch
          //SchedBatchUpdatePAccount SBatch = new SchedBatchUpdatePAccount ();
          //SchedulableContext sc ;
          //SBatch.execute(sc);
    
        String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
        UpdatePartnerAccount.isRunningTest = true;
      
        Id  recordResidentId = [SELECT Id,Name FROM RecordType WHERE Name = 'Residential' and Sobjecttype = 'lead' limit 1].id;
        Account objP1 = new Account(Name = 'test22',recordtypeId=recType1,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
        Insert objP1;
        UpdatePartnerAccount oppBatch = new UpdatePartnerAccount(); 
        oppBatch.query ='Select Id, BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Geo__Latitude__s,Geo__Longitude__s,recordtypeid  FROM Account  where recordtypeid  =recType1 and BillingCity != null and BillingState!= null and BillingStreet!= null  AND GEO__Latitude__s = null Limit 500' ;
        Test.startTest();
         //RA - 23.SEPT.2014 - Added condition to avoid the "Attempted to schedule too many concurrent batch jobs in this org (limit is 5). " error message upon deployment to Production.
         if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){
             Database.executeBatch(oppBatch);
        }else {
           //schedule this same schedulable class again in 30 mins
           SchedBatchUpdatePAccount SBatch = new SchedBatchUpdatePAccount ();
           Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,SBatch);
        }
        Test.stopTest();
        
  }
}