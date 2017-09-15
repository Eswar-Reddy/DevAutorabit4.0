@isTest
public class CaseOpportunityTestData {
    public Account account_1;
    public Opportunity opportunity_1, opportunity_2;
    public List <Account> accountList;
    public List <Opportunity> opportunityList;
    
    public void createTestData_newCase() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
    
        // opportunity
        opportunity_1 = getNewOpportunity('oppty_1', account_1.Id);
        insert new List <Opportunity>{opportunity_1};
        
    }

    public void createTestData_opptyChange() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
    
        // opportunity
        opportunity_1 = getNewOpportunity('oppty_1', account_1.Id);
        opportunity_2 = getNewOpportunity('oppty_2', account_1.Id);
        insert new List <Opportunity>{opportunity_1, opportunity_2};
        
    }

    public void createTestData_batch(Integer batchSize) {
        // account
        accountList = new List <Account>();
        for (Integer i=0; i<batchSize; i++) {
            Account acc = getNewAccount('acc_' + i);
            accountList.add(acc);  
        } 
        insert accountList;
    
        // opportunity
        opportunityList = new List <Opportunity>();
        for (Integer i=0; i<batchSize; i++) {
            Opportunity oppty_1 = getNewOpportunity('oppty_1_' + i, accountList[i].Id);
            opportunityList.add(oppty_1);
        }
        insert opportunityList;
        
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
    
    private static Opportunity getNewOpportunity(String name, String accountId) {
        Opportunity oppty = new Opportunity();
        oppty.Name = name;
        oppty.AccountId = accountId;
        oppty.StageName = '20% - Opportunity Contacted';    // avoid null pointer exception
        oppty.CloseDate = System.today();    // required
        return oppty;    
    
    }
        
}