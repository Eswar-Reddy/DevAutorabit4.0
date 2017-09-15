public with sharing class S3UploadPageController {
	public DocObject doc {get; set;}

	public S3UploadPageController() {
		// get the record id
		Id docId = ApexPages.currentPage().getParameters().get('Id');
		// get the object type
		Schema.SObjectType sObjType = docId.getSObjectType();
		// get the query data
		String query = 'SELECT ';
		for(String s : queryFields(String.valueOf(sObjType))) {
			query += s + ', ';
		}
		// build the query
		query = query.removeEnd(', ') + ' FROM ' + String.valueOf(sObjType) + ' WHERE Id = \'' + docId + '\'';
		// get new doc
		List<sObject> record = Database.query(query);
		if(String.valueOf(sObjType) == 'Invoice_Compliance_Document__c') {
			Invoice_Compliance_Document__c icd = (Invoice_Compliance_Document__c)record[0];
			doc = new DocObject(icd);
		}
		if(String.valueOf(sObjType) == 'Document__c') {
			Document__c d = (Document__c)record[0];
			doc = new DocObject(d);
		}
	}

	private List<String> queryFields(String sObjType) {
		Map<String, List<String>> data = new Map<String, List<String>>();
		// icds
		data.put('Invoice_Compliance_Document__c', new List<String>{'Id', 'Name', 'File_Name__c', 'Invoice_Type__c', 'Link_to_Attachment__c', 'Status__c'});
		// docs
		data.put('Document__c', new List<String>{'Id', 'Name', 'File_Name__c', 'URL__c', 'Document_Type__c'});

		return data.get(sObjType);
	}
}