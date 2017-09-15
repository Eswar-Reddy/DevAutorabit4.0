@isTest
public class CaseLeasePaymentTest {

    private static testMethod void test_LeaseOld_NotBlank() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeaseOld_NotBlank();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
            
    }

    private static testMethod void test_Lease_Active() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_Lease_Active();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_2.Id, c_1.Lease_Payment__c);
        system.assertEquals('67890', c_1.Lease__c);
            
    }

    private static testMethod void test_OriginalLeaseNumber_NotBlank() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_OriginalLeaseNumber_NotBlank();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
            
    }

    private static testMethod void test_AccountChange() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_AccountChange();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);

        // update account
        c_1.AccountId = td.account_2.Id;
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_2.Id, c_1.Lease_Payment__c);
        system.assertEquals('67890', c_1.Lease__c);
            
    }

    private static testMethod void test_AccountChange_NoLease() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_AccountChange_NoLease();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);

        // update account
        c_1.AccountId = td.account_2.Id;
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(null, c_1.Lease_Payment__c);
        system.assertEquals(null, c_1.Lease__c);
            
    }

    private static testMethod void test_LeasePaymentChange() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeasePaymentChange();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);

        // update lease payment
        c_1.Lease_Payment__c = td.leasePayment_2.Id;
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_2.Id, c_1.Lease_Payment__c);
        system.assertEquals('67890', c_1.Lease__c);
            
    }

    private static testMethod void test_LeasePaymentChange_Blank() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeasePaymentChange();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);

        // update lease payment
        c_1.Lease_Payment__c = null;
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(null, c_1.Lease_Payment__c);
        system.assertEquals(null, c_1.Lease__c);
            
    }

    private static testMethod void test_LeaseNumberChange() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeasePaymentChange();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);

        // update lease number
        c_1.Lease__c = '67890';
        update new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
            
    }

    private static testMethod void test_LeaseOld_Change() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeaseOld_NotBlank();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
        
        // update Lease_old__c 
        td.leasePayment_1.Lease_old__c = '67890';
        update td.leasePayment_1;
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('67890', c_1.Lease__c);
            
    }

    private static testMethod void test_OriginalLeaseNumber_Change() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_OriginalLeaseNumber_NotBlank();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
        
        // update Original_Lease_Number__c 
        td.quote_1.Original_Lease_Number__c  = '67890';
        update td.quote_1;
            
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('67890', c_1.Lease__c);
    }

    private static testMethod void test_SPVT() {
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_SPVT();
        
        Case c_1 = new Case();
        c_1.AccountId = td.account_1.Id;
        c_1.Lease_Payment__c = td.leasePayment_1.Id;
        c_1.SPVT_Case__c = true;
        insert new List <Case>{c_1};
        
        // requery and verify
        c_1 = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :c_1.Id];
        system.assertEquals(td.leasePayment_1.Id, c_1.Lease_Payment__c);
        system.assertEquals('12345', c_1.Lease__c);
            
    }

    private static testMethod void test_LeaseOld_Batch() {
        Integer batchSize = 20;
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_LeaseOld_Batch(batchSize);
        
        List <Case> caseList = new List <Case>();
        for (Integer i=0; i<batchSize; i++) {
            Case c = new Case();
            c.AccountId = td.accountList[i].Id;
            caseList.add(c);
        }
        insert caseList;
        
        // requery and verify
        caseList = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.leasePaymentList[i].Id, caseList[i].Lease_Payment__c);
            system.assertEquals(String.valueOf(i), caseList[i].Lease__c);
        }
        
        // update Lease_old__c 
        for (Integer i=0; i<batchSize; i++) {
            td.leasePaymentList[i].Lease_old__c = String.valueOf(i + 1000);
        }
        update td.leasePaymentList;
        
        // requery and verify
        caseList = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.leasePaymentList[i].Id, caseList[i].Lease_Payment__c);
            system.assertEquals(String.valueOf(i + 1000), caseList[i].Lease__c);
        }
            
    }

    private static testMethod void test_OriginalLeaseNumber_Batch() {
        Integer batchSize = 20;
        CaseLeasePaymentTestData td = new CaseLeasePaymentTestData();
        td.createTestData_OriginalLeaseNumber_Batch(batchSize);
        
        List <Case> caseList = new List <Case>();
        for (Integer i=0; i<batchSize; i++) {
            Case c = new Case();
            c.AccountId = td.accountList[i].Id;
            caseList.add(c);
        }
        insert caseList;
        
        // requery and verify
        caseList = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.leasePaymentList[i].Id, caseList[i].Lease_Payment__c);
            system.assertEquals(String.valueOf(i), caseList[i].Lease__c);
        }
        
        // update Original_Lease_Number__c 
        for (Integer i=0; i<batchSize; i++) {
            td.quoteList[i].Original_Lease_Number__c  = String.valueOf(i + 1000);
        }
        update td.quoteList;
            
        // requery and verify
        caseList = [SELECT Lease_Payment__c, Lease__c FROM Case WHERE Id = :caseList];
        for (Integer i=0; i<batchSize; i++) {
            system.assertEquals(td.leasePaymentList[i].Id, caseList[i].Lease_Payment__c);
            system.assertEquals(String.valueOf(i + 1000), caseList[i].Lease__c);
        }
    }
    
}