public class InvoiceDocumentsApprovalUtil {

    public static void setRequiredDocumentsApprovedFlag(Map<Integer, Invoice_Documents__c> qualifyMap) {
        Set <String> lpIdSet = new Set <String>();    
        for (Invoice_Documents__c doc : qualifyMap.values()) {
            if (doc.Lease_Payment__c != null) {
                lpIdSet.add(doc.Lease_Payment__c);
            }        
        }
        
        // query existing documents
        List <LeasePayment__c> lpList = new List <LeasePayment__c>();
        if (lpIdSet.size() > 0) {
            lpList = [SELECT Id, 
                (SELECT Id, Invoice_Type__c, Lease_Payment__c, Not_Required_for_Approval__c, Responsible_Partner__c, Status__c 
                    FROM Invoice_Documents__r
                    WHERE Invoice_Type__c != null AND Not_Required_for_Approval__c = false AND Responsible_Partner__c != null) 
                FROM LeasePayment__c 
                WHERE Id IN :lpIdSet];  
        }
        
        // get existing documents
        Map <String, Map <String, Invoice_Documents__c>> partnerTypeDocMapMap = new Map <String, Map <String, Invoice_Documents__c>>();
        for (LeasePayment__c lp : lpList) {
            for (Invoice_Documents__c doc : lp.Invoice_Documents__r) {        
                String key = getKey(doc);
                if (String.isNotBlank(key)) {
                    Map <String, Invoice_Documents__c> docMap = new Map <String, Invoice_Documents__c>();
                    if (partnerTypeDocMapMap.containsKey(key)) {
                        docMap = partnerTypeDocMapMap.get(key);
                    }        
                    docMap.put(doc.Id, doc);
                    partnerTypeDocMapMap.put(key, docMap);
                }
            }
        }
        
        // replace with current record that is getting modified
        for (Invoice_Documents__c doc : qualifyMap.values()) {
            String key = getKey(doc);
            if (String.isNotBlank(key)) {
                Map <String, Invoice_Documents__c> docMap = new Map <String, Invoice_Documents__c>();
                if (partnerTypeDocMapMap.containsKey(key)) {
                    docMap = partnerTypeDocMapMap.get(key);
                }
                if (doc.Id != null) {
                    docMap.put(doc.Id, doc);
                }
                partnerTypeDocMapMap.put(key, docMap);
            }
        }

        // add new records
        Map <String, List <Invoice_Documents__c>> partnerTypeDocListMap = new Map <String, List <Invoice_Documents__c>>();
        for (Invoice_Documents__c doc : qualifyMap.values()) {
            String key = getKey(doc);
            if (String.isNotBlank(key)) {
                List <Invoice_Documents__c> docList = new List <Invoice_Documents__c>();
                if (partnerTypeDocMapMap.containsKey(key)) {
                    docList = partnerTypeDocMapMap.get(key).values();
                }
                if (doc.Id == null) {
                    docList.add(doc);
                }
                partnerTypeDocListMap.put(key, docList);
            }
        }
        
        // set unapproved groups
        Set <String> upapprovedKeySet = new Set <String>();
        for (String key : partnerTypeDocListMap.keySet()) {
            List <Invoice_Documents__c> docList = partnerTypeDocListMap.get(key);
            for (Invoice_Documents__c doc : docList) {
                if (doc.Not_Required_for_Approval__c == false && doc.Status__c != 'Approved') {
                    upapprovedKeySet.add(key);
                    break;    // inner for
                }
            }
        }

        // group incoming records
        Map <String, List <Invoice_Documents__c>> keyDocListMap = new Map <String, List <Invoice_Documents__c>>();
        for (Invoice_Documents__c doc : qualifyMap.values()) {
            doc.Approved_Notification__c = false;
            String key = getKey(doc);
            if (String.IsNotBlank(key)) {
                List <Invoice_Documents__c> docList = new List <Invoice_Documents__c>();
                if (keyDocListMap.containsKey(key)) {
                    docList = keyDocListMap.get(key);
                }
                docList.add(doc);
                keyDocListMap.put(key, docList);
            }
        }
        
        for (String key : keyDocListMap.keySet()) {
            if (upapprovedKeySet.contains(key) == false) {
                List <Invoice_Documents__c> docList = keyDocListMap.get(key);
                for (Invoice_Documents__c doc : docList) {
                    if (doc.Not_Required_for_Approval__c == false) {
                        // change in this flag will trigger workflow. need to change only one record for each group
                        if (doc.Approved_Notification__c == false) {
                            doc.Approved_Notification__c = true;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    private static String getKey(Invoice_Documents__c doc) {
        String key;
        if (doc.Lease_Payment__c != null &&  doc.Responsible_Partner__c != null &&  doc.Invoice_Type__c != null) {
            key = doc.Lease_Payment__c + '_' + doc.Responsible_Partner__c + '_' + doc.Invoice_Type__c;
        }
        return key;
    }

}