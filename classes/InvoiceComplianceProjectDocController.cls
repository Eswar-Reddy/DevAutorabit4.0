public class InvoiceComplianceProjectDocController {
	private String sObjectName;
	public Id recordId {get; set;}
	public Id deleteDocId {get; set;}
	public List<DocObject> docRows {get; set;}
	public List<DocObject> projDocRows {get; set;}
	public List<DocObject> origDocRows {get; set;}
	public List<DocObject> instalDocRows {get; set;}
	public List<DocObject> interDocRows {get; set;}
	public List<DocObject> permitDocRows {get; set;}
	public Map<ID, String> docPartnerComment {get; set;}
	public String partnerRole {get; set;}
	public Integer currTab {get; set{currTab = value;}}
	public List<Integer> pageSize {get; set;}
	public List<Integer> pagePtr {get; set;}
	public Integer rowsOnPage {get; set;}
	public String errorMsg {get; private set;}
	public Boolean showError {get; private set;}
	public static Set<String> approvedSet;

	public InvoiceComplianceProjectDocController() {
		// get the record Id
		recordId = ApexPages.currentPage().getParameters().get('Id');
		// get object name so we know where we're at
		sObjectName = recordId.getSobjectType().getDescribe().getName();
		if(sObjectName == 'LeasePayment__c') sObjectName = 'Financial_Payment__c';
		// get files
		fileSetup();
	}

	public void fileSetup() {
		rowsOnPage = 5;
		docRows = new List<DocObject>();
		projDocRows = new List<DocObject>();
		origDocRows = new List<DocObject>();
		instalDocRows = new List<DocObject>();
		interDocRows = new List<DocObject>();
		permitDocRows = new List<DocObject>();
		docPartnerComment = new Map<ID, String>();
		pageSize = new List<Integer>{0,0,0,0,0};
		if (currTab == null) currTab = 0;
		if (pageptr == null) pagePtr = new List<Integer>{0,0,0,0,0};
		approvedSet = new Set<String>();

		// setup query for approved docs
		String approvedDocsQuery;
		if(sObjectName != 'Project_Task__c') {
			approvedDocsQuery = 'SELECT Documents_in_File__c FROM Invoice_Compliance_Document__c WHERE ' + sObjectName + ' = :recordId AND Status__c = \'Approved\'';
		} else {
			Id rpId = [SELECT Residential_Project__c FROM Project_Task__c WHERE Id = :recordId].Residential_Project__c;
			approvedDocsQuery = 'SELECT Documents_in_File__c FROM Invoice_Compliance_Document__c WHERE Residential_Project__c = :rpId AND Status__c = \'Approved\'';
		}

		// load approved set
		for(Invoice_Compliance_Document__c icd : Database.query(approvedDocsQuery)) {
			approvedSet.add(icd.Documents_in_File__c);
		}

		// setup query for project docs
		String docs = 'SELECT Id, Name, Type__c, Project_Task__c, Project_Task__r.Milestone__c, Document_Type__c, File_Name__c, URL__c FROM Document__c WHERE ' + sObjectName + ' = :recordId ORDER BY Name, CreatedDate';

		for(Document__c d : Database.query(docs)) {
			projDocRows.add(new DocObject(d, approvedSet));
		}
		pageSize[0]=projDocRows.size();

		// get all icds
		String invQuery = 'SELECT Id, Name, Invoice_Type__c, Status__c, Document_Submitted__c, Response_Date__c, Partner_Comments__c, Notes_to_Partner__c, Document_Owner__c, Link_to_Attachment__c, File_Name__c FROM Invoice_Compliance_Document__c WHERE ' + sObjectName + ' = :recordId';

		If(Userinfo.getUserType() == 'PowerPartner') {
		  partnerRole = FPOOrderLinesExt.fIdentifyCurrentUserRole();
		  invQuery += ' AND (((Sharing_Type__c = \'Secure\' OR (Type__c=\'Task\')) AND Document_Owner__c = :partnerRole) OR (Sharing_Type__c = \'Shared\' AND (Document_Owner__c = :partnerRole OR Shared_With__c includes (:partnerRole))))';
		}

		for(Invoice_Compliance_Document__c inv : Database.query(invQuery + ' ORDER BY Name, CreatedDate')) {
			if(String.isNotBlank(inv.Partner_Comments__c)) docPartnerComment.put(inv.Id, inv.Partner_Comments__c);
			if(inv.Invoice_Type__c == 'Origination') origDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Install') instalDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Interconnect') interDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Permit Received') permitDocRows.add(new DocObject(inv));
		}
		pageSize[1] = origDocRows.size();
		pageSize[2] = instalDocRows.size();
		pageSize[3] = interDocRows.size();
		pageSize[4] = permitDocRows.size();
	}

	public pageReference prevPage(){
		pagePtr[currTab] = pagePtr[currTab] - rowsOnPage;
		return null;
	}

	public pageReference nextPage(){
		pagePtr[currTab] = pagePtr[currTab] + rowsOnPage;
		return null;
	}

	public pageReference deleteDoc(){
		try {
			// get the doc to remove the s3 link
			Document__c d = [SELECT Id, Document_Type__c, File_Name__c, URL__c FROM Document__c WHERE Id = :deleteDocId];
			// list of icds that need updating
			List<Invoice_Compliance_Document__c> invDocs = new List<Invoice_Compliance_Document__c>();
			// query for icds
			String qry = 'SELECT Id, Status__c, Link_to_Attachment__c, Partner_Comments__c, Document_Submitted__c, Notes_to_Partner__c FROM Invoice_Compliance_Document__c WHERE ' + sObjectName + ' = \'' + recordId + '\' AND Documents_in_File__c = \'' + d.Document_Type__c + '\'';
			// update icds
			for(Invoice_Compliance_Document__c i : Database.query(qry)) {
				i.Status__c = 'Not Submitted';
				i.Link_to_Attachment__c = null;
				i.Partner_Comments__c = null;
				i.Document_Submitted__c = null;
				i.Notes_to_Partner__c = null;
				invDocs.add(i);
			}
			if(!invDocs.isEmpty()) update invDocs;
			// update project doc
			d.File_Name__c = null;
			d.URL__c = null;
			update d;
			deleteDocId = null;
			fileSetup();
		}
		catch(Exception e) {
			ExLog.log(e);
		}
		return null;
	}

	public pageReference deleteInvDoc(){
		try {
			// update the icd to remove the s3 doc
			Invoice_Compliance_Document__c inv = [SELECT Id, Status__c, Documents_in_File__c, Link_to_Attachment__c, Partner_Comments__c, Document_Submitted__c, Notes_to_Partner__c FROM Invoice_Compliance_Document__c WHERE Id = :deleteDocId];
			inv.Status__c = 'Not Submitted';
			inv.Link_to_Attachment__c = null;
			inv.Partner_Comments__c = null;
			inv.Document_Submitted__c = null;
			inv.Notes_to_Partner__c = null;
			inv.File_Name__c = null;
			update inv;

			deleteDocId = null;
			fileSetup();
		}
		catch(Exception e) {
			ExLog.log(e);
		}
		return null;
	}

	public pageReference saveFile(){
		partnerCommentUpdate();
		fileSetup();
		return null;
	}

	public void partnerCommentUpdate() {
		List<Invoice_Compliance_Document__c> invs = new List<Invoice_Compliance_Document__c>();
		for(DocObject doc : origDocRows) {
			if(checkComment(doc)) {
				invs.add(new Invoice_Compliance_Document__c(Id = doc.dId, Partner_Comments__c = doc.invDoc.Partner_Comments__c));
			}
		}
		for(DocObject doc : instalDocRows) {
			if(checkComment(doc)) {
				invs.add(new Invoice_Compliance_Document__c(Id = doc.dId, Partner_Comments__c = doc.invDoc.Partner_Comments__c));
			}
		}
		for(DocObject doc : interDocRows) {
			if(checkComment(doc)) {
				invs.add(new Invoice_Compliance_Document__c(Id = doc.dId, Partner_Comments__c = doc.invDoc.Partner_Comments__c));
			}
		}
		for(DocObject doc : permitDocRows) {
			if(checkComment(doc)) {
				invs.add(new Invoice_Compliance_Document__c(Id = doc.dId, Partner_Comments__c = doc.invDoc.Partner_Comments__c));
			}
		}
		try {
			if(!invs.isEmpty()) update invs;
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	private Boolean checkComment(DocObject doc) {
		Boolean result = false;
		Boolean hasVal = String.isNotBlank(doc.invDoc.Partner_Comments__c);
		Boolean hasOld = docPartnerComment.containsKey(doc.dId);
		String oldVal = docPartnerComment.get(doc.dId);
		// new comment
		if(hasVal && !hasOld) {
			result = true;
			docPartnerComment.put(doc.dId, doc.invDoc.Partner_Comments__c);
		}
		// deleted comment
		if(!hasVal && hasOld) {
			result = true;
			docPartnerComment.remove(doc.dId);
		}
		// updated comment
		if(hasVal && hasOld && doc.invDoc.Partner_Comments__c != oldVal) {
			result = true;
			docPartnerComment.put(doc.dId, doc.invDoc.Partner_Comments__c);
		}
		return result;
	}
}