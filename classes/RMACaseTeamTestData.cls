@isTest
public class RMACaseTeamTestData {
    public User user_1, user_2;
    public Case case_1;
    public RMA__c rma_1;

    public void createTestData_caseTeam() {
        // users
        user_1 =  getNewUser('Standard User', 'user_1');
        user_2 =  getNewUser('Standard User', 'user_2');
        insert new List <User>{user_1, user_2};
        
        // custom settings
        RMA_Settings__c s_1 = new RMA_Settings__c(Name = 'CaseTeam_RMAOwnerRole', Value__c = 'RMA Owner');
        RMA_Settings__c s_2 = new RMA_Settings__c(Name = 'CaseTeam_AddRMAOwner', Value__c = 'true');
        insert new List <RMA_Settings__c>{s_1, s_2};
    
        Account account_1 = getNewAccount('account_1');
        insert new List <Account>{account_1};
         
        case_1 = getNewCase('test', account_1.Id);
        insert new List <Case>{case_1}; 
        
        rma_1 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
        rma_1.RMA_Owner__c = user_1.Id; 
        insert new List <RMA__c>{rma_1}; 
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
    
    private static Case getNewCase(String subject, String accountId) {
        Case c = new Case();
        c.Subject = subject;
        c.AccountId = accountId;
        return c;    
    }
    
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