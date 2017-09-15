public class AgreementAfterUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------
	String lienWaiverRecTypeId = AgreementUtility.LeaseValsSettings.Lien_Waiver_Id__c;
	Id cancelledRecTypeId = AgreementUtility.cancelledRecTypeId;
	Id amendmentRecTypeId = AgreementUtility.amendmentRecTypeId;

	// -------- Constructor --------
	public AgreementAfterUpdateHandler() { }

	// -------- Variables --------
	Map<ID, echosign_dev1__SIGN_Agreement__c> oldAgreementMap;

	// -------- Properties --------
	// Qualified records for actions
	Map<Id, echosign_dev1__SIGN_Agreement__c> qualifiedAgreements;

	//---------Sets for queries----
	Set<Id> contractIds;
	Set<Id> oppIds;
	Set<Id> acctIds;
	Set<Id> approvedAccIds;
	Set<Id> futureStatusUpdateIds;
	Map<Id, Id> newprojects;

	//Collections for DML
	Map<Id, Contract> contractsToUpdate;
	Map<Id, Account> acctsToUpdate;
	Map<Id, LeasePayment__c> lpsToUpdate;
	Map<Id, TPSSF__Document__c> docsToUpdate;
	List<Residential_Project__c> projectInserts;
	List<echosign_dev1__SIGN_Agreement__c> pendingCancellation;
	List<echosign_dev1__SIGN_Agreement__c> completeCancellation;
	List<Id> amendmentAggs;
	List<Id> agreementStatusNotification;
    List<echosign_dev1__SIGN_Agreement__c> signedAmendmentAggs;
	Set<Id> fpoOppSet;

	//Begin Evaluation
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('AgreementAfterUpdate qualifyStartingRecords');

		Map<ID, echosign_dev1__SIGN_Agreement__c> newAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)newMap;
		oldAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)oldMap;
		qualifiedAgreements = new Map<Id, echosign_dev1__SIGN_Agreement__c>();

		contractIds = new Set<Id>();
		oppIds = new Set<Id>();
		acctIds = new Set<Id>();
		approvedAccIds = new Set<Id>();
		futureStatusUpdateIds = new Set<Id>();
		newProjects = new Map<Id, Id>();
		pendingCancellation = new List<echosign_dev1__SIGN_Agreement__c>();
		completeCancellation = new List<echosign_dev1__SIGN_Agreement__c>();
		amendmentAggs = new List<Id>();
		fpoOppSet = new Set<Id>();
		projectInserts = new List<Residential_Project__c>();
		contractsToUpdate = new Map<Id, Contract>();
		acctsToUpdate = new Map<Id, Account>();
		lpsToUpdate = new Map<Id, LeasePayment__c>();
		docsToUpdate = new Map<Id, TPSSF__Document__c>();
		agreementStatusNotification = new List<Id>();
        signedAmendmentAggs = new List<echosign_dev1__SIGN_Agreement__c>();

		//Begin processing records
		for(echosign_dev1__SIGN_Agreement__c agg : newAgreementMap.values()) {
			echosign_dev1__SIGN_Agreement__c oldAgg = oldAgreementMap.get(agg.Id);

			if(agg.echosign_dev1__Status__c != null && ((agg.echosign_dev1__Status__c != oldAgg.echosign_dev1__Status__c) || (agg.echosign_dev1__Status__c == 'Signed' && oldAgg.echosign_dev1__DateSigned__c == null && agg.echosign_dev1__DateSigned__c != null))) {

				qualifiedAgreements.put(agg.Id, agg);

				if(agg.echosign_dev1__Contract__c != null) contractIds.add(agg.echosign_dev1__Contract__c);

				if(agg.RecordTypeId == AgreementUtility.leaseRecTypeId && agg.Opportunity__c != null) oppIds.add(agg.Opportunity__c);

				if(agg.echosign_dev1__Status__c == 'Signed' && agg.Account__c != null) acctIds.add(agg.Account__c);

				if(AgreementUtility.statusForFutureCall.contains(agg.echosign_dev1__Status__c)) futureStatusUpdateIds.add(agg.Id);
			}

			// Residential Project Creation
			if(agg.RecordTypeId != amendmentRecTypeId && agg.echosign_dev1__Status__c == 'Waiting for Counter-Signature' && oldAgg.echosign_dev1__Status__c != 'Waiting for Counter-Signature'){
				newProjects.put(agg.Id, agg.Quote__c);
			}

			if(agg.RecordTypeId == lienWaiverRecTypeId && agg.Account__c != null && agg.Lease_Number__c != null && ((agg.Approved__c && !oldAgg.Approved__c) || agg.Status__c == 'Signed')) {
					approvedAccIds.add(agg.Account__c);
					qualifiedAgreements.put(agg.Id, agg);
			}

			// Cancellation Signed - Change Order MGMT
			if(agg.RecordTypeId == cancelledRecTypeId && agg.echosign_dev1__Status__c == 'Out for Signature' && oldAgg.echosign_dev1__Status__c != 'Out for Signature'){
				pendingCancellation.add(agg);
				ResidentialProjectUtility.runValidation = FALSE;
				// send the Oracle hold request.
				OracleCancellationUtility.fCallToOralce(agg.Id,agg.Quote__c,'Hold');
			}

			// Cancellation Signed  - Change Order MGMT
			if(agg.RecordTypeId == cancelledRecTypeId && agg.echosign_dev1__Status__c == 'Signed' && oldAgg.echosign_dev1__Status__c != 'Signed'){
				completeCancellation.add(agg);
				ResidentialProjectUtility.runValidation = FALSE;
				// send Oracle Cancel Request.
				OracleCancellationUtility.fCallToOralce(agg.Id,agg.Quote__c,'Cancel');
			}

			// Amendment Agreement Signed - Change Order MGMT
			if(agg.RecordTypeId == amendmentRecTypeId && agg.echosign_dev1__Status__c == 'Signed' && oldAgg.echosign_dev1__Status__c != 'Signed'){
				amendmentAggs.add(agg.Id);
				signedAmendmentaggs.add(agg);
				ResidentialProjectUtility.runValidation = FALSE;
			}

			// Amendment Agreement Status Notificaiton to Internal User
            if(agg.RecordTypeId == amendmentRecTypeId && agg.echosign_dev1__Status__c <> 'Draft' && (oldagg.echosign_dev1__Status__c <> agg.echosign_dev1__Status__c)){
                agreementStatusNotification.add(agg.Id);
                ResidentialProjectUtility.runValidation = FALSE;
            }
			if(((agg.echosign_dev1__Status__c == 'Signed' && oldAgg.echosign_dev1__Status__c != 'Signed') || (agg.echosign_dev1__Status__c == 'Waiting for Counter-signature' && oldAgg.echosign_dev1__Status__c != 'Waiting for Counter-signature')) && agg.Quote__c != null){
				fpoOppSet.add(agg.Id);
			}
		}

		//Special Scenarios
		TPSDocumentUtility.fUpdateHomeOwnerApproval(oldAgreementMap, newAgreementMap);
	}

	public override void start() {
		// Residential Project Creation
		Map<Id, Id> projectOppMap = new Map<Id, Id>();
        if(!newProjects.isEmpty()) {
            for(Residential_Project__c rp : [SELECT Id, Opportunity__c FROM Residential_Project__c WHERE Opportunity__c IN (SELECT OpportunityId FROM Quote WHERE Id IN: newProjects.values()) ]){
                projectOppMap.put(rp.Opportunity__c, rp.Id);
            }
        }

		// Pending Cancellation
		if(!pendingCancellation.isEmpty()) AgreementUtility.updateCancellationStatus(pendingCancellation, 'Pending Cancellation');

        if(!completeCancellation.isEmpty()) {
            // Confirmed Cancellation
            AgreementUtility.updateCancellationStatus(completeCancellation, 'Cancelled');
            // change order phase II - update cloned quotes for cancelled agreement
            QuoteAmendmentUtility.cancelClonedQuotes(completeCancellation);
        }

        if(!amendmentAggs.isEmpty()) {
            // Amendment Signed
            AgreementUtility.applyChangeAudits(amendmentAggs);
            // change order phase II - decommission old quote
            QuoteAmendmentUtility.decommissionQuote(amendmentAggs);
        }

        // AgreementStatusNotification Function called to send status notification
         if(!agreementStatusNotification.isEmpty()) AgreementUtility.sendAgreementStatusNotification(agreementStatusNotification,Null);

        // updating notes in the related LeasePayment object after amendment agreement signed.
        if(!signedAmendmentAggs.isEmpty()) AgreementUtility.updateAmendmentNotesOnLeasePayment(signedAmendmentAggs);

		//Update Opportunity Deal Type
		if(!fpoOppSet.isEmpty()) AgreementUtility.UpdateOppurtunutyDealType(fpoOppSet);

		// If Opportunity Partner Account = 'Sunpower Direct (SPD)' the project is record type SPD. If Opportunity Partner Account Business Function = TPS, project record type is TPS. If Opportunity Partner Account's Channel = 'Indirect' the project is record type Indirect.
		if(!newprojects.isEmpty()) {
			for(echosign_dev1__SIGN_Agreement__c agg : [SELECT Id, Quote__c, Quote__r.OpportunityId, Quote__r.Opportunity.OwnerId, Quote__r.Opportunity.Partner_Account_Text__c, Quote__r.Opportunity.Primary_Contact__c, Quote__r.Opportunity.Partner_Account_Id__r.NH_SSE_Type__c, Account__c, Account__r.Multiple_Meters__c, Quote__r.Opportunity.Name, Quote__r.Opportunity.Partner_Account_Id__r.Channel__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id IN: newprojects.keyset() AND (Quote__r.Opportunity.Partner_Account_Text__c = 'SunPower Direct (SPD)' OR Quote__r.Opportunity.Partner_Account_Id__r.NH_SSE_Type__c INCLUDES ('TPS') OR Quote__r.Opportunity.Partner_Account_Id__r.Channel__c = 'Indirect')]){
				if(agg.Account__r.Multiple_Meters__c == TRUE || !projectOppMap.containsKey(agg.Quote__r.OpportunityId)){
					Residential_Project__c p = new Residential_Project__c();

					if(agg.Quote__r.Opportunity.Partner_Account_Text__c == 'SunPower Direct (SPD)') {
						p.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId();
					} else if(agg.Quote__r.Opportunity.Partner_Account_Id__r.Channel__c == 'Indirect') {
						p.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Indirect').getRecordTypeId();
					} else p.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();

					p.OwnerId = agg.Quote__r.Opportunity.OwnerId;
					p.Opportunity__c = agg.Quote__r.OpportunityId;
					p.Primary_Contact__c = agg.Quote__r.Opportunity.Primary_Contact__c;
					p.Name = agg.Quote__r.Opportunity.Name;
					p.Quote__c = agg.Quote__c;
					p.Account__c = agg.Account__c;
					p.Status__c = 'Active';
					p.Priority__c = 'Normal';
					projectInserts.add(p);
				}
			}
		}

		Map<Id, Contract> contractMap = new Map<Id, Contract>();
		if(!contractIds.isEmpty()) {
			for(Contract c : [SELECT Id, Status, Sent_Date__c, Signed_Date__c, Viewed_Date__c FROM Contract WHERE Id IN: contractIds AND Status != 'Activated']) {
				contractMap.put(c.Id, c);
			}
		}

		Map<Id, Account> acctDataMap = new Map<Id, Account>();
		if(!acctIds.isEmpty() || !approvedAccIds.isEmpty()) {
			for(Account a : [SELECT Id, DSE_IsCustomer__c, DSE_CustomerType__c,
													(SELECT Id, Approved__c, Status__c, Lease_Number__c , echosign_dev1__DateSignedDate__c FROM Agreements__r
														WHERE RecordTypeId =: Lease_2_1_PO_Creation__c.getValues('Counter Signature Info').Lien_Waiver_Id__c AND (Status__c = 'Signed' OR Approved__c = TRUE)),
													(SELECT Id, Uncond_Fin_LW_Rcvd__c, Uncond_Fin_LW_Approved__c, Lease__c FROM Lease_Payments__r
														WHERE Status__c = '' OR Status__c = 'Active')
												FROM Account
												WHERE (Id IN: acctIds AND DSE_IsCustomer__c != TRUE)

												OR Id IN: approvedAccIds]) {
				acctDataMap.put(a.Id, a);
			}
		}

		Map<Id, TPSSF__Document__c> docDataMap = new Map<Id, TPSSF__Document__c>();
		if(!oppIds.isEmpty()) {
			for(TPSSF__Document__c doc : [SELECT Id, Opportunity__c, Agreement_Status__c FROM TPSSF__Document__c WHERE Opportunity__c IN: oppIds]) {
				docDataMap.put(doc.Opportunity__c, doc);
			}
		}

		for(echosign_dev1__SIGN_Agreement__c agg : qualifiedAgreements.values()) {
			echosign_dev1__SIGN_Agreement__c oldAgg = oldAgreementMap.get(agg.Id);

			if(agg.echosign_dev1__Contract__c != null && contractMap.containsKey(agg.echosign_dev1__Contract__c)) {
				setContractStatusFromAgreement(agg, contractMap.get(agg.echosign_dev1__Contract__c));
			}

			if(agg.echosign_dev1__Status__c != oldAgg.echosign_dev1__Status__c) {
				if(agg.echosign_dev1__Status__c == 'Signed' && agg.Account__c != null) {
					if(!acctDataMap.isEmpty() && acctDataMap.containsKey(agg.Account__c)) {
						setAcctIsCustomer(acctDataMap.get(agg.Account__c));
					}
				}

				if(agg.Opportunity__c != null && !oppIds.isEmpty() && oppIds.contains(agg.Opportunity__c)) {
					if(!docDataMap.isEmpty() && docDataMap.containsKey(agg.Opportunity__c)) {
						TPSSF__Document__c doc = docDataMap.get(agg.Opportunity__c);
						if(doc.Agreement_Status__c != agg.echosign_dev1__Status__c) {
							doc.Agreement_Status__c = agg.echosign_dev1__Status__c;
							docsToUpdate.put(doc.Id, doc);
						}
					}
				}
			}

			if(agg.Account__c != null && approvedAccIds.contains(agg.Account__c)) {
				if(acctDataMap.containsKey(agg.Account__c)) {
					setLeasePaymentFields(agg, acctDataMap.get(agg.Account__c));
				}
			}
		}
	}

	public override void finish(Boolean fromStart) {
		if(fromStart) {
			if(!projectInserts.isEmpty()) insert projectInserts;

			if(!contractsToUpdate.isEmpty()) update contractsToUpdate.values();

			if(!acctsToUpdate.isEmpty()) update acctsToUpdate.values();

			if(!lpsToUpdate.isEmpty()) update lpsToUpdate.values();

			if(!futureStatusUpdateIds.isEmpty() && !System.isFuture()) FutureHandlerClass.checkSigned(futureStatusUpdateIds);
		}
		Diagnostics.pop();
	}

	private void setContractStatusFromAgreement(echosign_dev1__SIGN_Agreement__c agg, Contract cont) {
		if(agg.echosign_dev1__Status__c == 'Draft') {
			cont.Status = 'New';
		} else cont.Status = agg.echosign_dev1__Status__c;

		cont.Sent_Date__c = agg.echosign_dev1__DateSentDate__c;
		cont.Signed_Date__c = agg.echosign_dev1__DateSignedDate__c;
		cont.Viewed_Date__c = agg.echosign_dev1__DateViewedDate__c;
		contractsToUpdate.put(cont.Id, cont);
	}

	private void setAcctIsCustomer(Account acc) {
		acc.DSE_IsCustomer__c = true;
		acc.DSE_CustomerType__c = 'Lease';
		acc.DSE__DS_Synchronize__c = true;
		acctsToUpdate.put(acc.Id, acc);
	}

	private void setLeasePaymentFields(echosign_dev1__SIGN_Agreement__c agg, Account acc) {
		for(LeasePayment__c lp : acc.Lease_Payments__r)  {
			Boolean isUpdated = false;
			if(agg.Status__c == 'Signed' && agg.Lease_Number__c == lp.Lease__c && lp.Uncond_Fin_LW_Rcvd__c == null) {
				lp.Uncond_Fin_LW_Rcvd__c = agg.echosign_dev1__DateSignedDate__c;
				isUpdated = true;
			}
			if(agg.Approved__c == true && agg.Lease_Number__c == lp.Lease__c && lp.Uncond_Fin_LW_Approved__c == null) {
				lp.Uncond_Fin_LW_Approved__c = System.Today();
				isUpdated = true;
			}
			if(isUpdated) lpsToUpdate.put(lp.Id, lp);
		}
	}
}