public class ProjectTaskDocumentsController {
	public Id ptId;
	public Id rId;
	public Id deleteDocId {get; set;}
	public List<DocObject> projDocRows {get;set;}
	public Map<ID, String> docPartnerComment {get;set;}
	public Integer currTab {get;set{currTab = value;}}
	public List<Integer> pageSize {get;set;}
	public List<Integer> pagePtr {get;set;}
	public Integer rowsOnPage {get;set;}
	public static Set<String> approvedSet;

	public ProjectTaskDocumentsController(ApexPages.StandardController controller) {
		Project_Task__c pt = (Project_Task__c)controller.getRecord();
        ptId = pt.Id;
        rId = [SELECT Residential_Project__c FROM Project_Task__c WHERE Id =: ptId].Residential_Project__c;
		fileSetup();
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
		Attachment a =  [SELECT Id, ParentId FROM Attachment WHERE Id = :deleteDocId];
		Document__c d = [SELECT Id, Document_Type__c FROM Document__c WHERE Id = :a.ParentId];
		List<Invoice_Documents__c> invDocs = [SELECT Id, Status__c, Link_to_Attachment__c, Partner_Comments__c, Document_Submitted__c, Notes_To_Dealer__c FROM Invoice_Documents__c WHERE Lease_Payment__r.Residential_Project__c = :rId AND Documents_in_File__c = :d.Document_Type__c AND Location__c = 'Residential Project'];
		if(invDocs.size() > 0){
			for(Invoice_Documents__c i : invDocs){
				i.Status__c = 'Not Submitted';
				i.Link_to_Attachment__c = null;
				i.Partner_Comments__c = null;
				i.Document_Submitted__c = null;
				i.Notes_To_Dealer__c = null;
			}
			update invDocs;
		}
		delete a;
        deleteDocId = null;
		fileSetup();
		return null;
	}

	public pageReference saveFile(){
		for(DocObject doc : projDocRows){
			if(doc.attBody != null && doc.attId == null) {
				Attachment a = new Attachment();
				a.Body = doc.attBody;
				a.Name = doc.attName;
				a.ParentId = doc.dId;
				insert a;
				doc.attBody = null;
			}
		}
		fileSetup();
		return null;
	}

	public void fileSetup(){
		rowsOnPage = 5;
		projDocRows = new List<DocObject>();
        docPartnerComment = new Map<ID, String>();
        pageSize = new List<Integer>{0};
        if (currTab == null) currTab = 0;
        if (pageptr == null) pagePtr = new List<Integer>{0};

        approvedSet = new Set<String>();
        for(Invoice_Documents__c appInv :[SELECT Documents_in_File__c FROM Invoice_Documents__c WHERE Lease_Payment__r.Residential_Project__c = :rId AND Status__c = 'Approved' AND Location__c = 'Residential Project']){
        	approvedSet.add(appInv.Documents_in_File__c);
        }

		List<Document__c> docs = [SELECT Id, Residential_Project__c, Name, Type__c, Project_Task__c, Project_Task__r.Milestone__c, Document_Type__c, (SELECT Id, Name  FROM Attachments) FROM Document__c WHERE Project_Task__c =:ptId ORDER BY Name, CreatedDate];
		for(Document__c d : docs){
			projDocRows.add(new DocObject(d));
		}
		pageSize[0]=projDocRows.size();
		
	}
    
	public class DocObject{
		public Invoice_Documents__c invDoc {get;set;}
		public Id dId {get;set;}
		public Id attId {get;set;}
		public String title {get;set;}
		public Boolean isComp {get;set;}
		public String dType {get;set;}
		public Boolean canDelete {get;set;}
		public Blob attBody {get;set;}
		public String attName {get;set;}
        public String attFileName {get;set;}

		public DocObject(Document__c doc){
			invDoc = null;
			attId = doc.Attachments.size() > 0 ? doc.Attachments[0].Id : null;
			attFileName = doc.Attachments.size() > 0 ? doc.Attachments[0].Name : null;
			dId = doc.Id;
			title = doc.Name;
			isComp = false;
			dType = doc.Project_Task__c != NULL ? doc.Project_Task__r.Milestone__c : 'Project';
			canDelete = attId != null && !approvedSet.contains(doc.Document_Type__c) ? true : false;

		}
	}
}