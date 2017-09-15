@isTest(seeAllData=true)
public class ResidentialProjectRedirectTest {

    private static testMethod void test_ResidentialProjectEditRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Residential_Project__c rp = [SELECT id from Residential_Project__c LIMIT 1];
        ResidentialProjectEditRedirect controller = new ResidentialProjectEditRedirect(new ApexPages.StandardController(rp));
        
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
    
    private static testMethod void test_ResidentialProjectEditRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
       Residential_Project__c rp = [SELECT id from Residential_Project__c LIMIT 1];
        ResidentialProjectEditRedirect controller = new ResidentialProjectEditRedirect(new ApexPages.StandardController(rp));
        
        User u_1 = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        User user_1;
        system.runAs(u_1) {
            user_1 = CaseRedirectTestData.getNewUser('Standard User', 'cUser_1');
        }
        
        system.runAs(user_1) {
            PageReference pr = controller.redirect();
        }
        
    }
    
     private static testMethod void test_ResidentialProjectRedirectcommunityUser() {
    
        CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
        
        Residential_Project__c rp = [SELECT id from Residential_Project__c LIMIT 1];
        ResidentialProjectEditRedirect controller = new ResidentialProjectEditRedirect(new ApexPages.StandardController(rp));
        
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
    
    private static testMethod void test_ResidentialProjectRedirectstandardUser() {
       CaseRedirectTestData td = new CaseRedirectTestData();
        td.createTestData();
       
       Residential_Project__c rp = [SELECT id from Residential_Project__c LIMIT 1];
        ResidentialProjectRedirect controller = new ResidentialProjectRedirect(new ApexPages.StandardController(rp));
               
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