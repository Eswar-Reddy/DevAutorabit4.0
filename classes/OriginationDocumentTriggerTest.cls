@isTest
private class OriginationDocumentTriggerTest {

    static void setupCustomSettings() {
        List<Origination_Document_Invoice_Type__c> originationDocumentInvoiceTypes = new List<Origination_Document_Invoice_Type__c>();

        Origination_Document_Invoice_Type__c originationDocumentInvoiceType = new Origination_Document_Invoice_Type__c();
        originationDocumentInvoiceType.Name = InvoiceDocumentServices.ORIGINATION_TYPE;
        originationDocumentInvoiceType.Invoice_Type__c = InvoiceDocumentServices.ORIGINATION_TYPE;
        originationDocumentInvoiceType.Approve_Field__c = 'Origination_Approved__c';
        originationDocumentInvoiceTypes.add(originationDocumentInvoiceType);

        originationDocumentInvoiceType = new Origination_Document_Invoice_Type__c();
        originationDocumentInvoiceType.Name = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocumentInvoiceType.Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocumentInvoiceType.Approve_Field__c = 'Approval_Approved__c';
        originationDocumentInvoiceTypes.add(originationDocumentInvoiceType);

        System.runAs(TestUtils.ADMIN_USER) {
            insert originationDocumentInvoiceTypes;
        }
    }

    static testMethod void bulkRemoveApprovedField() {
        setupCustomSettings();
        final Integer NUM_ACCOUNTS = 50;
        Date currentDate = Date.today();
        List<Account> testAccounts = TestUtils.createAccounts(NUM_ACCOUNTS, false);
        for(Account testAccount : testAccounts) {
            testAccount.Origination_Approved__c = Date.today().addDays(-1);
            testAccount.Approval_Approved__c = currentDate;
        }
        insert testAccounts;

        List<Origination_Document__c> originationDocs = new List<Origination_Document__c>();
        for(Account testAccount : testAccounts) {
            Origination_Document__c originationDoc = TestUtils.createOriginationDocuments(1, testAccount.Id, false)[0];
            originationDoc.Status__c = InvoiceDocumentServices.APPROVED;
            originationDocs.add(originationDoc);
        }
        insert originationDocs;

        for(Origination_Document__c originationDoc : originationDocs) {
            originationDoc.Status__c = 'test';
        }

        Test.startTest();
            update originationDocs;
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(NUM_ACCOUNTS, updatedAccounts.size(), 'The correct number of accounts should be pulled back');

        for(Account updatedAccount : updatedAccounts) {
            System.assertEquals(null, updatedAccount.Origination_Approved__c, 'The origination type field should be nulled out');
            System.assertEquals(currentDate, updatedAccount.Approval_Approved__c, 'The approval type field should be stay the same');
        }
    }

    static testMethod void bulkSetApprovedField() {
        setupCustomSettings();
        final Integer NUM_ACCOUNTS = 50;
        Date currentDate = Date.today();
        List<Account> testAccounts = TestUtils.createAccounts(NUM_ACCOUNTS, false);
        for(Account testAccount : testAccounts) {
            testAccount.Origination_Approved__c = null;
            testAccount.Approval_Approved__c = null;
        }
        insert testAccounts;

        List<Origination_Document__c> originationDocs = new List<Origination_Document__c>();
        for(Account testAccount : testAccounts) {
            Origination_Document__c originationDoc = TestUtils.createOriginationDocuments(1, testAccount.Id, false)[0];
            originationDoc.Status__c = 'test';
            originationDocs.add(originationDoc);
        }
        insert originationDocs;

        for(Origination_Document__c originationDoc : originationDocs) {
            originationDoc.Status__c = InvoiceDocumentServices.APPROVED;
        }

        Test.startTest();
            update originationDocs;
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(NUM_ACCOUNTS, updatedAccounts.size(), 'The correct number of accounts should be pulled back');

        for(Account updatedAccount : updatedAccounts) {
            System.assertEquals(currentDate, updatedAccount.Origination_Approved__c, 'The origination type field should be set correctly');
            System.assertEquals(null, updatedAccount.Approval_Approved__c, 'The approval type field should be null');
        }
    }
}