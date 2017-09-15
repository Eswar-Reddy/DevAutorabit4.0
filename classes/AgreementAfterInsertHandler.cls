public class AgreementAfterInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------

	// -------- Constructor --------
	public AgreementAfterInsertHandler() { }

	// -------- Variables --------

	// -------- Properties --------
	// Qualified records for actions
	private Map<Id, echosign_dev1__SIGN_Agreement__c> qualifiedAgreements;
	Map<ID, echosign_dev1__SIGN_Agreement__c> newAgreementMap;

	//---------Sets for queries----
	public Set<Id> contractIds;
	public Set<Id> oppIds;
	public Set<Id> idsForFutureHandler;

	//DML Collections
	public Map<Id, Contract> contractsToUpdate;
	public Map<Id, TPSSF__Document__c> docsToUpdate;
	public Set<Id> fpoOppSet;

	//Begin Evaluation
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('AgreementAfterInsert qualifyStartingRecords');

		newAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)newMap;
		qualifiedAgreements = new Map<Id, echosign_dev1__SIGN_Agreement__c>();
		contractIds = new Set<Id>();
		oppIds = new Set<Id>();
		idsForFutureHandler = new Set<Id>();
		fpoOppSet = new Set<Id>();
		contractsToUpdate = new Map<Id, Contract>();
		docsToUpdate = new Map<Id, TPSSF__Document__c>();

		//Begin processing records
		for(Id i : newAgreementMap.keySet()) {
			echosign_dev1__SIGN_Agreement__c agg = newAgreementMap.get(i);

			if(agg.echosign_dev1__Contract__c != null){
				contractIds.add(agg.echosign_dev1__Contract__c);
				qualifiedAgreements.put(i, agg);
			}

			if(agg.RecordTypeId == AgreementUtility.leaseRecTypeId && agg.Opportunity__c != null) {
				oppIds.add(agg.Opportunity__c);
				qualifiedAgreements.put(i, agg);
			}

			if(agg.echosign_dev1__Status__c == 'Draft' && agg.Quote__c != null) idsForFutureHandler.add(i);

			if((agg.echosign_dev1__Status__c=='Signed' || agg.echosign_dev1__Status__c=='Waiting for Counter-signature') && agg.Opportunity__c != null){
				fpoOppSet.add(agg.Id);
			}
		}
	}

	public override void start() {
		//Update Opportunity Deal Type
		if(!fpoOppSet.isEmpty()) AgreementUtility.UpdateOppurtunutyDealType(fpoOppSet);

		Map<Id,Contract> contractMap = new Map<Id,Contract>();
		if(!contractIds.isEmpty()) {
			contractMap = new Map<Id, Contract>([SELECT Id, Status, Sent_Date__c, Signed_Date__c, Viewed_Date__c
												 FROM Contract WHERE Id IN: contractIds AND Status != 'Activated']);
		}

		Map<Id, TPSSF__Document__c> docDataMap = new Map<Id, TPSSF__Document__c>();
		if(!oppIds.isEmpty()) {
			for(TPSSF__Document__c doc : [SELECT Id, Opportunity__c, Agreement_Status__c FROM TPSSF__Document__c WHERE Opportunity__c IN: oppIds]) {
						  docDataMap.put(doc.Opportunity__c, doc);
			}
		}

		for(Id i : qualifiedAgreements.keySet()) {
			echosign_dev1__SIGN_Agreement__c agg = qualifiedAgreements.get(i);

			if(agg.echosign_dev1__Contract__c != null && contractMap.containsKey(agg.echosign_dev1__Contract__c)) {
				setContractStatusFromAgreement(agg, contractMap.get(agg.echosign_dev1__Contract__c));
			}

			if(String.isNotBlank(agg.Opportunity__c) && !oppIds.isEmpty() && oppIds.contains(agg.Opportunity__c)) {
				if(!docDataMap.isEmpty() && docDataMap.containsKey(agg.Opportunity__c)) {
					TPSSF__Document__c doc = docDataMap.get(agg.Opportunity__c);
					if(doc.Agreement_Status__c != agg.echosign_dev1__Status__c) {
						doc.Agreement_Status__c = agg.echosign_dev1__Status__c;
						docsToUpdate.put(doc.Id, doc);
					}
				}
			}
		}
	}

	public override void finish(Boolean fromStart) {
		if(fromStart) {
			if(!contractsToUpdate.isEmpty()) update contractsToUpdate.values();

			if(!docsToUpdate.isEmpty()) update docsToUpdate.values();

			if(!idsForFutureHandler.isEmpty() && !System.isFuture()) FutureHandlerClass.CheckSigned(idsForFutureHandler);

			//call future to create record sharing
			if(!System.isFuture()) AgreementRecordSharingnew.futureAgreementSharing(newAgreementMap.keySet());
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
}