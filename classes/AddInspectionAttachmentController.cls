public class AddInspectionAttachmentController {
	
	public Boolean isAttached { get; set;}
	public transient blob contentFile { get; set;}
  	public string nameFile { get; set;}
	public  transient Attachment attachDoc { get; set;}
	public Inspection__c inspection {get;set;}
	public String inspectionid {get;set;}
	
	public AddInspectionAttachmentController(ApexPages.StandardController stdController) {

		if (ApexPages.currentPage().getParameters().get('insid')!=null){
			
			inspectionid = ApexPages.currentPage().getParameters().get('insid');
		}
	}
	
	public void AttachFile() {
    
      if (inspectionid != null || inspectionid != '') {
    	
    	attachDoc = new Attachment();
   		attachDoc.ParentId = inspectionid;
    	attachDoc.Body = contentFile;
    	attachDoc.Name = nameFile;
    	upsert attachDoc;
    	contentFile = null;
    	//nameFile = '';
    	isAttached = true;
    	//return null;
      }
      else {
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Inspection refererence is not avialable..'));
       // return null;
      }
       	
	}
	
	public void DeleteAttachments() {
		
		List<Attachment> lstInspectionAttach = [Select id,Name,Body,ParentId from Attachment where ParentId =: inspectionid];
    	if( lstInspectionAttach.size() > 0 ){
    		
    		delete lstInspectionAttach;
    	}
	}
}