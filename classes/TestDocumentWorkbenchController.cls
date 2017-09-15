@isTest(SeeAllData=true)
public class TestDocumentWorkbenchController{
    
    public static final String STATE = 'NY';
    static final List<String> DOCUMENT_TYPES = new List<String>{ 'type1', 'type3', 'typesX1' };
    static final Set<String> BAD_DOCUMENT_TYPES = new Set<String>{ 'moe', 'larry', 'curley' };
    static final String INVOICE_TYPE = 'install';
    static final String ORIGINATION_TYPE = 'origination';
    static final String REJECTED = 'Rejected';
    static LeasePayment__c leasePayment;
    static Account account;
    static Opportunity oppty;
    static DocumentWorkbenchController dwController;
    static Account customerAccount;
    static List<Opportunity> lstCustomerOpportunity;
    public static List<Contact> lstCustomerContact;
    public static List<Quote> lstQuotes;
    public static List<Document__c> docList;
    
    
    private static void setupLeasePayment(){
        
        Account partnerAccount = TestUtils.createAccount('TestAccount', false);
        partnerAccount.NH_SSE_Type__c ='TPS';
        insert partnerAccount;
        leasePayment = TestUtils.createLeasePayment('TestLeasePayment', partnerAccount.Id, false);
        leasePayment.Site_State_Prov_old__c = STATE;
        leasePayment.Date_Countersigned_old__c = Date.today();
        insert leasePayment;
        
        leasePayment = [SELECT Id, Site_State_Prov__c, CreatedDate, Date_Countersigned_old__c, Date_Countersigned__c, Lease__c FROM LeasePayment__c WHERE Id = :leasePayment.id LIMIT 1];
    }
    
    public static testMethod void testgetMethods(){
        setupLeasePayment();
        instantiateLeasePaymentController();
        
        Test.startTest();
        String GAProfileId = dwController.googleAnalyticsProfileId;
        System.assertEquals(GAProfileId,Null);
        test.stopTest();
    }
    
    public static testMethod void testQueryDocuments_NoDocument(){
        setupLeasePayment();
        instantiateLeasePaymentController();
        
        Test.startTest();
        
        dwController.queryDocuments();
        
        test.stopTest();
        
        System.assert(dwController.invoiceDocumentRows.isEmpty(), 'The controller should have no invoice document rows');
    }
    
    public static testMethod void testQueryInvoiceDocument_WithApprovedDocument(){
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
        
        System.assertEquals(1, dwController.invoiceDocumentRows.size(), 'One invoice document should be queried back');
        System.assertEquals(invoiceDocument.Id, dwController.invoiceDocumentRows[0].invoiceDocument.Id, 'The correct invoice document should be queried back');
        System.assertEquals(attachment.Id, dwController.invoiceDocumentRows[0].att.Id, 'The correct attachment should be queried back');
    }
    
    public static testMethod void testQueryInvoiceDocument_WithRejectedDocument(){
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
        
        System.assertEquals(1, dwController.invoiceDocumentRows.size(), 'One invoice document should be queried back');
        System.assertEquals(invoiceDocument.Id, dwController.invoiceDocumentRows[0].invoiceDocument.Id, 'The correct invoice document should be queried back');
        //System.assertEquals(null, dwController.invoiceDocumentRows[0].att.Id, 'A new attachment should be used for rejected documents');
    }
    
    //Test Submit with Attachments
    public static testMethod void testSubmitInvoiceDocuments_withAttachment(){
        setupLeasePayment();
        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,true);
        
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(invoiceDocuments, attachments, 'ParentId');
        instantiateLeasePaymentController();

        Test.startTest();

            //the equivalent of the user selecting a file
            for(Integer i = 0; i < NUM_DOCUMENTS; i++){
                invoiceDocuments[i].Documents_in_File__c = DOCUMENT_TYPES[i];
                dwController.invoiceDocumentRows[i].invoiceDocument = invoiceDocuments[i];
                dwController.invoiceDocumentRows[i].att = attachments[i];
            }
            dwController.submit();

