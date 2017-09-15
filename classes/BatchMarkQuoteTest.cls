/*********************************************************************
    Test Class For Class "BatchMarkQuote".
*********************************************************************/
@isTest(seealldata = true) 
private class BatchMarkQuoteTest{
    
    static testMethod void BatchMarkQuoteTest() { 

        List<Quote_Summary__c> lstQ = new List<Quote_Summary__c>();
        Database.BatchableContext BC;
        BatchMarkQuote batMarkQ = new BatchMarkQuote();
            
            batMarkQ.Query='Select Id,DM__c,createddate,Locked_Scenario__c,(Select Id,DM__c From Quotes__r) From Quote_Summary__c WHERE (DM__c = 603033 OR DM__c = 603032) ORDER BY createddate asc  limit 200';
            
            Database.executeBatch(batMarkQ, 200);         

            Test.startTest();
            batMarkQ.execute(BC, lstQ);
            //batMarkQ.finish(BC); 
            Test.stopTest();
                       

    }
}