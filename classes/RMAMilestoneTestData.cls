@isTest
public class RMAMilestoneTestData {
    public RMA__c rma_1;

    public void createTestData_createMilestones() {
        // custom settings
        RMA_Settings__c s_1 = new RMA_Settings__c(Name = 'Milestone_01', Value__c = 'Milestone_01');
        RMA_Settings__c s_2 = new RMA_Settings__c(Name = 'Milestone_02', Value__c = 'Milestone_02');
        insert new List <RMA_Settings__c>{s_1, s_2};
    
        Account account_1 = getNewAccount('account_1');
        insert new List <Account>{account_1};
         
        Case case_1 = getNewCase('test', account_1.Id);
        insert new List <Case>{case_1}; 
        
        rma_1 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
        insert new List <RMA__c>{rma_1}; 
    }

    public void createTestData_setDate() {
        // custom settings
        RMA_Settings__c s_1 = new RMA_Settings__c(Name = 'Milestone_01', Value__c = 'Milestone_01');
        insert new List <RMA_Settings__c>{s_1};
    
        Account account_1 = getNewAccount('account_1');
        insert new List <Account>{account_1};
         
        Case case_1 = getNewCase('test', account_1.Id);
        insert new List <Case>{case_1}; 
        
        rma_1 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
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

}