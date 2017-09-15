public class CaseHandler_beforeUpdate {

    // Nathan 12/16/2015
    // case 00628933 Prevent Case record Type change on EMEA case owner change
    public static void updatecaseRecordType(Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        if (newMap != null && oldMap != null) {
            Set <Id> ownerIdSet = new Set <Id>();
            Map <Id, User> userMap = new Map <Id, User>();
            Set <Id> accountIdSet = new Set <Id>();
            Map <Id, Account> accountMap = new Map <Id, Account>();
            List <Case> caseListOwnerChanged = new List <Case>();
            String PSR_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PSR Case').getRecordTypeId();
            String TS_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Support Case').getRecordTypeId();
            
            for (Case newCase : newMap.values()) {
                if (newCase.Id != null && oldMap.containsKey(newCase.Id)) {
                    Case oldCase = oldMap.get(newCase.Id);
                    if (newCase.OwnerId != oldCase.OwnerId) {
                        caseListOwnerChanged.add(newCase);
                        if (newCase.OwnerId != null) {
                            ownerIdSet.add(newCase.OwnerId);
                        }
                        if (newCase.AccountId != null) {
                            accountIdSet.add(newCase.AccountId);
                        }
                    }
                }
            }
            if (ownerIdSet.size() > 0) {
                for (User u : [SELECT Id, Role_text__c FROM User WHERE Id IN :ownerIdSet]) {
                    userMap.put(u.Id, u);
                }
            }
            if (accountIdSet.size() > 0) {
                for (Account a : [SELECT Id, Theater__c FROM Account WHERE Id IN :accountIdSet]) {
                    accountMap.put(a.Id, a);
                }
            }

            for (Case newCase : caseListOwnerChanged) {
                if (newCase.AccountId != null && accountMap.containsKey(newCase.AccountId)) {
                    Account acc = accountMap.get(newCase.AccountId);
                    if (acc.Theater__c == 'Europe' || acc.Theater__c == 'Middle East and Africa') {
                        continue;
                    }
                }
                if (newCase.OwnerId != null && userMap.containsKey(newCase.OwnerId)) {
                    User usr = userMap.get(newCase.OwnerId);
                    if (usr.Role_text__c == 'Partner Support Representative' || usr.Role_text__c == 'Partner Support Representative Team Lead') {
                        newCase.RecordTypeId = PSR_RT_ID;
                    }  else if (usr.Role_text__c == 'Technical Services Engineer' || usr.Role_text__c == 'Technical Services Team Leader') {
                        newCase.RecordTypeId = TS_RT_ID;
                    }
                }
            }
            
        }
    }

}