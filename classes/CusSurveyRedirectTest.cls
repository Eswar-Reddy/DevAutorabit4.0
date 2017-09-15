@isTest(seeAllData=true)
public class CusSurveyRedirectTest {

    private static testMethod void test_CusSurveyEditRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Customer_Survey_Result__c csr = [SELECT id from Customer_Survey_Result__c LIMIT 1];
        CusSurveyEditRedirect controller = new CusSurveyEditRedirect (new ApexPages.StandardController(csr));
        
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
    
    private static testMethod void test_CusSurveyEditRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
       Customer_Survey_Result__c csr = [SELECT id from Customer_Survey_Result__c LIMIT 1];
        CusSurveyEditRedirect controller = new CusSurveyEditRedirect(new ApexPages.StandardController(csr));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_CusSurveyRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Customer_Survey_Result__c csr = [SELECT id from Customer_Survey_Result__c LIMIT 1];
        CusSurveyRedirect controller = new CusSurveyRedirect(new ApexPages.StandardController(csr));
        
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
    
    private static testMethod void test_CusSurveyRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       
       Customer_Survey_Result__c csr = [SELECT id from Customer_Survey_Result__c LIMIT 1];
        CusSurveyRedirect controller = new CusSurveyRedirect(new ApexPages.StandardController(csr));
               
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