@isTest
public class LiveChatTranscriptTestData {

    @TestVisible LiveChatVisitor visitor_1;

    @TestVisible
    private void create_TestData() {

        visitor_1 = getNewLiveChatVisitor();
        insert new List <LiveChatVisitor>{visitor_1};
    }
    
    @TestVisible
    private static Live_Chat_Survey_Response__c getNewLiveChatSurveyResponse(String chatKey) {
        Live_Chat_Survey_Response__c response = new Live_Chat_Survey_Response__c();
        response.ChatKey__c = chatKey;
        return response;        
    }
    
    @TestVisible
    private static LiveChatTranscript getNewLiveChatTranscript(String visitorId, String chatKey) {
        LiveChatTranscript transcript = new LiveChatTranscript();
        transcript.LiveChatVisitorId = visitorId;
        transcript.ChatKey = chatKey;
        return transcript;
    }

    private static LiveChatVisitor getNewLiveChatVisitor() {
        LiveChatVisitor visitor = new LiveChatVisitor();
        return visitor;
    }
    
    @TestVisible
    private static Case getNewCase(String categories, String SubCategories) {
        Case c = new Case();    
        c.Categories__c = categories;
        c.Sub_Categories__c = SubCategories;
        return c;    
    }
    
}