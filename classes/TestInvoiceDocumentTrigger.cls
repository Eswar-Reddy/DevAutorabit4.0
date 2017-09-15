@isTest
public with sharing class TestInvoiceDocumentTrigger
{
    static final Integer NUM_PAYMENTS = 10;
    static final String STATE = 'CA';
    static final List<String> INSTALL_TYPES = new List<String>{ 'typea' , 'typeb' };
    static final List<String> INTERCONNECT_TYPES = new List<String>{ 'type1' , 'type2' };
    static Account testAccount;
    static List<LeasePayment__c> testLeasePayments;

    static void setup()
    {
        testAccount = TestUtils.createAccount( 'TestAccount', true );

        testLeasePayments = new List<LeasePayment__c>();
        for( Integer index = 0; index < NUM_PAYMENTS; index++ )
        {
            LeasePayment__c testLeasePayment = TestUtils.createLeasePayment( 'TestPayment' + index, testAccount.Id, false );
            testLeasePayment.Site_State_Prov_old__c = STATE;
            testLeasePayments.add( testLeasePayment );
        }
        insert testLeasePayments;
    }
    

    //TestMethod to test Create Rejection Reason
    static testMethod void testCreateRejectionReasons(){
        setup();
        
        //Setup Invoice Documents
        List<Invoice_Documents__c> testDocuments = new List<Invoice_Documents__c>();
        
        //Field constants
        final Date SUBMITTED_DATE = Date.today() - 1;
        final String TEST_NOTES = 'chocobo is kowai';
        
        //For each lease payment add NOT_SUBITTED Invoice Documents with TEST_NOTES
        for(LeasePayment__c leasePayment: testLeasePayments){
            Invoice_Documents__c newDocument = TestUtils.createInvoiceDocuments( 1, leasePayment.Id, 'chocobo', false )[0];
            newDocument.Status__c = InvoiceDocumentServices.NOT_SUBMITTED;
            newDocument.Document_Submitted__c = SUBMITTED_DATE;
            newDocument.Notes_to_Dealer__c = TEST_NOTES;
            testDocuments.add(newDocument);
        }
        insert testDocuments;
        
        //Store the id for rejection invoice documents
        Set<Id> rejectedDocumentIds = new Set<Id>();
        //Store the id for pending invoice documents
        Set<Id> pendingDocumentIds = new Set<Id>();
        
        Test.startTest();
            //To decide which documents is rejected/pending
            Boolean documentStatusSwitch = false;
            for (Invoice_Documents__c testDocument: testDocuments){
                //The odd one should be pending, the even one should be rejected
                if(documentStatusSwitch){
                    testDocument.Status__c = InvoiceDocumentServices.REJECTED;
                    rejectedDocumentIds.add(testDocument.Id);
                }
                else{
                    testDocument.Status__c = InvoiceDocumentServices.PENDING;
                    pendingDocumentIds.add(testDocument.Id);
                }
                documentStatusSwitch = !documentStatusSwitch;
            }
            update testDocuments;
        Test.stopTest();
        
        //Query back the rejected invoice docs from database
        List<Invoice_Document_Changed__c> actualRejectedReasons= [SELECT Invoice_Documents__c, Name, Document_Submitted__c, Notes_to_Dealer__c, Response_Date__c FROM Invoice_Document_Changed__c];
        system.assertEquals(NUM_PAYMENTS / 2, actualRejectedReasons.size(), 'the size should be the half of the documents size');
        
        //Test each field in invoice documents, and grab id into set to compare with
        Set<Id> actualIds = new Set<Id>();
        for(Invoice_Document_Changed__c rejectedReason: actualRejectedReasons){
            system.assertEquals(Date.today(), rejectedReason.Response_Date__c, 'should set the current date');
            system.assertEquals(SUBMITTED_DATE, rejectedReason.Document_Submitted__c, 'should have the same submitted date');
            system.assertEquals(TEST_NOTES, rejectedReason.Notes_to_Dealer__c, 'should have the same notes');
            system.assertEquals('1', rejectedReason.Name, 'should only have 1 rejected reason per document');
            actualIds.add(rejectedReason.Invoice_Documents__c);
        }
        
        system.assertEquals(rejectedDocumentIds, actualIds, 'should have the same document id');
    }
    
    static testMethod void testRemoveNotesToDealer(){
        setup();
        
        final String TEST_NOTES = 'chocobo is kawaii';
        List<Invoice_Documents__c> testDocuments = new List<Invoice_Documents__c>();
        for(LeasePayment__c leasePayment: testLeasePayments){
            Invoice_Documents__c newDocument = TestUtils.createInvoiceDocuments( 1, leasePayment.Id, 'chocobo', false )[0];
            newDocument.Notes_To_Dealer__c = TEST_NOTES;
            testDocuments.add(newDocument);
        }
        insert testDocuments;
        
        Set<Id> notSubmittedDocumentIds = new Set<Id>();
        Set<Id> pendingDocumentIds = new Set<Id>();
        
        Test.startTest();
            Boolean documentStatusSwitch = false;
            for (Invoice_Documents__c testDocument: testDocuments){
                if(documentStatusSwitch){
                    testDocument.Status__c = InvoiceDocumentServices.NOT_SUBMITTED;
                    notSubmittedDocumentIds.add(testDocument.Id);
                }
                else{
                    testDocument.Status__c = InvoiceDocumentServices.PENDING;
                    pendingDocumentIds.add(testDocument.Id);
                }
            
                documentStatusSwitch = !documentStatusSwitch;
            }
            update testDocuments;
        Test.stopTest();
        
        List<Invoice_Documents__c> actualDocuments = [
                                                        SELECT Status__c, Notes_To_Dealer__c
                                                        FROM Invoice_Documents__c
                                                     ];
        system.assertEquals(NUM_PAYMENTS, actualDocuments.size(), 'should have the same documents size');
        
        for (Invoice_Documents__c actualDocument: actualDocuments){
            if(notSubmittedDocumentIds.contains(actualDocument.Id)){
                system.assertEquals(TEST_NOTES, actualDocument.Notes_To_Dealer__c, 'notes should stay the same as the status have not changed to pending');
            }
            if(pendingDocumentIds.contains(actualDocument.Id)){
                system.assertEquals(InvoiceDocumentServices.DEFAULT_NOTES_TO_DEALER, actualDocument.Notes_To_Dealer__c, 'notes should set to default as the status have changed to pending');
            }
        }
    }
    
    static void testSetPaymentApproved(List<String> types, String documentType, String fieldToCheck)
    {
        setup();
        Date currentDate = Date.today();

        List<Invoice_Documents__c> testDocuments = new List<Invoice_Documents__c>();
        for( LeasePayment__c aPayment : testLeasePayments )
        {
            for(String type : types)
            {
                Invoice_Documents__c newDocument = TestUtils.createInvoiceDocuments( 1, aPayment.Id, documentType, false )[0];
                newDocument.Documents_in_File__c = type;
                testDocuments.add( newDocument );

            }

        }
        insert testDocuments;

        Test.startTest();

            for( Invoice_Documents__c aDocument : testDocuments )
            {
                aDocument.Status__c = InvoiceDocumentServices.APPROVED;
            }
            update testDocuments;

        Test.stopTest();
        String query = 'SELECT Id, ' + fieldToCheck + ' FROM LeasePayment__c WHERE Id IN :testLeasePayments';
        List<LeasePayment__c> updatedLeasePayments = Database.query(query);
        for( LeasePayment__c aPayment : updatedLeasePayments )
        {
            Date actualDate = (Date) aPayment.get(fieldToCheck);
            System.assertEquals( currentDate, actualDate, 'The approved date should be stamped if all of the ' + documentType + ' type documents are approved' );
        }
    }

    static testMethod void testSetInstallPaymentApproved()
    {
        testSetPaymentApproved(INSTALL_TYPES, InvoiceDocumentServices.INSTALL_TYPE, 'Install_Pymnt_Apprvd__c');
    }

    static testMethod void testSetInterconnectPaymentApproved()
    {
        testSetPaymentApproved(INTERCONNECT_TYPES, InvoiceDocumentServices.INTERCONNECT_TYPE, 'Intrcnct_Pymnt_Apprvd__c');
    }


    static testMethod void testGetLeaseIdToExistingDocTypes()
    {
        TestLeasePaymentSetup.setup();
        final String REJECTED_NAME = 'Homer Mobile';
        final String LEGACY_REJECTED_NAME = 'The Homer';
        final String APPROVED_NAME = 'Canyonero';


        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, TestLeasePaymentSetup.newAccount.Id, true);

        Invoice_Documents__c legacyRejectedDocument = TestUtils.createInvoiceDocuments( 1, leasePayments[0].Id, 'type', false )[0];
        legacyRejectedDocument.Status__c = InvoiceDocumentServices.LEGACY_REJECTED;
        legacyRejectedDocument.Documents_in_File__c = LEGACY_REJECTED_NAME;

        Invoice_Documents__c approvedDocument = TestUtils.createInvoiceDocuments( 1, leasePayments[0].Id, 'type', false )[0];
        approvedDocument.Status__c = InvoiceDocumentServices.APPROVED;
        approvedDocument.Documents_in_File__c = APPROVED_NAME;

        Invoice_Documents__c rejectedDocument = TestUtils.createInvoiceDocuments( 1, leasePayments[0].Id, 'type', false )[0];
        rejectedDocument.Status__c = InvoiceDocumentServices.REJECTED;
        rejectedDocument.Documents_in_File__c = REJECTED_NAME;

        insert new List<Invoice_Documents__c>{legacyRejectedDocument, approvedDocument, rejectedDocument};

        Test.startTest();
            Map<Id, Set<String>> actualLeaseIdToDocs = InvoiceDocumentServices.getParentIdToExistingDocTypes(leasePayments);
        Test.stopTest();

        System.assertEquals(1, actualLeaseIdToDocs.size(), 'There should be one lease payment');

        Set<String> actualDocuments = actualLeaseIdToDocs.get(leasePayments[0].Id);

        System.assertEquals(2, actualDocuments.size(), 'Two document types should be returned');
        System.assert(actualDocuments.contains(APPROVED_NAME), 'The approved document should be returned');
        System.assert(actualDocuments.contains(REJECTED_NAME), 'The rejected document should be returned');

    }

    static testMethod void testGetAccountIdToExistingDocTypes()
    {
        final String REJECTED_NAME = 'Homer Mobile';
        final String LEGACY_REJECTED_NAME = 'The Homer';
        final String APPROVED_NAME = 'Canyonero';
        final Integer NUM_ACCOUNTS = 10;

        List<Account> accounts = TestUtils.createAccounts(NUM_ACCOUNTS, true);
        List<Origination_Document__c> originationDocuments = new List<Origination_Document__c>();

        for(Account account : accounts)
        {
            Origination_Document__c legacyRejectedDocument = TestUtils.createOriginationDocuments( 1, account.Id, false )[0];
            legacyRejectedDocument.Status__c = InvoiceDocumentServices.LEGACY_REJECTED;
            legacyRejectedDocument.Documents_in_File__c = LEGACY_REJECTED_NAME;
            originationDocuments.add(legacyRejectedDocument);

            Origination_Document__c approvedDocument = TestUtils.createOriginationDocuments( 1, account.Id, false )[0];
            approvedDocument.Status__c = InvoiceDocumentServices.APPROVED;
            approvedDocument.Documents_in_File__c = APPROVED_NAME;
            originationDocuments.add(approvedDocument);

            Origination_Document__c rejectedDocument = TestUtils.createOriginationDocuments( 1, account.Id, false )[0];
            rejectedDocument.Status__c = InvoiceDocumentServices.REJECTED;
            rejectedDocument.Documents_in_File__c = REJECTED_NAME;
            originationDocuments.add(rejectedDocument);
        }

        insert originationDocuments;

        Test.startTest();
            Map<Id, Set<String>> actualAccountIdToDocs = InvoiceDocumentServices.getParentIdToExistingDocTypes(accounts);
        Test.stopTest();

        System.assertEquals(NUM_ACCOUNTS, actualAccountIdToDocs.size(), 'There should be the same amount of mappings as accounts created');

        for(Account account : accounts)
        {
            Set<String> actualDocuments = actualAccountIdToDocs.get(account.Id);

            System.assertEquals(2, actualDocuments.size(), 'Two document types should be returned');
            System.assert(actualDocuments.contains(APPROVED_NAME), 'The approved document should be returned');
            System.assert(actualDocuments.contains(REJECTED_NAME), 'The rejected document should be returned');
        }

    }

    static testMethod void testGetCountryStateKey()
    {
        String country = 'USA';

        Test.startTest();
            String actualKey = InvoiceDocumentServices.getCountryStateKey(country, STATE);
        Test.stopTest();

        String expectedKey = country + InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER + STATE;

        System.assertEquals(expectedKey, actualKey, 'The key should contain the country and state separated by the delimiter');
    }

    static testMethod void testSafeInsertInvoiceDocument()
    {
        SFDCSpecialUtilities.isRunningTest = True; 
        
        TestLeasePaymentSetup.setup();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, TestLeasePaymentSetup.newAccount.Id, true);
        Invoice_Documents__c invoiceDocument = TestUtils.createInvoiceDocuments(1, leasePayments[0].Id, 'type', false)[0];

        Test.startTest();
            InvoiceDocumentServices.safeInsert(new List<Invoice_Documents__c>{invoiceDocument}, new Map<Id, LeasePayment__c>(leasePayments));
        Test.stopTest();

        List<Invoice_Documents__c> actualInvoiceDocuments = [SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayments[0].Id];

        System.assertEquals(1, actualInvoiceDocuments.size(), 'There should be one invoice document inserted');
    }

    static testMethod void testSafeInsertInvoiceDocument_Fail()
    {
        TestLeasePaymentSetup.setup();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, TestLeasePaymentSetup.newAccount.Id, true);
        Invoice_Documents__c invoiceDocument = TestUtils.createInvoiceDocuments(1, leasePayments[0].Id, 'type', true)[0];

        Test.startTest();
            try
            {
                InvoiceDocumentServices.safeInsert(new List<Invoice_Documents__c>{invoiceDocument}, new Map<Id, LeasePayment__c>(leasePayments));
            }
            catch(DMLException dmx)
            {
                System.assert(false, 'The exception should have been caught in the method');
            }
        Test.stopTest();
    }

    static testMethod void testSafeInsertOriginationDocument()
    {
        TestLeasePaymentSetup.setup();

        Origination_Document__c originationDocument = TestUtils.createOriginationDocuments(1, TestLeasePaymentSetup.newAccount.Id, false)[0];

        Test.startTest();
            InvoiceDocumentServices.safeInsert(new List<Origination_Document__c>{originationDocument}, new Map<Id, Account>(new List<Account>{TestLeasePaymentSetup.newAccount}));
        Test.stopTest();

        List<Origination_Document__c> actualOriginationDocuments = [SELECT Id FROM Origination_Document__c WHERE Account__c = :TestLeasePaymentSetup.newAccount.Id];

        System.assertEquals(1, actualOriginationDocuments.size(), 'There should be one origination document inserted');
    }
   
    
    static testMethod void testSafeInsertOriginationDocument_Fail()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        
        TestLeasePaymentSetup.setup();
        
        Origination_Document__c originationDocument = TestUtils.createOriginationDocuments(1, TestLeasePaymentSetup.newAccount.Id, true)[0];

        Test.startTest();
            try
            {
                InvoiceDocumentServices.safeInsert(new List<Origination_Document__c>{originationDocument}, new Map<Id, Account>(new List<Account>{TestLeasePaymentSetup.newAccount}));
            }
            catch(DMLException dmx)
            {
                System.assert(false, 'The exception should have been caught in the method');
            }
        Test.stopTest();
    }
   
    static testMethod void removeApprovedFieldTest()
    {
        Account account = TestUtils.createAccount('testname', true);
        LeasePayment__c testLease = TestUtils.createLeasePayment('ryan gee', account.Id, false);
        testLease.Install_Pymnt_Apprvd__c = Date.today();
        testLease.Intrcnct_Pymnt_Apprvd__c = Date.today();

        insert testLease;

        List<Invoice_Documents__c> invoiceDocs = TestUtils.createInvoiceDocuments(2, testLease.Id, '', false);
        invoiceDocs[0].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[1].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;

        Test.startTest();
            InvoiceDocumentServices.removeApprovedField(invoiceDocs);
        Test.stopTest();

        LeasePayment__c updatedLease = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id = :testLease.Id];

        System.assertEquals(null, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be nulled out');
        System.assertEquals(null, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be nulled out');
    }

    static testMethod void setApprovedFieldTest_AllApproved()
    {
        Account account = TestUtils.createAccount('testname', true);
        LeasePayment__c testLease = TestUtils.createLeasePayment('ryan gee', account.Id, false);
        testLease.Install_Pymnt_Apprvd__c = null;
        testLease.Intrcnct_Pymnt_Apprvd__c = null;

        insert testLease;

        List<Invoice_Documents__c> invoiceDocs = TestUtils.createInvoiceDocuments(6, testLease.Id, '', false);
        invoiceDocs[0].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[1].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[1].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[2].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        invoiceDocs[3].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[3].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[4].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[4].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[5].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[5].Status__c = InvoiceDocumentServices.APPROVED;

        insert invoiceDocs;

        Test.startTest();
            InvoiceDocumentServices.setApprovedField(invoiceDocs);
        Test.stopTest();

        LeasePayment__c updatedLease = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id = :testLease.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be set to today');
        System.assertEquals(currentDate, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be set to today');
    }

    static testMethod void setApprovedFieldTest_AllApprovedWithNotRequiredInvoiceDoc()
    {
        Account account = TestUtils.createAccount('testname', true);
        LeasePayment__c testLease = TestUtils.createLeasePayment('ryan gee', account.Id, false);
        testLease.Install_Pymnt_Apprvd__c = null;
        testLease.Intrcnct_Pymnt_Apprvd__c = null;

        insert testLease;

        List<Invoice_Documents__c> invoiceDocs = TestUtils.createInvoiceDocuments(6, testLease.Id, '', false);
        invoiceDocs[0].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[1].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[1].Status__c = 'something it doesnt matter';
        invoiceDocs[1].Not_Required_for_Approval__c = true;
        invoiceDocs[2].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        invoiceDocs[3].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[3].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[4].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[4].Status__c = 'something it doesnt matter';
        invoiceDocs[4].Not_Required_for_Approval__c = true;
        invoiceDocs[5].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[5].Status__c = InvoiceDocumentServices.APPROVED;

        insert invoiceDocs;

        Test.startTest();
            InvoiceDocumentServices.setApprovedField(invoiceDocs);
        Test.stopTest();

        LeasePayment__c updatedLease = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id = :testLease.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be set to today');
        System.assertEquals(currentDate, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be set to today');
    }

    static testMethod void setApprovedFieldTest_NotAllApproved()
    {
        Account account = TestUtils.createAccount('testname', true);
        LeasePayment__c testLease = TestUtils.createLeasePayment('ryan gee', account.Id, false);
        testLease.Install_Pymnt_Apprvd__c = null;
        testLease.Intrcnct_Pymnt_Apprvd__c = null;

        insert testLease;

        List<Invoice_Documents__c> invoiceDocs = TestUtils.createInvoiceDocuments(6, testLease.Id, '', false);
        invoiceDocs[0].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[1].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[1].Status__c = 'something it doesnt matter';
        invoiceDocs[2].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        invoiceDocs[3].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[3].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[4].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[4].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[5].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[5].Status__c = InvoiceDocumentServices.APPROVED;

        insert invoiceDocs;

        Test.startTest();
            InvoiceDocumentServices.setApprovedField(invoiceDocs);
        Test.stopTest();

        LeasePayment__c updatedLease = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id = :testLease.Id];

        Date currentDate = Date.today();
        System.assertEquals(currentDate, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be set to today');
        System.assertEquals(null, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be set to null');
    }

    static testMethod void setApprovedFieldTest_DateAlreadySet()
    {
        Account account = TestUtils.createAccount('testname', true);
        LeasePayment__c testLease = TestUtils.createLeasePayment('ryan gee', account.Id, false);
        Date existingDate = Date.today().addDays(-1);
        testLease.Install_Pymnt_Apprvd__c = existingDate;
        testLease.Intrcnct_Pymnt_Apprvd__c = null;

        insert testLease;

        List<Invoice_Documents__c> invoiceDocs = TestUtils.createInvoiceDocuments(6, testLease.Id, '', false);
        invoiceDocs[0].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[0].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[1].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[1].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[2].Invoice_Type__c = InvoiceDocumentServices.INTERCONNECT_TYPE;
        invoiceDocs[2].Status__c = InvoiceDocumentServices.APPROVED;

        invoiceDocs[3].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[3].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[4].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[4].Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocs[5].Invoice_Type__c = InvoiceDocumentServices.INSTALL_TYPE;
        invoiceDocs[5].Status__c = InvoiceDocumentServices.APPROVED;

        insert invoiceDocs;

        Test.startTest();
            InvoiceDocumentServices.setApprovedField(invoiceDocs);
        Test.stopTest();

        LeasePayment__c updatedLease = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id = :testLease.Id];

        Date currentDate = Date.today();
        System.assertEquals(existingDate, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be set to today');
        System.assertEquals(currentDate, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be set to null');
    }

    static testMethod void bulkRemoveApprovedField() {
        final Integer NUM_LEASES = 50;
        Date currentDate = Date.today();
        Id accountId = TestUtils.createAccount('testname', true).Id;
        List<LeasePayment__c> testLeases = TestUtils.createLeasePayments(NUM_LEASES, accountId, false);
        for(LeasePayment__c testLease : testLeases) {
            testLease.Install_Pymnt_Apprvd__c = Date.today().addDays(-1);
            testLease.Intrcnct_Pymnt_Apprvd__c = currentDate;
        }
        insert testLeases;

        List<Invoice_Documents__c> invoiceDocs = new List<Invoice_Documents__c>();
        for(LeasePayment__c testLease : testLeases) {
            Invoice_Documents__c invoiceDoc = TestUtils.createInvoiceDocuments(1, testLease.Id, InvoiceDocumentServices.INSTALL_TYPE, false)[0];
            invoiceDoc.Status__c = InvoiceDocumentServices.APPROVED;
            invoiceDocs.add(invoiceDoc);
        }
        insert invoiceDocs;

        for(Invoice_Documents__c invoiceDoc : invoiceDocs) {
            invoiceDoc.Status__c = 'test';
        }

        Test.startTest();
            update invoiceDocs;
        Test.stopTest();

        List<LeasePayment__c> updatedLeases = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id IN :testLeases];
        System.assertEquals(NUM_LEASES, updatedLeases.size(), 'The correct number of leases should be pulled back');

        for(LeasePayment__c updatedLease : updatedLeases) {
            System.assertEquals(null, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be nulled out');
            System.assertEquals(currentDate, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be stay the same');
        }
    }

    static testMethod void bulkSetApprovedField() {
        final Integer NUM_LEASES = 50;
        Date currentDate = Date.today();
        Id accountId = TestUtils.createAccount('testname', true).Id;
        List<LeasePayment__c> testLeases = TestUtils.createLeasePayments(NUM_LEASES, accountId, false);
        for(LeasePayment__c testLease : testLeases) {
            testLease.Install_Pymnt_Apprvd__c = null;
            testLease.Intrcnct_Pymnt_Apprvd__c = null;
        }
        insert testLeases;

        List<Invoice_Documents__c> invoiceDocs = new List<Invoice_Documents__c>();
        for(LeasePayment__c testLease : testLeases) {
            Invoice_Documents__c invoiceDoc = TestUtils.createInvoiceDocuments(1, testLease.Id, InvoiceDocumentServices.INSTALL_TYPE, false)[0];
            invoiceDoc.Status__c = 'test';
            invoiceDocs.add(invoiceDoc);
        }
        insert invoiceDocs;

        for(Invoice_Documents__c invoiceDoc : invoiceDocs) {
            invoiceDoc.Status__c = InvoiceDocumentServices.APPROVED;
        }

        Test.startTest();
            update invoiceDocs;
        Test.stopTest();

        List<LeasePayment__c> updatedLeases = [SELECT Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c FROM LeasePayment__c WHERE Id IN :testLeases];
        System.assertEquals(NUM_LEASES, updatedLeases.size(), 'The correct number of leases should be pulled back');

        for(LeasePayment__c updatedLease : updatedLeases) {
            System.assertEquals(currentDate, updatedLease.Install_Pymnt_Apprvd__c, 'The install payment approved field should be set correctly');
            System.assertEquals(null, updatedLease.Intrcnct_Pymnt_Apprvd__c, 'The interconnect payment approved field should be null');
        }
    }
}