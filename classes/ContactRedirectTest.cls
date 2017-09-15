@isTest(seeAllData=true)
public class ContactRedirectTest {

    private static testMethod void test_AccontEditcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Contact C1 = [SELECT id from Contact LIMIT 1];
        ContactEditRedirect controller = new ContactEditRedirect(new ApexPages.StandardController(C1));
        
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
    
    private static testMethod void test_AccontEditstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
       Contact C1 = [SELECT id from Contact LIMIT 1];
        ContactEditRedirect controller = new ContactEditRedirect(new ApexPages.StandardController(C1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_ContactRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Contact C1 = [SELECT id from Contact LIMIT 1];
        ContactRedirect controller = new ContactRedirect(new ApexPages.StandardController(C1));
        
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
    
    private static testMethod void test_ContactRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       
       Contact C1 = [SELECT id from Contact LIMIT 1];
        ContactRedirect controller = new ContactRedirect(new ApexPages.StandardController(C1));
               
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