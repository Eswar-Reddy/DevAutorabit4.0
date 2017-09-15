@isTest
public class RMAMilestoneTest {
    private static testMethod void test_createMilestones() {
        RMAMilestoneTestData td = new RMAMilestoneTestData();
        td.createTestData_createMilestones();
        
        List <RMA_Milestone__c> msList = [SELECT Name FROM RMA_Milestone__c WHERE RMA__c = :td.rma_1.Id];
        system.assertEquals(2, msList.size());
        Set <String> msNameSet = new Set <String>();
        for (RMA_Milestone__c ms : msList) {
            msNameSet.add(ms.Name);
        }
        system.assertEquals(true, msNameSet.contains('Milestone_01'));
        system.assertEquals(true, msNameSet.contains('Milestone_02'));
    }

    private static testMethod void test_setDate() {
        RMAMilestoneTestData td = new RMAMilestoneTestData();
        td.createTestData_setDate();
        
        RMA_Milestone__c ms = [SELECT Name FROM RMA_Milestone__c WHERE RMA__c = :td.rma_1.Id];
        ms.Status__c = 'Completed';
        update ms;
        ms = [SELECT Date__c FROM RMA_Milestone__c WHERE RMA__c = :td.rma_1.Id];    // requery
        system.assertEquals(system.today(), ms.Date__c);
        ms.Status__c = null;
        update ms;
        ms = [SELECT Date__c FROM RMA_Milestone__c WHERE RMA__c = :td.rma_1.Id];    // requery
        system.assertEquals(null, ms.Date__c);
    }
    
}