/***********************************
** Created by- Kapil Goutam
** Created On- May 13 2009
** Last Modi by - 
** Last Modi On -  
** Vsrsion - 1.0
** Description- controller class for AttchFile Page
*************************************/
public class AttachFileController {

     private Attachment attach;
     public Attachment getAttach(){
            attach = new Attachment();
            return attach; 
     }
     public void setAttach(Attachment attach){
        this.attach = attach;
     }
     
     private Boolean renderAttachedFiles;
     public Boolean getRenderAttachedFiles(){
        if(attachmentsList != null && attachmentsList.Size()>0)
           return true;
        else
            return false;  
     }
     public String parentId{get;set;}
     public List<Attachment> attachmentsList{get;set;}
     public Boolean closePopup{get;set;}
     public CreditAppAttachment__c notesattach {get;set;}
     
     public AttachFileController(){
 
         attachmentsList = new List<Attachment>();
         if(ApexPages.CurrentPage().getParameters().get('Pid') != null) {
            parentId = ApexPages.CurrentPage().getParameters().get('Pid');
         }
     }
     
     //Function to attach file in attachment list
     public PageReference done(){
        try{

            attach.body = null;
            closePopup = true;
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;    
     }


     //Function to attach file in attachment list
     public PageReference attachFile(){
        try{
            attach.ParentId = parentId; 
            attach.ContentType = 'Attachment';
            attachmentsList.add(attach);
            insert attachmentsList;
            attach.body = null;
            closePopup = true;
       
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;    
     }

     
}