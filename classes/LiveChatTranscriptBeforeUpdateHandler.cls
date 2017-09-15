public without sharing class LiveChatTranscriptBeforeUpdateHandler extends TriggerHandlerBase {

    public LiveChatTranscriptBeforeUpdateHandler() {}
    
    private Map<ID, LiveChatTranscript> oldLiveChatTranscriptMap;
    private Map<ID, LiveChatTranscript> newLiveChatTranscriptMap;
    private List<LiveChatTranscript> newLiveChatTranscriptList;
    private List<LiveChatTranscript> oldLiveChatTranscriptList;
    private Map<Integer,LiveChatTranscript> qualifyChatsMap = new Map<Integer,LiveChatTranscript>();
    
    private Set <String> caseIdSet = new Set <String>();
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)newMap;
        oldLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)oldMap;
        newLiveChatTranscriptList = (List<LiveChatTranscript>)newList;
        oldLiveChatTranscriptList = (List<LiveChatTranscript>)oldList;
        
        for (Integer i=0; i<newLiveChatTranscriptList.size(); i++) {
            LiveChatTranscript transcript = newLiveChatTranscriptList[i];
            if (transcript.CaseId != null) {
                qualifyChatsMap.put(i, transcript);
                caseIdSet.add(transcript.CaseId);
            }
        }    
    }
    
    
    public override void start() {
        Map<String, Case> caseMap = new Map<String, Case>();
        
        if (caseIdSet.size() > 0) {
             caseMap = new Map <String, Case>([SELECT Id, Categories__c, Sub_Categories__c FROM Case WHERE Id IN :caseIdSet]);
        }
        for (Integer i: qualifyChatsMap.keySet()) {
                LiveChatTranscript transcript = qualifyChatsMap.get(i);
                if(transcript.CaseId != null && caseMap != null && caseMap.containsKey(transcript.CaseId)) {
                    Case c = caseMap.get(transcript.CaseId);
                    transcript.Categories__c = c.Categories__c;
                    transcript.Sub_Categories__c = c.Sub_Categories__c;
                }
                
         }
         
    }
    
    public override void finish(Boolean fromStart) { 
    
    }

}