public class DocObject {
	public Invoice_Compliance_Document__c invDoc {get; set;}
	public Id dId {get; set;}
	public String title {get; set;}
	public Boolean isComp {get; set;}
	public String dType {get; set;}
	public Boolean canDelete {get; set;}
	public String fileUrl {get; set;}
	public String linkField {get; set;}
	public String docName {get; set;}
	public String nameField {get; set;}

	public DocObject(Invoice_Compliance_Document__c doc) {
		invDoc = doc;
		dId = doc.Id;
		title = doc.Name;
		docName = doc.File_Name__c;
		isComp = true;
		dType = doc.Invoice_Type__c;
		fileUrl = doc.Link_to_Attachment__c;
		canDelete = fileUrl != null && doc.Status__c != 'Approved' ? true : false;
		linkField = 'Link_to_Attachment__c';
		nameField = 'File_Name__c';
	}

	// special record for s3 file upload
	public DocObject(Document__c doc) {
		dId = doc.Id;
		title = doc.Name;
		docName = doc.File_Name__c;
		fileUrl = doc.URL__c;
		linkField = 'URL__c';
		nameField = 'File_Name__c';
	}

	public DocObject(Document__c doc, Set<String> approvedSet) {
		dId = doc.Id;
		title = doc.Name;
		docName = doc.File_Name__c;
		isComp = false;
		dType = doc.Project_Task__c != NULL ? doc.Project_Task__r.Milestone__c : 'Project';
		fileUrl = doc.URL__c;
		canDelete = fileUrl != null && !approvedSet.contains(doc.Document_Type__c) ? true : false;
		linkField = 'URL__c';
		nameField = 'File_Name__c';
	}
}