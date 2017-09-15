/* **************************************************************************************
* Class Name     : Alliance_PartnerBeforeInserteHandler
* Version        : 1.0
* Created Date   : 13 feb 2017
* Function       : Function execute on Alliance_Partner before Insert

* Modification Log    :
* Developer             Date                   Description
* ----------------------------------------------------------------------------
* Ankit                 13 feb 2017         Original Version
*************************************************************************************/
public class Alliance_PartnerBeforeInsertHandler extends TriggerHandlerBase{
	// -------- Constants --------
	Id papId = AlliancePartnerUtility.papId;

	// -------- Variables --------
	Map<Id, List<Alliance_Partner__c>> mPartnerWithResProject;

	// -------- Constructor --------
	public Alliance_PartnerBeforeInsertHandler() {}

	//Begin processing
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('Alliance_PartnerAfterDeleteHandler qualifyStartingRecords');

		List<Alliance_Partner__c> newRecords = (List<Alliance_Partner__c>)newList;
		mPartnerWithResProject = new Map<Id, List<Alliance_Partner__c>> ();

		for(Alliance_Partner__c ap : newRecords) {
			// filtering the records for TPS IP Partners
			if(ap.RecordTypeId == papId && ap.Project_Record_Type__c == 'TPS' && ap.Role__c == 'IP') {
				if(!mPartnerWithResProject.Containskey(ap.Residential_Project__c))
					mPartnerWithResProject.put(ap.Residential_Project__c, new List<Alliance_Partner__c>{ap});
				}
			}
		}

	public override void start() {
		// Calling the function to assign the IP on Alliance Partner
		if(!mPartnerWithResProject.isEmpty()) {
			AlliancePartnerUtility.finsertIPPartnerForTPS(mPartnerWithResProject);
		}
	}

	public override void finish(Boolean fromStart) {
		Diagnostics.pop();
	}
}