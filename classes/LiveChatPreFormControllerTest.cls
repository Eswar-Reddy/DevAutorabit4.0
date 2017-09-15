@isTest
public class LiveChatPreFormControllerTest {

    private static testMethod void test_load() {
        LiveChatPreFormControllerTestData td = new LiveChatPreFormControllerTestData();
        td.createTestData();
        
        LiveChatPreFormController controller = new LiveChatPreFormController();
        system.assertEquals('en-US', controller.language);    
    }
    
}