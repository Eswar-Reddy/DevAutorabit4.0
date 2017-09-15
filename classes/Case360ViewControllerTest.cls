@isTest
public class Case360ViewControllerTest {

    private static testMethod void test_param_caseId() {
        Case360ViewControllerTestData td = new Case360ViewControllerTestData();
        td.createTestData();        

        PageReference pr = Page.Case360View;
        pr.getParameters().put('Id', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewController controller = new Case360ViewController();
        system.assertEquals(td.case_1.Id, controller.parentCase.Id);
        system.assertEquals(2, controller.wrprWorkOrderList.size());
        system.assertEquals(2, controller.wrprCommentList.size());
        system.assertEquals(2, controller.wrprRMAList.size());
        system.assertEquals(6, controller.wrprTaskList.size());
        system.assertEquals(6, controller.wrprEventList.size());
        system.assertEquals(2, controller.wrprEmailList.size());
        
    }

    private static testMethod void test_param_woId() {
        Case360ViewControllerTestData td = new Case360ViewControllerTestData();
        td.createTestData();        

        PageReference pr = Page.Case360View;
        pr.getParameters().put('Id', td.wo_1.Id);
        Test.setCurrentPage(pr);
        
        Case360ViewController controller = new Case360ViewController();
        system.assertEquals(td.case_1.Id, controller.parentCase.Id);
        system.assertEquals(2, controller.wrprWorkOrderList.size());
        system.assertEquals(2, controller.wrprCommentList.size());
        system.assertEquals(2, controller.wrprRMAList.size());
        system.assertEquals(6, controller.wrprTaskList.size());
        system.assertEquals(6, controller.wrprEventList.size());
        system.assertEquals(2, controller.wrprEmailList.size());
        
    }
    
}