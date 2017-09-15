public class AgreementBeforeInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------
	String CounterSignUserId = AgreementUtility.LeaseValsSettings.Contact_Counter_Signature_Id__c;
	String TermRecTypeId = AgreementUtility.LeaseValsSettings.Termination_Id__c;
	String AmendmentRecTypeId = AgreementUtility.LeaseValsSettings.Amendment_Id__c;
	string PartnerRecTypeId = AgreementUtility.LeaseValsSettings.Partner_Id__c;
	String LienWaiverRecTypeId = AgreementUtility.LeaseValsSettings.Lien_Waiver_Id__c;
	Id draftRecTypeId = AgreementUtility.draftRecTypeId;
	Id leaseRecTypeId = AgreementUtility.leaseRecTypeId;

	// -------- Constructor --------
	public AgreementBeforeInsertHandler() {}

	// -------- Variables --------

	// -------- Properties --------
	// Qualified records for actions
	private Map<Integer, echosign_dev1__SIGN_Agreement__c> qualifiedAgreements;

	//---------Sets for queries----
	public Set<Id> portalAgreementAccIds;
	public Set<Id> accIdsForContactMapping;

	//Begin processing
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('AgreementBeforeInsert qualifyStartingRecords');

		qualifiedAgreements = new Map<Integer, echosign_dev1__SIGN_Agreement__c>();
		portalAgreementAccIds = new Set<Id>();
		accIdsForContactMapping = new Set<Id>();

		List<echosign_dev1__SIGN_Agreement__c> newRecords = (List<echosign_dev1__SIGN_Agreement__c>)newList;

		//Begin processing records
		for(Integer i = 0; i < newRecords.size(); i++) {
            echosign_dev1__SIGN_Agreement__c agg = newRecords[i];

			if(String.isNotBlank(agg.Name) || String.isNotBlank(agg.Agreement_Name__c)) {//set rec type ids
				qualifiedAgreements.put(i, agg);
				if(String.isNotBlank(agg.Account__c) && String.isNotBlank(agg.Agreement_Name__c) && (agg.Agreement_Name__c.contains('Lien Waiver') || agg.Agreement_Name__c.contains('Lease Document'))) {
					portalAgreementAccIds.add(agg.Account__c); //set primary contact stuff
				}
			}
			if(agg.Created_By_Partner_Poratl_User__c == 'Y' && String.isNotBlank(agg.Account__c)) {
				qualifiedAgreements.put(i, agg);
				accIdsForContactMapping.add(agg.Account__c);
			}
		}
	}

	public override void start() {
		Map<Id, Account> accountData = new Map<Id, Account>();

		if(!portalAgreementAccIds.isEmpty() || !accIdsForContactMapping.isEmpty()) {
			accountData = new Map<Id, Account>([SELECT Id, Name, OwnerId,
														(SELECT Id, FirstName, LastName, Primary__c, Include_in_Lease_Doc__c
															FROM Contacts
															WHERE Include_in_Lease_Doc__c = true
															ORDER BY Primary__c DESC, CreatedDate ASC)
														FROM Account
														WHERE Id IN: portalAgreementAccIds
														OR Id IN: accIdsForContactMapping]);
		}
		//Process qualified records
		for(Integer i : qualifiedAgreements.keySet()) {
			echosign_dev1__SIGN_Agreement__c agg = qualifiedAgreements.get(i);

			setAgreementRecTypeByName(agg);

			if(agg.RecordTypeId == draftRecTypeId)
				AgreementUtility.setMessageFields(agg, 'Draft');
			if(agg.RecordTypeId == leaseRecTypeId)
				AgreementUtility.setMessageFields(agg, 'Lease');

			if(agg.Created_By_Partner_Poratl_User__c == 'Y' && !accountData.isEmpty() && accountData.containsKey(agg.Account__c)) {
				List<Contact> lstCon = accountData.get(agg.Account__c).Contacts;
				setAgreementContactData(agg, lstCon);
			}

			List<SenderUserAgreementRecordType__mdt> suagRecords = [SELECT RecordTypeId__c from SenderUserAgreementRecordType__mdt];
			Set<Id> agrSendUserRecIdSet = new Set<Id>();
			for(SenderUserAgreementRecordType__mdt suagr : suagRecords){
				agrSendUserRecIdSet.add(suagr.RecordTypeId__c);
			}

			if(agrSendUserRecIdSet != null && agrSendUserRecIdSet.contains(agg.RecordTypeId)){
				AgreementUtility.setAdobeSignFields(agg);
			}
		}
	}

	public override void finish(Boolean fromStart) {
		if(fromStart) {}
		Diagnostics.pop();
	}

	private void setAgreementRecTypeByName(echosign_dev1__SIGN_Agreement__c agg) {
		if(agg == null || (String.isBlank(agg.Name) && String.isBlank(agg.Agreement_Name__c))) return;

		String nameString = String.isNotBlank(agg.Name) ? agg.Name : agg.Agreement_Name__c;

		if(String.isBlank(nameString)) return;

		if(nameString.contains('Termination Doc')) {
			agg.RecordTypeId = TermRecTypeId;
			agg.echosign_dev1__Recipient3__c = CounterSignUserId;
		}
		else if(nameString.contains('Lien Waiver')) {
			agg.RecordTypeId = LienWaiverRecTypeId;
			agg.OwnerId = System.Label.Lien_Waiver_Agreement_Owner;
		}
		else if(nameString.contains('Amendment') && !nameString.contains('Master Dealer')) {
			agg.RecordTypeId = AmendmentRecTypeId;
			agg.echosign_dev1__Recipient3__c = CounterSignUserId;
		}
		else if(nameString.contains('Master Dealer')) { //Force the agreement record type to "Partner" when agreement name contains "Master Dealer"
			agg.RecordTypeId = PartnerRecTypeId;
		}
		else if(nameString.contains('Lease Document'))
			return;
		else
			System.debug('No match');
	}

	private void setAgreementContactData(echosign_dev1__SIGN_Agreement__c agg, List<Contact> lstCon) {
		if(agg == null || lstCon == null || lstCon.isEmpty()) return;

		Integer count = (lstCon.size() > 2) ? 2 : lstCon.size();
		for(Integer i = 0; i < count; i++) {
			if(lstCon[i].Primary__c == True) {
				agg.echosign_dev1__Recipient__c = lstCon[i].Id;
			}
			else {
				agg.echosign_dev1__Recipient2__c = lstCon[i].Id;
			}
		}
	}
}