@isTest
public class ServiceRequestControllerTest {

    private static testMethod void test_URLParam_required() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertNotEquals(null, controller.errorMsg); // Page requires case or service request id param               
    }

    private static testMethod void test_URLParam_invalid() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', 'xxx');
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertNotEquals(null, controller.errorMsg); // Not a case or service request id               
    }

    private static testMethod void test_URLParam_caseNotFound() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', Case.SObjectType.getDescribe().getKeyPrefix() + 'xxx');
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertNotEquals(null, controller.errorMsg); // Case not found for id               
    }

    private static testMethod void test_URLParam_workorderNotFound() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_woId_withCase();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', WorkOrder.SObjectType.getDescribe().getKeyPrefix() + 'xxx');
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertNotEquals(null, controller.errorMsg); // Service request not found for id               
    }

    private static testMethod void test_URLParam_caseId() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertEquals(null, controller.errorMsg);                
    }

    private static testMethod void test_URLParam_woId_withoutCase() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_woId_withoutCase();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.workOrder_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertNotEquals(null, controller.errorMsg);     // error Case not found               
    }

    private static testMethod void test_URLParam_woId_withCase() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_woId_withCase();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.workOrder_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        system.assertEquals(null, controller.errorMsg);                    
    }

    private static testMethod void test_gotoServiceRequest() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
    }

    private static testMethod void test_task() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_task();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.tempWorkOrder.OwnerId = UserInfo.getUserId();
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
        system.assertEquals(UserInfo.getUserId(), controller.srWorkOrder.OwnerId);                
        Task t = [SELECT OwnerId, WhatId FROM Task];
        system.assertEquals(controller.srWorkOrder.Id, t.WhatId);                
        system.assertEquals(controller.srWorkOrder.OwnerId, t.OwnerId);                
    }

    private static testMethod void test_task_flag_off() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_task();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.tempWorkOrder.OwnerId = UserInfo.getUserId();
        controller.createNotificationTask = false;
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
        system.assertEquals(UserInfo.getUserId(), controller.srWorkOrder.OwnerId);                
        system.assertEquals(0, [SELECT OwnerId, WhatId FROM Task].size());
    }

    private static testMethod void test_task_queue() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_task_queue();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.tempWorkOrder.OwnerId = td.queue_1.Id;
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
        
        List <Task> tList = [SELECT OwnerId, WhatId FROM Task];
        system.assertEquals(2, tList.size()); 
        Set <String> ownerIdSet = new Set <String>();
        for (Task t : tList) {
            system.assertEquals(controller.srWorkOrder.Id, t.WhatId); 
            ownerIdSet.add(t.OwnerId);               
        }               
        system.assertEquals(true, ownerIdSet.contains(td.user_1.id));                
        system.assertEquals(true, ownerIdSet.contains(td.user_2.id));                
    }

    private static testMethod void test_task_queue_no_users() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_task_queue_no_users();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.tempWorkOrder.OwnerId = td.queue_1.Id;
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
        
        List <Task> tList = [SELECT OwnerId FROM Task];
        system.assertEquals(0, tList.size()); 
    }

    private static testMethod void test_caseTeam() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_caseTeam();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.tempWorkOrder.OwnerId = UserInfo.getUserId();
        controller.gotoServiceRequest();
        system.assertEquals(null, controller.errorMsg);                
        system.assertNotEquals(null, controller.srWorkOrder.Id);                
        system.assertEquals(td.case_1.Id, controller.srWorkOrder.CaseId);                
        system.assertEquals(UserInfo.getUserId(), controller.srWorkOrder.OwnerId); 
        List <CaseTeamMember> ctmList = [SELECT Id, TeamRole.Name FROM CaseTeamMember 
            WHERE ParentId = :td.case_1.Id AND MemberId = :UserInfo.getUserId()];               
        system.assertEquals(1, ctmList.size());                
        system.assertEquals('Service Request Owner', ctmList[0].TeamRole.Name);                
    }

    private static testMethod void test_gotoCancel() {
        ServiceRequestControllerTestData td = new ServiceRequestControllerTestData();
        td.createTestData_URLParam_caseId();    
        
        PageReference pr = Page.ServiceRequest;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
         
        ServiceRequestController controller = new ServiceRequestController();
        controller.gotoCancel();
    }

}