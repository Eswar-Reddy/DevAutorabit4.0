public class CustomInteractionLog {
public string description {get;set;}

    public String caseId { 
        get {
            if(caseId == null) {
                caseId = ApexPages.currentPage().getParameters().get('id');
            }
            return caseId;
        }
        set; 
    }

    public void updateWhoWhatId() {
        Integer caseCount = [Select COUNT() from Case where id = :caseId];
        if (caseCount==0) {
            statusMessage = 'This log is not associated with a Case or Contact! Please save the case.';
            return;
        }
        Case myCase = [Select id, contactId from Case where id = :caseId];
        task.whoId = myCase.contactId;
        task.whatId = myCase.id;
    }

    private void initializeTask() {
        updateWhoWhatId();
        task.subject = Subject;
    }
    
    private String Subject { 
        get {
            Subject = 'Call at ' + DateTime.now();
            return Subject;
        }
        set; 
    }

    public CustomInteractionLog(ApexPages.StandardController controller) {
        initializeTask();
    }       

    public String ANI { get; set;}
    public String CallObject { get; set;} 
    public Integer CallDurationInSeconds { get; set;} 
    public String CallType { get; set;}  
    public String CallDisposition { get; set;}        
    
    public String statusMessage { get; set; }
    public boolean newCase { get; set;}

    public Task task { 
        get {
            if(task == null) {
                task = new Task();
            }
            return task;
        }
        set; 
    }
    
    public void setCallAttachedData() {
        task.CallObject = CallObject;
        //task.ANI__c = ANI;
    }     

    public void setCallEndData() {
        task.CallDurationInSeconds = CallDurationInSeconds;
        task.CallDisposition = CallDisposition;    
        save();
    }
    
    public PageReference save() {
        description=task.description;
        description=description.replace('\n', '/NEWLINE/');
        description=EncodingUtil.urlEncode(description, 'UTF-8');
        if(!newCase){
        upsert task;
        System.debug('task ----- '+task);
        System.debug('---------------task.WhoId2'+task.WhoId);
        if(task.whatId!=null && string.valueOf(task.whatId).startsWith('500')&& task.description != null ){
            System.debug('---------------task.WhoId1'+task.WhoId);
            CaseComment caseComment = new CaseComment();
            caseComment.ParentId = task.whatId;
            
            caseComment.CommentBody = task.description;
                insert caseComment;
        }
        statusMessage = 'Last save at ' + DateTime.now();
        PageReference acctPage = new PageReference('/apex/CustomInteractionLogs');
        System.debug('Page ----- '+acctPage);
        acctPage.setRedirect(true);
      }
          
        return null;
    }
    
     public PageReference saveAndNew() {
        save();
        task = null;
        initializeTask();
        //task.ANI__c= ANI;
        task.CallObject = CallObject;
         return null;
    }        
}