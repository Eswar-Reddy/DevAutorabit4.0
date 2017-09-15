public  class UploadFileNewController {
	
  public blob contentFile { get; set;}
  public string nameFile { get; set;}
 // public string contentTypeFile { get; set;}
  public string quesnumber {get; set;}
  public Boolean isQuestions {get; set;}
  Attachment doc = null;
  List<Attachment> lstAttachImages { get; set;}
  public string caseId {get; set;}
 // public String quesNo{ get; set;}
  
  public List<String> lstquesno {get; set;}
  public List<ShowQuesImage> lstShowQuesClass {get; set;}
  public UploadFileNewController() {
    
    caseId = ApexPages.currentPage().getParameters().get('caseId');
  //  quesNo = ApexPages.currentPage().getParameters().get('quesNo');
    
    if (caseId != null) {
      String docName = quesnumber + '_%';
      List<Attachment> docList = [select id, Body, Name 
                                  from Attachment
                                  where ParentId = :caseId and Name like :docName];
      if (docList.size() > 0)
        doc = docList[0];
    }
    lstquesno = new List<String>();
    lstShowQuesClass = new List<ShowQuesImage>();
    isQuestions = false;
    if ( caseId != null) {
    	
    	lstAttachImages = [select id, Body, Name from Attachment where ParentId = :caseId];
        
        if (lstAttachImages.size() > 0) {
        	
        	for (Attachment attach : lstAttachImages ) {
        		String str = attach.Name;
        		if (str.contains('_') ){
        			
        			str = str.substring(0, str.indexOf('_')); 
        			Integer intQues = Integer.valueOf(str.trim());//(Integer)str.trim();
        			if (intQues > 0 && intQues < 54 ) {
        				
        				lstquesno.add(str);
        				ShowQuesImage objQsImg = new ShowQuesImage();
        				objQsImg.quesno = intQues;
        				objQsImg.attachImg = attach.Id;
        				lstShowQuesClass.add(objQsImg);
        			}
        		}
        	}
        }
    }
    
    if (lstquesno.size() > 0)
    		isQuestions = true;
  }
  public pageReference uploadFile() {
    if (doc != null)
      delete doc;
    
    doc = new Attachment();
    doc.ParentId = caseId;
    doc.Body = contentFile;
    doc.Name = quesnumber + '_' + nameFile;
    upsert doc;
    quesnumber = '';
    //return null;
    return new PageReference('/apex/CloseUploadWindow') ;
    //return new PageReference('/apex/UploadFileNew?caseId=' + caseId ) ;
  }

public class ShowQuesImage {
	
	public Integer quesno{get;set;}
	public String attachImg {get;set;}
	
	
}

}