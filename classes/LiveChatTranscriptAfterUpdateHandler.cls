public without sharing class LiveChatTranscriptAfterUpdateHandler extends TriggerHandlerBase {

    public LiveChatTranscriptAfterUpdateHandler() {}
    
    private Map<ID, LiveChatTranscript> oldLiveChatTranscriptMap;
    private Map<ID, LiveChatTranscript> newLiveChatTranscriptMap;
    private List<LiveChatTranscript> newLiveChatTranscriptList;
    private List<LiveChatTranscript> oldLiveChatTranscriptList;
    private Map<Integer,LiveChatTranscript>  qualifyChatsMap = new Map<Integer,LiveChatTranscript>();
 
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)newMap;
        oldLiveChatTranscriptMap = (Map<ID, LiveChatTranscript>)oldMap;
        newLiveChatTranscriptList = (List<LiveChatTranscript>)newList;
        oldLiveChatTranscriptList = (List<LiveChatTranscript>)oldList;
        
    }
    
    
    public override void start() {
         
    }
    
    public override void finish(Boolean fromStart) { 

    }

}