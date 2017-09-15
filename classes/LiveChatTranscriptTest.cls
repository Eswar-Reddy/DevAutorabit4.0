@isTest
public class LiveChatTranscriptTest {

    private static testMethod void test_insertTranscriptAfterCase() {
        LiveChatTranscriptTestData td = new LiveChatTranscriptTestData();
        td.create_TestData();

        Case case_1 = LiveChatTranscriptTestData.getNewCase('categories_1', 'sub_categories_1');
        insert new List <Case>{case_1};

        LiveChatTranscript transcript_1 = LiveChatTranscriptTestData.getNewLiveChatTranscript(td.visitor_1.Id, 'response_1');
        transcript_1.CaseId = case_1.Id; 
        insert new List <LiveChatTranscript>{transcript_1};
           
        transcript_1 = [SELECT Categories__c, Sub_Categories__c FROM LiveChatTranscript WHERE Id = :transcript_1.Id];
        system.assertEquals('categories_1', transcript_1.Categories__c);
        system.assertEquals('sub_categories_1', transcript_1.Sub_Categories__c);
        
    }

    private static testMethod void test_updateTranscriptAfterCase() {
        LiveChatTranscriptTestData td = new LiveChatTranscriptTestData();
        td.create_TestData();

        Case case_1 = LiveChatTranscriptTestData.getNewCase('categories_1', 'sub_categories_1');
        insert new List <Case>{case_1};

        LiveChatTranscript transcript_1 = LiveChatTranscriptTestData.getNewLiveChatTranscript(td.visitor_1.Id, 'response_1');
        insert new List <LiveChatTranscript>{transcript_1};
           
        transcript_1.CaseId = case_1.Id; 
        update transcript_1;
        
        transcript_1 = [SELECT Categories__c, Sub_Categories__c FROM LiveChatTranscript WHERE Id = :transcript_1.Id];
        system.assertEquals('categories_1', transcript_1.Categories__c);
        system.assertEquals('sub_categories_1', transcript_1.Sub_Categories__c);
        
    }

    private static testMethod void test_insertTranscriptAfterResponse() {
        LiveChatTranscriptTestData td = new LiveChatTranscriptTestData();
        td.create_TestData();
        
        Live_Chat_Survey_Response__c response_1 = LiveChatTranscriptTestData.getNewLiveChatSurveyResponse('response_1');
        response_1.ChatKey__c = 'chatKey_1';
        insert new List <Live_Chat_Survey_Response__c>{response_1};

        LiveChatTranscript transcript_1 = LiveChatTranscriptTestData.getNewLiveChatTranscript(td.visitor_1.Id, 'chatKey_1');
        insert new List <LiveChatTranscript>{transcript_1};
        
        response_1 = [SELECT Live_Chat_Transcript__c FROM Live_Chat_Survey_Response__c WHERE Id = :response_1.Id];
        system.assertEquals(transcript_1.Id, response_1.Live_Chat_Transcript__c);
    }

    private static testMethod void test_insertResponseAfterTranscript() {
        LiveChatTranscriptTestData td = new LiveChatTranscriptTestData();
        td.create_TestData();
        
        LiveChatTranscript transcript_1 = LiveChatTranscriptTestData.getNewLiveChatTranscript(td.visitor_1.Id, 'chatKey_1');
        insert new List <LiveChatTranscript>{transcript_1};

        Live_Chat_Survey_Response__c response_1 = LiveChatTranscriptTestData.getNewLiveChatSurveyResponse('response_1');
        response_1.ChatKey__c = 'chatKey_1';
        insert new List <Live_Chat_Survey_Response__c>{response_1};
        
        response_1 = [SELECT Live_Chat_Transcript__c FROM Live_Chat_Survey_Response__c WHERE Id = :response_1.Id];
        system.assertEquals(transcript_1.Id, response_1.Live_Chat_Transcript__c);
    }

}