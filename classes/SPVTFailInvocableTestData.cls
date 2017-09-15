@isTest
public class SPVTFailInvocableTestData {

    public void createTestData() {
        SPVT_Settings__c s_1 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Account_Name', Value__c = 'Test Direct');    
        SPVT_Settings__c s_2 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Notification_Email', Value__c = 'test@sp.com');    
        SPVT_Settings__c s_3 = new SPVT_Settings__c(Name = 'SPVT_Fail_SPD_Notification_Name', Value__c = 'Test User');    
        SPVT_Settings__c s_4 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_OwnerId', Value__c = 'xxxxx');    
        SPVT_Settings__c s_5 = new SPVT_Settings__c(Name = 'SPVT_Fail_Case_RecordTypeId', Value__c = 'yyyyy');    
        insert new List <SPVT_Settings__c>{s_1, s_2, s_3, s_4, s_5};
        
    }
    
}