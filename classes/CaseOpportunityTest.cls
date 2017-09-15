@isTest
public class CaseOpportunityTest {
    private static testMethod void test_newCase() {
        CaseOpportunityTestData td = new CaseOpportunityTestData();
        td.createTestData_newCase();
    
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        c_1.Opportunity__c = td.opportunity_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        Opportunity oppty_1 = [SELECT Commercial_Project_num__c FROM Opportunity WHERE Id = :td.opportunity_1.Id];
        c_1 = [SELECT Commercial_Project_num__c FROM Case WHERE Id = :c_1.Id];
        system.assertNotEquals(null, c_1.Commercial_Project_num__c);
        system.assertEquals(oppty_1.Commercial_Project_num__c, c_1.Commercial_Project_num__c);
    }

    private static testMethod void test_opptyChange() {
        CaseOpportunityTestData td = new CaseOpportunityTestData();
        td.createTestData_opptyChange();
    
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        c_1.Opportunity__c = td.opportunity_1.Id;
        insert new List <Case>{c_1};
        
        // update case
        c_1.Opportunity__c = td.opportunity_2.Id;
        update new List <Case>{c_1};
        
        // requery and verify
        Opportunity oppty_1 = [SELECT Commercial_Project_num__c FROM Opportunity WHERE Id = :td.opportunity_1.Id];
        Opportunity oppty_2 = [SELECT Commercial_Project_num__c FROM Opportunity WHERE Id = :td.opportunity_2.Id];
        c_1 = [SELECT Commercial_Project_num__c FROM Case WHERE Id = :c_1.Id];
        system.assertNotEquals(null, c_1.Commercial_Project_num__c);
        system.assertNotEquals(oppty_1.Commercial_Project_num__c, c_1.Commercial_Project_num__c);
        system.assertEquals(oppty_2.Commercial_Project_num__c, c_1.Commercial_Project_num__c);
    }

    private static testMethod void test_opptyChange_Blank() {
        CaseOpportunityTestData td = new CaseOpportunityTestData();
        td.createTestData_newCase();
    
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        c_1.Opportunity__c = td.opportunity_1.Id;
        insert new List <Case>{c_1};
        
        // update case
        c_1.Opportunity__c = null;
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Commercial_Project_num__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(null, c_1.Commercial_Project_num__c);
    }

    private static testMethod void test_commercialProjectChange() {
        CaseOpportunityTestData td = new CaseOpportunityTestData();
        td.createTestData_opptyChange();
    
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        c_1.Opportunity__c = td.opportunity_1.Id;
        insert new List <Case>{c_1};
        
        // update case
        c_1.Commercial_Project_num__c = 'test001';
        update new List <Case>{c_1};
        
        // requery and verify
        Opportunity oppty_1 = [SELECT Commercial_Project_num__c FROM Opportunity WHERE Id = :td.opportunity_1.Id];
        c_1 = [SELECT Commercial_Project_num__c FROM Case WHERE Id = :c_1.Id];
        system.assertNotEquals('test001', c_1.Commercial_Project_num__c);
        system.assertEquals(oppty_1.Commercial_Project_num__c, c_1.Commercial_Project_num__c);
    }
    
    private static testMethod void test_Batch() {
        Integer batchSize = 20;
        CaseOpportunityTestData td = new CaseOpportunityTestData();
        td.createTestData_Batch(batchSize);
        
        List <Case> caseList = new List <Case>();
        for (Integer i=0; i<batchSize; i++) {
            Case c = new Case();
            c.AccountId = td.accountList[i].Id;
            c.Opportunity__c = td.opportunityList[i].Id;
            caseList.add(c);
        }
        insert caseList;
        
        // requery and verify
        Map <String, Opportunity> opptyMap = new Map <String, Opportunity>([SELECT Id, Commercial_Project_num__c 
            FROM Opportunity WHERE Id IN :td.opportunityList]);
        
        caseList = [SELECT Opportunity__c, Commercial_Project_num__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.opportunityList[i].Id, caseList[i].Opportunity__c);
            system.assertEquals(opptyMap.get(td.opportunityList[i].Id).Commercial_Project_num__c, caseList[i].Commercial_Project_num__c);
        }
        
        // update Opportunity__c
        for (Integer i=0; i<batchSize; i++) {
            caseList[i].Opportunity__c = td.opportunityList[batchSize-1-i].Id;
        }
        update caseList;

        // requery and verify
        caseList = [SELECT Opportunity__c, Commercial_Project_num__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.opportunityList[batchSize-1-i].Id, caseList[i].Opportunity__c);
            system.assertEquals(opptyMap.get(td.opportunityList[batchSize-1-i].Id).Commercial_Project_num__c, caseList[i].Commercial_Project_num__c);
        }
        
    }    

}