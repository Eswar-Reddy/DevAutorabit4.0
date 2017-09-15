@isTest
public class ServiceRequestTaskTest {

    private static testMethod void test_createTask_no_flag() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData(); 
        td.createUser('Standard User', 'user_1');
        
        td.wo_1.OwnerId = td.user_1.Id;
        update td.wo_1;
        system.assertEquals(0, [SELECT Id FROM Task WHERE WhatId = :td.wo_1.Id].size());
            
    }

    private static testMethod void test_createTask_flag_true() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData(); 
        td.createUser('Standard User', 'user_1');
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        insert new List <Service_Request_Settings__c>{s_1};   

        td.wo_1.OwnerId = td.user_1.Id;
        update td.wo_1;
        
        Task t = [SELECT Id, OwnerId FROM Task WHERE WhatId = :td.wo_1.Id];
        system.assertEquals(td.user_1.Id, t.OwnerId);
            
    }

    private static testMethod void test_createTask_srOwnerQueue() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData_queue(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        insert new List <Service_Request_Settings__c>{s_1};   

        td.wo_1.OwnerId = td.queue_1.Id;
        update td.wo_1;
        
        List <Task> tList = [SELECT Id, OwnerId, WhatId FROM Task];
        system.assertEquals(2, tList.size());    
        Set <String> ownerIdSet = new Set <String>();
        for (Task t : tList) {
            system.assertEquals(td.wo_1.Id, t.WhatId);
            ownerIdSet.add(t.OwnerId);
        }
        system.assertEquals(true, ownerIdSet.contains(td.user_1.id));                
        system.assertEquals(true, ownerIdSet.contains(td.user_2.id));
            
    }

    private static testMethod void test_defaultFields() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData(); 
        td.createUser('Standard User', 'user_1');
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_OwnerChangeSR_DefaultField_1', Default_Value__c = 'Status~In Progress');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.OwnerId = td.user_1.Id;
        update td.wo_1;
        system.assertEquals('In Progress', [SELECT Id, Status FROM Task WHERE WhatId = :td.wo_1.Id].Status);
            
    }

    private static testMethod void test_dueDate() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData(); 
        td.createUser('Standard User', 'user_1');
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_OwnerChangeSR_DueDate', Default_Value__c = '2');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.OwnerId = td.user_1.Id;
        update td.wo_1;
        system.assertEquals(system.today().addDays(2), [SELECT Id, ActivityDate FROM Task WHERE WhatId = :td.wo_1.Id].ActivityDate);
            
    }

    private static testMethod void test_recordType() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestData(); 
        td.createUser('Standard User', 'user_1');
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_OwnerChangeSR_RecordType', Default_Value__c = 'Private_Task');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.OwnerId = td.user_1.Id;
        update td.wo_1;
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Task' AND DeveloperName = 'Private_Task'];
        system.assertEquals(rt.Id, [SELECT Id, RecordTypeId FROM Task WHERE WhatId = :td.wo_1.Id].RecordTypeId);
            
    }

    private static testMethod void test_createTask_bulk() {
        ServiceRequestTaskTestData td = new ServiceRequestTaskTestData();    
        td.createTestDataBulk(20); 
        td.createUser('Standard User', 'user_1');
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_OwnerChangeSR', Default_Value__c = 'true');
        insert new List <Service_Request_Settings__c>{s_1};   

        for (WorkOrder wo : td.woList) {
            wo.OwnerId = td.user_1.Id;
        }
        update td.woList;
        system.assertEquals(20, [SELECT Id FROM Task WHERE WhatId IN :td.woList].size());
            
    }

}