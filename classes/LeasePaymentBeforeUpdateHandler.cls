public class LeasePaymentBeforeUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Constructor --------
	public LeasePaymentBeforeUpdateHandler() {}

	// -------- Variables --------
	Map<Id, LeasePayment__c> quoteIdLP;
	List<LeasePayment__c> pisList;
	List<LeasePayment__c> iiList; // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

	// -------- Properties --------

	// -------- Methods --------
	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
		Diagnostics.push('LeasePaymentBeforeUpdateHandler qualifyStartingRecords');

		List<LeasePayment__c> newRecords = (List<LeasePayment__c>)newList;
		Map<Id, LeasePayment__c> oldRecords = (Map<Id, LeasePayment__c>)oldMap;

		quoteIdLP = new Map<Id, LeasePayment__c>();
		iiList = new List<LeasePayment__c>(); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
		pisList = new List<LeasePayment__c>();

		for(LeasePayment__c lp : newRecords) {
			LeasePayment__c oldLP = oldRecords.get(lp.Id);

			if(String.isNotBlank(lp.Quote__c)) {
				quoteIdLP.put(lp.Quote__c, lp);

				// START ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
				// run the install/interconnect logic
				if(lp.Status__c == 'Active' && lp.Run_Invoice_Documents_Trigger__c) iiList.add(lp);
				// END ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
			}
			if(lp.Placed_In_Service__c != null && lp.Placed_In_Service__c != oldLP.Placed_In_Service__c) pisList.add(lp);

			if(lp.Run_Invoice_Documents_Trigger__c) lp.Run_Invoice_Documents_Trigger__c = false;
		}
		Diagnostics.pop();
	}

	public override void start() {
		Diagnostics.push('LeasePaymentBeforeUpdateHandler start');

		Diagnostics.pop();
	}

	public override void finish(Boolean fromStart) {
		Diagnostics.push('LeasePaymentBeforeUpdateHandler finish');

		if(fromStart) {
			if(!quoteIdLP.isEmpty()) LeasePaymentService.setLPemailAddresses(quoteIdLP);

			if(!pisList.isEmpty()) LeasePaymentService.applyFMVRate(pisList);

			if(!iiList.isEmpty()) LeasePaymentService.populateInstallAndInterconnect(iiList); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
		}

		Diagnostics.pop();
	}
}