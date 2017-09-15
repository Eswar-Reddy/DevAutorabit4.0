global with sharing class AngularUtilities {

    public AngularUtilities() {
        
    }

    public AngularUtilities(StatementOfAccounts controller) {

    }

    @RemoteAction
    global static ResultMessage getPartners() {
        try {
            Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('Partners', [SELECT Oracle_Account_Number__c, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE RecordTypeId =:recTypeId ORDER BY Name, BillingCountry, BillingState, BillingCity]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getSalesforceAccountId(String oracleAccountNumber) {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('SalesforeAccountId', [SELECT Id FROM Account WHERE Oracle_Account_Number__c =:oracleAccountNumber LIMIT 1]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static ResultMessage getPartnerInfo() {
        try {
            ResultMessage result = new ResultMessage(true, 'intializing');
            result.payloadMap.put('Partner', [Select Contact.Account.Oracle_Account_Number__c, Contact.Account.Partner_Opt_Out_Ok_To_Ship__c FROM User Where ID =: UserInfo.getUserId() LIMIT 1]);
            return result;
        }
        catch (Exception e) {
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    public static void generateLogging(String service, String outboundReq, String inboundRes, String sfAccountId) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;
            if(String.isNotBlank(sfAccountId))
                log.Partner_Account__c = sfAccountId;

            insert log;
        } catch (Exception e) {}
    }

    public static void generateLogging(String service, String outboundReq, String inboundRes) {
        try {
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.JSON_Payload__c = outboundReq.length() > 131072 ? outboundReq.left(131071) : outboundReq;
            log.Response__c = inboundRes.length() > 131072 ? inboundRes.left(131071) : inboundRes;
            log.Service__c = service;

            insert log;
        } catch (Exception e) {}
    }
}