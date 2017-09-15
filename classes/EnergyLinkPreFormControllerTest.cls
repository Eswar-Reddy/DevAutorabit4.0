@isTest
public class EnergyLinkPreFormControllerTest {

    private static testMethod void test_customSetting() {
        EnergyLinkPreFormControllerTestData td = new EnergyLinkPreFormControllerTestData();
        td.createTestData();
        EnergyLinkPreFormController.CustomSetting cs = EnergyLinkPreFormController.getCustomSetting();
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
        EnergyLinkPreFormController.SessionIdRequest req = new EnergyLinkPreFormController.SessionIdRequest();
        req.consumerKey = 'consumerKey_1';
        req.consumerSecret = 'consumerSecret_1';
        req.userName = 'userName_1';
        req.pwToken = 'pwToken_1';
        EnergyLinkPreFormController.SessionIdResponse resp = EnergyLinkPreFormController.getSessionId(req);
        system.assertEquals(null, resp.errorMsg);
        system.assertEquals('access_token_1', resp.sessionId);
    }
    
    private static testMethod void test_buttonOffline() {
        Test.setMock(HttpCalloutMock.class, new LiveChatEnergyLinkMockButtonOffline());
        EnergyLinkPreFormController.ButtonAvailabilityRequest req = new EnergyLinkPreFormController.ButtonAvailabilityRequest();
        req.liveAgentAPIEndpoint = 'liveAgentAPIEndpoint_1';
        req.sessionId = 'sessionId_1';
        req.org_id = 'org_id_1';
        req.deployment_id = 'deployment_id_1';
        req.button_id = '57334000000GnMT';
        EnergyLinkPreFormController.ButtonAvailabilityResponse resp = EnergyLinkPreFormController.getButtonAvailability(req);
        system.assertEquals(null, resp.errorMsg);
        system.assertEquals(false, resp.isAvailable);
    }
    private static testMethod void test_buttonOnline() {
        Test.setMock(HttpCalloutMock.class, new LiveChatEnergyLinkMockButtonOnline());
        EnergyLinkPreFormController.ButtonAvailabilityRequest req = new EnergyLinkPreFormController.ButtonAvailabilityRequest();
        req.liveAgentAPIEndpoint = 'liveAgentAPIEndpoint_1';
        req.sessionId = 'sessionId_1';
        req.org_id = 'org_id_1';
        req.deployment_id = 'deployment_id_1';
        req.button_id = '57334000000GnMT';
        EnergyLinkPreFormController.ButtonAvailabilityResponse resp = EnergyLinkPreFormController.getButtonAvailability(req);
        system.assertEquals(null, resp.errorMsg);
        system.assertEquals(true, resp.isAvailable);
    }
    private static testMethod void test_setCustomDetails() {
        Test.setMock(HttpCalloutMock.class, new LiveChatMockButtonOfflineResponse());
        PageReference pr = Page.LiveChatOfflineForm;
        pr.getParameters().put('baseUrl', 'baseUrl_1');
        pr.getParameters().put('org_id', 'org_id_1');
        pr.getParameters().put('deployment_id', 'deployment_id_1');
        pr.getParameters().put('button_id', '57334000000GnMT');
        Test.setCurrentPage(pr);
        //Creating Test data for Custom Setting Live_Agent_Url_Configuration__c
        Live_Agent_Url_Configuration__c liveAgenCOnfigurationObject= new Live_Agent_Url_Configuration__c();
        liveAgenCOnfigurationObject.Name='Test Live Agent';
        liveAgenCOnfigurationObject.Url__c='https://d.la4-c2-chi.salesforceliveagent.com/chat';
        liveAgenCOnfigurationObject.buttonid__c='57334000000GnMT';
        liveAgenCOnfigurationObject.deploymentId__c='57234000000TNu2';
        insert liveAgenCOnfigurationObject;
    
        
        EnergyLinkPreFormController controller = new EnergyLinkPreFormController();
        controller.setSessionId('sessionId_1');
        controller.setCustomDetails();
    }
    
}