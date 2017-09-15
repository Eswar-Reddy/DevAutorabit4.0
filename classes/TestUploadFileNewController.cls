public class TestUploadFileNewController {
	
	@isTest
   public  static  void myUnitTest() {
        // TO DO: implement unit test
        
        Case newCase = new Case();
        insert newCase;
        
        List<Attachment> lstattach = new List<Attachment>();
        
        Attachment attach = new Attachment();
        attach.Body = Blob.valueOf('Test String for attachment' + String.valueOf(Datetime.Now()));
        attach.Name = '5_test'+ String.valueOf(Datetime.Now());
        attach.ParentId = newCase.Id;
        insert attach;
        lstattach.add(attach);
        
        ApexPages.currentPage().getParameters().put('caseId', newCase.Id);
        ApexPages.currentPage().getParameters().put('quesNo', '5');
        UploadFileNewController objUpload = new UploadFileNewController();
        objUpload.contentFile = Blob.valueOf('Test String for attachment2' + String.valueOf(Datetime.Now()));
        objUpload.nameFile = 'testfile.txt';
        
        objUpload.uploadFile();
    }
}