/*********************************************************************
    Test Class For Class "BatchCalculateTimeForCRMCases".
*********************************************************************/
@isTest
private class TestBatchCalculateTimeForCRMCases{
    
    static testMethod void testBatchCalculate() { 

        List<Case> cases = new List<Case>();
        Database.BatchableContext BC;
        BatchCalculateTimeForCRMCases batCalTime = new BatchCalculateTimeForCRMCases();
            batCalTime.Query='Select Id,BusinessHoursId, (Select Id,Start_Date__c, Time_With_Support__c From Case_metrics__r where End_Date__c = null) From Case Where RecordTypeId =:CRMCaseRecTypeId And OwnerId In:AppirioOwners AND Status != \'Closed\' limit 200';
            
            Database.executeBatch(batCalTime, 200);         

            Test.startTest();
            batCalTime.execute(BC, cases);
            Test.stopTest();
            batCalTime.finish(BC);
            

    }
}