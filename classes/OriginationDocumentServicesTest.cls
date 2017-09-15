@isTest
private class OriginationDocumentServicesTest {


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

    static testMethod void removeApprovedFieldTest()
    {
        setupCustomSettings();
        Account testAccount = TestUtils.createAccount('testname', false);
        testAccount.Origination_Approved__c = Date.today();
        testAccount.Approval_Approved__c = Date.today();

        insert testAccount;

        List<Origination_Document__c> originationDocs = TestUtils.createOriginationDocuments(3, testAccount.Id, false);
        originationDocs[1].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[2].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;

        Test.startTest();
            OriginationDocumentServices.removeApprovedField(originationDocs);
        Test.stopTest();

        Account updatedAccount = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(null, updatedAccount.Origination_Approved__c, 'The origination type field should be nulled out');
        System.assertEquals(null, updatedAccount.Approval_Approved__c, 'The approval type field should be nulled out');
    }

    static testMethod void setApprovedFieldTest_AllApproved()
    {
        setupCustomSettings();
        Account testAccount = TestUtils.createAccount('testname', false);
        testAccount.Origination_Approved__c = null;
        testAccount.Approval_Approved__c = null;

        insert testAccount;

        List<Origination_Document__c> originationDocs = TestUtils.createOriginationDocuments(3, testAccount.Id, false);
        originationDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[1].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[1].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[2].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        insert originationDocs;

        Test.startTest();
            OriginationDocumentServices.setApprovedField(originationDocs);
        Test.stopTest();

        Account updatedAccount = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id = :testAccount.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedAccount.Origination_Approved__c, 'The origination type field should be set to today');
        System.assertEquals(currentDate, updatedAccount.Approval_Approved__c, 'The approval type field should be set to today');
    }

    static testMethod void setApprovedFieldTest_AllApprovedWithNotRequiredOriginationDoc()
    {
        setupCustomSettings();
        Account testAccount = TestUtils.createAccount('testname', false);
        testAccount.Origination_Approved__c = null;
        testAccount.Approval_Approved__c = null;

        insert testAccount;

        List<Origination_Document__c> originationDocs = TestUtils.createOriginationDocuments(3, testAccount.Id, false);
        originationDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[1].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[1].Status__c = 'test';
        originationDocs[1].Not_Required_for_Approval__c = true;
        originationDocs[2].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        insert originationDocs;

        Test.startTest();
            OriginationDocumentServices.setApprovedField(originationDocs);
        Test.stopTest();

        Account updatedAccount = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id = :testAccount.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedAccount.Origination_Approved__c, 'The origination type field should be set to today');
        System.assertEquals(currentDate, updatedAccount.Approval_Approved__c, 'The approval type field should be set to today');
    }

    static testMethod void setApprovedFieldTest_NotAllApproved()
    {
        setupCustomSettings();
        Account testAccount = TestUtils.createAccount('testname', false);
        testAccount.Origination_Approved__c = null;
        testAccount.Approval_Approved__c = null;

        insert testAccount;

        List<Origination_Document__c> originationDocs = TestUtils.createOriginationDocuments(3, testAccount.Id, false);
        originationDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[1].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[1].Status__c = 'test';
        originationDocs[2].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        insert originationDocs;

        Test.startTest();
            OriginationDocumentServices.setApprovedField(originationDocs);
        Test.stopTest();

        Account updatedAccount = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id = :testAccount.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedAccount.Origination_Approved__c, 'The origination type field should be set to today');
        System.assertEquals(null, updatedAccount.Approval_Approved__c, 'The approval type field should be null');
    }

    static testMethod void setApprovedFieldTest_DateAlreadySet()
    {
        setupCustomSettings();
        Account testAccount = TestUtils.createAccount('testname', false);
        Date existingDate = Date.today().addDays(-1);
        testAccount.Origination_Approved__c = existingDate;
        testAccount.Approval_Approved__c = null;

        insert testAccount;

        List<Origination_Document__c> originationDocs = TestUtils.createOriginationDocuments(3, testAccount.Id, false);
        originationDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[1].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[1].Status__c = InvoiceDocumentServices.APPROVED;
        originationDocs[2].Invoice_Type__c = InvoiceDocumentServices.APPROVAL_TYPE;
        originationDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        insert originationDocs;

        Test.startTest();
            OriginationDocumentServices.setApprovedField(originationDocs);
        Test.stopTest();

        Account updatedAccount = [SELECT Origination_Approved__c, Approval_Approved__c FROM Account WHERE Id = :testAccount.Id];

        Date currentDate = Date.today();
        System.assertEquals(existingDate, updatedAccount.Origination_Approved__c, 'When the date is already set, the origination type field should not change');
        System.assertEquals(currentDate, updatedAccount.Approval_Approved__c, 'The approval type field should be set to today');
    }
}