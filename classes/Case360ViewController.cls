public class Case360ViewController {
    public Case parentCase {get; private set;}
    public List <WrapperWorkOrder> wrprWorkOrderList {get; private set;}
    public List <WrapperComment> wrprCommentList {get; private set;}
    public List <WrapperRMA> wrprRMAList {get; private set;}
    public List <WrapperTask> wrprTaskList {get; private set;}
    public List <WrapperEvent> wrprEventList {get; private set;}
    public List <WrapperEmail> wrprEmailList {get; private set;}
    public String errorMsg {get; private set;}
    
    String serviceRequestParentId;

    public Case360ViewController() {
        parentCase = new Case();
        wrprWorkOrderList = new List <WrapperWorkOrder>();
        wrprCommentList = new List <WrapperComment>();
        wrprRMAList = new List <WrapperRMA>();
        wrprTaskList = new List <WrapperTask>();
        wrprEventList = new List <WrapperEvent>();
        wrprEmailList = new List <WrapperEmail>();
        load360();
    }
    
    private void load360() {
        String parentId = APexPages.currentPage().getParameters().get('Id');
        String caseKeyPrefix = Case.SObjectType.getDescribe().getKeyPrefix();
        String WorkOrderKeyPrefix = WorkOrder.SObjectType.getDescribe().getKeyPrefix();
        String caseId;
        if (String.IsNotBlank(parentId)) {
            if (parentId.startsWithIgnoreCase(caseKeyPrefix)) {
                List <Case> cList = [SELECT Id FROM Case WHERE Id = :parentId];
                if (cList.size() > 0) {
                    caseId = cList[0].Id;
                } else {
                    errorMessage('Case not found for id: ' + parentId);
                }
            } else if (parentId.startsWithIgnoreCase(WorkOrderKeyPrefix)) {
                List <WorkOrder> woList = [SELECT Id, CaseId, WorkOrderNumber FROM WorkOrder WHERE Id = :parentId];
                if (woList.size() > 0) {
                    if (woList[0].CaseId != null) {
                        caseId = woList[0].CaseId;
                    } else {
                        errorMessage('Case is required in service request: ' + woList[0].WorkOrderNumber);
                    } 
                } else {
                    errorMessage('Service request not found for id: ' + parentId);
                }
            } else {
                errorMessage('Not a case or service request id: ' + parentId);
            }       
        } else {
            errorMessage('Page requires case or service request id param');
        }
        if (String.IsNotBlank(errorMsg)) {
            return;
        }
        
        if (String.IsNotBlank(caseId)) {
            loadWrapper(caseId);
        }
    }
    
    private void loadWrapper(String caseId) {
        List <Case> caseList = [SELECT Id, CreatedDate, CaseNumber, Subject, RecordType.Name, Status, Priority, Owner.Name,
                    Commitment_Date__c, Description,
                (SELECT Id, CreatedBy.Name, CreatedDate, CaseId, WorkOrderNumber, Priority, Status, Subject, RecordType.Name, Owner.Name,
                    Description FROM WorkOrders 
                    ORDER BY CreatedDate DESC),
                (SELECT Id, Name, RMA_Type__c, RMA_Status__c, CreatedDate, CreatedBy.Name FROM RMAs__r ORDER BY CreatedDate DESC),   
                (SELECT Id, Subject, ActivityDate, Status, Priority, Owner.Name FROM Tasks ORDER BY CreatedDate DESC),
                (SELECT Id, Subject, ActivityDate, StartDateTime, EndDateTime, Owner.Name  FROM Events ORDER BY CreatedDate DESC),
                (SELECT Id, CommentBody, CreatedDate, CreatedBy.Name FROM CaseComments ORDER BY CreatedDate DESC),
                (SELECT Id, Status, Subject, ToAddress, MessageDate FROM EmailMessages ORDER BY CreatedDate DESC)
            FROM Case 
            WHERE Id = :caseId];    

        Set <String> woIdSet = new Set <String>();
        if (caseList.size() > 0) {
            parentCase = caseList[0];        
            for (WorkOrder wo : parentCase.WorkOrders) {
                woIdSet.add(wo.Id);
            }
        }
        
        if (woIdSet.size() > 0) {
            List <WorkOrder> woList = [SELECT Id, WorkOrderNumber,
                    (SELECT Id, Subject, ActivityDate, Status, Priority, Owner.Name FROM Tasks ORDER BY CreatedDate DESC),
                    (SELECT Id, Subject, ActivityDate, StartDateTime, EndDateTime, Owner.Name  FROM Events ORDER BY CreatedDate DESC)
                FROM WorkOrder
                WHERE Id IN :woIdSet];
                
            for (WorkOrder wo : woList) {
                for (Task t : wo.Tasks) {
                    wrprTaskList.add(new WrapperTask(wo, t));
                }            
                for (Event e : wo.Events) {
                    wrprEventList.add(new WrapperEvent(wo, e));
                }            
            } 
        }   
            
        for (Case c : caseList) {
            for (WorkOrder wo : c.WorkOrders) {
                wrprWorkOrderList.add(new WrapperWorkOrder(c, wo));
            }            
            for (CaseComment comment : c.CaseComments) {
                wrprCommentList.add(new WrapperComment(c, comment));
            }            
            for (RMA__c rma : c.RMAs__r) {
                wrprRMAList.add(new WrapperRMA(c, rma));
            }            
            for (Task t : c.Tasks) {
                wrprTaskList.add(new WrapperTask(c, t));
            }            
            for (Event e : c.Events) {
                wrprEventList.add(new WrapperEvent(c, e));
            }            
            for (EmailMessage em : c.EmailMessages) {
                wrprEmailList.add(new WrapperEmail(c, em));
            }            
        }    
    
    }

    private void errorMessage(String msg) {
        errorMsg = msg;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    
    public class WrapperWorkOrder {
        public Case c {get; private set;}    
        public WorkOrder wo {get; private set;}    
        public WrapperWorkOrder(Case c, WorkOrder wo) {
            this.c = c;
            this.wo = wo;
        }   
    }
            
    public class WrapperComment {
        public Case c {get; private set;}    
        public CaseComment comment {get; private set;} 
        public WrapperComment(Case c, CaseComment comment) {
            this.c = c;
            this.comment = comment;
        }   
    }

    public class WrapperRMA {
        public Case c {get; private set;}    
        public RMA__c rma {get; private set;} 
        public WrapperRMA(Case c, RMA__c rma) {
            this.c = c;
            this.rma = rma;
        }   
    }

    public class WrapperTask {
        public Case c {get; private set;} 
        public WorkOrder wo {get; private set;}    
        public Task t {get; private set;} 
        public WrapperTask(Case c, Task t) {
            this.c = c;
            this.t = t;
        }   
        public WrapperTask(WorkOrder wo, Task t) {
            this.wo = wo;
            this.t = t;
        }   
    }

    public class WrapperEvent {
        public Case c {get; private set;}    
        public WorkOrder wo {get; private set;}    
        public Event e {get; private set;} 
        public WrapperEvent(Case c, Event e) {
            this.c = c;
            this.e = e;
        }   
        public WrapperEvent(WorkOrder wo, Event e) {
            this.wo = wo;
            this.e = e;
        }   
    }

    public class WrapperEmail {
        public Case c {get; private set;}    
        public EmailMessage em {get; private set;} 
        public WrapperEmail(Case c, EmailMessage em) {
            this.c = c;
            this.em = em;
        }   
    }

}