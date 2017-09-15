public class CaseEmailRollup {

    public static void rollup(List <Case> newList) {
        Set <String> caseIdSet = new Set <String>();
        Map <Id, Case> caseMap = new Map <Id, Case>();
        for (Case c : newList) {
            if (c.Id != null) {
                caseIdSet.add(c.Id);
                caseMap.put(c.Id, c);
            }
        }
        if (caseIdSet.size() > 0) {
            List <Case> caseListUpdate = rollup(caseIdSet);
            // no need to update list. to be called in before update trigger
            for (Case c : caseListUpdate) {
                if (caseMap.containsKey(c.Id)) {
                    caseMap.get(c.Id).New_Emails_Count__c = c.New_Emails_Count__c;
                }
            }
        }   
    }
    
    public static void rollup(List <EmailMessage> newList, Map <Id, EmailMessage> oldMap) {
        Set <String> caseIdSet = new Set <String>();
        if (newList != null && newList.size() > 0) {
            for (EmailMessage e : newList) {
                if (e.ParentId != null) {
                    caseIdSet.add(e.ParentId);
                }
            }
        } 
        if (oldMap != null && oldMap.size() > 0) {
            for (EmailMessage e : oldMap.values()) {
                if (e.ParentId != null) {
                    caseIdSet.add(e.ParentId);
                }
            }
        }
        if (caseIdSet.size() > 0) {
            List <Case> caseListUpdate = rollup(caseIdSet);
            if (caseListUpdate.size() > 0) {
                // allow partial updates. dont want to prevent getting emails when case update fails 
                Database.SaveResult[] srList = Database.update(caseListUpdate, false);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully updated case. Case ID: ' + sr.getId());
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Case fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }   
    
    }

    private static List <Case> rollup(Set <String> caseIdSet) {
        List <Case> caseListUpdate = new List <Case>();
        for (Case c : [SELECT Id, New_Emails_Count__c, (SELECT Id, Status FROM EmailMessages) FROM Case WHERE Id IN :caseIdSet]) {
            Integer newEmailsCount = 0;
            for (EmailMessage e : c.EmailMessages) {
                // New=0, Read=1, Replied=2, Sent=3, Forwarded=4, Draft=5
                if (e.Status == '0') {
                    newEmailsCount++;
                }            
            }
            if (c.New_Emails_Count__c != newEmailsCount) {
                c.New_Emails_Count__c = newEmailsCount;
                caseListUpdate.add(c);
            }
        }
        return caseListUpdate;
    }
    
}