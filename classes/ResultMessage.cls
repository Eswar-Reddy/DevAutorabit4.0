global with sharing class ResultMessage {
  global Boolean success          {get; set;}
  global String message           {get; set;}
  global List<Object> payload     {get; set;}
  global Map<String, Object> payloadMap   {get; set;}
  global List<SpectrumDebugUtility.debugLog> logs {get; set;}
  global Object err {get;set;}
  global HttpResponse calloutResponse {get;set;}
  global List<Exception_Log__c> exceptionLogs {get;set;}


  global ResultMessage() {
    payload = new List<Object>();
    payloadMap = new Map<String, Object>();
    logs = new List<SpectrumDebugUtility.debugLog>();
    exceptionLogs = new List<Exception_Log__c>();
  }

  global ResultMessage(Boolean r, String m) {
    payload = new List<Object>();
    payloadMap = new Map<String, Object>();
    logs = new List<SpectrumDebugUtility.debugLog>();
    success = r;
    message = m;
  }
}