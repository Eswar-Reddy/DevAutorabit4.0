public without sharing class LiveChatSurveyRespBeforeInsertHandler extends TriggerHandlerBase {

    public LiveChatSurveyRespBeforeInsertHandler() {}
    
    private List<Live_Chat_Survey_Response__c> newLiveChatSurveyRespList;
    private List<Live_Chat_Survey_Response__c> oldLiveChatSurveyRespList;
    private Map<ID, Live_Chat_Survey_Response__c> newLiveChatSurveyRespMap;
    private Map<ID, Live_Chat_Survey_Response__c> oldLiveChatSurveyRespMap;
    private Map<Integer, Live_Chat_Survey_Response__c> qualifyLiveChatSurveyRespMap = new Map<Integer, Live_Chat_Survey_Response__c>();

    private Set<String> chatKeySet = new Set <String>();
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newLiveChatSurveyRespList = (List<Live_Chat_Survey_Response__c>)newList;
        oldLiveChatSurveyRespList = (List<Live_Chat_Survey_Response__c>)oldList;
        newLiveChatSurveyRespMap = (Map<ID, Live_Chat_Survey_Response__c>)newMap;
        oldLiveChatSurveyRespMap = (Map<ID, Live_Chat_Survey_Response__c>)oldMap;
        
        for (Integer i=0; i<newLiveChatSurveyRespList.size(); i++) {
            Live_Chat_Survey_Response__c response = newLiveChatSurveyRespList[i];
            
            if(response.ChatKey__c != null){
                qualifyLiveChatSurveyRespMap.put(i,response);
                chatKeySet.add(response.ChatKey__c);
            }
        }    
        
    }
    
    public override void start() {
        if (chatKeySet.size() > 0) {
            Map <String, LiveChatTranscript> chatKey_transcript_map = new Map <String, LiveChatTranscript>();
            for (LiveChatTranscript transcript : [SELECT Id, ChatKey FROM LiveChatTranscript WHERE ChatKey IN :chatKeySet]) {
                if (transcript.ChatKey != null) {
                    chatKey_transcript_map.put(transcript.ChatKey, transcript);
                }
            }        
            for (Integer i : qualifyLiveChatSurveyRespMap.keySet()) {
                Live_Chat_Survey_Response__c response = qualifyLiveChatSurveyRespMap.get(i);
                if (response.ChatKey__c != null && chatKey_transcript_map.containsKey(response.ChatKey__c)) {
                    response.Live_Chat_Transcript__c = chatKey_transcript_map.get(response.ChatKey__c).Id;
                }
            }        
        }         
    }
    
    public override void finish(Boolean fromStart) { 

    }

}