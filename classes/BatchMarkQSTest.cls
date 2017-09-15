/*********************************************************************
    Test Class For Class "BatchMarkQS".
*********************************************************************/
@isTest(seealldata = true) 
private class BatchMarkQSTest{
    
    static testMethod void BatchMarkQSTest() { 

        List<Quote_Summary__c> lstQS = new List<Quote_Summary__c>();
        Database.BatchableContext BC;
        BatchMarkQS batMarkQS = new BatchMarkQS();
            //batMarkQS.Query='Select Id,BusinessHoursId, (Select Id,Start_Date__c, Time_With_Support__c From Case_metrics__r where End_Date__c = null) From Case Where RecordTypeId =:CRMCaseRecTypeId And OwnerId In:AppirioOwners AND Status != \'Closed\' limit 200';
            
            batMarkQS.Query='Select Id,createddate,Locked_Scenario__c,DM__c,(Select Id From Quotes__r) From Quote_Summary__c WHERE Locked_Scenario__c = null ORDER BY createddate asc limit 200';
            
            Database.executeBatch(batMarkQS, 200);         

            Test.startTest();
            batMarkQS.execute(BC, lstQS);
            //batMarkQS.finish(BC); 
            Test.stopTest();
                       

    }
}