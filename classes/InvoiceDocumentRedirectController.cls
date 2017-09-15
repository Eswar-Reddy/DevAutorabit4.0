public with sharing class InvoiceDocumentRedirectController {
	
	public Invoice_Documents__c invoiceDoc {get; private set;}

	public InvoiceDocumentRedirectController(ApexPages.StandardController stdController)
	{
		invoiceDoc = (Invoice_Documents__c) stdController.getRecord();
	}
	
	public PageReference redirect()
	{
		Profile userProfile = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
		RedirectProfiles__c partnerProfile = RedirectProfiles__c.getInstance(userProfile.Id); 
		
		if(partnerProfile.Id != null)
		{
			//Redirect to InvoiceDocumentUploadPage
			invoiceDoc = [SELECT Id, Lease_Payment__c, Invoice_Type__c FROM Invoice_Documents__c WHERE Id = :invoiceDoc.Id LIMIT 1];
			
			PageReference uploadPage = Page.InvoiceDocumentUpload;
			uploadPage.getParameters().put('id', invoiceDoc.Lease_Payment__c);
			uploadPage.getParameters().put('type', invoiceDoc.Invoice_Type__c);
			uploadPage.setRedirect(true);
			
			return uploadPage;
		}
		else
		{
			//Redirect to Standard detail page
			PageReference standardPage = new PageReference('/'+invoiceDoc.Id);
			standardPage.getParameters().put('nooverride', '1');
			standardPage.setRedirect(true);
			
			return standardPage;
		}
	}
}