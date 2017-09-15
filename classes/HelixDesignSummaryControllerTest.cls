@isTest
public class HelixDesignSummaryControllerTest {

    private static testMethod void test_googleMap() {
        HelixDesignSummaryControllerTestData td = new HelixDesignSummaryControllerTestData();
        td.createTestData_googleMap();
    
        ApexPages.StandardController stdController = new ApexPages.StandardController(td.design_1);
        HelixDesignSummaryController controller = new HelixDesignSummaryController(stdController);
        //system.assertEquals(true, String.IsNotBlank(controller.mapURL));
        //system.assertEquals(controller.mapURL, controller.imageDisplayURL);
    }

    private static testMethod void test_png() {
        HelixDesignSummaryControllerTestData td = new HelixDesignSummaryControllerTestData();
        td.createTestData_png();
    
        ApexPages.StandardController stdController = new ApexPages.StandardController(td.design_1);
        HelixDesignSummaryController controller = new HelixDesignSummaryController(stdController);
        //system.assertEquals(true, String.IsNotBlank(controller.pngURL));
        //system.assertEquals(controller.pngURL, controller.imageDisplayURL);
    }

}