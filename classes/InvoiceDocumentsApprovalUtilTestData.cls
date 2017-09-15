@isTest
public class InvoiceDocumentsApprovalUtilTestData {
    private Account account_1;
    public Account responsiblePartner_1, responsiblePartner_2;
    private LeasePayment__c leasePayment_1;
    public Invoice_Documents__c invoiceDocument_1, invoiceDocument_2, invoiceDocument_3;

    public void createTestData_new_1nr() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_1.Not_Required_for_Approval__c = true;
        insert new List <Invoice_Documents__c>{invoiceDocument_1};
        
    }

    public void createTestData_new_1a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1};
        
    }
    
    public void createTestData_new_1a_1na() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Pending';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
    }

    public void createTestData_new_2a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Approved';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
    }

    public void createTestData_new_2a_1nr() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Approved';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_3');
        invoiceDocument_3.Status__c = 'Pending';
        invoiceDocument_3.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3.Not_Required_for_Approval__c = true;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2, invoiceDocument_3};
        
    }

    public void createTestData_new_3a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        responsiblePartner_2 = getNewAccount('responsiblePartner_2');
        insert new List <Account>{account_1, responsiblePartner_1, responsiblePartner_2};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Approved';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_3');
        invoiceDocument_3.Status__c = 'Approved';
        invoiceDocument_3.Responsible_Partner__c = responsiblePartner_2.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2, invoiceDocument_3};
        
    }

    public void createTestData_update_1nr() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Pending';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_1.Not_Required_for_Approval__c = true;
        insert new List <Invoice_Documents__c>{invoiceDocument_1};
        
        invoiceDocument_1.Status__c = 'Approved';
        update invoiceDocument_1;
        
    }

    public void createTestData_update_1ua_1a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Pending';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Pending';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
        invoiceDocument_1.Status__c = 'Approved';
        update invoiceDocument_1;
        
    }

    public void createTestData_update_2a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Pending';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Pending';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_2.Status__c = 'Approved';
        update new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
    }

    public void createTestData_update_2a_1nr() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Pending';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Pending';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_3');
        invoiceDocument_3.Status__c = 'Pending';
        invoiceDocument_3.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3.Not_Required_for_Approval__c = true;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2, invoiceDocument_3};
        
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_2.Status__c = 'Approved';
        update new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
    }

    public void createTestData_update_3a() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        responsiblePartner_2 = getNewAccount('responsiblePartner_2');
        insert new List <Account>{account_1, responsiblePartner_1, responsiblePartner_2};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Pending';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Pending';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_3 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_3');
        invoiceDocument_3.Status__c = 'Pending';
        invoiceDocument_3.Responsible_Partner__c = responsiblePartner_2.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2, invoiceDocument_3};
        
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_2.Status__c = 'Approved';
        invoiceDocument_3.Status__c = 'Approved';
        update new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2, invoiceDocument_3};
        
    }

    public void createTestData_update_2a_1ua() {
        account_1 = getNewAccount('account_1');
        responsiblePartner_1 = getNewAccount('responsiblePartner_1');
        insert new List <Account>{account_1, responsiblePartner_1};  
        
        leasePayment_1 = getNewLeasePayment(account_1.Id, 'leasePayment_1');
        insert new List <LeasePayment__c>{leasePayment_1};
          
        invoiceDocument_1 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_1');
        invoiceDocument_1.Status__c = 'Approved';
        invoiceDocument_1.Responsible_Partner__c = responsiblePartner_1.Id;
        invoiceDocument_2 = getNewInvoiceDocument(leasePayment_1.Id, 'invoiceDocument_2');
        invoiceDocument_2.Status__c = 'Approved';
        invoiceDocument_2.Responsible_Partner__c = responsiblePartner_1.Id;
        insert new List <Invoice_Documents__c>{invoiceDocument_1, invoiceDocument_2};
        
        invoiceDocument_1.Status__c = 'Pending';
        update new List <Invoice_Documents__c>{invoiceDocument_1};
        
    }
    
    private static Account getNewAccount(String name) {
        Account a = new Account();
        a.Name = name;
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'San Jose';
        a.BillingState = 'CA';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '95087';
        return a;    
    }

    private static LeasePayment__c getNewLeasePayment(String accountId, String name) {
        LeasePayment__c lp = new LeasePayment__c();
        lp.Account__c = accountId;
        lp.Name = name;
        return lp;    
    }

    private static Invoice_Documents__c getNewInvoiceDocument(String lpId, String name) {
        Invoice_Documents__c doc = new Invoice_Documents__c();
        doc.Lease_Payment__c = lpId;
        doc.Name = name;
        doc.Invoice_Type__c = 'Install';
        doc.Not_Required_for_Approval__c = false;
        return doc;    
    }
    
}