@IsTest (SeeAllData=true)
public with sharing class TestBatch_ConvertLead {

    static testMethod void testBatchConvertLead()
    {
        /*Lead l = TestALRCommon.CreateRawLead('Test', 'Web', '', '');
        l.IsAutoConvert__c = true;
        l.Status = 'Awaiting Duplicate Review';
        insert l;

        Batch_ConvertLead b = new Batch_ConvertLead();

        Test.startTest();
        String query = 'SELECT Id, Status, FirstName, Lastname, Company, street, city, state, postalCode, country, Email, isConverted, OwnerId, Campaign_ID__c, IsAutoConvert__c , Dealer_Locator_Selection__c FROM Lead where isConverted = false limit 1';
        List<Lead> listLeads = Database.query(query);

        Id batchProcessId = Database.executeBatch(b,1);
        b.execute(null, listLeads); //Strange but I needed this line to actually get coverage

        Test.stopTest();*/

    }

}