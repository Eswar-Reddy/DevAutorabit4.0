@isTest
public with sharing class TestInvoiceDocumentUploadController {
    static final String STATE = 'CA';
    static final List<String> DOCUMENT_TYPES = new List<String>{ 'type1', 'type3', 'typesX1' };
    static final Set<String> BAD_DOCUMENT_TYPES = new Set<String>{ 'moe', 'larry', 'curley' };
    static final String INVOICE_TYPE = 'install';
    static final String ORIGINATION_TYPE = 'origination';
    static final String REJECTED = 'Rejected';

    static LeasePayment__c leasePayment;
    static Account account;
    static InvoiceDocumentUploadController invoiceController;

    private static void setupLeasePayment()
    {
        Account partnerAccount = TestUtils.createAccount('TestAccount', true);
        leasePayment = TestUtils.createLeasePayment('TestLeasePayment', partnerAccount.Id, false);
        leasePayment.Site_State_Prov_old__c = STATE;
        leasePayment.Date_Countersigned_old__c = Date.today();
        insert leasePayment;

        leasePayment = [SELECT Id, Site_State_Prov__c, CreatedDate, Date_Countersigned_old__c, Date_Countersigned__c, Lease__c FROM LeasePayment__c WHERE Id = :leasePayment.id LIMIT 1];
    }

    private static void instantiateLeasePaymentController()
    {
        Test.setCurrentPageReference(Page.InvoiceDocumentUpload);
        ApexPages.currentPage().getParameters().put(InvoiceDocumentUploadController.ID_URL_PARAM, leasePayment.Id);
        ApexPages.currentPage().getParameters().put(InvoiceDocumentUploadController.TYPE_URL_PARAM, INVOICE_TYPE);
        invoiceController = new InvoiceDocumentUploadController();
    }

    private static void instantiateAccountController()
    {
        Test.setCurrentPageReference(Page.OriginationDocumentUpload);
        ApexPages.currentPage().getParameters().put(InvoiceDocumentUploadController.ID_URL_PARAM, account.Id);
        ApexPages.currentPage().getParameters().put(InvoiceDocumentUploadController.TYPE_URL_PARAM, ORIGINATION_TYPE);
        invoiceController = new InvoiceDocumentUploadController();
    }
    
    //MAM 07/18/2014 New Test Method testgoogleAnalyticsProfileId and isArchived to increase code coverage start
    public static testMethod void testgetMethods(){
        setupLeasePayment();
        instantiateLeasePaymentController();
        
        Test.startTest();
            String GAProfileId = invoiceController.googleAnalyticsProfileId;
            System.assertEquals(GAProfileId,Null);
        test.stopTest();
    }
    //MAM 07/18/2014 end
    
    public static testMethod void testQueryDocuments_NoDocument()
    {
        setupLeasePayment();
        instantiateLeasePaymentController();

        Test.startTest();

            invoiceController.queryDocuments();

        test.stopTest();

        System.assert(invoiceController.invoiceDocumentRows.isEmpty(), 'The controller should have no invoice document rows');
    }


    public static testMethod void testQueryInvoiceDocument_WithApprovedDocument()
    {
        setupLeasePayment();

        Invoice_Documents__c invoiceDocument = TestUtils.createInvoiceDocuments(1, leasePayment.Id, INVOICE_TYPE, false)[0];
        invoiceDocument.Status__c = InvoiceDocumentServices.APPROVED;
        invoiceDocument.Documents_in_File__c = DOCUMENT_TYPES[0];
        insert invoiceDocument;

        Attachment attachment = TestUtils.createAttachments(1, 'TEST', false)[0];
        attachment.ParentId = invoiceDocument.Id;
        insert attachment;

        Test.startTest();

            instantiateLeasePaymentController();

        test.stopTest();

        System.assertEquals(1, invoiceController.invoiceDocumentRows.size(), 'One invoice document should be queried back');
        System.assertEquals(invoiceDocument.Id, invoiceController.invoiceDocumentRows[0].invoiceDocument.Id, 'The correct invoice document should be queried back');
        System.assertEquals(attachment.Id, invoiceController.invoiceDocumentRows[0].att.Id, 'The correct attachment should be queried back');
    }

    public static testMethod void testQueryOriginationDocument_WithApprovedDocument()
    {
        final Integer NUM_DOCS = 2;
        account = TestUtils.createAccount('TestAccount', true);

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCS, account.Id, false);
        for(Origination_Document__c originationDocument : originationDocuments) {
            originationDocument.Status__c = InvoiceDocumentServices.APPROVED;
            originationDocument.Documents_in_File__c = DOCUMENT_TYPES[0];
        }
        originationDocuments[1].Order__c = 1;
        originationDocuments[0].Order__c = 2;
        insert originationDocuments;

        Attachment attachment = TestUtils.createAttachments(1, 'TEST', false)[0];
        attachment.ParentId = originationDocuments[0].Id;
        insert attachment;

        Test.startTest();

            instantiateAccountController();

        test.stopTest();

        System.assertEquals(NUM_DOCS, invoiceController.invoiceDocumentRows.size(), 'The correct number of origination documents should be queried back');
        System.assertEquals(originationDocuments[1].Id, invoiceController.invoiceDocumentRows[0].invoiceDocument.Id, 'The first origination document should be queried back');
        System.assertEquals(originationDocuments[0].Id, invoiceController.invoiceDocumentRows[1].invoiceDocument.Id, 'The second origination document should be queried back');
        System.assertEquals(attachment.Id, invoiceController.invoiceDocumentRows[1].att.Id, 'The correct attachment should be queried back');
    }

    public static testMethod void testQueryInvoiceDocument_WithRejectedDocument()
    {
        setupLeasePayment();

        Invoice_Documents__c invoiceDocument = TestUtils.createInvoiceDocuments(1, leasePayment.Id, INVOICE_TYPE, false)[0];
        invoiceDocument.Status__c = InvoiceDocumentServices.REJECTED;
        invoiceDocument.Documents_in_File__c = DOCUMENT_TYPES[0];
        insert invoiceDocument;

        Attachment attachment = TestUtils.createAttachments(1, 'TEST', false)[0];
        attachment.ParentId = invoiceDocument.Id;
        insert attachment;

        Test.startTest();

            instantiateLeasePaymentController();

        test.stopTest();

        System.assertEquals(1, invoiceController.invoiceDocumentRows.size(), 'One invoice document should be queried back');
        System.assertEquals(invoiceDocument.Id, invoiceController.invoiceDocumentRows[0].invoiceDocument.Id, 'The correct invoice document should be queried back');
//        System.assertEquals(null, invoiceController.invoiceDocumentRows[0].att.Id, 'A new attachment should be used for rejected documents');
    }

    public static testMethod void testQueryOriginationDocument_WithRejectedDocument()
    {
        account = TestUtils.createAccount('TestAccount', true);

        Origination_Document__c originationDocument = TestUtils.createOriginationDocuments(1, account.Id, false)[0];
        originationDocument.Status__c = InvoiceDocumentServices.REJECTED;
        originationDocument.Documents_in_File__c = DOCUMENT_TYPES[0];
        insert originationDocument;

        Attachment attachment = TestUtils.createAttachments(1, 'TEST', false)[0];
        attachment.ParentId = originationDocument.Id;
        insert attachment;

        Test.startTest();

            instantiateAccountController();

        test.stopTest();

        System.assertEquals(1, invoiceController.invoiceDocumentRows.size(), 'One origination document should be queried back');
        System.assertEquals(originationDocument.Id, invoiceController.invoiceDocumentRows[0].invoiceDocument.Id, 'The correct origination document should be queried back');
  //      System.assertEquals(null, invoiceController.invoiceDocumentRows[0].att.Id, 'A new attachment should be used for rejected documents');
    }

    private static void associateChildren(List<SObject> parents, List<SObject> children, String childLookupFieldName) {
        for(Integer i = 0; i< parents.size(); i++) {
            children[i].put(childLookupFieldName, parents[i].Id);
        }
    }

    public static testMethod void testSubmitInvoiceDocuments_withAttachment()
    {
        setupLeasePayment();
        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(invoiceDocuments, attachments, 'ParentId');
        instantiateLeasePaymentController();

        Test.startTest();

            //the equivalent of the user selecting a file
            for(Integer i = 0; i < NUM_DOCUMENTS; i++)
            {
                invoiceDocuments[i].Documents_in_File__c = DOCUMENT_TYPES[i];
                invoiceController.invoiceDocumentRows[i].invoiceDocument = invoiceDocuments[i];
                invoiceController.invoiceDocumentRows[i].att = attachments[i];
            }
            invoiceController.submit();

        Test.stopTest();

        Map<Id, Invoice_Documents__c> invoiceDocMap = new Map<Id, Invoice_Documents__c>([SELECT Id, Name, Lease_Payment__c, Link_to_Attachment__c, Status__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id]);
        Map<Id, Attachment> attMap = new Map<Id, Attachment>([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :invoiceDocMap.keySet()]);

        System.assertEquals(NUM_DOCUMENTS, invoiceDocMap.size(), 'We should have inserted 2 documents');
        System.assertEquals(NUM_DOCUMENTS, attMap.size(), 'We should have inserted '+ NUM_DOCUMENTS + ' attachments');

        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR), 'There should be no errors on the page');

        for(Integer i = 0; i < NUM_DOCUMENTS; i++)
        {
            Attachment expectedAtt = invoiceController.invoiceDocumentRows[i].att;
            Invoice_Documents__c expectedDoc = (Invoice_Documents__c) invoiceController.invoiceDocumentRows[i].invoiceDocument;

            Attachment actualAtt = attMap.get(expectedAtt.Id);
            Invoice_Documents__c actualInvoiceDoc = invoiceDocMap.get(expectedDoc.Id);
            
            System.assertEquals(InvoiceDocumentUploadController.baseURL + expectedAtt.Id, actualInvoiceDoc.Link_to_Attachment__c, 'link to attachment should have been populated');
            System.assertEquals(InvoiceDocumentServices.PENDING, actualInvoiceDoc.Status__c, 'The status should be changed to pending');
            System.assertEquals(actualAtt.ParentId, actualInvoiceDoc.Id, 'The inserted attachment should link to the inserted document');
        }
    }

    public static testMethod void testSubmitOriginationDocuments_withAttachment()
    {
        account = TestUtils.createAccount('TestAccount', true);
        final Integer NUM_DOCUMENTS = 2;

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCUMENTS, account.Id, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(originationDocuments, attachments, 'ParentId');
        instantiateAccountController();

        Test.startTest();

            //the equivalent of the user selecting a file
            for(Integer i = 0; i < NUM_DOCUMENTS; i++)
            {
                originationDocuments[i].Documents_in_File__c = DOCUMENT_TYPES[i];
                invoiceController.invoiceDocumentRows[i].invoiceDocument = originationDocuments[i];
                invoiceController.invoiceDocumentRows[i].att = attachments[i];
                //MAM 07/18/2014 to increase code coverage start
                System.assertEquals(invoiceController.invoiceDocumentRows[i].isArchived,false); 
                System.assertEquals(invoiceController.invoiceDocumentRows[i].isPending,false);
                //MAM 07/18/2014 end
            }
            invoiceController.submit();

        Test.stopTest();

        Map<Id, Origination_Document__c> originationDocMap = new Map<Id, Origination_Document__c>([SELECT Id, Name, Account__c, Link_to_Attachment__c, Status__c FROM Origination_Document__c WHERE Account__c = :account.Id]);
        Map<Id, Attachment> attMap = new Map<Id, Attachment>([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :originationDocMap.keySet()]);

        System.assertEquals(NUM_DOCUMENTS, originationDocMap.size(), 'We should have inserted 2 documents');
        System.assertEquals(NUM_DOCUMENTS, attMap.size(), 'We should have inserted ' + NUM_DOCUMENTS + ' attachments');

        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR), 'There should be no errors on the page');

        for(Integer i = 0; i < NUM_DOCUMENTS; i++)
        {
            Attachment expectedAtt = invoiceController.invoiceDocumentRows[i].att;
            Origination_Document__c expectedDoc = (Origination_Document__c) invoiceController.invoiceDocumentRows[i].invoiceDocument;

            Attachment actualAtt = attMap.get(expectedAtt.Id);
            Origination_Document__c actualOriginationDoc = originationDocMap.get(expectedDoc.Id);

            System.assertEquals(InvoiceDocumentUploadController.baseURL + expectedAtt.Id, actualOriginationDoc.Link_to_Attachment__c, 'link to attachment should have been populated');
            System.assertEquals(InvoiceDocumentServices.PENDING, actualOriginationDoc.Status__c, 'The status should be changed to pending');
            System.assertEquals(actualAtt.ParentId, actualOriginationDoc.Id, 'The inserted attachment should link to the inserted document');
        }
    }

    public static testMethod void testSubmitDocuments_withoutAttachment()
    {
        setupLeasePayment();
        instantiateLeasePaymentController();

        Test.startTest();

            invoiceController.submit();

        Test.stopTest();

        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR), 'We should get an error');
        System.assertEquals(System.Label.SUBMIT_WITHOUT_ATTACHMENTS, ApexPages.getMessages()[0].getSummary(), 'We should get the correct error message');
    }

    public static testMethod void testUpdateInvoiceDocuments()
    {
        setupLeasePayment();

        Integer NUM_DOCUMENTS = 1;

        List<InvoiceDocumentUploadController.InvoiceDocumentRow> rowsToUpdate = new List<InvoiceDocumentUploadController.InvoiceDocumentRow>();

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE, true);

        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments;

        instantiateLeasePaymentController();

        List<Attachment> queriedAtt = [SELECT Id, CreatedDate, ParentId FROM Attachment WHERE Id = :attachments[0].Id];
        Map<Id, Attachment> attMap = new Map<Id, Attachment>();
        attMap.put(queriedAtt[0].ParentId, queriedAtt[0]);

        Test.startTest();

            invoiceController.invoiceDocumentRows[0].invoiceDocument = invoiceDocuments[0];
            invoiceController.invoiceDocumentRows[0].att = attachments[0];
            rowsToUpdate.add(invoiceController.invoiceDocumentRows[0]);
            List<Invoice_Documents__c> actualDocuments = invoiceController.updateDocuments(rowsToUpdate, attMap);

        Test.stopTest();

        String attId = attachments[0].Id;
        System.assertEquals(1, actualDocuments.size(), 'One document should have been updated');
        System.assertEquals(InvoiceDocumentUploadController.baseURL + attId, actualDocuments[0].Link_to_Attachment__c, 'Link to attachment should have been updated');
    }

    public static testMethod void testUpdateOriginationDocuments()
    {
        account = TestUtils.createAccount('TestAccount', true);

        Integer NUM_DOCUMENTS = 1;

        List<InvoiceDocumentUploadController.InvoiceDocumentRow> rowsToUpdate = new List<InvoiceDocumentUploadController.InvoiceDocumentRow>();

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCUMENTS, account.Id, true);

        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = originationDocuments[0].Id;
        insert attachments;

        instantiateAccountController();

        List<Attachment> queriedAtt = [SELECT Id, CreatedDate, ParentId FROM Attachment WHERE Id = :attachments[0].Id];
        Map<Id, Attachment> attMap = new Map<Id, Attachment>();
        attMap.put(queriedAtt[0].ParentId, queriedAtt[0]);

        Test.startTest();

            invoiceController.invoiceDocumentRows[0].invoiceDocument = originationDocuments[0];
            invoiceController.invoiceDocumentRows[0].att = attachments[0];
            rowsToUpdate.add(invoiceController.invoiceDocumentRows[0]);
            List<Origination_Document__c> actualDocuments = invoiceController.updateDocuments(rowsToUpdate, attMap);

        Test.stopTest();

        String attId = attachments[0].Id;
        System.assertEquals(1, actualDocuments.size(), 'One document should have been updated');
        System.assertEquals(InvoiceDocumentUploadController.baseURL + attId, actualDocuments[0].Link_to_Attachment__c, 'Link to attachment should have been updated');
    }

    public static testMethod void testValidUpload_InvoiceDocuments()
    {
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = invoiceDocuments[0].Id;
        attachments[1].ParentId = invoiceDocuments[1].Id;
        attachments[1].body = null;

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRowSucceed = new InvoiceDocumentUploadController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRowSucceed.att = attachments[0];
        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRowFail = new InvoiceDocumentUploadController.InvoiceDocumentRow(invoiceDocuments[1]);
        invoiceDocumentRowFail.att = attachments[1];

        Test.startTest();

            Boolean actualSucceed = invoiceDocumentRowSucceed.validUpload();
            Boolean actualFail = invoiceDocumentRowFail.validUpload();

        Test.stopTest();

        System.assert(actualSucceed, 'This row should be a valid upload');
        System.assert(!actualFail, 'This row should not be a valid upload');
    }

    public static testMethod void testValidUpload_OriginationDocuments()
    {
        account = TestUtils.createAccount('TestAccount', true);

        final Integer NUM_DOCUMENTS = 2;

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCUMENTS, account.Id, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = originationDocuments[0].Id;
        attachments[1].ParentId = originationDocuments[1].Id;
        attachments[1].body = null;

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRowSucceed = new InvoiceDocumentUploadController.InvoiceDocumentRow(originationDocuments[0]);
        invoiceDocumentRowSucceed.att = attachments[0];
        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRowFail = new InvoiceDocumentUploadController.InvoiceDocumentRow(originationDocuments[1]);
        invoiceDocumentRowFail.att = attachments[1];

        Test.startTest();

            Boolean actualSucceed = invoiceDocumentRowSucceed.validUpload();
            Boolean actualFail = invoiceDocumentRowFail.validUpload();

        Test.stopTest();

        System.assert(actualSucceed, 'This row should be a valid upload');
        System.assert(!actualFail, 'This row should not be a valid upload');
    }

    public static testMethod void testDeleteInvoiceDocument()
    {
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 1;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE, false);
        invoiceDocuments[0].Document_Submitted__c = Date.today();
        insert invoiceDocuments;

        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        Id invoiceId = invoiceDocuments[0].id;

        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments;

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRow = new InvoiceDocumentUploadController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();

            invoiceDocumentRow.deleteDocument();

        Test.stopTest();

        List<Invoice_Documents__c> actualInvoiceDocs = [SELECT Id, Document_Submitted__c, Status__c, Link_to_Attachment__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id AND Id = :invoiceId];
        List<Attachment> actualAttachments = [SELECT Id FROM Attachment WHERE ParentId = :invoiceId];

        System.assert(!actualInvoiceDocs.isEmpty(), 'The invoice document should not have been deleted');
        System.assertEquals(null, actualInvoiceDocs[0].Document_Submitted__c, 'The document submitted field should be nulled out');
        System.assertEquals(null, actualInvoiceDocs[0].Link_to_Attachment__c, 'The link to attachment field should be nulled out');
        System.assertEquals(InvoiceDocumentServices.NOT_SUBMITTED, actualInvoiceDocs[0].Status__c, 'The document status should be set correctly');
        System.assert(actualAttachments.isEmpty(), 'We should not get any attachments back from the query');
    }

    public static testMethod void testDeleteOriginationDocument()
    {
        account = TestUtils.createAccount('TestAccount', true);

        final Integer NUM_DOCUMENTS = 1;

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCUMENTS, account.Id, false);
        originationDocuments[0].Document_Submitted__c = Date.today();
        insert originationDocuments;

        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        Id originationId = originationDocuments[0].id;

        attachments[0].ParentId = originationDocuments[0].Id;
        insert attachments;

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRow = new InvoiceDocumentUploadController.InvoiceDocumentRow(originationDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();

            invoiceDocumentRow.deleteDocument();

        Test.stopTest();

        List<Origination_Document__c> actualOriginationDocs = [SELECT Id, Document_Submitted__c, Status__c, Link_to_Attachment__c FROM Origination_Document__c WHERE Account__c = :account.Id AND Id = :originationId];
        List<Attachment> actualAttachments = [SELECT Id FROM Attachment WHERE ParentId = :originationId];

        System.assert(!actualOriginationDocs.isEmpty(), 'The origination document should not have been deleted');
        System.assertEquals(null, actualOriginationDocs[0].Document_Submitted__c, 'The document submitted field should be nulled out');
        System.assertEquals(null, actualOriginationDocs[0].Link_to_Attachment__c, 'The link to attachment field should be nulled out');
        System.assertEquals(InvoiceDocumentServices.NOT_SUBMITTED, actualOriginationDocs[0].Status__c, 'The document status should be set correctly');
        System.assert(actualAttachments.isEmpty(), 'We should not get any attachments back from the query');
    }

    public static testMethod void testReUploadDeletedInvoiceDocument()
    {
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);

        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments[0];
        instantiateLeasePaymentController();

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRow = new InvoiceDocumentUploadController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();
            invoiceController.invoiceDocumentRows[0] = invoiceDocumentRow;
            invoiceDocumentRow.deleteDocument();

            //reupload an attachment to invoice document row
            attachments[1].ParentId = invoiceDocumentRow.invoiceDocument.Id;
            invoiceDocumentRow.att = attachments[1];
            invoiceController.submit();

        Test.stopTest();

        List<Invoice_Documents__c> actualInvoiceDocs = [SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id];
        List<Attachment> actualAttachments = [SELECT Id FROM Attachment WHERE ParentId = :invoiceDocumentRow.invoiceDocument.Id];

        System.assert(!actualInvoiceDocs.isEmpty(), 'A new invoice document should be inserted');
        System.assert(!actualAttachments.isEmpty(), 'An attachment should have been created');
    }

    public static testMethod void testReUploadDeletedOriginationDocument()
    {
        account = TestUtils.createAccount('TestAccount', true);

        final Integer NUM_DOCUMENTS = 2;

        List<Origination_Document__c> originationDocuments = TestUtils.createOriginationDocuments(NUM_DOCUMENTS, account.Id, true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);

        attachments[0].ParentId = originationDocuments[0].Id;
        insert attachments[0];
        instantiateAccountController();

        InvoiceDocumentUploadController.InvoiceDocumentRow invoiceDocumentRow = new InvoiceDocumentUploadController.InvoiceDocumentRow(originationDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();
            invoiceController.invoiceDocumentRows[0] = invoiceDocumentRow;
            invoiceDocumentRow.deleteDocument();

            //reupload an attachment to invoice document row
            attachments[1].ParentId = invoiceDocumentRow.invoiceDocument.Id;
            invoiceDocumentRow.att = attachments[1];
            invoiceController.submit();

        Test.stopTest();

        List<Origination_Document__c> actualOriginationDocs = [SELECT Id FROM Origination_Document__c WHERE Account__c = :account.Id];
        List<Attachment> actualAttachments = [SELECT Id FROM Attachment WHERE ParentId = :invoiceDocumentRow.invoiceDocument.Id];

        System.assert(!actualOriginationDocs.isEmpty(), 'A new invoice document should be inserted');
        System.assert(!actualAttachments.isEmpty(), 'An attachment should have been created');
    }

}