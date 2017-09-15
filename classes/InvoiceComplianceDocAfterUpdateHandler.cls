public class InvoiceComplianceDocAfterUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------
	Map<String, Mosaic_Upload_Documents__c> docKeys = Mosaic_Upload_Documents__c.getAll();

	// -------- Variables --------
	Map<Id, Invoice_Compliance_Document__c> newICDmap;
	Set<Id> fpoIds;
	List<LeasePayment__c> fposToUpdate;
	List<Invoice_Compliance_Document__c> docsToApprove;
	List<Invoice_Compliance_Document__c> docsToUnapprove;
	List<Invoice_Compliance_Document__c> rejectedDocs;
    Set<Id> updateLastDocSubmission;
    Set<Id> icdForSharing;
    Map<Id, Invoice_Compliance_Document__c> oldICDMap;

	// -------- Constructor --------
	public InvoiceComplianceDocAfterUpdateHandler() {}

	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('InvoiceComplianceDocAfterUpdateHandler qualifyStartingRecords');
		List<Invoice_Compliance_Document__c> newRecords = (List<Invoice_Compliance_Document__c>)newList;
		Map<Id, Invoice_Compliance_Document__c> oldRecordsMap = (Map<Id, Invoice_Compliance_Document__c>)oldMap;

		newICDmap 				= (Map<Id, Invoice_Compliance_Document__c>)newMap;
		fpoIds 					= new Set<Id>();
		fposToUpdate 			= new List<LeasePayment__c>();
		docsToApprove 			= new List<Invoice_Compliance_Document__c>();
		docsToUnapprove 		= new List<Invoice_Compliance_Document__c>();
		rejectedDocs 			= new List<Invoice_Compliance_Document__c>();
        updateLastDocSubmission = new Set<Id>();
        icdForSharing 			= new Set<Id>();
        oldICDMap 				= new Map<Id, Invoice_Compliance_Document__c>();

		for(Invoice_Compliance_Document__c icd : newRecords) {
			Invoice_Compliance_Document__c oldICD = oldRecordsMap.get(icd.Id);

			// setup vars for mosaic check
			String mStatus = icd.Mosaic_Status__c;
			String mOldStatus = oldICD.Mosaic_Status__c;
			Boolean curFPO = String.isNotBlank(icd.Financial_Payment__c);
			Boolean oldFPO = String.isNotBlank(oldICD.Financial_Payment__c);

			// check if icd has an fpo, doc is a key one and status is valid
			if(curFPO && docKeys.containsKey(icd.Documents_in_File__c) && (mStatus == 'Upload Success' || mStatus == 'Installation Confirmed')) {
				// confirm this is a new doc
				if(mStatus != moldStatus || curFPO != oldFPO) {
					fpoIds.add(icd.Financial_Payment__c);
				}
			}
			// handle approved/unapproved/rejected docs
			String curStatus = icd.Status__c;
			String oldStatus = oldICD.Status__c;

			// get docs for approval/unapproval
			if(!icd.Not_Required_for_Approval__c) {
				// approved docs
				if(curStatus == 'Approved' && curStatus != oldStatus) docsToApprove.add(icd);

				// unapproved docs
				if(oldStatus == 'Approved' && curStatus != oldStatus && String.isNotBlank(icd.Financial_Payment__c)) docsToUnapprove.add(icd);
			}
			// get rejected docs
			if(curStatus == 'Rejected' && curStatus != oldStatus) {
				rejectedDocs.add(icd);
				oldICDMap.put(icd.Id, oldICD);
			}

			// filtering the install and interconnect document with new pending status
            if((icd.Invoice_Type__c == 'Install' || icd.Invoice_Type__c == 'Interconnect') && icd.status__c == 'Pending' && oldICD.status__c != 'Pending') updateLastDocSubmission.add(icd.Financial_Payment__c);

            // If Responsible Partner or Shared With changes, rerun custom sharing logic
            if(icd.Shared_With__c != oldICD.Shared_With__c || icd.Responsible_Partner__c != oldICD.Responsible_Partner__c) icdForSharing.add(icd.Id);
		}
		Diagnostics.pop();
	}

    public override void start() {
    	Diagnostics.push('InvoiceComplianceDocAfterUpdateHandler start');

    	// update mosaic status on fpo
    	for(Id i : fpoIds) {
    		LeasePayment__c fpo = new LeasePayment__c();
    		fpo.Id = i;
    		fpo.Mosaic_Status__c = 'Submit for Final Review';
    		fposToUpdate.add(fpo);
    	}

    	Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
        Diagnostics.push('InvoiceComplianceDocAfterUpdateHandler finish');

        if(fromStart) {
        	InvoiceComplianceDocumentUtility.rollups_Count(null, newICDmap);

        	try {
        		if(!fposToUpdate.isEmpty()) update fposToUpdate;
        	}
        	catch(Exception e) {
        		ExLog.log(e);
        	}

        	if(!docsToApprove.isEmpty()) 			InvoiceComplianceDocumentUtility.setApprovedField(docsToApprove);

        	if(!docsToUnapprove.isEmpty()) 			InvoiceComplianceDocumentUtility.removeApprovedField(docsToUnapprove);

        	if(!rejectedDocs.isEmpty()) 			InvoiceComplianceDocumentUtility.createRejectionReasons(rejectedDocs, oldICDMap);

            if(!updateLastDocSubmission.isEmpty()) 	InvoiceComplianceDocumentUtility.updateLastDocSubmissionDate(updateLastDocSubmission);

            if(!icdForSharing.isEmpty())            InvoiceComplianceDocSharingUtility.updateICDSharing(icdForSharing);
        }
        Diagnostics.pop();
    }
}