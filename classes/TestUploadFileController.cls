/*******************************************
**Created by - Kapil Goutam
**Created On - June 05 2009
**Last Modified On- 
**Last Modifiled by- 
**Description- Test Class for UploadFileController
********************************************/
public class TestUploadFileController {
    
    @isTest
    public static void Test_UploadFile(){
        
        Case newCase = new Case();
        insert newCase;
        
        Attachment attach = new Attachment();
        attach.Body = Blob.valueOf('Test String for attachment' + String.valueOf(Datetime.Now()));
        attach.Name = 'Test_Attachment'+ String.valueOf(Datetime.Now());
        attach.ParentId = newCase.Id;
        insert attach;
        ApexPages.currentPage().getParameters().put('caseId', newCase.Id);
        ApexPages.currentPage().getParameters().put('quesNo', 'Test');
        UploadFileController upload = new UploadFileController();
        upload.contentFile = Blob.valueOf('Test String for attachment2' + String.valueOf(Datetime.Now()));
        upload.uploadFile();
    }

}