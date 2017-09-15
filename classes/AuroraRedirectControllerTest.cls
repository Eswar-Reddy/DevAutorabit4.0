@isTest
public class AuroraRedirectControllerTest {

    private static testMethod void test_newInternalProject() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_newInternalProject();
        
        Test.startTest();
        // set success response 200
        AuroraRedirectControllerMock.STATUS_CODE = AuroraRedirectControllerMock.STATUS_CODE_200;
        AuroraRedirectControllerMock.STATUS = AuroraRedirectControllerMock.STATUS_200;
        AuroraRedirectControllerMock.BODY = AuroraRedirectControllerMock.BODY_200;
        Test.setMock(HttpCalloutMock.class, new AuroraRedirectControllerMock());
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('siteId', td.site_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);
        Test.stopTest();
    }

    private static testMethod void test_newInternalProject_401() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_newInternalProject();
        
        Test.startTest();
        // set success response 200
        AuroraRedirectControllerMock.STATUS_CODE = AuroraRedirectControllerMock.STATUS_CODE_401;
        AuroraRedirectControllerMock.STATUS = AuroraRedirectControllerMock.STATUS_401;
        AuroraRedirectControllerMock.BODY = AuroraRedirectControllerMock.BODY_401;
        Test.setMock(HttpCalloutMock.class, new AuroraRedirectControllerMock());
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('siteId', td.site_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);    // System.PageReference[/apex/auroraredirectmessage]
        Test.stopTest();
    }

    private static testMethod void test_oldInternalProject() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_oldInternalProject();
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('siteId', td.site_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);
    }

    private static testMethod void test_newDesign_newInternalProject() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_newDesign_newInternalProject();
        
        Test.startTest();
        // set success response 200
        AuroraRedirectControllerMock.STATUS_CODE = AuroraRedirectControllerMock.STATUS_CODE_200;
        AuroraRedirectControllerMock.STATUS = AuroraRedirectControllerMock.STATUS_200;
        AuroraRedirectControllerMock.BODY = AuroraRedirectControllerMock.BODY_200;
        Test.setMock(HttpCalloutMock.class, new AuroraRedirectControllerMock());
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('designId', td.design_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);
        Test.stopTest();
    }

    private static testMethod void test_newDesign_oldInternalProject() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_newDesign_oldInternalProject();
        
        Test.startTest();
        // set success response 200
        AuroraRedirectControllerMock.STATUS_CODE = AuroraRedirectControllerMock.STATUS_CODE_200;
        AuroraRedirectControllerMock.STATUS = AuroraRedirectControllerMock.STATUS_200;
        AuroraRedirectControllerMock.BODY = AuroraRedirectControllerMock.BODY_200;
        Test.setMock(HttpCalloutMock.class, new AuroraRedirectControllerMock());
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('designId', td.design_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);
        Test.stopTest();
    }

    private static testMethod void test_oldDesign() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_oldDesign();
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('designId', td.design_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);
    }

    private static testMethod void test_newDesign_newInternalProject_401() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_newDesign_newInternalProject();
        
        Test.startTest();
        // set success response 200
        AuroraRedirectControllerMock.STATUS_CODE = AuroraRedirectControllerMock.STATUS_CODE_401;
        AuroraRedirectControllerMock.STATUS = AuroraRedirectControllerMock.STATUS_401;
        AuroraRedirectControllerMock.BODY = AuroraRedirectControllerMock.BODY_401;
        Test.setMock(HttpCalloutMock.class, new AuroraRedirectControllerMock());
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('designId', td.design_1.Id);
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);    // System.PageReference[/apex/auroraredirectmessage]
        Test.stopTest();
    }

    private static testMethod void test_siteNotFound() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_oldInternalProject();
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('siteId', 'testSiteId');
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);    // System.PageReference[/apex/auroraredirectmessage]
    }

    private static testMethod void test_designNotFound() {
        AuroraRedirectControllerTestData td = new AuroraRedirectControllerTestData();
        td.createTestData_oldDesign();
        
        PageReference pr = Page.AuroraRedirect;
        pr.getParameters().put('designId', 'testDesignId');
        Test.setCurrentPageReference(pr);
        
        AuroraRedirectController controller = new AuroraRedirectController();
        PageReference returnPR = controller.redirectToAurora();
        system.assertNotEquals(null, returnPR);    // System.PageReference[/apex/auroraredirectmessage]
    }
    
}