@isTest
private class InvoiceDocumentsApprovalUtilTest {
    // method name suffixes
    // nr-not required, a-approved, na-not approved
    
    private static testMethod void test_new_1nr() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_1nr();

        Invoice_Documents__c doc = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        system.assertEquals(false, doc.Approved_Notification__c); 
    }

    private static testMethod void test_new_1a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_1a();

        Invoice_Documents__c doc = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        system.assertEquals(true, doc.Approved_Notification__c); 
    }

    private static testMethod void test_new_1a_1na() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_1a_1na();

        List <Invoice_Documents__c> docList = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        for (Invoice_Documents__c doc : docList) {
            system.assertEquals(false, doc.Approved_Notification__c); 
        }       
    }

    private static testMethod void test_new_2a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_2a();

        List <Invoice_Documents__c> docList = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        Integer flagCount = 0;
        for (Invoice_Documents__c doc : docList) {
            if (doc.Approved_Notification__c == true) {
                flagCount++;
            }
        }       
        system.assertEquals(1, flagCount); 
    }

    private static testMethod void test_new_2a_1nr() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_2a_1nr();

        List <Invoice_Documents__c> docList = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        Integer flagCount = 0;
        for (Invoice_Documents__c doc : docList) {
            if (doc.Approved_Notification__c == true) {
                flagCount++;
            }
        }       
        system.assertEquals(1, flagCount); 
    }

    private static testMethod void test_new_3a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_new_3a();

        List <Invoice_Documents__c> docList = [SELECT Responsible_Partner__c FROM Invoice_Documents__c
            WHERE Approved_Notification__c = true];
        Set <String> rpIdSet = new Set <String>();
        for (Invoice_Documents__c doc : docList) {
            rpIdSet.add(doc.Responsible_Partner__c);
        }       
        system.assertEquals(2, docList.size()); 
        system.assertEquals(true, rpIdSet.contains(td.responsiblePartner_1.Id)); 
        system.assertEquals(true, rpIdSet.contains(td.responsiblePartner_2.Id)); 
    }

    private static testMethod void test_update_1nr() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_1nr();

        Invoice_Documents__c doc = [SELECT Approved_Notification__c FROM Invoice_Documents__c WHERE Id = :td.invoiceDocument_1.Id];
        system.assertEquals(false, doc.Approved_Notification__c); 
    }

    private static testMethod void test_update_1ua_1a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_1ua_1a();

        Invoice_Documents__c doc = [SELECT Approved_Notification__c FROM Invoice_Documents__c WHERE Id = :td.invoiceDocument_1.Id];
        system.assertEquals(false, doc.Approved_Notification__c); 
    }

    private static testMethod void test_update_2a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_2a();

        List <Invoice_Documents__c> docList = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        Integer flagCount = 0;
        for (Invoice_Documents__c doc : docList) {
            if (doc.Approved_Notification__c == true) {
                flagCount++;
            }
        }       
        system.assertEquals(1, flagCount); 
    }

    private static testMethod void test_update_2a_1nr() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_2a_1nr();

        List <Invoice_Documents__c> docList = [SELECT Approved_Notification__c FROM Invoice_Documents__c];
        Integer flagCount = 0;
        for (Invoice_Documents__c doc : docList) {
            if (doc.Approved_Notification__c == true) {
                flagCount++;
            }
        }       
        system.assertEquals(1, flagCount); 
    }

    private static testMethod void test_update_3a() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_3a();

        List <Invoice_Documents__c> docList = [SELECT Responsible_Partner__c FROM Invoice_Documents__c
            WHERE Approved_Notification__c = true];
        Set <String> rpIdSet = new Set <String>();
        for (Invoice_Documents__c doc : docList) {
            rpIdSet.add(doc.Responsible_Partner__c);
        }       
        system.assertEquals(2, docList.size()); 
        system.assertEquals(true, rpIdSet.contains(td.responsiblePartner_1.Id)); 
        system.assertEquals(true, rpIdSet.contains(td.responsiblePartner_2.Id)); 
    }

    private static testMethod void test_update_2a_1ua() {
        InvoiceDocumentsApprovalUtilTestData td = new InvoiceDocumentsApprovalUtilTestData();    
        td.createTestData_update_2a_1ua();

        Invoice_Documents__c doc = [SELECT Approved_Notification__c FROM Invoice_Documents__c WHERE Id = :td.invoiceDocument_1.Id];
        system.assertEquals(false, doc.Approved_Notification__c); 
    }
    
}