// *********************************************************************
// Name : UploadFileController 
// Created On : 20th April,2009
// Created By : Appirio (Kirtesh)
// Implementation: Controller Class for Upload_File page.
//                 Check for attachment on Question. if it exist then 
//                 delete old attachment and overidde by new attachment.
//                 If new attachment is there,then insert that attachment
//                 Attachment Name are prefixed with Question number.
//                 Currently it is using with InspectionReport Vf page.
// **********************************************************************
public class UploadFileController {
  
  public blob contentFile { get; set;}
  public string nameFile { get; set;}
  public string contentTypeFile { get; set;}
  
  Attachment doc = null;
  string caseId;
  String quesNo;
  
  public UploadFileController() {
    
    caseId = ApexPages.currentPage().getParameters().get('caseId');
    quesNo = ApexPages.currentPage().getParameters().get('quesNo');
    
    if (caseId != null) {
      String docName = quesNo + '_%';
      List<Attachment> docList = [select id, Body, Name 
                                  from Attachment
                                  where ParentId = :caseId and Name like :docName];
      if (docList.size() > 0)
        doc = docList[0];
    }
  }
  
  public pageReference uploadFile() {
    if (doc != null)
      delete doc;
    
    doc = new Attachment();
    doc.ParentId = caseId;
    doc.Body = contentFile;
    doc.Name = quesNo + '_' + nameFile;
    upsert doc;
    
    return new PageReference('/apex/CloseUploadWindow') ;
  }
}