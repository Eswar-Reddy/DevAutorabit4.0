public class ImageUploadController {
 
  public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }
 
  public PageReference upload() {
 
   // attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = ApexPages.currentPage().getParameters().get('aID');
    attachment.IsPrivate = false;
 
    try {
      insert attachment;
     
      
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment' + e));
      return null;
    } finally {
      attachment = new Attachment(); 
    }
 PageReference parentpage ;
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    string returnstng;
    if(ApexPages.currentPage().getParameters().get('qID') == null){
          returnstng = '/apex/Quickquote?aid='+ApexPages.currentPage().getParameters().get('aID')+'&oppId='+ApexPages.currentPage().getParameters().get('oppID')+'&imageId=1';
          parentpage = new PageReference(returnstng);
      }else{
         returnstng = '/apex/Quickquote?qid='+ApexPages.currentPage().getParameters().get('qID')+'&aId='+ApexPages.currentPage().getParameters().get('aID')+'&imageId=1';
         parentpage = new PageReference(returnstng);
      }
    return null;
  }
 
}