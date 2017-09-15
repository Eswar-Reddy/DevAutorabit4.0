public without sharing class LeasePaymentAfterUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Constructor --------
	public LeasePaymentAfterUpdateHandler() {}

	// -------- Variables --------
	List<LeasePayment__c> qualifyLeaseOldMap;
	Set<String> getRecordIdsForChangeInSPVTCaseValue; // List to get all Ids for the records whenever check box SPVT To Case Gets Change
	Set<Id> quoteIds;
	List<LeasePayment__c> idList; // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
	Set<Id> pisIds;
	Map<Id, Id> icdMap;
	Set<Id> coBrandIds;

	// -------- Properties --------

	// -------- Methods --------
	// Cast and determine qualified records
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('LeasePaymentAfterUpdateHandler qualifyStartingRecords');

		List<LeasePayment__c> newRecords = (List<LeasePayment__c>)newList;
		Map<Id, LeasePayment__c> oldRecordsMap = (Map<Id, LeasePayment__c>)oldMap;

		qualifyLeaseOldMap = new List<LeasePayment__c>();
		getRecordIdsForChangeInSPVTCaseValue = new Set<String>();
		quoteIds = new Set<Id>();
		idList = new List<LeasePayment__c>(); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
		pisIds = new Set<Id>();
		icdMap = new Map<Id, Id>();
		coBrandIds = new Set<Id>();

		for(LeasePayment__c lp : newRecords) {
			LeasePayment__c oldLP = oldRecordsMap.get(lp.Id);

			if(lp.Lease_old__c != oldLP.Lease_old__c) qualifyLeaseOldMap.add(lp);

			// Code Addition Related to SPVT Send Email once Person Click on CheckBox SPVT case to SunPower
			if(lp.SPVT_case_to_SunPower__c && !oldLP.SPVT_case_to_SunPower__c && lp.SPVT_Result__c.equalsIgnoreCase('Fail')) {
				getRecordIdsForChangeInSPVTCaseValue.add(lp.Id);
			}

			if(lp.Payment_Date_Interconnect__c != null && oldLP.Payment_Date_Interconnect__c == null && String.isNotBlank(lp.Quote__c)) quoteIds.add(lp.Quote__c);

			// START ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****
			// lp list to create invoice documents
			if(lp.Status__c == 'Active' && lp.Run_Invoice_Documents_Trigger__c && !oldLP.Run_Invoice_Documents_Trigger__c) {
				idList.add(lp);
			}
			// END ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

			// update opportunity stage if placed in service
			if(String.isNotBlank(lp.Opportunity__c) && lp.Placed_In_Service__c != null && lp.Placed_In_Service__c != oldLP.Placed_In_Service__c) {
				pisIds.add(lp.Opportunity__c);
			}

			// co branding - waiting for feedback from the business on this feature
			if(lp.Funding_Tranche__c != 'ConEdison Solutions' && oldLP.Funding_Tranche__c == 'ConEdison Solutions') coBrandIds.add(lp.Account__c);

			// check if fpo got a new quote and link icds
			if(String.isNotBlank(lp.Quote__c) && String.isBlank(oldLP.Quote__c)) {
				icdMap.put(lp.Quote__c, lp.Id);
			}
		}
		Diagnostics.pop();
	}

	public override void start() {
		Diagnostics.push('LeasePaymentAfterUpdateHandler start');

		Diagnostics.pop();
	}

	public override void finish(Boolean fromStart) {
		Diagnostics.push('LeasePaymentAfterUpdateHandler finish');

		if(fromStart) {
			if(!qualifyLeaseOldMap.isEmpty()) CaseLeasePayment.updateCase(qualifyLeaseOldMap);

			if(!getRecordIdsForChangeInSPVTCaseValue.isEmpty()) sendEmailSPVTClass.sendSingleEmail(getRecordIdsForChangeInSPVTCaseValue);

			if(!quoteIds.isEmpty()) LeasePaymentService.sendLienWaiver(quoteIds);

			if(!idList.isEmpty()) LeasePaymentService.createInvoiceDocuments(idList); // ***** THIS CAN BE REMOVED AFTER INVOICE OPTIMIZATION CUT OVER *****

			if(!pisIds.isEmpty()) LeasePaymentService.updateOppStage(pisIds);

			if(!icdMap.isEmpty()) LeasePaymentService.linkICDs(icdMap);

			if(!coBrandIds.isEmpty()) LeasePaymentService.nullCoBranding(coBrandIds);
		}
		Diagnostics.pop();
	}
}