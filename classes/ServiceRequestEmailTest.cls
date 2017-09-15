@isTest
public class ServiceRequestEmailTest {

    private static testMethod void test_email_username() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_username();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.user_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.user_1.Id, ServiceRequestEmail.emailRequestList[0].targetObjectId);                
    }

    private static testMethod void test_email_profile() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_profile();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.user_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.user_1.Id, ServiceRequestEmail.emailRequestList[0].targetObjectId);                
    }

    private static testMethod void test_email_userRole() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_userRole();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.user_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.user_1.Id, ServiceRequestEmail.emailRequestList[0].targetObjectId);                
    }

    private static testMethod void test_email_profile_queue() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_profile_queue();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.queue_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(2, ServiceRequestEmail.emailRequestList.size());                
        Set <String> targetObjectIdSet = new Set <String>();
        for (ServiceRequestEmail.Request req : ServiceRequestEmail.emailRequestList) {
            targetObjectIdSet.add(req.targetObjectId);
        }                
        system.assertEquals(true, targetObjectIdSet.contains(td.user_1.Id));                
        system.assertEquals(true, targetObjectIdSet.contains(td.user_2.Id));                
    }

    private static testMethod void test_email_queue_noMembers() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_queue_noMembers();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.queue_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.queue_1.Email.toLowerCase(), ServiceRequestEmail.emailRequestList[0].toAddresses[0]);                
    }

    private static testMethod void test_email_OwnerChange() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_OwnerChange();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.user_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.user_1.Id, ServiceRequestEmail.emailRequestList[0].targetObjectId); 
        
        sr.OwnerId = td.user_2.Id;
        System.runAs(u) {
            update sr;
        }
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(td.user_2.Id, ServiceRequestEmail.emailRequestList[0].targetObjectId); 
                       
    }

    private static testMethod void test_email_profile_noTemplate() {
        ServiceRequestEmailTestData td = new ServiceRequestEmailTestData();
        td.createTestData_email_profile_noTemplate();    
        
        WorkOrder sr = new WorkOrder(CaseId = td.case_1.Id, OwnerId = td.user_1.Id);

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): WorkOrder, original object: EmailTemplate
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            insert sr;
        }
        system.assertNotEquals(null, sr.Id);                
        system.assertEquals(1, ServiceRequestEmail.emailRequestList.size());                
        system.assertEquals(null, ServiceRequestEmail.emailRequestList[0].templateId); 
        system.assertEquals(1, ServiceRequestEmail.emailResponseList.size());                
        // error: Either the plain text body or html body must be supplied
        system.assertEquals(false, ServiceRequestEmail.emailResponseList[0].isSuccess); 
    }

}