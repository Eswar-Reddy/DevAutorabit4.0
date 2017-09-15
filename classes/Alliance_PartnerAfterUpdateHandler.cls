public class Alliance_PartnerAfterUpdateHandler extends TriggerHandlerBase{
    // -------- Constants --------
    Id papId = AlliancePartnerUtility.papId;
    Id capId = AlliancePartnerUtility.capId;

    // -------- Variables --------
    List<Id>                            communities;
    List<Id>                            partnerProject;
    List<Alliance_Partner__c>           lstAlliancePartner;
    List<Alliance_Partner__c>           finalPAList;
    List<Alliance_Partner__c>           apToInsert;
    List<Alliance_Partner__c>           spdPartners;
    Set<Id>                             aps4ICDs;
    Set<Id>								rpIds;
    Map<Id, Id>                         ipUpdate;

    // -------- Constructor --------
    public Alliance_PartnerAfterUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Alliance_PartnerAfterUpdateHandler qualifyStartingRecords');

        List<Alliance_Partner__c> newRecords        = (List<Alliance_Partner__c>)newList;
        Map<Id,Alliance_Partner__c> oldRecordMap    = (Map<Id, Alliance_Partner__c>)oldMap;
        Set<String> sTPSPartnerRole = new Set<String>{'IP','DRIP'};

        communities         = new List<Id>();
        partnerProject      = new List<Id>();
        finalPAList         = new List<Alliance_Partner__c>();
        apToInsert          = new List<Alliance_Partner__c>();
        lstAlliancePartner  = new List<Alliance_Partner__c>();
        spdPartners         = new List<Alliance_Partner__c>();
        aps4ICDs            = new Set<Id>();
        rpIds				= new Set<Id>();
        ipUpdate            = new Map<Id, Id>();

        for(Alliance_Partner__c ap : newRecords) {
            Alliance_Partner__c oldAP = oldRecordMap.get(ap.Id);
            // Community Alliance Partners
            if(ap.RecordTypeId == capId && ap.Community__c != NULL ) communities.add(ap.Community__c);

            // Project Alliance Partners
            if(ap.RecordTypeId == papId && ap.Residential_Project__c != NULL) {
                if(String.isNotBlank(ap.Residential_Project__c)) {
                    // TPS Alliance Partners
                    if(ap.Project_Record_Type__c == 'TPS'){
                        if(ap.Partner_Account__c != oldAP.Partner_Account__c) {
                            // If partner account added or changed, run user assignment
                            partnerProject.add(ap.Residential_Project__c);

                            // If alliance partner is IP or DRIP, update Opportunity Team Members
                            if(sTPSPartnerRole.contains(ap.Role__c)) lstAlliancePartner.add(ap);
                        }
                        // Check if all roles from installation model are now assigned, flag OppTeamComplete on project
                        if(oldAP.Partner_Account__c == NULL) finalPAList.add(ap);
                    }

                    // SPD Alliance Partners
                    if(ap.Project_Record_Type__c == 'SPD') {
                        // if partner changes run team member assignment
                        if(ap.Partner_Account__c != oldAP.Partner_Account__c) spdPartners.add(ap);

                        // If IP changed update Installation Partner field on project - this is a workaround until we can completely remove the Installation Partner field on the project record
                        if((ap.Role__c == 'IP' || ap.Role__c == 'Installation Partner') && ap.Partner_Account__c != oldAP.Partner_Account__c) ipUpdate.put(ap.Residential_Project__c, ap.Partner_Account__c);
                    }
                }
                // check to see if the partner or roll changed
                if(ap.Role__c != oldAP.Role__c || ap.Partner_Account__c != oldAP.Partner_Account__c) {
                	aps4ICDs.add(ap.Id);
                	// add rp id so we can run sharing logic
                	rpIds.add(ap.Residential_Project__c);
                }
            }
        }
        Diagnostics.pop();
    }

    public override void start() {
    	Diagnostics.push('Alliance_PartnerAfterUpdateHandler start');
        if(!communities.isEmpty()){
            // If Community Alliance Partners changed, delete existing Alliance Partners on related projects and recreate
            List<Alliance_Partner__c> aPartners = [SELECT Community__c, Role__c, Partner_Account__c, RecordTypeId FROM Alliance_Partner__c WHERE Community__c IN: communities];
            for(Residential_Project__c project : [SELECT Id, Community__c, RecordType.Name FROM Residential_Project__c WHERE Community__c IN: communities AND RecordType.Name = 'New Home' ]){
                for(Alliance_Partner__c ap : aPartners){
                    if(ap.Community__c == project.Community__c){
                        Alliance_Partner__c nap = new Alliance_Partner__c();
                        nap.RecordTypeId = papId;
                        nap.Role__c = ap.Role__c;
                        nap.Partner_Account__c = ap.Partner_Account__c;
                        nap.Residential_Project__c = project.Id;
                        apToInsert.add(nap);
                    }
                }
            }
        }
        Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
    	Diagnostics.push('Alliance_PartnerAfterUpdateHandler finish');
        if(fromStart) {
            // If Alliance Partner was assigned or reassigned, run user assignment on project
            if(!partnerProject.isEmpty())       AlliancePartnerUtility.IMUserAssignment(partnerProject);

            // Calling Function to update the OppTeamMember.
            if(!lstAlliancePartner.isEmpty())   AlliancePartnerUtility.finsertOppTeamMember('Update',lstAlliancePartner);

            // Check if all roles from installation model are now assigned, flag OppTeamComplete on project
            if(!finalPAList.isEmpty())          AlliancePartnerUtility.finalPAcheck(finalPAList);

            // if partner changed, run team memeber assignment for spd projects
            if(!spdPartners.isEmpty())          ResidentialProjectUtility.updateTeamRoles(spdPartners);

            // if role or partner changed update invoice compliance documents
            if(!aps4ICDs.isEmpty())             InvoiceComplianceDocumentUtility.setICDforAPs(aps4ICDs);

            // run ICD sharing logic with new alliance partners
            if(!rpIds.isEmpty())				InvoiceComplianceDocumentUtility.flagICDsForSharing(rpIds);

            // If IP changed update Installation Partner field on project - this is a workaround until we can completely remove the Installation Partner field on the project record
            if(!ipUpdate.isEmpty())             AlliancePartnerUtility.updateSPDIP(ipUpdate);

            if(!communities.isEmpty()) {
            	try {
	                // If community alliance partners changed, delete existing alliance partners on related projects and recreate
	                delete [SELECT Id FROM Alliance_Partner__c WHERE Residential_Project__r.Community__c IN: communities];
	                insert apToInsert;
	            }
	            catch(Exception e) {
	            	ExLog.log(e);
	            }
            }
        }
        Diagnostics.pop();
    }
}