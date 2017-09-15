@isTest
public class CaseRedirectTestData {
    public Account account_1;
    public Contact contact_1;
    public Case case_1;
    
    public void createTestData() {
        account_1 = getNewAccount('account_1');
        insert new List <Account>{account_1}; 

        contact_1 =  getNewContact('fn_1', 'ln_1', account_1.Id);  
        insert new List <Contact>{contact_1};

        case_1 = getNewCase('case_1');
        insert new List <Case>{case_1};
    }
    
    private static Case getNewCase(String subject) {
        Case c = new Case();
        c.Subject = subject;
        return c;
    }

    @TestVisible
    private static User getNewCommunityUser(String profileName, String userName, String contactId) {
        User u_1 = getNewUser(profileName, userName);
        u_1.ContactId = contactId;
        u_1.PortalRole = 'Executive';
        
        return u_1;
    }
    
    private static Contact getNewContact(String firstName, String lastName, String accountId) {
        Contact c = new Contact();
        c.FirstName = firstName;
        c.LastName = lastName;
        c.AccountId = accountId;
    
        return c;
    }
    
    private static Account getNewAccount(String name) {
        Account a = new Account();
        a.Name = name;
        a.BillingStreet = '100 XYZ Plaza';
        a.BillingCity = 'Sunnyvale';
        a.BillingState = 'CA';
        a.BillingCountry = 'United States'; 
        a.BillingPostalCode = '94086';
        
        return a;
    }
    
    @TestVisible
    private static User getNewUser(String profileName, String userName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(
            Alias = userName, 
            Email = userName + '@testsp.com',
            EmailEncodingKey = 'UTF-8', 
            LastName = userName + 'LN', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', 
            UserName = userName + '@testsp.com',
            Country = 'United States',
            Division = 'IT');    
        
        return u;    
    }

}