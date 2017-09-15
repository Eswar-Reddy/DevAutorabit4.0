public class ContentDetailPageController{
  //properties
  public String contentId{get;set;}
  public String url{get;set;}
  public String docurl{get;set;}
  public ContentDetailPageController(ApexPages.StandardController controller){
    if(ApexPages.currentPage().getParameters().get('cId') != null){
      this.contentId = ApexPages.currentPage().getParameters().get('cId');      
    }    
    if(ApexPages.currentPage().getParameters().get('retUrl') != null){
      this.url = ApexPages.currentPage().getParameters().get('retUrl');      
    }
    //Parameter passed when page is opend from Document library
    if(ApexPages.currentPage().getParameters().get('docurl') != null){
      //this.docurl = ApexPages.currentPage().getParameters().get('docurl');   
      String decodedUrl = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('docurl'), 'UTF-8'); 
      this.docurl = decodedUrl;
         
    }
  } 
  
  public void insertTrackerObject(){
    //create a content tracker object
    if(this.contentId != null){
      ContentTrackerUtilClass.createContentTracker(this.contentId, UserInfo.getUserId());
    }
  }
}