@isTest
public class CaseEmailRollupTest {

    private static testMethod void testNewEmail() {
        CaseEmailRollupTestData td = new CaseEmailRollupTestData();    
        td.createTestData();    
    
        // requery and verify
        system.assertEquals(1, [SELECT New_Emails_Count__c FROM Case WHERE Id = :td.case_1.Id].New_Emails_Count__c);
    }

    private static testMethod void testNewEmailBulk() {
        CaseEmailRollupTestData td = new CaseEmailRollupTestData();    
        td.createTestDataBulk(20, 10);    
    
        // requery and verify
        List <Case> caseList = [SELECT New_Emails_Count__c FROM Case WHERE Id IN :td.caseList_1];
        for (Case c : caseList) {
            system.assertEquals(10, c.New_Emails_Count__c);
        }
        
    }
    
}