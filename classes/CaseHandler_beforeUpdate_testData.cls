@isTest
public class CaseHandler_beforeUpdate_testData {

    @TestVisible
    private static Account getNewAccount(String theater) {
        Account a = new Account();
        a.Name = 'account_1'; 
        a.BillingStreet = '100 XYZ Plaza';
        a.BillingCity = 'Sunnyvale';
        a.BillingState = 'CA';
        a.BillingCountry = 'United States'; 
        a.BillingPostalCode = '94086';     
        a.Theater__c = theater;
        
        return a;
    }
    
    @TestVisible
    private static Case getNewCase(String accountId, String ownerId) {
        Case c = new Case();
        c.AccountId = accountId;
        c.OwnerId = ownerId;
        
        return c;
    }
    
    @TestVisible
    private static User getNewUser(String userName, String profileName, String roleName) {
        User u = new User();
        
        UserRole ur = new UserRole(Name = roleName);
        insert ur;
        
        u.Alias = 'alia_1'; 
        u.Email = userName;
        u.EmailEncodingKey = 'UTF-8';
        u.FirstName = 'firstName_1';
        u.LastName = 'lastName_1';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
        u.UserRoleId = ur.Id;
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.UserName = userName; 
        
        // validation rule: An internal user must have a division and country
        u.Country = 'United States';
        u.Division = 'Test';   
    
        return u;
    }

}