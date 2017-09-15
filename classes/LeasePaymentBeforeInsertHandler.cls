public class LeasePaymentBeforeInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Constructor --------
	public LeasePaymentBeforeInsertHandler() {}

	// -------- Variables --------
	Map<Id, LeasePayment__c> quoteIdLP;
	List<LeasePayment__c> iiList; // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

	// -------- Properties --------

	// -------- Methods --------
	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
		Diagnostics.push('LeasePaymentBeforeInsertHandler qualifyStartingRecords');

		List<LeasePayment__c> newRecords = (List<LeasePayment__c>)newList;

		quoteIdLP = new Map<Id, LeasePayment__c>();
		iiList = new List<LeasePayment__c>(); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

		for(LeasePayment__c lp : newRecords) {
			if(String.isNotBlank(lp.Quote__c)) {
				quoteIdLP.put(lp.Quote__c, lp);

				// START ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
				// run the install/interconnect logic
				if(lp.Status__c == 'Active') iiList.add(lp);
				// END ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
			}
		}
		Diagnostics.pop();
	}

	public override void start() {
		Diagnostics.push('LeasePaymentBeforeInsertHandler start');

		Diagnostics.pop();
	}

	public override void finish(Boolean fromStart) {
		Diagnostics.push('LeasePaymentBeforeInsertHandler finish');

		if(fromStart) {
			if(!quoteIdLP.isEmpty()) {
				LeasePaymentService.connectFPOtoRP(quoteIdLP);

				LeasePaymentService.setLPemailAddresses(quoteIdLP);
			}
			if(!iiList.isEmpty()) LeasePaymentService.populateInstallAndInterconnect(iiList); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
		}
		Diagnostics.pop();
	}
}