public without sharing class SpectrumDebugUtility {

    public static void generateDebugLog(List<debugLog> logs){
        List<Sunpower_Spectrum_Debug_Log__c> logsToInsert = new List<Sunpower_Spectrum_Debug_Log__c>();

        for(debugLog l : logs){
            Sunpower_Spectrum_Debug_Log__c log = createLog(l);
            logsToInsert.add(log);
        }
        try {
            insert logsToInsert;
        } catch (Exception e) {}
    }

    public static void generateDebugLog(debugLog l){
        Sunpower_Spectrum_Debug_Log__c log = createLog(l);
        try {
            insert log;
        } catch (Exception e) {}
    }

    public static void generateDebugLog(String log){
        // check context so insert doesn't interfere with callouts
        if(System.isFuture()) {
            debugLog l = (debugLog)JSON.deserialize(log, debugLog.class);
            Sunpower_Spectrum_Debug_Log__c sslog = createLog(l);
            try {
                insert sslog;
            } catch (Exception e) {}
        } else insertDebugLog(log);
    }

	public static void generateDebugLog(String service, String jsonPayload, String response) {
		debugLog l = new debugLog();
		l.service = service;
		l.jsonPayload = jsonPayload;
		l.response = response;
		if(System.isFuture()) {
			Sunpower_Spectrum_Debug_Log__c sslog = createLog(l);
			try {
				insert sslog;
			} catch (Exception e) {}
		} else insertDebugLog(JSON.serialize(l));
    }
	
    @future
    private static void insertDebugLog(String log){
        debugLog l = (debugLog)JSON.deserialize(log, debugLog.class);
        Sunpower_Spectrum_Debug_Log__c sslog = createLog(l);
        try {
            insert sslog;
        } catch (Exception e) {}
    }

    private static Sunpower_Spectrum_Debug_Log__c createLog(debugLog l) {
        Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
        log.JSON_Payload__c = l.jsonPayload != null && l.jsonPayload.length() > 131072 ? l.jsonPayload.left(131071) : l.jsonPayload;
        log.Opportunity__c = l.opportunityId;
        log.Quote__c = l.quoteId;
        log.Exception_log__c=l.exceptionID;
        log.Account__c = l.accountId;
        log.Agreement__c = l.agreementId;
        log.Service__c = l.service;
        log.Response__c = l.jsonPayload != null && l.response.length() > 131072 ? l.response.left(131071) : l.response;
        log.LeadId__c = l.LeadID;
        log.Response_Status_Code__c = l.ResponseCode;
        log.Contact__c = l.ContactId;
        log.Purchase_Order__c = l.purchaseOrderId;

        return log;
    }

    public static void createExceptionLogs(List<Database.SaveResult> saveResults, String errorMessage, Schema.sObjectType soType){
        List<Exception_log__c> exceptionLogs = new List<Exception_log__c>();
        Exception_log__c exceptionLog = new Exception_Log__c();
        for(Database.SaveResult sr : saveResults){
            if(!sr.isSuccess()){
                String errorMsg = '';
                String errorCds = '';
                exceptionLog = new Exception_log__c();
                if(soType != null){
                    if(soType.getDescribe().getName() == 'Quote'){
                         exceptionLog.Quote__c = sr.getId();
                    } else if(soType.getDescribe().getName() == 'Account'){
                        exceptionLog.Account_Id__c = sr.getId();
                    } else if(soType.getDescribe().getName() == 'Opportunity'){
                        exceptionLog.Opportunity_Id__c = sr.getId();
                    } else if(soType.getDescribe().getName() == 'echosign_dev1__SIGN_Agreement__c '){
                        exceptionLog.Agreement__c  = sr.getId();
                    } else if(soType.getDescribe().getName() == 'Purchase Order'){
                        exceptionLog.Purchase_Order__c  = sr.getId();
                    }
                }

                for(Database.Error error : sr.getErrors()) {
                    errorMsg += error.getMessage();
                    errorCds += error.getStatusCode();
                }
                exceptionLog.Error_Message__c = 'The error '+ errorMsg + ' happened while' + errorMessage;
                exceptionLogs.add(exceptionLog);
            }

        }
        if(exceptionLogs != null){
            try {
                insert exceptionLogs;
            } catch (Exception e) {}
        }
    }

    public static void createExceptionLog(String errorMessage, String stackTrace, String type){
        if(System.isFuture()) {
            Exception_log__c log = new Exception_Log__c();
            log.Error_Message__c = errorMessage;
            log.Stack_Trace__c = stackTrace;
            log.Type__c = type;

            try {
                insert log;
            } catch (Exception e) {}
        } else insertExceptionLog(errorMessage, stackTrace, type);
    }

    public static void createExceptionLog(String errorMessage, String stackTrace, String type, Id objId) {
        if(System.isFuture()) {
            Schema.SObjectType soType = objId.getSobjectType();
            Exception_log__c log = new Exception_Log__c();
            log.Error_Message__c = errorMessage;
            log.Stack_Trace__c = stackTrace;
            log.Type__c = type;

            if(soType != null){
                if(soType.getDescribe().getName() == 'Purchase_Order__c'){
                    log.Purchase_Order__c = objId;
                } else if(soType.getDescribe().getName() == 'Account'){
                    log.Account_Id__c = objId;
                } else if(soType.getDescribe().getName() == 'Opportunity'){
                    log.Opportunity_Id__c = objId;
                } else if(soType.getDescribe().getName() == 'echosign_dev1__SIGN_Agreement__c'){
                    log.Agreement__c  = objId;
                } else if(soType.getDescribe().getName() == 'Quote'){
                    log.Quote__c  = objId;
                }
            }
            try {
                insert log;
            } catch (Exception e) {}
        } else insertExceptionLog(errorMessage, stackTrace, type, objId);
    }

    @future
    private static void insertExceptionLog(String errorMessage, String stackTrace, String type) {
        Exception_log__c log = new Exception_Log__c();
        log.Error_Message__c = errorMessage;
        log.Stack_Trace__c = stackTrace;
        log.Type__c = type;

        try {
            insert log;
        } catch (Exception e) {}
    }

    @future
    private static void insertExceptionLog(String errorMessage, String stackTrace, String type, Id objId) {
        Schema.SObjectType soType = objId.getSobjectType();
        Exception_log__c log = new Exception_Log__c();
        log.Error_Message__c = errorMessage;
        log.Stack_Trace__c = stackTrace;
        log.Type__c = type;

        if(soType != null){
            if(soType.getDescribe().getName() == 'Purchase_Order__c'){
                log.Purchase_Order__c = objId;
            } else if(soType.getDescribe().getName() == 'Account'){
                log.Account_Id__c = objId;
            } else if(soType.getDescribe().getName() == 'Opportunity'){
                log.Opportunity_Id__c = objId;
            } else if(soType.getDescribe().getName() == 'echosign_dev1__SIGN_Agreement__c'){
                log.Agreement__c  = objId;
            } else if(soType.getDescribe().getName() == 'Quote'){
                log.Quote__c  = objId;
            }
        }
        try {
            insert log;
        } catch (Exception e) {}
    }

    public class debugLog{
        public Id opportunityId {get;set;}
        public Id quoteId {get;set;}
        public Id accountId {get;set;}
        public Id exceptionId {get;set;}
        public Id agreementId {get;set;}
        public String jsonPayload {get;set;}
        public String service {get;set;}
        public String response {get;set;}
        public String leadID {get;set;}
        public Integer responseCode {get;set;}
        public Blob responseBlob {get;set;}
        public Id contactId {get;set;}
        public Id purchaseOrderId {get;set;}

        public debugLog(){

        }
    }
}