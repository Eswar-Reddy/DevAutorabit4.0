@isTest(seeAllData=true)
public class AgreementRedirectTest {

    private static testMethod void test_AgreementEditRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        echosign_dev1__SIGN_Agreement__c ag1 = [SELECT id from echosign_dev1__SIGN_Agreement__c LIMIT 1];
        AgreementEditRedirect controller = new AgreementEditRedirect (new ApexPages.StandardController(ag1));
        
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
    
    private static testMethod void test_AgreementEditRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
       echosign_dev1__SIGN_Agreement__c ag1 = [SELECT id from echosign_dev1__SIGN_Agreement__c LIMIT 1];
        AgreementEditRedirect controller = new AgreementEditRedirect(new ApexPages.StandardController(ag1));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_AgreementRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        echosign_dev1__SIGN_Agreement__c ag1 = [SELECT id from echosign_dev1__SIGN_Agreement__c LIMIT 1];
        AgreementRedirect controller = new AgreementRedirect(new ApexPages.StandardController(ag1));
        
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
    
    private static testMethod void test_AgreementRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       
       echosign_dev1__SIGN_Agreement__c ag1 = [SELECT id from echosign_dev1__SIGN_Agreement__c LIMIT 1];
        AgreementRedirect controller = new AgreementRedirect(new ApexPages.StandardController(ag1));
               
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