public class ProjectDocumentsController {
	public Id rId;
	public Id deleteDocId {get; set;}
	public List<DocObject> docRows {get;set;}
	public List<DocObject> projDocRows {get;set;}
	public List<DocObject> origDocRows {get;set;}
	public List<DocObject> instalDocRows {get;set;}
	public List<DocObject> interDocRows {get;set;}
	public List<DocObject> permitDocRows {get;set;}
	public Map<ID, String> docPartnerComment {get;set;}
	public String partnerRole {get;set;}
	public Integer currTab {get;set{currTab = value;}}
	public List<Integer> pageSize {get;set;}
	public List<Integer> pagePtr {get;set;}
	public Integer rowsOnPage {get;set;}
	public String errorMsg {get; private set;}
	public Boolean showError {get; private set;}
	public static Set<String> approvedSet;

	public ProjectDocumentsController(ApexPages.StandardController controller) {
		Residential_Project__c r = (Residential_Project__c)controller.getRecord();
		rId = r.Id;
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

	public pageReference deleteInvDoc(){
		Attachment a =  [SELECT Id, ParentId FROM Attachment WHERE Id =: deleteDocId];
		Invoice_Documents__c inv = [SELECT Id, Status__c, Documents_in_File__c, Link_to_Attachment__c, Partner_Comments__c, Document_Submitted__c, Notes_to_Dealer__c FROM Invoice_Documents__c WHERE Id =: a.ParentId];
		inv.Status__c = 'Not Submitted';
		inv.Link_to_Attachment__c = null;
		inv.Partner_Comments__c = null;
		inv.Document_Submitted__c = null;
		inv.Notes_To_Dealer__c = null;
		update inv;
		
		delete a;
        deleteDocId = null;
		fileSetup();
		return null;
	}

	public pageReference saveFile(){
        partnerCommentUpdate();
		docRows.addAll(projDocRows);        
		docRows.addAll(origDocRows);        
		docRows.addAll(instalDocRows);        
		docRows.addAll(interDocRows);
		docRows.addAll(permitDocRows);        
		for(DocObject doc : docRows){
			system.debug('%%% doc='+doc);
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
        for(Invoice_Documents__c appInv :[SELECT Documents_in_File__c FROM Invoice_Documents__c WHERE Lease_Payment__r.Residential_Project__c = :rId AND Status__c = 'Approved' AND Location__c = 'Residential Project']){
        	approvedSet.add(appInv.Documents_in_File__c);
        }

		List<Document__c> docs = [SELECT Id, Name, Type__c, Project_Task__c, Project_Task__r.Milestone__c, Document_Type__c, (SELECT Id, Name  FROM Attachments) FROM Document__c WHERE Residential_Project__c =: rId ORDER BY Name, CreatedDate];
		for(Document__c d : docs){
			projDocRows.add(new DocObject(d));
		}
		pageSize[0]=projDocRows.size();

		//If Partner User Use additional Sharing Type Filter Logic
		String invQuery = 'SELECT Id, Name, Invoice_Type__c, Status__c, Document_Submitted__c, Response_Date__c, Partner_Comments__c, Notes_to_Dealer__c, Document_Owner__c, Location__c, (SELECT Id, Name FROM Attachments) FROM Invoice_Documents__c WHERE Lease_Payment__r.Residential_Project__r.Id = :rId AND Location__c != \'Residential Project\'';
        If(Userinfo.getUserType()=='PowerPartner'){
          partnerRole=FPOOrderLinesExt.fIdentifyCurrentUserRole();
          invQuery = invQuery + ' AND (((Sharing_Type__c = \'Secure\' OR (Type__c=\'Task\')) AND Document_Owner__c = :partnerRole) OR (Sharing_Type__c = \'Shared\' AND (Document_Owner__c = :partnerRole OR Shared_With__c includes (:partnerRole))))';
        }

		List<Invoice_Documents__c> invs = Database.query(invQuery + ' ORDER BY Name, CreatedDate');
		for(Invoice_Documents__c inv : invs){
            docPartnerComment.put(inv.Id, inv.Partner_Comments__c);
			if(inv.Invoice_Type__c == 'Origination') origDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Install') instalDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Interconnect') interDocRows.add(new DocObject(inv));
			if(inv.Invoice_Type__c == 'Permit Received') permitDocRows.add(new DocObject(inv));
		}
		pageSize[1]=origDocRows.size();
		pageSize[2]=instalDocRows.size();
		pageSize[3]=interDocRows.size();
		pageSize[4]=permitDocRows.size();
	}

    public void partnerCommentUpdate(){
		List<Invoice_Documents__c> invs = new List<Invoice_Documents__c>();
		for (DocObject doc : origDocRows) if (doc.invDoc.Partner_Comments__c != docPartnerComment.get(doc.dId)) invs.add(new Invoice_Documents__c(Id=doc.dId, Partner_Comments__c=doc.invDoc.Partner_Comments__c));
		for (DocObject doc : instalDocRows) if (doc.invDoc.Partner_Comments__c != docPartnerComment.get(doc.dId)) invs.add(new Invoice_Documents__c(Id=doc.dId, Partner_Comments__c=doc.invDoc.Partner_Comments__c));
		for (DocObject doc : interDocRows) if (doc.invDoc.Partner_Comments__c != docPartnerComment.get(doc.dId)) invs.add(new Invoice_Documents__c(Id=doc.dId, Partner_Comments__c=doc.invDoc.Partner_Comments__c));
		for (DocObject doc : permitDocRows) if (doc.invDoc.Partner_Comments__c != docPartnerComment.get(doc.dId)) invs.add(new Invoice_Documents__c(Id=doc.dId, Partner_Comments__c=doc.invDoc.Partner_Comments__c));
		for (Invoice_Documents__c inv : invs) docPartnerComment.put(inv.Id, inv.Partner_Comments__c);
		if (invs.size() > 0) update invs;
    }
    
	public class DocObject{
		public Invoice_Documents__c invDoc {get;set;}
		public Id dId {get;set;}
		public Id attId {get;set;}
		public String title {get;set;}
		public Boolean isComp {get;set;}
		public String dType {get;set;}
		public Boolean canDelete {get;set;}
		public Boolean isLegacy {get;set;}
		public Blob attBody {get;set;}
		public String attName {get;set;}
        public String attFileName {get;set;}

		public DocObject(Invoice_Documents__c doc){
			invDoc = doc;
			attId = doc.Attachments.size() > 0 ? doc.Attachments[0].Id : null;
			attFileName = doc.Attachments.size() > 0 ? doc.Attachments[0].Name : null;
			dId = doc.Id;
			title = doc.Name;
			isComp = true;
			dType = doc.Invoice_Type__c;
			// What else can prevent a deletion??
			canDelete = attId != null && doc.Status__c != 'Approved' ? true : false;
			isLegacy = doc.Location__c == 'Opportunity' || doc.Location__c == 'Account' ? true : false;
		}
		public DocObject(Document__c doc){
			invDoc = null;
			attId = doc.Attachments.size() > 0 ? doc.Attachments[0].Id : null;
			attFileName = doc.Attachments.size() > 0 ? doc.Attachments[0].Name : null;
			dId = doc.Id;
			title = doc.Name;
			isComp = false;
			dType = doc.Project_Task__c != NULL ? doc.Project_Task__r.Milestone__c : 'Project';

			canDelete = attId != null && !approvedSet.contains(doc.Document_Type__c) ? true : false;
			isLegacy = false;
		}

	}
}