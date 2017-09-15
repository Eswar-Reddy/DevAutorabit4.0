@isTest
public class WorkOrderEditExtensionTest {

    private static testMethod void test_case_lkid() {
        WorkOrderEditExtensionTestData td = new WorkOrderEditExtensionTestData();    
        td.createTestData();    

        ApexPages.StandardController stdController = new ApexPages.StandardController(td.wo_1); 
        
        PageReference pr = Page.WorkOrderEdit;
        pr.getParameters().put('id', td.wo_1.Id); 
        Test.setCurrentPage(pr);
        
        WorkOrderEditExtension extension = new WorkOrderEditExtension(stdController);
        system.assertNotEquals(null, extension.redirectPage());
                   
    }

}