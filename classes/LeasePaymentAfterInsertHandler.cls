public class LeasePaymentAfterInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Constructor --------
	public LeasePaymentAfterInsertHandler() {}

	// -------- Variables --------
	Set<Id> quoteIds;
	Map<Id, LeasePayment__c> lsMap;
	List<LeasePayment__c> idList; // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
	Map<Id, Id> icdMap;

	// -------- Properties --------

	// -------- Methods --------
	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
		Diagnostics.push('LeasePaymentAfterInsertHandler qualifyStartingRecords');

		List<LeasePayment__c> newRecords = (List<LeasePayment__c>)newList;

		quoteIds = new Set<Id>();
		lsMap = new Map<Id, LeasePayment__c>();
		idList = new List<LeasePayment__c>(); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
		icdMap = new Map<Id, Id>();

		for(LeasePayment__c lp : newRecords) {
			if(lp.Payment_Date_Interconnect__c != null && String.isNotBlank(lp.Quote__c)) quoteIds.add(lp.Quote__c);

			// create lease summary for lp
			if(String.isNotBlank(lp.Quote__c)) {
				if(lp.Date_Lease_Document_signed__c != null || lp.Create_Lease_Summary__c) lsMap.put(lp.Id, lp);

				// START ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
				// lp list to create invoice documents
				if(lp.Status__c == 'Active') idList.add(lp);
				// END ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

				// add new fpo's to list so we can link icd's to it
				icdMap.put(lp.Quote__c, lp.Id);
			}
		}
		Diagnostics.pop();
	}

	public override void start() {
		Diagnostics.push('LeasePaymentAfterInsertHandler start');

		Diagnostics.pop();
	}

	public override void finish(Boolean fromStart) {
		Diagnostics.push('LeasePaymentAfterInsertHandler finish');

		if(fromStart) {
			if(!quoteIds.isEmpty()) LeasePaymentService.sendLienWaiver(quoteIds);

			if(!lsMap.isEmpty()) LeasePaymentService.createLeaseScheduleSummary(lsMap);

			if(!idList.isEmpty()) LeasePaymentService.createInvoiceDocuments(idList); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

			if(!icdMap.isEmpty()) LeasePaymentService.linkICDs(icdMap);
		}

		Diagnostics.pop();
	}
}