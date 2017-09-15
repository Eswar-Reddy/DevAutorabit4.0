public class InvoiceComplianceDocBeforeInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Variables --------
	Map<Id, List<Alliance_Partner__c>> apList;

	// -------- Constructor --------
	public InvoiceComplianceDocBeforeInsertHandler() { }

	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('InvoiceComplianceDocBeforeInsertHandler qualifyStartingRecords');

		List<Invoice_Compliance_Document__c> newRecords = (List<Invoice_Compliance_Document__c>)newList;

		apList = new Map<Id, List<Alliance_Partner__c>>();

		for(Invoice_Compliance_Document__c icd : newRecords) {
			// set the default for new docs
			icd.Approved_Notification__c = false;

			// check icd and add to map if it has a project and owner
			if(String.isNotBlank(icd.Residential_Project__c) && String.isNotBlank(icd.Document_Owner__c)) {
				if(!apList.containsKey(icd.Residential_Project__c)) {
					apList.put(icd.Residential_Project__c, new List<Alliance_Partner__c>());
				}
			}
		}
		// get list of alliance partners for each project
		if(!apList.isEmpty()) {
			for(Residential_Project__c rp : [SELECT Id, (SELECT Residential_Project__c, Partner_Account__c, Role__c FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id IN :apList.keySet()]) {
				apList.get(rp.Id).addAll(rp.Alliance_Partners__r);
			}
			// assign the responsible party for each document based on the ap.role/icd.Owner
			for(Invoice_Compliance_Document__c icd : newRecords) {
				if(String.isNotBlank(icd.Residential_Project__c) && String.isNotBlank(icd.Document_Owner__c)) {
					for(Alliance_Partner__c ap : apList.get(icd.Residential_Project__c)) {
						if(icd.Document_Owner__c == ap.Role__c) {
							icd.Responsible_Partner__c = ap.Partner_Account__c;
						}
					}
				}
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
        }
        Diagnostics.pop();
    }
}