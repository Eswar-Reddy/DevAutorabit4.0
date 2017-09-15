public class CaseLeasePayment {

    // to prevent trigger recursions
    private static Boolean updateFromLeasePaymentRunning = false;
    private static Boolean updateFromQuoteRunning = false;

    public static void setLeaseNumber(Map <Integer, Case> qualifyMap) {
        Set <String> lpIdSet = new Set <String>();
        List <Case> caseList = new List <Case>(); 
        for (Case c : qualifyMap.values()) {
            if (c.Lease_Payment__c != null) { 
                lpIdSet.add(c.Lease_Payment__c);
                caseList.add(c);
            } else {
                c.Lease__c = null;
            }
        } 
        if (lpIdSet.size() > 0) {
            Map <String, LeasePayment__c> lpMap = new Map <String, LeasePayment__c>([SELECT Id, Lease__c 
                FROM LeasePayment__c WHERE Id IN :lpIdSet]);
            for (Case c : caseList) {
                if (c.Lease_Payment__c != null) {
                    if (lpMap != null && lpMap.containsKey(c.Lease_Payment__c)) { 
                        c.Lease__c = lpMap.get(c.Lease_Payment__c).Lease__c;
                    }
                }
            } 
    
        }
    }

    public static void setLeaseNumberSPVT(Map <Integer, Case> qualifyMap) {
        Set <String> lpIdSet = new Set <String>();
        List <Case> caseList = new List <Case>(); 
        for (Case c : qualifyMap.values()) {
            if (c.SPVT_Case__c == true) {
                if (c.Lease_Payment__c != null) { 
                    lpIdSet.add(c.Lease_Payment__c);
                    caseList.add(c);
                } else {
                    c.Lease__c = null;
                }
            }
        } 
        if (lpIdSet.size() > 0) {
            Map <String, LeasePayment__c> lpMap = new Map <String, LeasePayment__c>([SELECT Id, Lease__c 
                FROM LeasePayment__c WHERE Id IN :lpIdSet]);
            for (Case c : caseList) {
                if (c.SPVT_Case__c == true) {
                    if (c.Lease_Payment__c != null) {
                        if (lpMap != null && lpMap.containsKey(c.Lease_Payment__c)) { 
                            c.Lease__c = lpMap.get(c.Lease_Payment__c).Lease__c;
                        }
                    }
                }
            } 
    
        }
    }
    
    public static void setLeasePayment(Map <Integer, Case> qualifyMap) {
        Set <String> accountIdSet = new Set <String>();
        for (Case c : qualifyMap.values()) {
            if (c.AccountId != null) {        
                accountIdSet.add(c.AccountId);
            }
        } 
        if (accountIdSet.size() > 0) {
            List <LeasePayment__c> lpList = [SELECT Id, Account__c, Lease__c, Status__c 
                FROM LeasePayment__c 
                WHERE Account__c IN :accountIdSet
                ORDER BY CreatedDate DESC];        

            Map <String, LeasePayment__c> lpMap_active = new Map <String, LeasePayment__c>();
            Map <String, LeasePayment__c> lpMap_latest = new Map <String, LeasePayment__c>();

            for (LeasePayment__c lp : lpList) {
                if (lp.Account__c != null) {
                    if (lpMap_latest.keySet().contains(lp.Account__c) == false) {
                        lpMap_latest.put(lp.Account__c, lp);
                    }            
                    if (lpMap_active.keySet().contains(lp.Account__c) == false && lp.Status__c == 'Active') {
                        lpMap_active.put(lp.Account__c, lp);
                    }            
                
                }
            }

            for (Case c : qualifyMap.values()) {
                if (c.AccountId != null) { 
                    LeasePayment__c lp;       
                    if (lpMap_active.containsKey(c.AccountId)) {
                        lp = lpMap_active.get(c.AccountId);
                    } else if (lpMap_latest.containsKey(c.AccountId)) {
                        lp = lpMap_latest.get(c.AccountId);
                    }
                    if (lp != null) {
                        c.Lease_Payment__c = lp.Id;
                        c.Lease__c = lp.Lease__c;
                    } else {
                        c.Lease_Payment__c = null;
                        c.Lease__c = null;
                    }
                }
            } 
                                    
        }

    }

    public static void updateCase(List<LeasePayment__c> qualifyMap) {
        if (updateFromLeasePaymentRunning == true) {
            return;
        }
        updateFromLeasePaymentRunning = true;

        Set <String> lpIdSet = new Set <String>();
        for (LeasePayment__c lp : qualifyMap) {
            if (lp.Id != null) {        
                lpIdSet.add(lp.Id);
            }
        } 
        
        if (lpIdSet.size() > 0) {
            updateCase(lpIdSet);
        }

    }

    public static void updateCase(Map <Integer, Quote> qualifyMap) {
        if (updateFromQuoteRunning == true) {
            return;
        }
        updateFromQuoteRunning = true;
        
        Set <String> quoteIdSet = new Set <String>();
        for (Quote q : qualifyMap.values()) {
            if (q.Id != null) {
                quoteIdSet.add(q.Id);
            }        
        }
        if (quoteIdSet.size() > 0) {
            Set <String> lpIdSet = new Set <String>();
            for (LeasePayment__c lp : [SELECT Id, Quote__c FROM LeasePayment__c WHERE Quote__c IN :quoteIdSet]) {
                lpIdSet.add(lp.Id);
            }
            if (lpIdSet.size() > 0) {
                updateCase(lpIdSet);
            }        
        }
    }
            
    private static void updateCase(Set <String> lpIdSet) {
        if (lpIdSet.size() > 0) {
            List <Case> caseList = new List <Case>();
            for (Case c : [SELECT Id, Lease__c, Lease_Payment__c, Lease_Payment__r.Lease__c 
                    FROM Case WHERE Lease_Payment__c IN :lpIdSet]) {        
                if (c.Lease__c != c.Lease_Payment__r.Lease__c) {
                    c.Lease__c = c.Lease_Payment__r.Lease__c;
                    caseList.add(c);
                }
            }
            if (caseList.size() > 0) {
                Database.SaveResult[] srList = Database.update(caseList, false);
                for(Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Updated case successfully for ID: ' + sr.getId());
                    } else {
                        System.debug('Updating case for ID: ' + sr.getId() + ' returned the following errors.');
                        for(Database.Error e : sr.getErrors()) {
                            System.debug(e.getMessage());
                        }
                    }
                }
            }
        }
    }
    
}