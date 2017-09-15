@isTest
public class ServiceRequestControllerTestData {

    public Case case_1;
    public WorkOrder workOrder_1;
    public Group queue_1;
    public User User_1, User_2;
    
    public void createTestData_URLParam_caseId() {
        case_1 = new Case();    
        insert new List <Case>{case_1};    
    }

    public void createTestData_URLParam_woId_withoutCase() {
        workOrder_1 = new WorkOrder();    
        insert new List <WorkOrder>{workOrder_1};    
    }

    public void createTestData_URLParam_woId_withCase() {
        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id);    
        insert new List <WorkOrder>{workOrder_1};    
    }

    public void createTestData_task() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_NewSR', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_1', Default_Value__c = 'OwnerId~OwnerId'); 
        Service_Request_Settings__c s_3 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_3', Default_Value__c = 'Id~WhatId'); 
        Service_Request_Settings__c s_4 = new Service_Request_Settings__c(Name = 'SR_InputField_1', Default_Value__c = 'OwnerId~Service Request Owner'); 
        Service_Request_Settings__c s_5 = new Service_Request_Settings__c(Name = 'SR_InputField_2', Default_Value__c = 'Subject~Service Request Subject~SR -~width:500px~true'); 
        Service_Request_Settings__c s_6 = new Service_Request_Settings__c(Name = 'SR_CopyField_CaseToSR_01', Default_Value__c = 'Priority'); 
        Service_Request_Settings__c s_7 = new Service_Request_Settings__c(Name = 'SR_DefaultField_1', Default_Value__c = 'Status~New'); 
        Service_Request_Settings__c s_8 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_DueDate', Default_Value__c = '0'); 
        Service_Request_Settings__c s_9 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_RecordType', Default_Value__c = 'Notification_Task'); 
        Service_Request_Settings__c s_10 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_CaseToTask_1', Default_Value__c = 'Priority~Priority'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9, s_10};   

        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id);    
        insert new List <WorkOrder>{workOrder_1};
    }

    public void createTestData_task_queue() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_NewSR', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_1', Default_Value__c = 'OwnerId~OwnerId'); 
        Service_Request_Settings__c s_3 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_3', Default_Value__c = 'Id~WhatId'); 
        Service_Request_Settings__c s_4 = new Service_Request_Settings__c(Name = 'SR_InputField_1', Default_Value__c = 'OwnerId~Service Request Owner'); 
        Service_Request_Settings__c s_5 = new Service_Request_Settings__c(Name = 'SR_InputField_2', Default_Value__c = 'Subject~Service Request Subject~SR -~width:500px~true'); 
        Service_Request_Settings__c s_6 = new Service_Request_Settings__c(Name = 'SR_CopyField_CaseToSR_01', Default_Value__c = 'Priority'); 
        Service_Request_Settings__c s_7 = new Service_Request_Settings__c(Name = 'SR_DefaultField_1', Default_Value__c = 'Status~New'); 
        Service_Request_Settings__c s_8 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_DueDate', Default_Value__c = '0'); 
        Service_Request_Settings__c s_9 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_RecordType', Default_Value__c = 'Notification_Task'); 
        Service_Request_Settings__c s_10 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_CaseToTask_1', Default_Value__c = 'Priority~Priority'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9, s_10};   

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): QueueSobject, original object: Service_Request_Settings__c
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            // create queue and queue users
            queue_1 = new Group(Name='Test_SP_SR_Group', type='Queue');
            insert new List <Group>{queue_1};
            QueuesObject qo_1 = new QueueSObject(QueueID = queue_1.id, SobjectType = 'WorkOrder');
            insert new List <QueuesObject>{qo_1};
            user_1 = getNewUser('Standard User', 'user_1');
            user_2 = getNewUser('Standard User', 'user_2');
            insert new List <User>{user_1, user_2};
            GroupMember gm_1 = new GroupMember(GroupId = queue_1.Id, UserOrGroupId = user_1.Id);
            GroupMember gm_2 = new GroupMember(GroupId = queue_1.Id, UserOrGroupId = user_2.Id);
            insert new List <GroupMember>{gm_1, gm_2};
        }
        
        case_1 = new Case();    
        insert new List <Case>{case_1};    
        
    }

    public void createTestData_task_queue_no_users() {
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_NewSR', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_1', Default_Value__c = 'OwnerId~OwnerId'); 
        Service_Request_Settings__c s_3 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_SRToTask_3', Default_Value__c = 'Id~WhatId'); 
        Service_Request_Settings__c s_4 = new Service_Request_Settings__c(Name = 'SR_InputField_1', Default_Value__c = 'OwnerId~Service Request Owner'); 
        Service_Request_Settings__c s_5 = new Service_Request_Settings__c(Name = 'SR_InputField_2', Default_Value__c = 'Subject~Service Request Subject~SR -~width:500px~true'); 
        Service_Request_Settings__c s_6 = new Service_Request_Settings__c(Name = 'SR_CopyField_CaseToSR_01', Default_Value__c = 'Priority'); 
        Service_Request_Settings__c s_7 = new Service_Request_Settings__c(Name = 'SR_DefaultField_1', Default_Value__c = 'Status~New'); 
        Service_Request_Settings__c s_8 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_DueDate', Default_Value__c = '0'); 
        Service_Request_Settings__c s_9 = new Service_Request_Settings__c(Name = 'SR_Task_NewSR_RecordType', Default_Value__c = 'Notification_Task'); 
        Service_Request_Settings__c s_10 = new Service_Request_Settings__c(Name = 'SR_CopyField_NewSR_CaseToTask_1', Default_Value__c = 'Priority~Priority'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9, s_10};   

        // MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a 
        // non-setup object (or vice versa): QueueSobject, original object: Service_Request_Settings__c
        User u = [SELECT Id From User WHERE Id = :UserInfo.getUserId()];
        System.runAs(u) {
            // create queue and queue users
            queue_1 = new Group(Name='Test_SP_SR_Group', type='Queue');
            insert new List <Group>{queue_1};
            QueuesObject qo_1 = new QueueSObject(QueueID = queue_1.id, SobjectType = 'WorkOrder');
            insert new List <QueuesObject>{qo_1};
        }
        
        case_1 = new Case();    
        insert new List <Case>{case_1};    
        
    }

    public void createTestData_caseTeam() {
        case_1 = new Case();    
        insert new List <Case>{case_1};    
        workOrder_1 = new WorkOrder(CaseId = case_1.Id);    
        insert new List <WorkOrder>{workOrder_1};
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_AddSROwner', Default_Value__c = 'true'); 
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_CaseTeam_Role', Default_Value__c = 'Service Request Owner'); 
        Service_Request_Settings__c s_3 = new Service_Request_Settings__c(Name = 'SR_InputField_1', Default_Value__c = 'OwnerId~Service Request Owner'); 
        insert new List <Service_Request_Settings__c>{s_1, s_2, s_3};   
    }

    public static User getNewUser(String profileName, String userName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User u = new User(
            Alias = userName, 
            Email = userName + '@testsp.com',
            EmailEncodingKey = 'UTF-8', 
            LastName = userName + 'LN', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', 
            UserName = userName + '@testsp.com',
            Country = 'United States',
            Division = 'IT');    
        
        return u;    
    }
    
 }