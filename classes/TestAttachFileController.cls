/**************************************************
** PR- 01923
**Created By- Kapil Goutam
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller AttachFileController
*****************************************************/
public class TestAttachFileController {
    
    @isTest
    public static void Test_AttachFileController(){
        CreditAppAttachment__c notesattach = new CreditAppAttachment__c();
        insert notesattach;
        String parentId=notesattach.id;
        Apexpages.currentPage().getParameters().put('PId', parentId); 
        AttachFileController afc = new AttachFileController();
        Attachment attach = afc.getAttach();
        attach.Body = blob.valueOf('Test String attachment');
        attach.ParentId = parentId;
        afc.setAttach(attach);
        Boolean render = afc.getRenderAttachedFiles();
        afc.attachFile();
        afc.done();
    }

}