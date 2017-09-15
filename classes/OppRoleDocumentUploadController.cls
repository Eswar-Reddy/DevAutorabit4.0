public with sharing class OppRoleDocumentUploadController {
    
    //Constants
    private final Integer MAX_FILE_SIZE = 10485760;
    
    
    
    //Variables
    public String parentRecordId {get;set;}
    public Boolean dmlSuccess {
        get {
            if(dmlSuccess == null)
                dmlSuccess = false;
            return dmlSuccess;
        }
        set;
    }
    public Boolean isLocked {get;set;}
    
    //Collections
    public List<OppRoleDocumentRow> oppRoleDocList {get;set;}
    
    public OppRoleDocumentUploadController(ApexPages.StandardController controller) {
        parentRecordId = ApexPages.currentPage().getParameters().get('id');
        isLocked = Approval.isLocked(parentRecordId);
        fetchDocuments();
    }
    
    public void fetchDocuments() {
        
        if(oppRoleDocList == null)
            oppRoleDocList = new List<OppRoleDocumentRow>();
        else 
            oppRoleDocList.clear();
        
        for(UC_Document__c d : [SELECT Id, Name, Document_Type__c, Required_For_Approval__c, Document_Status__c,
                                Opportunity_Role__r.Status__c,
                                (SELECT Id, Name FROM Attachments ORDER BY CreatedDate DESC)
                                FROM UC_Document__c 
                                WHERE Opportunity_Role__c =: parentRecordId Order By Document_Type__c DESC, Name ASC]) {
                                    OppRoleDocumentRow row = new OppRoleDocumentRow(d);
                                    oppRoleDocList.add(row);
                                }
        
    }
    
    public Class OppRoleDocumentRow {
        
        public Attachment att {get;set;}
        public UC_Document__c oppRoleDoc {get;set;}
        public String attName {get;set;}
        public String originalFileName {get;set;}
        public String mostRecentFileId {get;set;}
        
        public Integer versionNo {get;set;}
        
        public OppRoleDocumentRow( UC_Document__c theDoc )
        {
            oppRoleDoc = theDoc;
            // pull document if existing
            if(theDoc.getSObjects('Attachments') != null && !theDoc.getSObjects('Attachments').isEmpty()) {
                att = (Attachment)theDoc.getSObjects('Attachments')[0].clone(true, true, false, false);
                mostRecentFileId = att.Id;
                System.debug('mostRecentFileId: ' + mostRecentFileId);
                attName = att.Name;
                
                versionNo = theDoc.getSObjects('Attachments').size();
            }
            // otherwise default to new
            else{
                att = new Attachment();
                versionNo = 0;
            }
        }
        
        public Attachment clearAttachmentBody(){
            att.body = null;
            return att;
        }
    }
    
    
    public PageReference insertAttachments() {
        
        dmlSuccess = false;
        try {
            
            transient List<Attachment> attsToUpload = new List<Attachment>();
            transient List<OppRoleDocumentRow> rowsToUpdate = new List<OppRoleDocumentRow>();
            transient Map<Id, UC_Document__c> documentDataMap = new Map<Id, UC_Document__c>();
            
            for(OppRoleDocumentRow row : oppRoleDocList) {
                System.debug('loop: ' + row.att);
                if(row.att != null && row.att.body != null && validUpload(row.att)) { 
                    Attachment temp = row.att.clone(false, true, false, false);
                    temp.Name = row.originalFileName;
                    temp.ParentId = row.oppRoleDoc.Id;
                    attsToUpload.add(temp);
                    row.clearAttachmentBody();
                    documentDataMap.put(row.oppRoleDoc.Id, row.oppRoleDoc);
                }
            }
            
            Savepoint sp = Database.setSavepoint();
            List<Database.SaveResult> attResults;
            try {
                attResults = Database.insert(attsToUpload);
                
                Set<Id> resultIds = new Set<Id>();
                for(Database.SaveResult result : attResults) {
                    if(result.isSuccess()) {
                        resultIds.add(result.getId());
                    }
                }
                System.debug('Sucessful Inserts: ' + resultIds.size());
                
                Map<Id, UC_Document__c> docsToUpdate = new Map<Id, UC_Document__c>();
                for(Attachment a : [SELECT Id, ParentId FROM Attachment WHERE Id IN: resultIds]) {
                    for(Id i : documentDataMap.keySet()) {
                        if(a.ParentId == i) {
                            if(documentDataMap.get(i).Document_Status__c != 'Submitted') {
                                UC_Document__c temp = new UC_Document__c();
                                temp.Id = i;
                                temp.Document_Status__c = 'Submitted';
                                docsToUpdate.put(temp.Id, temp);
                            }
                        }
                    }
                }
                
                if(!docsToUpdate.isEmpty()) {
                    try {
                        update docsToUpdate.values();
                        dmlSuccess = true;
                    } catch(Exception e) {
                        System.debug('Doc Update Error: ' + e);
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error uploading the document.');
                        ApexPages.addMessage(errorMsg);
                        return null;
                    }
                }
            } catch(Exception e) {
                System.debug('Att Insert Error: ' + e);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error uploading the document.');
                ApexPages.addMessage(errorMsg);
                return null;
            }
            
            fetchDocuments();   
            return null;
            
        } catch(Exception e) {
            System.debug('General Error: ' + e);
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error uploading the document: ' + e.getMessage());
            ApexPages.addMessage(errorMsg);
            return null;
        }
        
        return null;
        
    }
    
    public Boolean validUpload(Attachment att){
        if(att.Body != null){
            if(att.BodyLength > MAX_FILE_SIZE){
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Submit_size_too_large);
                ApexPages.addMessage(errorMsg);
                return false;
            }
            return true;
        }
        
        return false;
    }
    
    public PageReference Cancel() {
        PageReference ref = new PageReference('/' + parentRecordId);
        ref.setRedirect(true);
        return ref;
    }
    
    @RemoteAction
    public static DeleteAttachmentResponse deleteAttachment(DeleteAttachmentRequest request) {
        DeleteAttachmentResponse response = new DeleteAttachmentResponse();
        
        String errorMessage = '';
        Savepoint sp = Database.setSavepoint();
        if (request != null) {
            if (request.attachmentId != null) {
                try {
                    
                    List <Attachment> attList = [SELECT Id, ParentId FROM Attachment WHERE Id = :request.attachmentId];    
                    String parentId = attList[0].ParentId;
                    delete attList[0];
                    Integer attCount = [SELECT COUNT() FROM Attachment WHERE ParentId = :parentId];
                    if (attCount == 0) {
                        List <UC_Document__c> docList = [SELECT Id, Document_Status__c FROM UC_Document__c WHERE Id =:parentId];
                        if (docList.size() > 0 && docList[0].Document_Status__c != 'Not Submitted') {
                            docList[0].Document_Status__c = 'Not Submitted';
                            update docList[0];
                        }
                    }
                    response.isSuccess = true;
                } catch(Exception e) {
                    errorMessage = 'Error while deleting attachment: ' + e.getMessage();
                }
            } else {
                errorMessage = 'request.attachmentId is null';
            }
        } else {
            errorMessage = 'request is null';
        }
        
        if (String.IsNotBlank(errorMessage)) {
            Database.rollback(sp);
        }
        
        response.errorMessage = errorMessage;
        return response;    
    }    
    
    public class DeleteAttachmentRequest {
        public String attachmentId;
    }
    public class DeleteAttachmentResponse {
        public Boolean isSuccess;
        public String errorMessage;
        DeleteAttachmentResponse() {
            isSuccess = false;
        }
    }
    
    
}