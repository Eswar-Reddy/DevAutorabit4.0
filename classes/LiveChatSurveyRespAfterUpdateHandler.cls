public without sharing class LiveChatSurveyRespAfterUpdateHandler extends TriggerHandlerBase {

    public LiveChatSurveyRespAfterUpdateHandler() {}
    
    private List<Live_Chat_Survey_Response__c> newLiveChatSurveyRespList;
    private List<Live_Chat_Survey_Response__c> oldLiveChatSurveyRespList;
    private Map<ID, Live_Chat_Survey_Response__c> newLiveChatSurveyRespMap;
    private Map<ID, Live_Chat_Survey_Response__c> oldLiveChatSurveyRespMap;
    private Map<Integer, Live_Chat_Survey_Response__c> qualifyLiveChatSurveyRespMap = new Map<Integer, Live_Chat_Survey_Response__c>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newLiveChatSurveyRespList = (List<Live_Chat_Survey_Response__c>)newList;
        oldLiveChatSurveyRespList = (List<Live_Chat_Survey_Response__c>)oldList;
        newLiveChatSurveyRespMap = (Map<ID, Live_Chat_Survey_Response__c>)newMap;
        oldLiveChatSurveyRespMap = (Map<ID, Live_Chat_Survey_Response__c>)oldMap;
        
    }
    
    public override void start() {
         
    }
    
    public override void finish(Boolean fromStart) { 

    }

}