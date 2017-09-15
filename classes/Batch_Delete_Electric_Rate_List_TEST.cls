/**
 * Created by cdevarapalli on 8/1/17.
 */
@isTest
private class Batch_Delete_Electric_Rate_List_TEST {

    @testSetup
    static void dataSetup() {
        insert new List<Electric_Rate_List__c>{
                new Electric_Rate_List__c(Name = 'TestElectricRateList1')
        };
    }

    static testMethod void test_Batch_Delete_Electric_Rate_List() {
        test.startTest();
            Batch_Delete_Electric_Rate_List bderl = new Batch_Delete_Electric_Rate_List('SELECT Id from Electric_Rate_List__c', true);
            Database.executeBatch(bderl,2000);
        test.stopTest();
    }
}