@isTest
public class AuroraProjectAPITest {

    private static testMethod void test_getProjectPage() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_getProjectPage();
    
        AuroraProjectAPI.GetProjectPageRequest request = new AuroraProjectAPI.GetProjectPageRequest();
        request.auroraProjectId = 'testAuroraProjectId';
        AuroraProjectAPI.GetProjectPageResponse response = AuroraProjectAPI.getProjectPage(request);

        system.assertNotEquals(null, response.projectPageReference);
    }

    private static testMethod void test_getProjectPage_auroraProjectId_required() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_getProjectPage();
    
        AuroraProjectAPI.GetProjectPageRequest request = new AuroraProjectAPI.GetProjectPageRequest();
        AuroraProjectAPI.GetProjectPageResponse response = AuroraProjectAPI.getProjectPage(request);

        system.assertEquals(true, response.errorMessageList.size() > 0);
    }
    
    private static testMethod void test_createProject_200() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_createProject();
    
        AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
        request.siteId = td.site_1.Id;
        
        Test.startTest();
        // set success response 200
        AuroraProjectAPIMock.STATUS_CODE = AuroraProjectAPIMock.STATUS_CODE_200;
        AuroraProjectAPIMock.STATUS = AuroraProjectAPIMock.STATUS_200;
        AuroraProjectAPIMock.BODY = AuroraProjectAPIMock.BODY_200;

        Test.setMock(HttpCalloutMock.class, new AuroraProjectAPIMock());
        AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.createProject(request);
        Test.stopTest();
        
        system.assertEquals('db0791db-444c-44e5-b50c-e5e649118c0d', response.auroraProjectId);
    }

    private static testMethod void test_createProject_401() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_createProject();
    
        AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
        request.siteId = td.site_1.Id;
        
        Test.startTest();
        // set Unauthorized response 401
        AuroraProjectAPIMock.STATUS_CODE = AuroraProjectAPIMock.STATUS_CODE_401;
        AuroraProjectAPIMock.STATUS = AuroraProjectAPIMock.STATUS_401;
        AuroraProjectAPIMock.BODY = AuroraProjectAPIMock.BODY_401;

        Test.setMock(HttpCalloutMock.class, new AuroraProjectAPIMock());
        AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.createProject(request);
        Test.stopTest();
        
        system.assertEquals(true, String.IsBlank(response.auroraProjectId));
    }

    private static testMethod void test_createProject_siteId_required() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_createProject();
    
        AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
        AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.createProject(request);
        // error siteId parameter is required
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }

    private static testMethod void test_createProject_internalProjectId_exists() {
        AuroraProjectAPITestData td = new AuroraProjectAPITestData();
        td.createTestData_createProject_internalProjectId_exists();
    
        AuroraProjectAPI.CreateProjectRequest request = new AuroraProjectAPI.CreateProjectRequest();
        request.siteId = td.site_1.Id;
        AuroraProjectAPI.CreateProjectResponse response = AuroraProjectAPI.createProject(request);
        // error Site already has aurora internal project id
        system.assertEquals(true, response.errorMessageList.size() > 0);
    }
    
}