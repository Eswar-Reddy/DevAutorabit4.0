@isTest
public class ServiceRequestUtilTest {

    private static testMethod void test_createTask_no_flag() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestData(); 
        
        td.wo_1.Status = 'Closed';
        update td.wo_1;
        system.assertEquals(0, [SELECT Id FROM Task WHERE WhatId = :td.wo_1.Id].size());
            
    }

    private static testMethod void test_createTask_flag_true() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_CloseSR', Default_Value__c = 'true');
        insert new List <Service_Request_Settings__c>{s_1};   

        td.wo_1.Status = 'Closed';
        update td.wo_1;
        system.assertEquals(1, [SELECT Id FROM Task WHERE WhatId = :td.wo_1.Id].size());
            
    }

    private static testMethod void test_defaultFields() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_CloseSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_CloseSR_DefaultField_1', Default_Value__c = 'Status~In Progress');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.Status = 'Closed';
        update td.wo_1;
        system.assertEquals('In Progress', [SELECT Id, Status FROM Task WHERE WhatId = :td.wo_1.Id].Status);
            
    }

    private static testMethod void test_dueDate() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_CloseSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_CloseSR_DueDate', Default_Value__c = '2');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.Status = 'Closed';
        update td.wo_1;
        system.assertEquals(system.today().addDays(2), [SELECT Id, ActivityDate FROM Task WHERE WhatId = :td.wo_1.Id].ActivityDate);
            
    }

    private static testMethod void test_recordType() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_CloseSR', Default_Value__c = 'true');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_Task_CloseSR_RecordType', Default_Value__c = 'Private_Task');
        insert new List <Service_Request_Settings__c>{s_1, s_2};   

        td.wo_1.Status = 'Closed';
        update td.wo_1;
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Task' AND DeveloperName = 'Private_Task'];
        system.assertEquals(rt.Id, [SELECT Id, RecordTypeId FROM Task WHERE WhatId = :td.wo_1.Id].RecordTypeId);
            
    }

    private static testMethod void test_createTask_bulk() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createTestDataBulk(20); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_CreateTask_CloseSR', Default_Value__c = 'true');
        insert new List <Service_Request_Settings__c>{s_1};   

        for (WorkOrder wo : td.woList) {
            wo.Status = 'Closed';
        }
        update td.woList;
        system.assertEquals(20, [SELECT Id FROM Task WHERE WhatId IN :td.woList].size());
            
    }

    private static testMethod void test_completedDate_closed_insert() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createCompletedDateTestData_closed_insert(); 
        
        update td.wo_1;
        system.assertEquals(system.today(), [SELECT Completed_Date__c FROM WorkOrder WHERE Id = :td.wo_1.Id].Completed_Date__c);
            
    }

    private static testMethod void test_completedDate_closed_withoutDate() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createCompletedDateTestData(); 
        
        td.wo_1.Status = 'Closed';
        update td.wo_1;
        system.assertEquals(system.today(), [SELECT Completed_Date__c FROM WorkOrder WHERE Id = :td.wo_1.Id].Completed_Date__c);
            
    }

    private static testMethod void test_completedDate_closed_withDate() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createCompletedDateTestData(); 
        
        td.wo_1.Status = 'Closed';
        Date closedDate = system.today().addDays(-2);
        td.wo_1.Completed_Date__c = closedDate;
        update td.wo_1;
        system.assertEquals(closedDate, [SELECT Completed_Date__c FROM WorkOrder WHERE Id = :td.wo_1.Id].Completed_Date__c);
            
    }

    private static testMethod void test_completedDate_notClosed_withoutDate() {
        ServiceRequestUtilTestData td = new ServiceRequestUtilTestData();    
        td.createCompletedDateTestData(); 
        
        td.wo_1.Status = 'In Progress';
        update td.wo_1;
        system.assertEquals(null, [SELECT Completed_Date__c FROM WorkOrder WHERE Id = :td.wo_1.Id].Completed_Date__c);
            
    }

}