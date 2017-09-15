@isTest
public class Case360ViewChronControllerTest {

    private static testMethod void test_param_id_required() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData();        

        PageReference pr = Page.Case360ViewChron;
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertNotEquals(null, controller.errorMsg);
    }

    private static testMethod void test_param_caseId() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData();        

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(null, controller.errorMsg);
    }

    private static testMethod void test_param_woId() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData();        

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.wo_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(null, controller.errorMsg);
    }

    private static testMethod void test_case() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_x', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        insert new List <Service_Request_Settings__c>{s_1};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(1, controller.wrapper360List.size());
        system.assertEquals('Case', controller.wrapper360List[0].type);
        
    }

    private static testMethod void test_serviceRequest() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'Service Request~WorkOrder~WorkOrderNumber,SR#~Subject~Owner.Name,Owner~Status');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(3, controller.wrapper360List.size());
        
    }

    private static testMethod void test_rma() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'RMA~RMA__c~Name~RMA_Type__c,Type~RMA_Status__c,Status');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(3, controller.wrapper360List.size());
        
    }

    private static testMethod void test_caseComment() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'Comment~CaseComment~CommentBody,Comment');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(3, controller.wrapper360List.size());
        
    }

    private static testMethod void test_email() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'Email~EmailMessage~Subject~Status~ToAddress');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(3, controller.wrapper360List.size());
        
    }

    private static testMethod void test_task() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'Task~Task~What.Name,Case/SR#~Subject~ActivityDate,Due Date~Status');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(7, controller.wrapper360List.size());
        
    }

    private static testMethod void test_event() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_1', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~Status~Description');
        Service_Request_Settings__c s_2 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_2', 
            Default_Value__c = 'Event~Event~What.Name,Case/SR#~Subject~StartDateTime,Start Date~EndDateTime,End Date~Owner.Name,Assigned To');
        insert new List <Service_Request_Settings__c>{s_1, s_2};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(7, controller.wrapper360List.size());
        
    }

    private static testMethod void test_queryException() {
        Case360ViewChronControllerTestData td = new Case360ViewChronControllerTestData();
        td.createTestData(); 
        
        // StatusX not a field in case
        Service_Request_Settings__c s_1 = new Service_Request_Settings__c(Name = 'SR_360Chron_Fields_x', 
            Default_Value__c = 'Case~Case~CaseNumber,Case#~Subject~Owner.Name,Owner~StatusX~Description');
        insert new List <Service_Request_Settings__c>{s_1};       

        PageReference pr = Page.Case360ViewChron;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewChronController controller = new Case360ViewChronController();
        system.assertEquals(0, controller.wrapper360List.size());
        system.assertNotEquals(null, controller.errorMsg);
        
    }

}