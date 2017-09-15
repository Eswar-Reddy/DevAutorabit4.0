@isTest
public class AuroraDesignAPITest {

    private static testMethod void test_getDesignPage() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_getDesignPage();
    
        AuroraDesignAPI.GetDesignPageRequest request = new AuroraDesignAPI.GetDesignPageRequest();
        request.auroraDesignId = 'testAuroraDesignId';
        AuroraDesignAPI.GetDesignPageResponse response = AuroraDesignAPI.getDesignPage(request);

        system.assertNotEquals(null, response.designPageReference);
    }
    
    private static testMethod void test_getDesignPage_auroraDesignId_required() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_getDesignPage();
    
        AuroraDesignAPI.GetDesignPageRequest request = new AuroraDesignAPI.GetDesignPageRequest();
        AuroraDesignAPI.GetDesignPageResponse response = AuroraDesignAPI.getDesignPage(request);
        // error Aurora design id is required
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }
    
    private static testMethod void test_createDesign_200() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_createDesign();
    
        AuroraDesignAPI.CreateDesignRequest request = new AuroraDesignAPI.CreateDesignRequest();
        request.designId = td.design_1.Id;
        request.auroraProjectId = 'testAuroraProjectId'; // Aurora project id is required to create design
        
        Test.startTest();
        // set success response 200
        AuroraDesignAPIMock.STATUS_CODE = AuroraDesignAPIMock.STATUS_CODE_200;
        AuroraDesignAPIMock.STATUS = AuroraDesignAPIMock.STATUS_200;
        AuroraDesignAPIMock.BODY = AuroraDesignAPIMock.BODY_200;

        Test.setMock(HttpCalloutMock.class, new AuroraDesignAPIMock());
        AuroraDesignAPI.CreateDesignResponse response = AuroraDesignAPI.createDesign(request);
        Test.stopTest();
        
        system.assertEquals('db0791db-444c-44e5-b50c-e5e649118c0e', response.auroraDesignId);
    }
    
    private static testMethod void test_createDesign_401() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_createDesign();
    
        AuroraDesignAPI.CreateDesignRequest request = new AuroraDesignAPI.CreateDesignRequest();
        request.designId = td.design_1.Id;
        request.auroraProjectId = 'testAuroraProjectId'; // Aurora project id is required to create design
        
        Test.startTest();
        // set Unauthorized response 401
        AuroraDesignAPIMock.STATUS_CODE = AuroraDesignAPIMock.STATUS_CODE_401;
        AuroraDesignAPIMock.STATUS = AuroraDesignAPIMock.STATUS_401;
        AuroraDesignAPIMock.BODY = AuroraDesignAPIMock.BODY_401;

        Test.setMock(HttpCalloutMock.class, new AuroraDesignAPIMock());
        AuroraDesignAPI.CreateDesignResponse response = AuroraDesignAPI.createDesign(request);
        Test.stopTest();
        
        system.assertEquals(true, String.IsBlank(response.auroraDesignId));
    }
    
    private static testMethod void test_createDesign_designId_required() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_createDesign();
    
        AuroraDesignAPI.CreateDesignRequest request = new AuroraDesignAPI.CreateDesignRequest();
        AuroraDesignAPI.CreateDesignResponse response = AuroraDesignAPI.createDesign(request);
        // error designId parameter is required
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }

    private static testMethod void test_createDesign_auroraProjectId_required() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_createDesign();
    
        AuroraDesignAPI.CreateDesignRequest request = new AuroraDesignAPI.CreateDesignRequest();
        request.designId = td.design_1.Id;
        AuroraDesignAPI.CreateDesignResponse response = AuroraDesignAPI.createDesign(request);
        // error Aurora project id is required to create design
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }
    
    private static testMethod void test_createDesign_designId_exists() {
        AuroraDesignAPITestData td = new AuroraDesignAPITestData();
        td.createTestData_createDesign_designId_exists();
    
        AuroraDesignAPI.CreateDesignRequest request = new AuroraDesignAPI.CreateDesignRequest();
        request.designId = td.design_1.Id;
        request.auroraProjectId = 'testAuroraProjectId'; // Aurora project id is required to create design
        AuroraDesignAPI.CreateDesignResponse response = AuroraDesignAPI.createDesign(request);
        // error Aurora design id already exists in roof design
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }
    
}