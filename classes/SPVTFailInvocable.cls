public class SPVTFailInvocable {
    
    @InvocableMethod(label='Get Settings')
    public static List <Response> getSettings(List <Request> requestList) {
        List <Response> responseList = new List <Response>();
        
        SettingsWrapper wrpr = loadCustomSettings();
        
        for (Request req : requestList) {
            Response res = new Response();
            
            res.spdAccountName = wrpr.spdAccountName;
            res.spdNotificationEmail = wrpr.spdNotificationEmail;
            res.spdNotificationName = wrpr.spdNotificationName;
            res.caseOwnerId = wrpr.caseOwnerId;
            res.caseRecordTypeId = wrpr.caseRecordTypeId;
            
            responseList.add(res);
        }
                
        return responseList;    
    }
    
    private static SettingsWrapper loadCustomSettings() {
        SettingsWrapper wrpr = new SettingsWrapper(); 
        
        List <SPVT_Settings__c> settingList = [SELECT Name, Value__c FROM SPVT_Settings__c];   
        for (SPVT_Settings__c setting : settingList) {    
            if (String.IsNotBlank(setting.Value__c)) {
                if (setting.Name.equalsIgnoreCase('SPVT_Fail_SPD_Account_Name')) {
                    wrpr.spdAccountName = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_SPD_Notification_Email')) {
                    wrpr.spdNotificationEmail = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_SPD_Notification_Name')) {
                    wrpr.spdNotificationName = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_Case_OwnerId')) {
                    wrpr.caseOwnerId = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_Case_RecordTypeId')) {
                    wrpr.caseRecordTypeId = setting.Value__c;
                }
            }    
        }
        
        return wrpr;
    }
    
    public class Request {
        @InvocableVariable public String leasePaymentId;
    }
    
    public class Response {
        @InvocableVariable public String spdAccountName;
        @InvocableVariable public String spdNotificationEmail;
        @InvocableVariable public String spdNotificationName;
        @InvocableVariable public String caseRecordTypeId;
        @InvocableVariable public String caseOwnerId;
        
        public Response() {}
    }
    
    private class SettingsWrapper {
        private String spdAccountName;
        private String spdNotificationEmail;
        private String spdNotificationName;
        private String caseRecordTypeId;
        private String caseOwnerId;
        
        private SettingsWrapper() {
            // default values
            spdAccountName = 'SunPower Direct (SPD)';
            spdNotificationEmail = 'trevor.williams@sunpower.com';
            spdNotificationName = 'Trevor Williams';
            caseRecordTypeId = '01280000000379u';    // System Design Case
            caseOwnerId = '00G80000002g67g';    // NA DSE Queue
        }
    }

}