@isTest
public class WorkOrderNewExtensionTest {

    private static testMethod void test_wo_id() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        pr.getParameters().put('id', td.wo_1.Id);    // this comes from work order edit override
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertNotEquals(null, extension.redirectPage());
                   
    }

    private static testMethod void test_case_lkid() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        pr.getParameters().put('Case_lkid', td.case_1.Id);
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertNotEquals(null, extension.redirectPage());
                   
    }

    private static testMethod void test_retURL_workOrder() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        pr.getParameters().put('retURL', '/' + td.wo_1.Id);
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertNotEquals(null, extension.redirectPage());
                   
    }

    private static testMethod void test_retURL_case() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        pr.getParameters().put('retURL', '/' + td.case_1.Id);
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertNotEquals(null, extension.redirectPage());
                   
    }

    private static testMethod void test_retURL_SRTab() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        pr.getParameters().put('retURL', '/0WO/o');
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertEquals(null, extension.redirectPage());
                   
    }

    private static testMethod void test_noParams() {
        WorkOrderNewExtensionTestData td = new WorkOrderNewExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderNew;
        Test.setCurrentPage(pr);
        
        WorkOrderNewExtension extension = new WorkOrderNewExtension(stdController);
        system.assertEquals(null, extension.redirectPage());
                   
    }

}