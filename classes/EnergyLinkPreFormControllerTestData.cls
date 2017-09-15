@isTest
public class EnergyLinkPreFormControllerTestData {

    @TestVisible
    private void createTestData() {
    
        // custom settings
        Live_Agent_Settings__c s_1 = new Live_Agent_Settings__c(Name = 'consumerKey', Value__c = 'consumerKey_1');
        Live_Agent_Settings__c s_2 = new Live_Agent_Settings__c(Name = 'consumerSecret', Value__c = 'consumerSecret_1');
        Live_Agent_Settings__c s_3 = new Live_Agent_Settings__c(Name = 'userName', Value__c = 'userName_1');
        Live_Agent_Settings__c s_4 = new Live_Agent_Settings__c(Name = 'pwToken', Value__c = 'pwToken_1');
        Live_Agent_Settings__c s_5 = new Live_Agent_Settings__c(Name = 'showDebug', Value__c = 'true');
        Live_Agent_Settings__c s_6 = new Live_Agent_Settings__c(Name = 'deploymentHostName', Value__c = 'deploymentHostName_1');
        Live_Agent_Settings__c s_7 = new Live_Agent_Settings__c(Name = 'preChatHostName', Value__c = 'preChatHostName_1');
        Live_Agent_Settings__c s_8 = new Live_Agent_Settings__c(Name = 'liveAgentAPIEndpoint', Value__c = 'liveAgentAPIEndpoint_1');
        Live_Agent_Settings__c s_9 = new Live_Agent_Settings__c(Name = 'org_id', Value__c = 'org_id_1');
        insert new List <Live_Agent_Settings__c>{s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9};
    }
}