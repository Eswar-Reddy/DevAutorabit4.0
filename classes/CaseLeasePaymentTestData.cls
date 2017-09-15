@isTest
public class CaseLeasePaymentTestData {
    public Account account_1, account_2;
    public LeasePayment__c leasePayment_1, leasePayment_2;
    public Quote quote_1;
    public List <Account> accountList;
    public List <LeasePayment__c> leasePaymentList;
    public List <Quote> quoteList;
    
    public void createTestData_LeaseOld_NotBlank() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';   
        insert new List <LeasePayment__c>{leasePayment_1};
    }

    public void createTestData_Lease_Active() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';
        leasePayment_1.Status__c = 'Terminated';   
        leasePayment_2 = getNewLeasePayment('leasePayment_2', account_1.Id);
        leasePayment_2.Lease_old__c = '67890';   
        leasePayment_2.Status__c = 'Active';   
        insert new List <LeasePayment__c>{leasePayment_1, leasePayment_2};
    }

    public void createTestData_AccountChange() {
        // account
        account_1 = getNewAccount('account_1');   
        account_2 = getNewAccount('account_2');   
        insert new List <Account>{account_1, account_2};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';   
        leasePayment_2 = getNewLeasePayment('leasePayment_2', account_2.Id);
        leasePayment_2.Lease_old__c = '67890';   
        insert new List <LeasePayment__c>{leasePayment_1, leasePayment_2};
    }

    public void createTestData_AccountChange_NoLease() {
        // account
        account_1 = getNewAccount('account_1');   
        account_2 = getNewAccount('account_2');   
        insert new List <Account>{account_1, account_2};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';   
        insert new List <LeasePayment__c>{leasePayment_1};
    }

    public void createTestData_LeasePaymentChange() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';   
        leasePayment_2 = getNewLeasePayment('leasePayment_2', account_1.Id);
        leasePayment_2.Lease_old__c = '67890';   
        insert new List <LeasePayment__c>{leasePayment_1, leasePayment_2};
    }

    public void createTestData_OriginalLeaseNumber_NotBlank() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
        // opportunity
        Opportunity oppty_1 = getNewOpportunity('oppty_1', account_1.Id);
        insert new List <Opportunity>{oppty_1};
        // quote
        quote_1 = getNewQuote('quote_1', oppty_1.Id);
        quote_1.Original_Lease_Number__c = '12345';
        insert new List <Quote>{quote_1};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Quote__c = quote_1.Id;
        insert new List <LeasePayment__c>{leasePayment_1};
    }

    public void createTestData_SPVT() {
        // account
        account_1 = getNewAccount('account_1');   
        insert new List <Account>{account_1};
        // lease payment
        leasePayment_1 = getNewLeasePayment('leasePayment_1', account_1.Id);
        leasePayment_1.Lease_old__c = '12345';   
        insert new List <LeasePayment__c>{leasePayment_1};
    }

    public void createTestData_LeaseOld_Batch(Integer batchSize) {
        // account
        accountList = new List <Account>();
        for (Integer i=0; i<batchSize; i++) {
            Account a = getNewAccount('account_' + i);
            accountList.add(a); 
        }  
        insert accountList;
        // lease payment
        leasePaymentList = new List <LeasePayment__c>();
        for (Integer i=0; i<batchSize; i++) {
            LeasePayment__c lp = getNewLeasePayment('leasePayment_' + i, accountList[i].Id);
            lp.Lease_old__c = String.valueOf(i); 
            leasePaymentList.add(lp);  
        }
        insert leasePaymentList;
    }

    public void createTestData_OriginalLeaseNumber_Batch(Integer batchSize) {
        // account
        accountList = new List <Account>();
        for (Integer i=0; i<batchSize; i++) {
            Account a = getNewAccount('account_' + i);
            accountList.add(a); 
        }  
        insert accountList;
        // opportunity
        List <Opportunity> opptyList = new List <Opportunity>();
        for (Integer i=0; i<batchSize; i++) {
            Opportunity oppty = getNewOpportunity('oppty_' + i, accountList[i].Id);
            opptyList.add(oppty);
        }
        insert opptyList;
        // quote
        quoteList = new List <Quote>();
        for (Integer i=0; i<batchSize; i++) {
            Quote q = getNewQuote('quote_' + i, opptyList[i].Id);
            q.Original_Lease_Number__c = String.valueOf(i);
            quoteList.add(q);
        }
        insert quoteList;
        // lease payment
        leasePaymentList = new List <LeasePayment__c>();
        for (Integer i=0; i<batchSize; i++) {
            LeasePayment__c lp = getNewLeasePayment('leasePayment_' + i, accountList[i].Id);
            lp.Quote__c = quoteList[i].Id; 
            leasePaymentList.add(lp);  
        }
        insert leasePaymentList;
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
    
    private static LeasePayment__c getNewLeasePayment(String name, String accountId) {
        LeasePayment__c lp = new LeasePayment__c();
        lp.Name = name;
        lp.Account__c = accountId; 
        return lp;
    }
    
    private static Opportunity getNewOpportunity(String name, String accountId) {
        Opportunity oppty = new Opportunity();
        oppty.Name = name;
        oppty.AccountId = accountId;
        oppty.StageName = '20% - Opportunity Contacted';    // avoid null pointer exception
        oppty.CloseDate = System.today();    // required
        return oppty;    
    
    }

    private static Quote getNewQuote(String name, String opportunityId) {
        Quote q = new Quote();
        q.Name = name;
        q.OpportunityId = opportunityId;
        return q;    
    
    }
    
    
}