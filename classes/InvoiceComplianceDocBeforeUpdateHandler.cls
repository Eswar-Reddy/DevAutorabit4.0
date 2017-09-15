public class InvoiceComplianceDocBeforeUpdateHandler extends TriggerHandlerBase {
    // -------- Constants --------

    // -------- Variables --------
    List<Invoice_Compliance_Document__c> docsToFlag;
    Map<Id, Invoice_Compliance_Document__c> fpoEmails;
    Map<Id, Invoice_Compliance_Document__c> tpsEmails;
    List<Invoice_Compliance_Document__c> documentUploaded;
    List<Invoice_Compliance_Document__c> documentDeleted;
    Set<Id> icds4Sharing;

    // -------- Constructor --------
    public InvoiceComplianceDocBeforeUpdateHandler() { }

    // Cast and determine qualified records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('InvoiceComplianceDocBeforeUpdateHandler qualifyStartingRecords');
        List<Invoice_Compliance_Document__c> newRecords = (List<Invoice_Compliance_Document__c>)newList;
        Map<Id, Invoice_Compliance_Document__c> oldMapRecords = (Map<Id, Invoice_Compliance_Document__c>)oldMap;

        docsToFlag = new List<Invoice_Compliance_Document__c>();
        fpoEmails = new Map<Id, Invoice_Compliance_Document__c>();
        tpsEmails = new Map<Id, Invoice_Compliance_Document__c>();
        documentUploaded = new List<Invoice_Compliance_Document__c>();
        documentDeleted = new List<Invoice_Compliance_Document__c>();
        icds4Sharing = new Set<Id>();

        for(Invoice_Compliance_Document__c icd : newRecords) {
            Invoice_Compliance_Document__c oldICD = oldMapRecords.get(icd.Id);

            // load icds for email updates
            if(icd.Program__c == 'TPS' && String.isNotBlank(icd.Responsible_Partner__c)) {
                tpsEmails.put(icd.Responsible_Partner__c, icd);
            } else if(String.isNotBlank(icd.Financial_Payment__c)) {
                fpoEmails.put(icd.Financial_Payment__c, icd);
            }

            // check if icd is pending and null notes if not null
            if(icd.Status__c == 'Pending' && oldICD.Status__c != 'Pending' && String.isNotBlank(icd.Notes_to_Partner__c)) icd.Notes_to_Partner__c = null;

            // get newly approved docs and send them in to check to see if they are the last one in the docType so notification is sent
            if(icd.Status__c == 'Approved' && oldICD.Status__c != 'Approved') {
                icd.Response_Date__c = System.today();
                // check required
                if(!icd.Not_Required_for_Approval__c) {
                    // check for new approved docs
                    if(icd.Status__c != oldICD.Status__c && String.isNotBlank(icd.Financial_Payment__c) && String.isNotBlank(icd.Responsible_Partner__c) && String.isNotBlank(icd.Invoice_Type__c)) {
                        docsToFlag.add(icd);
                    // get old approved docs that were rejected due to missing values above
                    } else if(icd.Status__c == oldICD.Status__c && (icd.Financial_Payment__c != oldICD.Financial_Payment__c || icd.Responsible_Partner__c != oldICD.Responsible_Partner__c || icd.Invoice_Type__c != oldICD.Invoice_Type__c) && String.isNotBlank(icd.Financial_Payment__c) && String.isNotBlank(icd.Responsible_Partner__c) && String.isNotBlank(icd.Invoice_Type__c)) {
                        docsToFlag.add(icd);
                    }
                }
            }

            if(String.isNotBlank(icd.Link_to_Attachment__c) && String.isBlank(oldICD.Link_to_Attachment__c)) documentUploaded.add(icd);

            if(icd.Status__c != 'Rejected' && String.isNotBlank(oldICD.Link_to_Attachment__c) && String.isBlank(icd.Link_to_Attachment__c)) documentDeleted.add(icd);

            // check rejected
            if(icd.Status__c == 'Rejected' && oldICD.Status__c != 'Rejected') {
                icd.Response_Date__c = System.today();
                icd.File_Name__c = null;
                icd.Link_to_Attachment__c = null;
                icd.Document_Submitted__c = null;
            }

            // check for sharing flag
            if(icd.UpdateSharing__c) {
            	icd.UpdateSharing__c = false;
            	icds4Sharing.add(icd.Id);
            }
        }
        Diagnostics.pop();
    }

    public override void start() {
        Diagnostics.push('InvoiceComplianceDocBeforeInsertHandler start');

        Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
        Diagnostics.push('InvoiceComplianceDocBeforeInsertHandler finish');

        if(fromStart) {
            if(!docsToFlag.isEmpty()) InvoiceComplianceDocumentUtility.setRequiredDocumentsApprovedFlag(docsToFlag);

            if(!documentUploaded.isEmpty()) InvoiceComplianceDocumentUtility.icdDocumentUploaded(documentUploaded);

            if(!documentDeleted.isEmpty()) InvoiceComplianceDocumentUtility.icdDocumentDeleted(documentDeleted);

            if(!icds4Sharing.isEmpty()) InvoiceComplianceDocSharingUtility.updateICDSharing(icds4Sharing);

            if(!fpoEmails.isEmpty()) {
                try {
                    // loop over fpo to set emails
                    for(LeasePayment__c fpo : [SELECT Id, Partner_Account__r.Invoice_Document_Email__c, RecordType.DeveloperName FROM LeasePayment__c WHERE Id IN :fpoEmails.keySet()]) {
                        // load the icd
                        Invoice_Compliance_Document__c icd = fpoEmails.get(fpo.Id);
                        icd.Invoice_Document_Email__c = fpo.Partner_Account__r.Invoice_Document_Email__c;
                    }
                } catch(Exception e) {
                    ExLog.log(e);
                }
            }
            if(!tpsEmails.isEmpty()) {
                try {
                    // loop over partner accounts to set emails
                    for(Account a : [SELECT Id, Invoice_Document_Email__c FROM Account WHERE Id IN :tpsEmails.keySet()]) {
                        // load the icd
                        Invoice_Compliance_Document__c icd = tpsEmails.get(a.Id);
                        icd.Invoice_Document_Email__c = a.Invoice_Document_Email__c;
                    }
                } catch(Exception e) {
                    ExLog.log(e);
                }
            }
        }
        Diagnostics.pop();
    }
}