        Test.stopTest();

        Map<Id, Invoice_Documents__c> invoiceDocMap = new Map<Id, Invoice_Documents__c>([SELECT Id, Name, Lease_Payment__c, Link_to_Attachment__c, Status__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id]);
        Map<Id, Attachment> attMap = new Map<Id, Attachment>([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :invoiceDocMap.keySet()]);

        System.assertEquals(NUM_DOCUMENTS, invoiceDocMap.size(), 'We should have inserted 2 documents');
        System.assertEquals(NUM_DOCUMENTS, attMap.size(), 'We should have inserted '+ NUM_DOCUMENTS + ' attachments');

        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR), 'There should be no errors on the page');

        for(Integer i = 0; i < NUM_DOCUMENTS; i++){
            Attachment expectedAtt = dwController.invoiceDocumentRows[i].att;
            Invoice_Documents__c expectedDoc = (Invoice_Documents__c) dwController.invoiceDocumentRows[i].invoiceDocument;

            Attachment actualAtt = attMap.get(expectedAtt.Id);
            Invoice_Documents__c actualInvoiceDoc = invoiceDocMap.get(expectedDoc.Id);
            
            //System.assertEquals(InvoiceDocumentUploadController.baseURL + expectedAtt.Id, actualInvoiceDoc.Link_to_Attachment__c, 'link to attachment should have been populated');
            System.assertEquals(InvoiceDocumentServices.PENDING, actualInvoiceDoc.Status__c, 'The status should be changed to pending');
            System.assertEquals(actualAtt.ParentId, actualInvoiceDoc.Id, 'The inserted attachment should link to the inserted document');
        }
    }
    
    //test submit without attachments
    public static testMethod void testSubmitDocuments_withoutAttachment(){
        setupLeasePayment();
        instantiateLeasePaymentController();

        Test.startTest();

            dwController.submit();

        Test.stopTest();

        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR), 'We should get an error');
        System.assertEquals(System.Label.SUBMIT_WITHOUT_ATTACHMENTS, ApexPages.getMessages()[0].getSummary(), 'We should get the correct error message');
    }
    
    //Test updateDocuments method
    public static testMethod void testUpdateInvoiceDocuments(){
        setupLeasePayment();

        Integer NUM_DOCUMENTS = 1;

        List<DocumentWorkbenchController.InvoiceDocumentRow> rowsToUpdate = new List<DocumentWorkbenchController.InvoiceDocumentRow>();

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments;

        instantiateLeasePaymentController();

        List<Attachment> queriedAtt = [SELECT Id, CreatedDate, ParentId FROM Attachment WHERE Id = :attachments[0].Id];
        Map<Id, Attachment> attMap = new Map<Id, Attachment>();
        attMap.put(queriedAtt[0].ParentId, queriedAtt[0]);

        Test.startTest();
            boolean isNew = dwController.invoiceDocumentRows[0].isNew;
            boolean isPending = dwController.invoiceDocumentRows[0].isPending;
            dwController.invoiceDocumentRows[0].invoiceDocument = invoiceDocuments[0];
            dwController.invoiceDocumentRows[0].att = attachments[0];
            rowsToUpdate.add(dwController.invoiceDocumentRows[0]);
            List<Invoice_Documents__c> actualDocuments = dwController.updateDocuments(rowsToUpdate, attMap);
        Test.stopTest();
        
        dwController.filterRedirect();
        String attId = attachments[0].Id;
        System.assertEquals(1, actualDocuments.size(), 'One document should have been updated');
        //System.assertEquals(InvoiceDocumentUploadController.baseURL + attId, actualDocuments[0].Link_to_Attachment__c, 'Link to attachment should have been updated');
    }
    
    //test Valid Upload
    public static testMethod void testValidUpload_InvoiceDocuments(){
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = invoiceDocuments[0].Id;
        attachments[1].ParentId = invoiceDocuments[1].Id;
        attachments[1].body = null;

        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRowSucceed = new DocumentWorkbenchController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRowSucceed.att = attachments[0];
        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRowFail = new DocumentWorkbenchController.InvoiceDocumentRow(invoiceDocuments[1]);
        invoiceDocumentRowFail.att = attachments[1];

        Test.startTest();

            Boolean actualSucceed = invoiceDocumentRowSucceed.validUpload();
            Boolean actualFail = invoiceDocumentRowFail.validUpload();

        Test.stopTest();

        System.assert(actualSucceed, 'This row should be a valid upload');
        System.assert(!actualFail, 'This row should not be a valid upload');
    }
    
    //test Delete
    public static testMethod void testDeleteInvoiceDocument(){
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 1;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,false);
        invoiceDocuments[0].Document_Submitted__c = Date.today();
        insert invoiceDocuments;

        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        Id invoiceId = invoiceDocuments[0].id;

        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments;

        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRow = new DocumentWorkbenchController.InvoiceDocumentRow(invoiceDocuments[0]);
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
    
    
    //test Delete with Response Date not null
    public static testMethod void testDeleteInvoiceDocumentResponseDate(){
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 1;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,false);
        invoiceDocuments[0].Document_Submitted__c = Date.today();
        insert invoiceDocuments;
        
        List<Attachment> attachments = TestUtils.createAttachments(2, 'TEST', false);

        attachments[0].ParentId = invoiceDocuments[0].Id;
        attachments[1].ParentId = invoiceDocuments[0].Id;
        insert attachments;
        
        invoiceDocuments[0].Response_Date__c=Date.today();
        update invoiceDocuments;
        
        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRow = new DocumentWorkbenchController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();

            invoiceDocumentRow.deleteDocument();

        Test.stopTest();

    }
    
    //test reupload delete
    public static testMethod void testReUploadDeletedInvoiceDocument(){
        setupLeasePayment();

        final Integer NUM_DOCUMENTS = 2;
        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,true);
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);

        attachments[0].ParentId = invoiceDocuments[0].Id;
        insert attachments[0];
        instantiateLeasePaymentController();

        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRow = new DocumentWorkbenchController.InvoiceDocumentRow(invoiceDocuments[0]);
        invoiceDocumentRow.att = attachments[0];

        Test.startTest();
            dwController.invoiceDocumentRows[0] = invoiceDocumentRow;
            invoiceDocumentRow.deleteDocument();

            //reupload an attachment to invoice document row
            attachments[1].ParentId = invoiceDocumentRow.invoiceDocument.Id;
            invoiceDocumentRow.att = attachments[1];
            dwController.submit();

        Test.stopTest();

        List<Invoice_Documents__c> actualInvoiceDocs = [SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id];
        List<Attachment> actualAttachments = [SELECT Id FROM Attachment WHERE ParentId = :invoiceDocumentRow.invoiceDocument.Id];

        System.assert(!actualInvoiceDocs.isEmpty(), 'A new invoice document should be inserted');
        System.assert(!actualAttachments.isEmpty(), 'An attachment should have been created');
    }
    
    private static void setupLeasePayment2(){
        
        customerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'NY';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        lstCustomerContact = new List<Contact>();
        lstCustomerContact.add(TestUtils.createContact('CustomerContact', CustomerAccount.Id, true));
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        //lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
        
        //// Quote Creation
        lstQuotes = TestUtils.createQuotes(1, 'NYLeaseQuoteDWCT1', lstCustomerOpportunity[0].id, false);
        lstQuotes[0].Account__c=customerAccount.Id;
        lstQuotes[0].OpportunityId=lstCustomerOpportunity[0].Id;
        lstQuotes[0].ContactID=lstCustomerContact[0].Id;
        lstQuotes[0].System_Cost__c=25000.00;
        //lstQuotes[0].Module_Oracle_Item_Number__c=item.Id;
        lstQuotes[0].Module_Quantity__c =16;
        lstQuotes[0].Dealer_Fees__c =13000;
        lstQuotes[0].QuoteType__c ='Lease';
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Quote_Type__c='TPS Quote';
        upsert lstQuotes;
        
        
        leasePayment = TestUtils.createLeasePayment('TestLeasePayment', customerAccount.Id, false);
        leasePayment.Site_State_Prov_old__c = STATE;
        leasePayment.Date_Countersigned_old__c = Date.today();
        leasePayment.Quote__c = lstQuotes[0].Id;
        leasePayment.Opportunity__c=lstCustomerOpportunity[0].Id;
        insert leasePayment;
        oppty = [select Id from Opportunity where Id=:lstCustomerOpportunity[0].Id];
        leasePayment = [SELECT Id, Site_State_Prov__c, CreatedDate, Date_Countersigned_old__c, Date_Countersigned__c, Lease__c, Quote__r.OpportunityId FROM LeasePayment__c WHERE Id = :leasePayment.id LIMIT 1];
    }
    
    //Test Submit with Attachments
    public static testMethod void testSubmitInvoiceDocuments_withAttachment_Shared(){
        test.startTest();
        setupLeasePayment2();
        test.stopTest();
        final Integer NUM_DOCUMENTS = 2;

        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Shared','Opportunity','DRIP',true);
        
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(invoiceDocuments, attachments, 'ParentId');
        instantiateLeasePaymentController();

        //Test.startTest();

            //the equivalent of the user selecting a file
            for(Integer i = 0; i < NUM_DOCUMENTS; i++){
                invoiceDocuments[i].Documents_in_File__c = DOCUMENT_TYPES[i];
                dwController.invoiceDocumentRows[i].invoiceDocument = invoiceDocuments[i];
                dwController.invoiceDocumentRows[i].att = attachments[i];
            }
            dwController.submit();

        //Test.stopTest();

        Map<Id, Invoice_Documents__c> invoiceDocMap = new Map<Id, Invoice_Documents__c>([SELECT Id, Name, Lease_Payment__c, Link_to_Attachment__c, Status__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id]);
        Map<Id, Attachment> attMap = new Map<Id, Attachment>([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :invoiceDocMap.keySet()]);

        for(Integer i = 0; i < NUM_DOCUMENTS; i++){
            Attachment expectedAtt = dwController.invoiceDocumentRows[i].att;
            Invoice_Documents__c expectedDoc = (Invoice_Documents__c) dwController.invoiceDocumentRows[i].invoiceDocument;

            Attachment actualAtt = attMap.get(expectedAtt.Id);
            Invoice_Documents__c actualInvoiceDoc = invoiceDocMap.get(expectedDoc.Id);
        }
    }
    
    //Test Shared Documents attachments where Docs on Opportunity are already existing.
    public static testMethod void testSubmitInvoiceDocuments_withAttachment_DocType_Shared(){
        test.startTest();
        setupLeasePayment2();
        test.stopTest();
        
        final Integer NUM_DOCUMENTS = 2;
        
        docList = new List<Document__c>();
        docList.add(new Document__c(Document_Type__c='Photos1',Opportunity__c=leasePayment.Quote__r.OpportunityId));
        docList.add(new Document__c(Document_Type__c='Photos2',Opportunity__c=leasePayment.Quote__r.OpportunityId));
        insert docList;
        
        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Shared','Opportunity','DRIP',false);
        invoiceDocuments[0].Documents_in_File__c='Photos1';
        invoiceDocuments[1].Documents_in_File__c='Photos2';
        insert invoiceDocuments;
        
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(invoiceDocuments, attachments, 'ParentId');
        instantiateLeasePaymentController();

        //Test.startTest();

            //the equivalent of the user selecting a file
            for(Integer i = 0; i < NUM_DOCUMENTS; i++){
                invoiceDocuments[i].Documents_in_File__c = DOCUMENT_TYPES[i];
                dwController.invoiceDocumentRows[i].invoiceDocument = invoiceDocuments[i];
                dwController.invoiceDocumentRows[i].att = attachments[i];
            }
            dwController.submit();

        //Test.stopTest();

        Map<Id, Invoice_Documents__c> invoiceDocMap = new Map<Id, Invoice_Documents__c>([SELECT Id, Name, Lease_Payment__c, Link_to_Attachment__c, Status__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :leasePayment.Id]);
        Map<Id, Attachment> attMap = new Map<Id, Attachment>([SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :invoiceDocMap.keySet()]);

        for(Integer i = 0; i < NUM_DOCUMENTS; i++){
            Attachment expectedAtt = dwController.invoiceDocumentRows[i].att;
            Invoice_Documents__c expectedDoc = (Invoice_Documents__c) dwController.invoiceDocumentRows[i].invoiceDocument;

            Attachment actualAtt = attMap.get(expectedAtt.Id);
            Invoice_Documents__c actualInvoiceDoc = invoiceDocMap.get(expectedDoc.Id);
        }
    }
    
    //Test Shared Documents attachments where Docs on Opportunity are already existing with Attachments.
    public static testMethod void testSubmitInvoiceDocuments_withAttachment_DocAttachments(){
        test.startTest();
        setupLeasePayment2();
        test.stopTest();
        
        final Integer NUM_DOCUMENTS = 2;
        
        docList = new List<Document__c>();
        docList.add(new Document__c(Document_Type__c='Photos1',Opportunity__c=leasePayment.Quote__r.OpportunityId));
        docList.add(new Document__c(Document_Type__c='Photos2',Opportunity__c=leasePayment.Quote__r.OpportunityId));
        insert docList;
        
        List<Invoice_Documents__c> sharedInvoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Shared','Opportunity','DRIP',false);
        sharedInvoiceDocuments[0].Documents_in_File__c='Photos1';
        sharedInvoiceDocuments[1].Documents_in_File__c='Photos2';
        insert sharedInvoiceDocuments;
        
        List<Attachment> docAttachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(docList, docAttachments, 'ParentId');
        insert docAttachments;
        
        List<Invoice_Documents__c> secureInvoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,false);
        insert secureInvoiceDocuments;
        
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        associateChildren(secureInvoiceDocuments, attachments, 'ParentId');
        insert attachments;
        
        instantiateLeasePaymentController();
    }
    
    //Test Delete withe Response Date not null with Shared Documents
    public static testMethod void testSubmitInvoiceDocuments_withAttachment_DocAttachments_Delete(){
        test.startTest();
        setupLeasePayment2();
        test.stopTest();
        
        final Integer NUM_DOCUMENTS = 1;
        
        docList = new List<Document__c>();
        docList.add(new Document__c(Document_Type__c='Photos1',Opportunity__c=leasePayment.Quote__r.OpportunityId));
        insert docList;
        
        List<Invoice_Documents__c> sharedInvoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Shared','Opportunity','DRIP',false);
        sharedInvoiceDocuments[0].Documents_in_File__c='Photos1';
        insert sharedInvoiceDocuments;
        
        List<Attachment> docAttachments = TestUtils.createAttachments(2, 'TEST', false);
        docAttachments[0].ParentId=docList[0].Id;
        docAttachments[1].ParentId=docList[0].Id;
        insert docAttachments;
        
        instantiateLeasePaymentController();
        
        sharedInvoiceDocuments[0].Response_Date__c=Date.today();
        update sharedinvoiceDocuments;
        
        DocumentWorkbenchController.InvoiceDocumentRow invoiceDocumentRow = new DocumentWorkbenchController.InvoiceDocumentRow(sharedinvoiceDocuments[0]);
        invoiceDocumentRow.att = docAttachments[0];

        //Test.startTest();

            invoiceDocumentRow.deleteDocument();

        //Test.stopTest();
        
    }
    
    
    
    private static void associateChildren(List<SObject> parents, List<SObject> children, String childLookupFieldName) {
        for(Integer i = 0; i< parents.size(); i++) {
            children[i].put(childLookupFieldName, parents[i].Id);
        }
    }
    
    private static void instantiateLeasePaymentController(){
        ApexPages.StandardController sc = new ApexPages.StandardController(leasePayment);
        Test.setCurrentPageReference(Page.DocumentWorkbench);
        ApexPages.currentPage().getParameters().put(DocumentWorkbenchController.ID_URL_PARAM, leasePayment.Id);
        ApexPages.currentPage().getParameters().put(DocumentWorkbenchController.TYPE_URL_PARAM, INVOICE_TYPE);
        dwController = new DocumentWorkbenchController(sc);
    }
    
    
    private static void setupLoanFPO(){
        
        customerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'NY';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        lstCustomerContact = new List<Contact>();
        lstCustomerContact.add(TestUtils.createContact('CustomerContact', CustomerAccount.Id, true));
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        //lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
        
        //// Quote Creation
        lstQuotes = TestUtils.createQuotes(1, 'NYLeaseQuoteDWCT1', lstCustomerOpportunity[0].id, false);
        lstQuotes[0].Account__c=customerAccount.Id;
        lstQuotes[0].OpportunityId=lstCustomerOpportunity[0].Id;
        lstQuotes[0].ContactID=lstCustomerContact[0].Id;
        lstQuotes[0].System_Cost__c=25000.00;
        //lstQuotes[0].Module_Oracle_Item_Number__c=item.Id;
        lstQuotes[0].Module_Quantity__c =16;
        lstQuotes[0].Dealer_Fees__c =13000;
        lstQuotes[0].QuoteType__c ='Loan';
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        lstQuotes[0].Quote_Type__c='TPS Quote';
        upsert lstQuotes;
        
        
        leasePayment = TestUtils.createLeasePayment('TestLeasePayment', customerAccount.Id, false);
        leasePayment.Site_State_Prov_old__c = STATE;
        leasePayment.Date_Countersigned_old__c = Date.today();
        leasePayment.Quote__c = lstQuotes[0].Id;
        leasePayment.Opportunity__c=lstCustomerOpportunity[0].Id;
        insert leasePayment;
        oppty = [select Id from Opportunity where Id=:lstCustomerOpportunity[0].Id];
        leasePayment = [SELECT Id, Site_State_Prov__c, CreatedDate, Date_Countersigned_old__c, Date_Countersigned__c, Lease__c, Quote__r.OpportunityId FROM LeasePayment__c WHERE Id = :leasePayment.id LIMIT 1];
    }
    
        //Test updateDocuments method
    public static testMethod void testMosaicUploadDocuments1(){
        setupLoanFPO();
        Integer NUM_DOCUMENTS = 3;
        
        List<Invoice_Documents__c> invoiceDocuments = TestUtils.createTPSInvoiceDocuments(NUM_DOCUMENTS, leasePayment.Id, INVOICE_TYPE,'TPS','Document','TPS','Secure',null,null,false);
        invoiceDocuments[0].Documents_in_File__c = 'Photos';
        invoiceDocuments[0].Status__c = 'Submitted';
        
        invoiceDocuments[1].Documents_in_File__c = 'PTO Letter';
        invoiceDocuments[1].Status__c = 'Submitted';
        
        invoiceDocuments[2].Documents_in_File__c= 'Final Permit';
        invoiceDocuments[2].Status__c = 'Submitted';
        
        insert invoiceDocuments;
        
        List<Attachment> attachments = TestUtils.createAttachments(NUM_DOCUMENTS, 'TEST', false);
        attachments[0].ParentId = invoiceDocuments[0].Id;
        attachments[1].ParentId = invoiceDocuments[1].Id;
        attachments[2].ParentId = invoiceDocuments[2].Id;
        insert attachments;
        
        test.startTest();
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        invoiceDocuments[0].Status__c = 'Approved';
        invoiceDocuments[1].Status__c = 'Approved';
        invoiceDocuments[2].Status__c = 'Approved';
        update invoiceDocuments;

        test.stopTest();
    }
}