@isTest
public class ProjectDocumentsControllerTest {

	@testSetup static void setupControllers() {
 		//Setup Test Data
       	Account a = new Account(Name = 'TestAccount', BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
       	insert a;

 		Residential_Project__c rc = new Residential_Project__c(Name = 'TestResidentialProject', Status__c = 'Active', Account__c = a.id);
 		rc.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId();
       	insert rc;

       	LeasePayment__c lp = new LeasePayment__c(Name = 'TestFinancialPayment', Account__c = a.id, Residential_Project__c = rc.Id);
       	insert lp;

		Project_Task__c ta = new Project_Task__c(Name = 'TestProjectTask', Residential_Project__c = rc.id, Status__c = 'Not Started');
		insert ta;

       	Document__c projDoc = new Document__c(Name = '1TestProjectDocument', Residential_Project__c = rc.id, Project_Task__c = ta.id);
       	insert projDoc;

       	Document__c projRPDoc = new Document__c(Name = '2TestProjectDocumentResidentialProject', Residential_Project__c = rc.id, Project_Task__c = ta.id, Document_Type__c = '12 Month Utility Bills');
       	insert projRPDoc;

       	Invoice_Documents__c invDoc = new Invoice_Documents__c(Name = '1TestInvoiceDocument', Invoice_Type__c = 'Origination', Lease_Payment__c = lp.id, Status__c = 'Approved');
       	insert invDoc;

       	Invoice_Documents__c invRPDoc = new Invoice_Documents__c(Name = '2TestInvoiceDocumentResidentialProject', Invoice_Type__c = 'Origination', Lease_Payment__c = lp.id, Status__c = 'Approved', Location__c = 'Residential Project', Documents_in_File__c = '12 Month Utility Bills');
       	insert invRPDoc;
	}

	static testMethod void testProjectDocumentsContoller() {
	 	//Get Setup Ids
	 	Residential_Project__c rc = [SELECT Id FROM Residential_Project__c];
 		Document__c projDoc = [SELECT Id FROM Document__c WHERE Name = '1TestProjectDocument'];
 		Document__c projRPDoc = [SELECT Id FROM Document__c WHERE Name = '2TestProjectDocumentResidentialProject'];
		Invoice_Documents__c invDoc = [SELECT Id FROM Invoice_Documents__c WHERE Name = '1TestInvoiceDocument'];

    	//Get Controller
       	ApexPages.StandardController rcController = new ApexPages.StandardController(rc);
		ProjectDocumentsController pdController = new ProjectDocumentsController(rcController);

		test.startTest();
			//Test Partner Comments
			pdController.origDocRows[0].invDoc.Partner_Comments__c = 'TestComment';
			pdController.partnerCommentUpdate();
			List<Invoice_Documents__c> invDocComments = [SELECT Id FROM Invoice_Documents__c WHERE Partner_Comments__c = 'TestComment'];
			system.assertEquals(1, invDocComments.size());

			//Test Saving Project Attachment
			pdController.projDocRows[0].attName = 'TestAttachment';
			pdController.projDocRows[0].attBody = Blob.valueOf('TestAttachmentBody');
			pdController.saveFile();
			List<Attachment> savedAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projDoc.id AND Name = 'TestAttachment'];
			system.assertEquals(1, savedAttachment.size());

			//Test Deleting Project Attachment
			pdController.deleteDocId = savedAttachment[0].id;
			pdController.deleteDoc();
			List<Attachment> deletedAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projDoc.id AND Name = 'TestAttachment'];
			system.assertEquals(0, deletedAttachment.size());

			//Test nextPage
			pdController.nextPage();
			system.assertEquals(pdController.rowsOnPage, pdController.pagePtr[0]);

