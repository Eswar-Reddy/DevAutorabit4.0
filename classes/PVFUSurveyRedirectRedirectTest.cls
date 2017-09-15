@isTest(seeAllData=true)
public class PVFUSurveyRedirectRedirectTest {

    private static testMethod void test_PVFUSurveyEditRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Post_Visit_Follow_Up_Survey__c pvfus = [SELECT id from Post_Visit_Follow_Up_Survey__c LIMIT 1];
        PVFUSurveyEditRedirect controller = new PVFUSurveyEditRedirect(new ApexPages.StandardController(pvfus));
        
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
    
    private static testMethod void test_PVFUSurveyEditRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
       Post_Visit_Follow_Up_Survey__c pvfus = [SELECT id from Post_Visit_Follow_Up_Survey__c LIMIT 1];
        PVFUSurveyEditRedirect controller = new PVFUSurveyEditRedirect(new ApexPages.StandardController(pvfus));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_PVFUSurveyRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Post_Visit_Follow_Up_Survey__c pvfus = [SELECT id from Post_Visit_Follow_Up_Survey__c LIMIT 1];
        PVFUSurveyRedirect controller = new PVFUSurveyRedirect(new ApexPages.StandardController(pvfus));
        
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
    
    private static testMethod void test_PVFUSurveyRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       
       Post_Visit_Follow_Up_Survey__c pvfus = [SELECT id from Post_Visit_Follow_Up_Survey__c LIMIT 1];
        PVFUSurveyRedirect controller = new PVFUSurveyRedirect(new ApexPages.StandardController(pvfus));
               
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