/*********************************************************************
    Test Class For Class "BatchUpdateQuote".
*********************************************************************/
@isTest(seealldata = true) 
private class BatchUpdateQuoteTest{
    
    static testMethod void BatchCloneQSMarked2Test() { 

        List<Quote> lstQ = new List<Quote>();
        Database.BatchableContext BC;
        BatchUpdateQuote batMarkQ = new BatchUpdateQuote();
            
        batMarkQ.Query=' Select id, (select id, quote__c, Current_Quantity_kWh__c from Electric_Bill_Details__r) from quote where createddate >= 2013-06-17T00:00:00.000Z And RecordtypeId=\'01280000000PzNK\' limit 10 ';
            
        Database.executeBatch(batMarkQ, 200);         

        Test.startTest();
          batMarkQ.execute(BC, lstQ);
        Test.stopTest();
                       

    }
}