@isTest
public class Case360ViewChronControllerTestData {

    public Case case_1;
    public WorkOrder wo_1, wo_2;
    public CaseComment cc_1, cc_2;
    public RMA__c rma_1, rma_2;
    public Task caseTask_1, caseTask_2, woTask_11, woTask_12, woTask_21, woTask_22;
    public Event caseEvent_1, caseEvent_2, woEvent_11, woEvent_12, woEvent_21, woEvent_22;
    public EmailMessage em_1, em_2;
    
    public void createTestData() {
        Account account_1 = new Account(Name = 'account_1');
        insert new List <Account>{account_1};
         
        case_1 = new Case(AccountId = account_1.Id);
        insert new List <Case>{case_1}; 
        
        wo_1 = new WorkOrder(CaseId = case_1.Id);   
        wo_2 = new WorkOrder(CaseId = case_1.Id);   
        insert new List <WorkOrder>{wo_1, wo_2};
        
        cc_1 = new CaseComment(ParentId = case_1.Id);
        cc_2 = new CaseComment(ParentId = case_1.Id);
        insert new List <CaseComment>{cc_1, cc_2};
        
        rma_1 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
        rma_2 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
        insert new List <RMA__c>{rma_1, rma_2}; 
        
        caseTask_1 = new Task(WhatId = case_1.Id);       
        caseTask_2 = new Task(WhatId = case_1.Id); 
        woTask_11 = new Task(WhatId = wo_1.Id); 
        woTask_12 = new Task(WhatId = wo_1.Id); 
        woTask_21 = new Task(WhatId = wo_2.Id); 
        woTask_22 = new Task(WhatId = wo_2.Id); 
        insert new List <Task>{caseTask_1, caseTask_2, woTask_11, woTask_12, woTask_21, woTask_22};      

        caseEvent_1 = new Event(WhatId = case_1.Id, DurationInMinutes = 60, ActivityDateTime = system.today());       
        caseEvent_2 = new Event(WhatId = case_1.Id, DurationInMinutes = 60, ActivityDateTime = system.today()); 
        woEvent_11 = new Event(WhatId = wo_1.Id, DurationInMinutes = 60, ActivityDateTime = system.today()); 
        woEvent_12 = new Event(WhatId = wo_1.Id, DurationInMinutes = 60, ActivityDateTime = system.today()); 
        woEvent_21 = new Event(WhatId = wo_2.Id, DurationInMinutes = 60, ActivityDateTime = system.today()); 
        woEvent_22 = new Event(WhatId = wo_2.Id, DurationInMinutes = 60, ActivityDateTime = system.today()); 
        insert new List <Event>{caseEvent_1, caseEvent_2, woEvent_11, woEvent_12, woEvent_21, woEvent_22};  
        
        em_1 = new EmailMessage(ParentId = case_1.Id);    
        em_2 = new EmailMessage(ParentId = case_1.Id); 
        insert new List <EmailMessage>{em_1, em_2};   
                    
    }

}