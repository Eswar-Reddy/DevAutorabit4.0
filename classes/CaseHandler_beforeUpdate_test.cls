@isTest
public class CaseHandler_beforeUpdate_test {
    private static testMethod void europe_psr_to_tsr() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('Europe');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User psrUser, tsrUser;
        system.runAs(myUser) {
            psrUser = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Partner Support Representative');        
            tsrUser = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Technical Services Engineer');        
            insert new List <User>{psrUser, tsrUser};
        }
        
        String PSR_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSR Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, psrUser.Id);
        case_1.RecordTypeId = PSR_RT_ID;
        insert new List <Case>{case_1};
        case_1.OwnerId = tsrUser.Id;
        update case_1;
        
        system.assertEquals(PSR_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

    private static testMethod void europe_tsr_to_psr() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('Europe');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User psrUser, tsrUser;
        system.runAs(myUser) {
            psrUser = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Partner Support Representative');        
            tsrUser = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Technical Services Engineer');        
            insert new List <User>{psrUser, tsrUser};
        }
        
        String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, tsrUser.Id);
        case_1.RecordTypeId = TS_RT_ID;
        case_1.Categories__c = 'category_1';    // validation: You must enter a value for Categories
        insert new List <Case>{case_1};
        case_1.OwnerId = psrUser.Id;
        update case_1;
        
        system.assertEquals(TS_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

    private static testMethod void europe_other() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('Europe');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user_1, user_2;
        system.runAs(myUser) {
            user_1 = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Role 1');        
            user_2 = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Role 2');        
            insert new List <User>{user_1, user_2};
        }
        
        String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, user_1.Id);
        case_1.RecordTypeId = TS_RT_ID;
        case_1.Categories__c = 'category_1';    // validation: You must enter a value for Categories
        insert new List <Case>{case_1};
        case_1.OwnerId = user_2.Id;
        update case_1;
        
        system.assertEquals(TS_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

    private static testMethod void non_europe_psr_to_tsr() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('North America');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User psrUser, tsrUser;
        system.runAs(myUser) {
            psrUser = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Partner Support Representative');        
            tsrUser = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Technical Services Engineer');        
            insert new List <User>{psrUser, tsrUser};
        }
        
        String PSR_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSR Case').getRecordTypeId();
        String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, psrUser.Id);
        case_1.RecordTypeId = PSR_RT_ID;
        insert new List <Case>{case_1};
        case_1.OwnerId = tsrUser.Id;
        case_1.Categories__c = 'category_1';    // validation: You must enter a value for Categories
        update case_1;
        
        //system.assertEquals(TS_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

    private static testMethod void non_europe_tsr_to_psr() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('North America');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User psrUser, tsrUser;
        system.runAs(myUser) {
            psrUser = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Partner Support Representative');        
            tsrUser = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Technical Services Engineer');        
            insert new List <User>{psrUser, tsrUser};
        }
        
        String PSR_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSR Case').getRecordTypeId();
        String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, tsrUser.Id);
        case_1.RecordTypeId = TS_RT_ID;
        case_1.Categories__c = 'category_1';    // validation: You must enter a value for Categories
        insert new List <Case>{case_1};
        case_1.OwnerId = psrUser.Id;
        update case_1;
        
        //system.assertEquals(PSR_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

    private static testMethod void non_europe_other() {
        Account account_1 = CaseHandler_beforeUpdate_testData.getNewAccount('North America');    
        insert new List <Account>{account_1};

        User myUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User user_1, user_2;
        system.runAs(myUser) {
            user_1 = CaseHandler_beforeUpdate_testData.getNewUser('psrUser@sp.com', 'Standard User', 'Role 1');        
            user_2 = CaseHandler_beforeUpdate_testData.getNewUser('tsrUser@sp.com', 'Standard User', 'Role 2');        
            insert new List <User>{user_1, user_2};
        }
        
        String PSR_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSR Case').getRecordTypeId();
        String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
        Case case_1 = CaseHandler_beforeUpdate_testData.getNewCase(account_1.Id, user_1.Id);
        case_1.RecordTypeId = TS_RT_ID;
        case_1.Categories__c = 'category_1';    // validation: You must enter a value for Categories
        insert new List <Case>{case_1};
        case_1.OwnerId = user_2.Id;
        update case_1;
        
        system.assertEquals(TS_RT_ID, [SELECT RecordTypeId FROM Case WHERE Id = :case_1.Id].RecordTypeId);
                
    }

}