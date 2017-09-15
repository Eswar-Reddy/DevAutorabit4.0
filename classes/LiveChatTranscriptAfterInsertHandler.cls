public without sharing class LiveChatTranscriptAfterInsertHandler extends TriggerHandlerBase {

    public LiveChatTranscriptAfterInsertHandler() {}
    
    private Map<ID, LiveChatTranscript> oldLiveChatTranscriptMap;
    private Map<ID, LiveChatTranscript> newLiveChatTranscriptMap;
    private List<LiveChatTranscript> newLiveChatTranscriptList;
    private List<LiveChatTranscript> oldLiveChatTranscriptList;
    private Map<Integer,LiveChatTranscript>  qualifyChatsMap = new Map<Integer,LiveChatTranscript>();
    
    private Set<String> chatKeySet = new Set <String>();
    private List <Live_Chat_Survey_Response__c> respListUpdate = new List <Live_Chat_Survey_Response__c>();
 
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)newMap;
        oldLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)oldMap;
        newLiveChatTranscriptList = (List<LiveChatTranscript>)newList;
        oldLiveChatTranscriptList = (List<LiveChatTranscript>)oldList;
        
        for (Integer i=0; i<newLiveChatTranscriptList.size(); i++) {
            LiveChatTranscript transcript = newLiveChatTranscriptList[i];
            
            if(transcript.ChatKey != null){
                qualifyChatsMap.put(i,transcript);
                chatKeySet.add(transcript.chatKey);
            }
        }    
    }
        
    public override void start() {

        if (chatKeySet.size() > 0) {
            Map<String, List <Live_Chat_Survey_Response__c>> chatKey_responses_Map = new Map<String, List <Live_Chat_Survey_Response__c>>();
            List <Live_Chat_Survey_Response__c> respList = [SELECT Id, Name, ChatKey__c, Live_Chat_Transcript__c
                FROM Live_Chat_Survey_Response__c
                WHERE ChatKey__c IN :chatKeySet];
            for(Live_Chat_Survey_Response__c resp : respList) {
                if (resp.ChatKey__c != null) {
                    List <Live_Chat_Survey_Response__c> responses = new List <Live_Chat_Survey_Response__c>();
                    if (chatKey_responses_Map.containsKey(resp.ChatKey__c)) {
                        responses = chatKey_responses_Map.get(resp.ChatKey__c);
                    }
                    responses.add(resp);
                    chatKey_responses_Map.put(resp.ChatKey__c, responses);
                }
                
            }            

            for(Integer i : qualifyChatsMap.keySet()) {
                LiveChatTranscript transcript = qualifyChatsMap.get(i); 
                if (transcript.ChatKey != null && chatKey_responses_Map.containsKey(transcript.ChatKey)) {
                    List <Live_Chat_Survey_Response__c> responses = chatKey_responses_Map.get(transcript.ChatKey);
                    for (Live_Chat_Survey_Response__c resp : responses) {
                        if (resp.Live_Chat_Transcript__c != transcript.Id) {
                            resp.Live_Chat_Transcript__c = transcript.Id; 
                            respListUpdate.add(resp);
                        }               
                    } 
                }
            }
        }
         
    }
    
    public override void finish(Boolean fromStart) { 
         if (respListUpdate.size() > 0) {
            Database.SaveResult[] srList = Database.update(respListUpdate, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    System.debug('Successfully updated record id: ' + sr.getId());
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields that affected this error: ' + err.getFields());
                    }
                }
            }        
        }
    }

}