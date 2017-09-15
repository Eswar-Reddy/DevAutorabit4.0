@isTest
public without sharing class OppRoleDocumentController_Test {
    
    @TestSetup
    public static void setupDocData() {
        
        List<Document_Data_Matrix__c> matrixList = new List<Document_Data_Matrix__c>();
        Document_Data_Matrix__c d = new Document_Data_Matrix__c();
        d.Name = 'Test';
        d.Contract_Type__c = 'PPA';
        d.Deal_Type__c = 'PPA (including EPC)';
        d.Document_Type__c = 'Firm Offer Approval';
        d.Effective_End_Date__c = Date.today().addDays(30);
        d.Effective_Start_Date__c = Date.today().addDays(-1);
        d.Required_for_Approval__c = true;
        d.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d);
        
        Document_Data_Matrix__c d2 = new Document_Data_Matrix__c();
        d2.Name = 'Test2';
        d2.Contract_Type__c = 'PPA';
        d2.Deal_Type__c = 'PPA (including EPC)';
        d2.Document_Type__c = 'Firm Offer Approval';
        d2.Effective_End_Date__c = Date.today().addDays(30);
        d2.Effective_Start_Date__c = Date.today().addDays(-1);
        d2.Required_for_Approval__c = true;
        d2.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Document_Data_Matrix__c', 'Opportunity Role');
        matrixList.add(d2);
        
        insert matrixList;
        
        
        Account a = TestClassFactory.testAccount('TestAcct', TestClassFactory.retrieveRecordTypeId('Account', 'Standard'));
        insert a;
        
        Opportunity o = TestClassFactory.testOpportunity('Commercial Opp1', '01 - Build Single Sales Objective', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Systems'));
        o.Contract_Type__c = 'PPA (including EPC)';
        o.Business_Unit__c = 'NA Commercial';
        o.Region1__c = 'Americas';
        o.Sub_Region__c = 'California - North';
        
        insert o;
        
        Opportunity_Role__c role = new Opportunity_Role__c();
        role.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Opportunity_Role__c', 'Energy Off Taker (PPA)');
        role.Contract_Type__c = 'PPA';
        role.Account__c = a.Id;
        role.Opp_Name__c = o.Id;
        insert role;
        
    }
    
    
    private static TestMethod void testDocUpload1() {
        
        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];
        
        UC_Document__c doc = [SELECT Id FROM UC_Document__c LIMIT 1];
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('Test');
        a.ParentId = doc.Id;
        a.Name = 'test.xlsx';
        insert a;
        
        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);
        
        OppRoleDocumentUploadController.OppRoleDocumentRow row = controller.oppRoleDocList[0];
        row.originalFileName = 'New Attachment Test';
        row.att.Body = Blob.valueOf('test2');
        row.att.Name = 'Test2';
        
        controller.insertAttachments();
        
        PageReference ref2 = controller.Cancel();
        
        Test.stopTest();
    }
    
    private static TestMethod void testDocDelete1() {
        
        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];
        
        UC_Document__c doc = [SELECT Id FROM UC_Document__c LIMIT 1];
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('Test');
        a.ParentId = doc.Id;
        a.Name = 'test.xlsx';
        insert a;
        
        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);
        
        OppRoleDocumentUploadController.OppRoleDocumentRow row = controller.oppRoleDocList[0];
        row.originalFileName = 'New Attachment Test';
        row.att.Body = Blob.valueOf('test2');
        row.att.Name = 'Test2';
        
        controller.insertAttachments();
        
        OppRoleDocumentUploadController.DeleteAttachmentRequest delRequest = new OppRoleDocumentUploadController.DeleteAttachmentRequest();
        delRequest.attachmentId = [SELECT Id FROM Attachment LIMIT 1].Id;
        
        OppRoleDocumentUploadController.DeleteAttachmentResponse response = OppRoleDocumentUploadController.deleteAttachment(delRequest);
        
        Test.stopTest();
    }
    
    private static TestMethod void testDocDelete2() {
        
        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];
        
        UC_Document__c doc = [SELECT Id FROM UC_Document__c LIMIT 1];
        
        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);
        
        OppRoleDocumentUploadController.OppRoleDocumentRow row = controller.oppRoleDocList[0];
        row.originalFileName = 'New Attachment Test';
        row.att.Body = Blob.valueOf('test');
        row.att.Name = 'Test';
        
        controller.insertAttachments();
        
        OppRoleDocumentUploadController.DeleteAttachmentRequest delRequest = new OppRoleDocumentUploadController.DeleteAttachmentRequest();
        delRequest.attachmentId = [SELECT Id FROM Attachment LIMIT 1].Id;
        
        OppRoleDocumentUploadController.DeleteAttachmentResponse response = OppRoleDocumentUploadController.deleteAttachment(delRequest);
        System.assert(response.isSuccess == true, response);
        
        Test.stopTest();
    }
    
    private static TestMethod void negativetestDocUpload1() {
        
        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];
        
        UC_Document__c doc = [SELECT Id FROM UC_Document__c LIMIT 1];
        
        Attachment a = new Attachment();
        a.Body = Blob.valueOf('Test');
        a.ParentId = doc.Id;
        a.Name = 'test.xlsx';
        insert a;
        
        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);
        
        OppRoleDocumentUploadController.OppRoleDocumentRow row = controller.oppRoleDocList[0];
        row.att.Body = Blob.valueOf('test2');
        row.att.Name = 'Test2';
        
        controller.insertAttachments();
        
        Test.stopTest();
    }
    
    private static TestMethod void negativetestDocUpload2() {
        
        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];
        
        delete [SELECT Id FROM UC_Document__c];
        
        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);
        
        controller.insertAttachments();
        
        controller.dmlSuccess = null;
        
        Boolean testSuccess = controller.dmlSuccess;
        
        Test.stopTest();
    }
    
    private static TestMethod void negativeTestDocDelete1() {

        Opportunity_Role__c role = [SELECT Id, RecordTypeId, Contract_Type__c, Opp_Name__c
                                    FROM Opportunity_Role__c LIMIT 1];

        UC_Document__c doc = [SELECT Id FROM UC_Document__c LIMIT 1];

        Attachment a = new Attachment();
        a.Body = Blob.valueOf('Test');
        a.ParentId = role.Opp_Name__c;
        a.Name = 'test.xlsx';
        insert a;

        Test.startTest();
        PageReference ref = Page.OppRoleDocumentUpload;
        ref.getParameters().put('id', role.Id);
        Test.setCurrentPage(ref);

        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        OppRoleDocumentUploadController controller = new OppRoleDocumentUploadController(sc);

        OppRoleDocumentUploadController.OppRoleDocumentRow row = controller.oppRoleDocList[0];
        row.originalFileName = 'New Attachment Test';
        row.att.Body = Blob.valueOf('test2');
        row.att.Name = 'Test2';

        controller.insertAttachments();
        
        OppRoleDocumentUploadController.DeleteAttachmentResponse response = OppRoleDocumentUploadController.deleteAttachment(null);
        System.assert(response.isSuccess == false, response);
        
        OppRoleDocumentUploadController.DeleteAttachmentRequest delRequest1 = new OppRoleDocumentUploadController.DeleteAttachmentRequest();
        delRequest1.attachmentId = null;
        OppRoleDocumentUploadController.DeleteAttachmentResponse response1 = OppRoleDocumentUploadController.deleteAttachment(delRequest1);
		System.assert(response1.isSuccess == false, response1);
        
        OppRoleDocumentUploadController.DeleteAttachmentRequest delRequest2 = new OppRoleDocumentUploadController.DeleteAttachmentRequest();
        delRequest2.attachmentId = a.Id;
        OppRoleDocumentUploadController.DeleteAttachmentResponse response2 = OppRoleDocumentUploadController.deleteAttachment(null);
		System.assert(response2.isSuccess == false, response2);

        Test.stopTest();
    }
}