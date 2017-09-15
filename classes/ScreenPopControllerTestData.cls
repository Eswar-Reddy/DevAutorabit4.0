@isTest
public class ScreenPopControllerTestData {
    public Account account_1;
    public Contact contact_1;
    public Case case_1;
    public Opportunity opportunity_1;
    
    public void createTestData_oneAccount() {
        account_1 = getNewAccount('account_1');    
        account_1.Phone = '1112223333';
        insert new List <Account>{account_1};
        
        case_1 = getNewCase('case_1', account_1.Id);
        insert new List <Case>{case_1};
        
        opportunity_1 = getNewOpportunity('opportunity_1', account_1.Id);
        insert new List <Opportunity>{opportunity_1};
        
    }

    public void createTestData_oneContact() {
        account_1 = getNewAccount('account_1');    
        account_1.Phone = '1112223333';
        insert new List <Account>{account_1};
        
        contact_1 = getNewContact('fn_1', 'ln_1', account_1.Id);
        contact_1.Phone = '5556667777';
        insert new List <Contact>{contact_1};
        
        case_1 = getNewCase('case_1', account_1.Id);
        insert new List <Case>{case_1};
        
        opportunity_1 = getNewOpportunity('opportunity_1', account_1.Id);
        insert new List <Opportunity>{opportunity_1};
        
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
    
    private static Contact getNewContact(String firstName, String lastName, String accountId) {
        Contact c = new Contact();
        c.FirstName = firstName;
        c.LastName = lastName;
        c.AccountId = accountId;
        return c;
    }
    
    private static Case getNewCase(String subject, String accountId) {
        Case c = new Case();
        c.Subject = subject;
        c.AccountId = accountId;
        return c;    
    }
    
    private static Opportunity getNewOpportunity(String name, String accountId) {
        Opportunity oppty = new Opportunity();
        oppty.Name = name;
        oppty.AccountId = accountId;
        oppty.StageName = '20% - Opportunity Contacted';    // avoid null pointer exception
        oppty.CloseDate = System.today();    // required
        return oppty;    
    }
    
}