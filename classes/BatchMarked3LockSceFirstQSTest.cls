/*********************************************************************
    Test Class For Class "BatchMarked3LockSceFirstQS".
*********************************************************************/
@isTest(seealldata = true) 
private class BatchMarked3LockSceFirstQSTest{
    
    static testMethod void BatchMarked3LockSceFirstQSTest() { 

        List<Quote_Summary__c> lstQ = new List<Quote_Summary__c>();
        Database.BatchableContext BC;
        BatchMarked3LockSceFirstQS batMarkQ = new BatchMarked3LockSceFirstQS();
            
            batMarkQ.Query='Select Id,Account_Name__c,Comments__c,CPR_Company_ID__c,CPR_License_ID__c,CPR_QuoteID__c,Create_Amendment_Doc__c,Create_Lease_Docs__c,Create_Termination_Doc__c,CurrencyIsoCode,Dealer_Account__c,Dealer_Installer__c,Dealer__c,Description__c,Edit_Quote_in_CPR__c,Install_Date__c,IsDeleted,Islocked__c,Lease_Doc_Signed__c,Lease_Doc_Terminated__c,Lease_Number__c,Lease_to_be_Amended__c,Lessee__c,Locked_Scenario_Formula__c,Locked_Scenario__c,Name,Old_Lease_Number__c,Old_Quote__c,Opportunity__c,Override_30KW_Limit__c,Override__c,OwnerId,Primary_PSR__c,Quote_Number__c,Quote_View__c,View_Quote__c,(Select Id,Quote_Summary__c From Quotes__r   ORDER BY  Lease_Number__c limit 1) FROM Quote_Summary__c WHERE DMDone__c = 6030330 OR DMDone__c = 6030320 order by createddate asc limit 10';
            
            Database.executeBatch(batMarkQ, 200);         

            Test.startTest();
            batMarkQ.execute(BC, lstQ);
            //batMarkQ.finish(BC); 
            Test.stopTest();
                       

    }
}