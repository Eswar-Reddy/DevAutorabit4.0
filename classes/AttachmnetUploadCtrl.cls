global with sharing class AttachmnetUploadCtrl{

    public AttachmnetUploadCtrl(){
    
    }
    
    @RemoteAction
    global static ResultMessage fetchAttachments(String parentID) {
         
         ResultMessage result = new ResultMessage();
         result.success = true;   
         result.payloadMap.put('attachments', new List<Attachment>());
         //Attachment[] atts = [SELECT Id,ParentId,Name,ContentType FROM Attachment WHERE ParentId =: parentID];
                                                      
         result.payloadMap.put('attachments', [SELECT Id, Name, ContentType, ParentId 
                                                      FROM Attachment 
                                                      WHERE ParentId =: parentID]);
         return result;                                             
        
    }

    public String docIdToDelete {get;set;}
    public PageReference deleteDesignDocuments() {
        System.debug('docIdToDelete: ' + docIdToDelete);

        try {
            delete [SELECT Id FROM Attachment WHERE Id =: docIdToDelete];
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
            System.debug('MSG ERROR DELETE: ' + e);
        }
        return null;
    }

}