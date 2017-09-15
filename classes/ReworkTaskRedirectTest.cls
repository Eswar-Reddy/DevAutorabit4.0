@isTest(seeAllData=true)
public class ReworkTaskRedirectTest {

    private static testMethod void test_EditcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Task_Rework_Request__c TRR_1 = [SELECT id from Task_Rework_Request__c LIMIT 1];
        TaskReworkEditRedirect controller = new TaskReworkEditRedirect(new ApexPages.StandardController(TRR_1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User cUser_1;
        system.runAs(u_1) {
            // avoid error MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated 
            // a non-setup object (or vice versa): User, original object: AccountShare
            UserManagement.IS_TEST = true;
            cUser_1 = CaseRedirectTestData.getNewCommunityUser('Partner Executive', 'cUser_1', td.contact_1.Id);
        }
        
        system.runAs(cUser_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
    private static testMethod void test_EditstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       Task_Rework_Request__c TRR_1 = [SELECT id from Task_Rework_Request__c LIMIT 1];
        
    
        TaskReworkRedirect controller = new TaskReworkRedirect(new ApexPages.StandardController(TRR_1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_communityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Task_Rework_Request__c TRR_1 = [SELECT id from Task_Rework_Request__c LIMIT 1];
        TaskReworkRedirect controller = new TaskReworkRedirect(new ApexPages.StandardController(TRR_1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User cUser_1;
        system.runAs(u_1) {
            // avoid error MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated 
            // a non-setup object (or vice versa): User, original object: AccountShare
            UserManagement.IS_TEST = true;
            cUser_1 = CaseRedirectTestData.getNewCommunityUser('Partner Executive', 'cUser_1', td.contact_1.Id);
        }
        
        system.runAs(cUser_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
    private static testMethod void test_standardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       Task_Rework_Request__c TRR_1 = [SELECT id from Task_Rework_Request__c LIMIT 1];
        
    
        TaskReworkRedirect controller = new TaskReworkRedirect(new ApexPages.StandardController(TRR_1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
}