public class InvoiceComplianceDocAfterInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Variables --------
	Map<Id, Invoice_Compliance_Document__c> newICDmap;
    Set<Id> updateLastDocSubmission;
    Set<Id> icdForSharing;

	// -------- Constructor --------
	public InvoiceComplianceDocAfterInsertHandler() {}

	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('InvoiceComplianceDocAfterInsertHandler qualifyStartingRecords');

		List<Invoice_Compliance_Document__c> newRecords = (List<Invoice_Compliance_Document__c>)newList;
        newICDmap = (Map<Id, Invoice_Compliance_Document__c>)newMap;
        icdForSharing = new Set<Id>();
        updateLastDocSubmission = new Set<Id>();

        for(Invoice_Compliance_Document__c icd : newRecords){

        	// filtering the install and interconnect document with new pending status
            if((icd.Invoice_Type__c == 'Install' || icd.Invoice_Type__c == 'Interconnect') && icd.status__c == 'Pending') updateLastDocSubmission.add(icd.Financial_Payment__c);

            if(icd.Residential_Project__c != NULL) icdForSharing.add(icd.Id);
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
	        InvoiceComplianceDocumentUtility.rollups_Count(null, newICDmap);

	        if(!updateLastDocSubmission.isEmpty())  InvoiceComplianceDocumentUtility.updateLastDocSubmissionDate(updateLastDocSubmission);

            if(!icdForSharing.isEmpty())            InvoiceComplianceDocSharingUtility.newICDSharing(icdForSharing);
        }
        Diagnostics.pop();
    }
}