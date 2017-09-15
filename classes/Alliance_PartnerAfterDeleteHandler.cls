public class Alliance_PartnerAfterDeleteHandler extends TriggerHandlerBase{
	// -------- Constants --------
	Id papId = AlliancePartnerUtility.papId;

	// -------- Variables --------
	List<Alliance_Partner__c>           apToInsert;
	List<Id>                            communities;
	List<Alliance_Partner__c>			lstAlliancePartner;
	Map<Id, Map<Id, String>>			apRPs;

	// -------- Constructor --------
	public Alliance_PartnerAfterDeleteHandler() {}

	//Begin processing
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('Alliance_PartnerAfterDeleteHandler qualifyStartingRecords');

		List<Alliance_Partner__c> oldRecords = (List<Alliance_Partner__c>)oldList;

		communities = new List<Id>();
		apToInsert = new List<Alliance_Partner__c>();
		lstAlliancePartner = new List<Alliance_Partner__c>();
		apRPs = new Map<Id, Map<Id, String>>();

		Set<String> sTPSPartnerRole = new Set<String>{'IP','DRIP'};

		for(Alliance_Partner__c ap : oldRecords){
			if(ap.Community__c != NULL ){
				communities.add(ap.Community__c);
			}

			if(ap.recordTypeId == papId) {
				if(ap.Project_Record_Type__c == 'TPS' && ap.Partner_Account__c <> null && sTPSPartnerRole.contains(ap.Role__c)){
					lstAlliancePartner.add(ap);
				}
				// add ap to map for invoce complicance doc assignments
				if(String.isNotBlank(ap.Residential_Project__c)) {
					apRPs.put(ap.Partner_Account__c, new Map<Id, String>{ap.Residential_Project__c => ap.Role__c});
				}
			}
		}
	}

	public override void start() {
		if(!communities.isEmpty()) {
			List<Alliance_Partner__c> aPartners = [SELECT Community__c, Role__c, Partner_Account__c, RecordTypeId FROM Alliance_Partner__c WHERE Community__c IN: communities];
			for(Residential_Project__c project : [SELECT Id, Community__c, RecordType.Name FROM Residential_Project__c WHERE Community__c IN: communities AND RecordType.Name = 'New Home' ]){
				for(Alliance_Partner__c ap : aPartners){
					if(ap.Community__c == project.Community__c){
						Alliance_Partner__c nap = new Alliance_Partner__c();
						nap.RecordTypeId = ap.RecordTypeId;
						nap.Role__c = ap.Role__c;
						nap.Partner_Account__c = ap.Partner_Account__c;
						nap.Residential_Project__c = project.Id;
						apToInsert.add(nap);
					}
				}
			}
		}

		// Calling function to delete the OppTeamMember.
		if(!lstAlliancePartner.isEmpty()) AlliancePartnerUtility.finsertOppTeamMember('Delete',lstAlliancePartner);

		// send map of deleted aps to the icd utility to update assignments
		if(!apRPs.isEmpty()) InvoiceComplianceDocumentUtility.updateICDs4DeletedAPs(apRPs);
	}

	public override void finish(Boolean fromStart) {
		if(fromStart) {
			delete [SELECT Id FROM Alliance_Partner__c WHERE Residential_Project__r.Community__c IN: communities];
			insert apToInsert;
		}

		Diagnostics.pop();
	}
}