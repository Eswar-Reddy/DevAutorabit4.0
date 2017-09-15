public class Alliance_PartnerAfterInsertHandler extends TriggerHandlerBase{
    // -------- Constants --------
    Id papId = AlliancePartnerUtility.papId;

    // -------- Variables --------
    Map<Alliance_Partner__c, Id>        apCommunityId;
    List<Alliance_Partner__c>           apToInsert;
    List<Id>                            partnerProject;
    List<Alliance_Partner__c>           lstAlliancePartner;
    List<Alliance_Partner__c>           spdPartners;
    Set<Id>                             aps4ICDs;
    Set<Id>								rpIds;

    // -------- Constructor --------
    public Alliance_PartnerAfterInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Alliance_PartnerAfterInsertHandler qualifyStartingRecords');

        List<Alliance_Partner__c> newRecords = (List<Alliance_Partner__c>)newList;

        apCommunityId           = new Map<Alliance_Partner__c, Id>();
        apToInsert              = new List<Alliance_Partner__c>();
        partnerProject          = new List<Id>();
        lstAlliancePartner      = new List<Alliance_Partner__c>();
        spdPartners             = new List<Alliance_Partner__c>();
        aps4ICDs                = new Set<Id>();
        rpIds					= new Set<Id>();

        Set<String> sTPSPartnerRole = new Set<String>{'IP','DRIP'};

        for(Alliance_Partner__c ap : newRecords){
            if(String.isNotBlank(ap.Community__c)) apCommunityId.put(ap, ap.Community__c);

            if(ap.recordTypeId == papId) {
                if(String.isNotBlank(ap.Partner_Account__c)) {
                    if(ap.Project_Record_Type__c == 'TPS') {
                        if(sTPSPartnerRole.contains(ap.Role__c)) lstAlliancePartner.add(ap);
                        if(String.isNotBlank(ap.Residential_Project__c)) partnerProject.add(ap.Residential_Project__c);
                    }

                    // run team member assignment if it's an spd project
                    if(ap.Project_Record_Type__c == 'SPD') spdPartners.add(ap);
                }
                // check to see if the ap has a partner and role
                if(String.isNotBlank(ap.Residential_Project__c) && String.isNotBlank(ap.Role__c) && String.isNotBlank(ap.Partner_Account__c)) {
                	aps4ICDs.add(ap.Id);
                	// add rp id so we can run sharing logic
                	rpIds.add(ap.Residential_Project__c);
                }
            }
        }
        Diagnostics.pop();
    }

    public override void start() {
    	Diagnostics.push('Alliance_PartnerAfterInsertHandler start');
        if(!apCommunityId.isEmpty()) {
            for(Residential_Project__c rp : [SELECT Id, Community__c FROM Residential_Project__c WHERE Community__c IN: apCommunityId.values() AND (Status__c = 'Hold' OR Status__c = 'Active')]){
                for(Alliance_Partner__c ap : apCommunityId.keyset()){
                    if(ap.Community__c == rp.Community__c){
                        Alliance_Partner__c nap = new Alliance_Partner__c();
                        nap.RecordTypeId = papId;
                        nap.Role__c = ap.Role__c;
                        nap.Partner_Account__c = ap.Partner_Account__c;
                        nap.Residential_Project__c = rp.Id;
                        apToInsert.add(nap);
                    }
                }
            }
        }
        Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
    	Diagnostics.push('Alliance_PartnerAfterInsertHandler finish');
        if(fromStart) {
            // If alliance partner was assignment, run user assignment on project
            if(!partnerProject.isEmpty())       AlliancePartnerUtility.IMUserAssignment(partnerProject);

            // Calling the function to insert the Opportunity Team Member
            if(!lstAlliancePartner.isEmpty())   AlliancePartnerUtility.finsertOppTeamMember('Insert', lstAlliancePartner);

            // run team member assignments for new ap's on spd projects
            if(!spdPartners.isEmpty())          ResidentialProjectUtility.updateTeamRoles(spdPartners);

            // if role or partner changed update invoice compliance documents
            if(!aps4ICDs.isEmpty())             InvoiceComplianceDocumentUtility.setICDforAPs(aps4ICDs);

            // run ICD sharing logic with new alliance partners
            if(!rpIds.isEmpty())				InvoiceComplianceDocumentUtility.flagICDsForSharing(rpIds);

            try {
            	insert apToInsert;
            }
            catch(Exception e) {
            	ExLog.log(e);
            }
        }
        Diagnostics.pop();
    }
}