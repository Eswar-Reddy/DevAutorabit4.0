/************************************
**PR-01802
**By- Kapil Goutam
**On- May 25 2009
**Description- Controller class for SetPartnerLogo
**
*************************************/
public class SetPartnerLogoController {
	public Blob logo {get;set;}
	public Account acc{get;set;}
	public Boolean refreshParent{get;set;}
    public List<Attachment> listAttachment{get;set;}
    public List<attachmentClass> listAttachmentClass{get;set;}
    public String imageId{get;set;}
    public String imageName{get;set;}
    public String checkeRadioId{get;set;}
    
    public SetPartnerLogoController(ApexPages.StandardController stdController) {
        acc = (Account)stdController.getRecord();
        loadAttachment();
       	//listAttachment = new List<Attachment>([Select Id, Name,ContentType from Attachment where ParentId =:acc.Id and ContentType in ('image/jpg','image/jpeg','image/png','image/bmp','image/gif')]);
    }
    
    public void loadAttachment(){
    	listAttachmentClass = new List<attachmentClass>();
    	AttachmentClass newAttachment;
    	String curentLogoid;
    	Boolean isLogoSet = false;
    	String partnerLogo = getLogoURL();
    	if(partnerLogo != '' && partnerLogo.lastIndexOf('=') >0 ){
    		curentLogoid = partnerLogo.substring(partnerLogo.lastIndexOf('=') + 1);
    		isLogoSet = true; 
    	}
    	//listAttachment = new List<Attachment>([Select Id, Name,ContentType from Attachment where ParentId =:acc.Id and ContentType in ('image/jpg','image/jpeg','image/png','image/bmp','image/gif')]);
    	List<Attachment> listAttachmentTemp = new List<Attachment>([Select Id, Name,ContentType from Attachment where ParentId =:acc.Id and ContentType in ('image/jpg','image/jpeg','image/png','image/bmp','image/gif')]);
    	if(listAttachmentTemp.Size()>0){
    		for(Attachment a: listAttachmentTemp){
    			newAttachment = new AttachmentClass();
    			newAttachment.id = a.Id;
    			newAttachment.imageName = a.Name;
    			if(isLogoSet && a.Id == curentLogoid){
    				newAttachment.isChecked = 'checked';
    				checkeRadioId = a.Id;
    			}
    			else{
    				newAttachment.isChecked = '';
    			}
    			listAttachmentClass.add(newAttachment);
    		}
    	}
    }
    
     public String getLogoURL(){
    	List<Account> listAccount = new List<Account>([Select Partner_Logo__c from Account where Id=:acc.Id limit 1]);
    	if(listAccount.Size()>0 && listAccount.get(0).Partner_Logo__c != null){
    		return listAccount.get(0).Partner_Logo__c;
    	}
    	return '';
    }
    
    public PageReference save(){
    	PageReference pr = null; 
    	try{
    		 
	    	 Attachment attach = new Attachment();
	    	 attach.ParentId = acc.Id;
	    	 if(imageName != null){ 
	    	 	attach.ContentType = 'image/'+ imageName.substring(imageName.lastIndexOf('.')+1).toLowerCase();
	    	 }
	    	 else{
	         		attach.ContentType = 'Attachment';
	    	 }		
	         attach.body = logo;
	         if(imageName != null)
	         	attach.Name =  String.valueOf(DateTime.Now()) +' '+ imageName;
	         else
	         	attach.Name =  String.valueOf(DateTime.Now());
	         insert attach;
	        // acc.Partner_Logo__c = '/servlet/servlet.FileDownload?file='+ attach.id;
	         //update acc;
	         attach.body = null;
	         logo= null;
	         refreshParent = true;
	         loadAttachment();
	         //pr = new PageReference('/apex/SetPartnerLogo');
	         
    	}
    	 catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return pr;    
    	
    }
    public PageReference setPartnerLogo(){
    	PageReference pr = null; 
    	try{
    		 
	         acc.Partner_Logo__c = '/servlet/servlet.FileDownload?file='+ imageId;
	         update acc;
	         refreshParent = true;
	         loadAttachment();
	         
	         //pr = new PageReference('/apex/SetPartnerLogo');
	         
    	}
    	 catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return pr;    
    	
    }
    
    public class attachmentClass{
    	public String id{get;set;}
    	public String imageName{get;set;}
    	public String isChecked{get;set;}
    }

}