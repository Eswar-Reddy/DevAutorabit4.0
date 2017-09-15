@isTest(seealldata=false)
private class TestBatchCalCloseOppRatio  {
       
  static testMethod void Test_BatchCalCloseOppRatio (){
        
        BatchCalCloseOppRatio batchCOR = new BatchCalCloseOppRatio();
        
        //RA - 23.SEPT.2014 - Added condition to avoid the "Attempted to schedule too many concurrent batch jobs in this org (limit is 5). " error message upon deployment to Production.
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){
            Database.executeBatch(batchCOR);
        }else {
           //schedule this same schedulable class again in 30 mins
           SchedBatchCOR SBatch = new SchedBatchCOR();
           Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,SBatch);
        }
        
        //SchedulableContext sc ;
        //SBatch.execute(sc);
    
        Id recordPartnerId = [SELECT Id,Name FROM RecordType WHERE Name = 'Partner' and Sobjecttype = 'Account' limit 1].id;
        Account objP1 = new Account(Name = 'test22',recordtypeId=recordPartnerId ,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
        Insert objP1;
        Opportunity opp = new Opportunity(Name='opp'+String.valueOf(DateTime.Now()),AccountID=objP1.id,closedate=date.today());
        
        Opp.StageName = 'Opportunity Lost';
        opp.Reason_Won_Lost__c='Insufficient budget';
        opp.Reason_Won_Lost_comments__c = 'Test';
        Opp.Opportunity_Status__c='Closed Won';
        Opp.Partner_Account_Id__c=objP1.Id;
        Opp.CreatedDate=System.now();
        Insert Opp; 
        BatchCalCloseOppRatio oppBatch = new BatchCalCloseOppRatio (); 
        oppBatch.query ='Select Id,Name, RecordTypeId ,Opportunity_Close__c From Account where RecordTypeId = \''+ recordPartnerId +'\'' ;
        Test.startTest();
        Database.executeBatch(oppBatch);
        Test.stopTest();      
          datetime chkdate = datetime.now();
        datetime chkdateforupdate = chkdate.addmonths(-6);
        datetime chkdateyear = chkdate.addYears(-1);  
        opp = new Opportunity(Name='opp'+String.valueOf(DateTime.Now()),AccountID=objP1.id,closedate=date.today());
        opp.Reason_Won_Lost__c='Insufficient budget';
        opp.Reason_Won_Lost_comments__c = 'Test';
        Opp.Opportunity_Status__c='Closed Won';
        Opp.StageName = 'Opportunity Lost';
        Opp.Partner_Account_Id__c=objP1.Id;
        Opp.CreatedDate=System.now();
        Insert Opp; 
        
        system.debug('Enter 1'+opp.AccountID);
        system.debug('Enter 2'+ objP1.Id);
        system.debug('Enter 3'+ opp.CreatedDate);
        system.debug('Enter 4'+ chkdateyear);   
        
  }
   static testMethod void Test_BatchCalCloseOppRatio1 (){
     Id recordResidentId = [SELECT Id,Name FROM RecordType WHERE Name = 'Residential' and Sobjecttype = 'lead' limit 1].id;     
     LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];     
      Lead l= new Lead();
     l.Status='new';
     l.LeadSource='Affilate';
     l.Street ='Adriatic Way';
     l.City='Santa Clara'; 
     l.State='CA';
     l.PostalCode='95051';
     l.Country='United States';
     l.Phone='1234567895'; 
     l.LastName = 'Test1';
     l.Email='a@gmail.com';
     l.Lead_Manufacturer__c='SunPower';
     l.recordtypeid=recordResidentId;
     l.Company='ABC';
     l.Theater__c = 'North America';
     insert l;
    /* Database.LeadConvert lc = new database.LeadConvert();
     lc.setLeadId(l.id);
     system.debug('>>>>>>>abhi'+lc);
     lc.setConvertedStatus(convertStatus.MasterLabel);              
     Database.LeadConvertResult lcr = Database.convertLead(lc);
     system.debug('>>>>>>>lcr>>>'+lcr);*/
    
       
   } 
  
}