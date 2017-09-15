@isTest
public class LiveChatOfflineControllerTest {

    private static testMethod void test_customSetting() {
        LiveChatOfflineControllerTestData td = new LiveChatOfflineControllerTestData();
        td.createTestData_customSetting();
        
        LiveChatOfflineController.CustomSetting cs = LiveChatOfflineController.getCustomSetting();

        system.assertEquals('consumerKey_1', cs.consumerKey);
        system.assertEquals('consumerSecret_1', cs.consumerSecret);
        system.assertEquals('userName_1', cs.userName);
        system.assertEquals('pwToken_1', cs.pwToken);
        system.assertEquals(true, cs.showDebug);
        system.assertEquals('deploymentHostName_1', cs.deploymentHostName);
        system.assertEquals('preChatHostName_1', cs.preChatHostName);
        system.assertEquals('liveAgentAPIEndpoint_1', cs.liveAgentAPIEndpoint);
        system.assertEquals('org_id_1', cs.org_id);
    }

    private static testMethod void test_getSessionId() {
        Test.setMock(HttpCalloutMock.class, new LiveChatMockSessionIdResponse());
        
        LiveChatOfflineController.SessionIdRequest req = new LiveChatOfflineController.SessionIdRequest();
        req.consumerKey = 'consumerKey_1';
        req.consumerSecret = 'consumerSecret_1';
        req.userName = 'userName_1';
        req.pwToken = 'pwToken_1';
        
        LiveChatOfflineController.SessionIdResponse resp = LiveChatOfflineController.getSessionId(req);

        system.assertEquals(null, resp.errorMsg);
        system.assertEquals('access_token_1', resp.sessionId);
    }

    private static testMethod void test_buttonOffline() {
        Test.setMock(HttpCalloutMock.class, new LiveChatMockButtonOfflineResponse());
        
        LiveChatOfflineController.ButtonAvailabilityRequest req = new LiveChatOfflineController.ButtonAvailabilityRequest();
        req.liveAgentAPIEndpoint = 'liveAgentAPIEndpoint_1';
        req.sessionId = 'sessionId_1';
        req.org_id = 'org_id_1';
        req.deployment_id = 'deployment_id_1';
        req.button_id = '57354000000006d';
        
        LiveChatOfflineController.ButtonAvailabilityResponse resp = LiveChatOfflineController.getButtonAvailability(req);

        system.assertEquals(null, resp.errorMsg);
        system.assertEquals(false, resp.isAvailable);
    }

    private static testMethod void test_buttonOnline() {
        Test.setMock(HttpCalloutMock.class, new LiveChatMockButtonOnlineResponse());
        
        LiveChatOfflineController.ButtonAvailabilityRequest req = new LiveChatOfflineController.ButtonAvailabilityRequest();
        req.liveAgentAPIEndpoint = 'liveAgentAPIEndpoint_1';
        req.sessionId = 'sessionId_1';
        req.org_id = 'org_id_1';
        req.deployment_id = 'deployment_id_1';
        req.button_id = '57354000000006d';
        
        LiveChatOfflineController.ButtonAvailabilityResponse resp = LiveChatOfflineController.getButtonAvailability(req);

        system.assertEquals(null, resp.errorMsg);
        system.assertEquals(true, resp.isAvailable);
    }

    private static testMethod void test_setCustomDetails() {
        Test.setMock(HttpCalloutMock.class, new LiveChatMockButtonOfflineResponse());
        
        PageReference pr = Page.LiveChatOfflineForm;
        pr.getParameters().put('baseUrl', 'baseUrl_1');
        pr.getParameters().put('org_id', 'org_id_1');
        pr.getParameters().put('deployment_id', 'deployment_id_1');
        pr.getParameters().put('button_id', '57354000000006d');
        Test.setCurrentPage(pr);
        
        LiveChatOfflineController controller = new LiveChatOfflineController();
        controller.setSessionId('sessionId_1');
        controller.setCustomDetails();
        
    }

}