			//Test prevPage
			pdController.prevPage();
			system.assertEquals(0, pdController.pagePtr[0]);
		test.stopTest();
	}

	static testMethod void testInvoiceDocument() {
	 	//Get Setup Ids
	 	Residential_Project__c rc = [SELECT Id FROM Residential_Project__c];
 		Document__c projDoc = [SELECT Id FROM Document__c WHERE Name = '1TestProjectDocument'];
 		Document__c projRPDoc = [SELECT Id FROM Document__c WHERE Name = '2TestProjectDocumentResidentialProject'];
		Invoice_Documents__c invDoc = [SELECT Id FROM Invoice_Documents__c WHERE Name = '1TestInvoiceDocument'];

    	//Get Controller
       	ApexPages.StandardController rcController = new ApexPages.StandardController(rc);
		ProjectDocumentsController pdController = new ProjectDocumentsController(rcController);

		test.startTest();
			//Test Saving Invoice Document Attachment
			pdController.origDocRows[0].attName = 'TestAttachment2';
			pdController.origDocRows[0].attBody = Blob.valueOf('TestAttachmentBody');
			pdController.saveFile();
			List<Attachment> savedInvAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :invDoc.id AND Name = 'TestAttachment2'];
			system.assertEquals(1, savedInvAttachment.size());

			//Test Deleting InvoiceDocument Attachment
			pdController.deleteDocId = savedInvAttachment[0].id;
			pdController.deleteInvDoc();
			List<Attachment> deletedInvAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :invDoc.id AND Name = 'TestAttachment2'];
			system.assertEquals(0, deletedInvAttachment.size());
		test.stopTest();
	}

	static testMethod void testRPMDocument() {
	 	//Get Setup Ids
	 	Residential_Project__c rc = [SELECT Id FROM Residential_Project__c];
 		Document__c projDoc = [SELECT Id FROM Document__c WHERE Name = '1TestProjectDocument'];
 		Document__c projRPDoc = [SELECT Id FROM Document__c WHERE Name = '2TestProjectDocumentResidentialProject'];
		Invoice_Documents__c invDoc = [SELECT Id FROM Invoice_Documents__c WHERE Name = '1TestInvoiceDocument'];

    	//Get Controller
       	ApexPages.StandardController rcController = new ApexPages.StandardController(rc);
		ProjectDocumentsController pdController = new ProjectDocumentsController(rcController);

		test.startTest();
			//Add Residential Project Project Attachment
			pdController.projDocRows[1].attName = 'TestAttachment3';
			pdController.projDocRows[1].attBody = Blob.valueOf('TestAttachmentBody');
			pdController.saveFile();
			List<Attachment> savedRPAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projRPDoc.id AND Name = 'TestAttachment3'];
			system.assertEquals(1, savedRPAttachment.size());

			//Test Residential Project Project Attachment
			pdController.deleteDocId = savedRPAttachment[0].id;
			pdController.deleteDoc();
			List<Attachment> deletedRPAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projRPDoc.id AND Name = 'TestAttachment3'];
			system.assertEquals(0, deletedRPAttachment.size());
		test.stopTest();
	}

	static testMethod void testProjectTaskDocumentsContoller() {
	 	test.startTest();
		 	//Get Setup Ids
		 	Project_Task__c ta = [SELECT Id FROM Project_Task__c];
	 		Document__c projDoc = [SELECT Id FROM Document__c WHERE Name = '1TestProjectDocument'];
			Document__c projRPDoc = [SELECT Id FROM Document__c WHERE Name = '2TestProjectDocumentResidentialProject'];

		   	//Get Controller
	       	ApexPages.StandardController taController = new ApexPages.StandardController(ta);
	       	PageReference pageRef = Page.ProjectTaskDocuments;
			ProjectTaskDocumentsController pdController = new ProjectTaskDocumentsController(taController);

			//Test Saving Project Task Attachment
			pdController.projDocRows[0].attName = 'TestAttachment';
			pdController.projDocRows[0].attBody = Blob.valueOf('TestAttachmentBody');
			pdController.saveFile();
			List<Attachment> savedAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projDoc.id AND Name = 'TestAttachment'];
			system.assertEquals(1, savedAttachment.size());

			//Test Deleting Attachment
			pdController.deleteDocId = savedAttachment[0].id;
			pdController.deleteDoc();
			List<Attachment> deletedAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projDoc.id AND Name = 'TestAttachment'];
			system.assertEquals(0, deletedAttachment.size());

			//Add Residential Project Project Attachment
			pdController.projDocRows[1].attName = 'TestAttachment3';
			pdController.projDocRows[1].attBody = Blob.valueOf('TestAttachmentBody');
			pdController.saveFile();
			List<Attachment> savedRPAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projRPDoc.id AND Name = 'TestAttachment3'];
			system.assertEquals(1, savedRPAttachment.size());

			//Test Residential Project Project Attachment
			pdController.deleteDocId = savedRPAttachment[0].id;
			pdController.deleteDoc();
			List<Attachment> deletedRPAttachment = [SELECT Id, Name, Body FROM Attachment WHERE ParentId = :projRPDoc.id AND Name = 'TestAttachment3'];
			system.assertEquals(0, deletedRPAttachment.size());

			//Test nextPage
			pdController.nextPage();
			system.assertEquals(pdController.rowsOnPage, pdController.pagePtr[0]);

			//Test prevPage
			pdController.prevPage();
			system.assertEquals(0, pdController.pagePtr[0]);
		test.stopTest();
	}
}