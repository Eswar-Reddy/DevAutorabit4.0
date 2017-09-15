public with sharing class LeadAfterInsertHandler extends TriggerHandlerBase {
    // -------- Constants --------
    // None

    // -------- Constructor --------
    public LeadAfterInsertHandler() {}

    // -------- Variables --------
    private List<Lead> leadListNew;

    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Lead> qualifiedLeads;
    private Set<Id> setAutoConvertLeads;
    private Set<Id> setCompaignLeads;
    private Set<Id> setAssignmentLeads;

    // private LeadDataContainer leadData;
    private Set<String> setPromoCode;
    private List<Lead> leadListToInsertLS;
    private Set<Id> leadIdSetToInsertLS;
    private Set<Id> leadIdToDeleteNALS;
    private Set<Id> leadIdToDeleteLS;
    private Set<Id> leadIDSetToInsertNALS;
    private Set<Id> leadsForALR;

    // The final records for DML operations
    private Set<Lead> leadSetForALR;
    private  List<Lead> lstLeadForAutoConvert;
    private  List<CampaignMember> lstCampaignMember;
    private  List<Lead> lstLeadForAssignment;
    private  List<LeadShare> leadShareToBeInserted;
    private  List<LeadShare> leadShareToBeDeleted;

    // -------- Methods --------
    // Cast and determine qualified records for various field updates
    public override void qualifyStartingRecords(List<sObject> newList,
            List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        Diagnostics.push('LAI qualifyStartingRecords');

        leadsForALR = new Set<Id>();
        leadListNew = newList;
        qualifiedLeads = new Map<Id, Lead>();
        setAutoConvertLeads = new Set<Id>();
        setCompaignLeads    = new Set<Id>();
        setAssignmentLeads  = new Set<Id>();

        leadListToInsertLS = new List<Lead>();
        leadIdSetToInsertLS = new Set<Id>();
        leadIdToDeleteNALS = new Set<Id>();
        leadIdToDeleteLS = new Set<Id>();
        leadIDSetToInsertNALS = new Set<Id>();

        List<Lead> newLeads = (List<Lead>)newList;
        //Prepare set of promocdes of lead and set of leadIDs
        setPromoCode = new Set<String>();

        //Prepare set of lead which has campaign
        Set<String> setLeadWithCampaign = new Set<String>();
        for (CampaignMember camp : [Select id, leadID from CampaignMember where LeadID in
                                    :newMap.keySet() ]) {
            setLeadWithCampaign.Add(camp.leadID);
        }

        for (Integer i = 0; i < newLeads.size(); i++) {
            Lead l = newLeads[i];

            //collect leads qualified to go through new alr process            
            if(l.Theater__c != null && !l.isConverted && l.RecordTypeId == Utility_Lead.ResidentialRecordTypeId && Utility_Lead.VALIDCOUNTRIES.contains(l.Theater__c) 
               && l.Status != 'Disqualified' && l.Status != 'Awaiting Qualification Review' && l.Status != 'Awaiting Duplicate Review') {
                leadsForALR.add(l.Id);
                qualifiedLeads.put(l.Id, l);
                System.debug(logginglevel.ERROR,'lead added for ALR: ' + leadsForALR.size());
            }

            if(l.Theater__c == 'Europe' && l.Status != 'Ready for Assignment - EU Only') {
                leadsForALR.remove(l.Id);
                System.debug('Removing EU: ' + leadsForAlr.size());
            }
            if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
                if (l.isConverted == false && l.IsAutoConvert__c == true) {
                    // map for the qualified lead
                    qualifiedLeads.put(l.Id, l);
                    // set for business logic of converting leads
                    setAutoConvertLeads.add(l.Id);
                }
            }
            // for validation logic
            if (!util.byPassValidation() && !util.byPassLeadValidation() &&
                    (l.RecordTypeId != null && l.RecordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Systems').getRecordTypeId())) {
                // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
                // if (l.BU__c != null && (l.BU__c == 'NA Commercial' || l.BU__c ==  'IBD' || l.BU__c == 'Components' || l.BU__c == 'RLC') && currentUser.id != '00580000002hsak'){//for case#00067713 //l.BU__c == 'UPP Intl' ||
                if (l.BU__c != null && (l.BU__c == 'NA Commercial' || l.BU__c == 'UPP Intl' || l.BU__c == 'RLC') &&
                        (UserInfo.getUserId()  != '00580000002hsak' || UserInfo.getUserId()  != '00580000003Xwxw')) { //{for case#00067713 //l.BU__c == 'UPP Intl' ||}  //{for case#00135965 // currentUser.id != '00580000003Xwxw'||}
                    if (l.Rating == null || l.Rating == '')
                        l.Rating.addError('Rating is required');
                }
            }

            // for set compaign logic
            if (l.Promo_Code__c != null && l.Promo_Code__c != '') {
                setPromoCode.Add(l.Promo_Code__c);
            }

            //Save campaignID according to Campaign_Temp__c of lead
            if (!setLeadWithCampaign.contains(l.Id) && l.Id != null) {
                // map for the qualified lead
                qualifiedLeads.put(l.Id, l);
                setCompaignLeads.add(l.Id);
            }

            // for assignment rule
            if (Util.currentUser.Web_User__c == True && !l.IsRuleRunForWebUser__c) {
                // map for the qualified lead
                qualifiedLeads.put(l.Id, l);
                setAssignmentLeads.add(l.Id);
            }

            // shareLeadRecordsAfterInsertAndUpdate
            // Utility_Lead.qualifyLeadForShare(l, LeadDataContainer data);
            Utility_Lead.qualifyLeadForShare(l, (Map<Id, Lead>)oldMap, leadIdSetToInsertLS,
                                             leadIdToDeleteLS, leadIdToDeleteNALS,
                                             leadIDSetToInsertNALS, leadListToInsertLS);

            
        }

        Diagnostics.pop();
    }

    // Start processing field changes and assignments
    public override void start() {

        Diagnostics.push('LeadAfterInsert start');

        lstLeadForAutoConvert  = new List<Lead>();
        lstLeadForAssignment = new List<Lead>();

        //list of CampaignMember to insert
        lstCampaignMember = new List<CampaignMember>();
        map<String, String> mapPromoCampaign = new Map<String, String>();

        if (!setCompaignLeads.isEmpty() && !setPromoCode.isEmpty()) {
            //Prepare map of promocode with campaigns
            
            for (Campaign camp : [Select id, Promo_Code__c from Campaign where Promo_Code__c in
                                  :setPromoCode ]) {
                mapPromoCampaign.put(camp.Promo_Code__c, camp.id);
            }
        }

        //SetDealerAccountName(leadList);
        for (Id leadId : qualifiedLeads.keySet()) {
            
            // business logic for lead auto convert
            if ( setAutoConvertLeads.contains(leadId)) {
                lstLeadForAutoConvert.add(qualifiedLeads.get(leadId));
            }

            // business logic for set lead compain
            if(setCompaignLeads.contains(leadId)) {
                //If Campaign exist for promo code
                if(!mapPromoCampaign.isEmpty() && mapPromoCampaign.containskey(qualifiedLeads.get(leadId).Promo_code__c)) {
                    CampaignMember m = new CampaignMember(leadID = qualifiedLeads.get(leadId).Id,
                                                          CampaignID = mapPromoCampaign.get(qualifiedLeads.get(leadId).Promo_code__c));
                    lstCampaignMember.Add(m);
                }
            }

            // Business logic : doCallAssignmentRule
            if (setAssignmentLeads.contains(leadId)) {

                database.DMLOptions dmo = new database.DMLOptions();
                dmo.AssignmentRuleHeader.UseDefaultRule = true;

                //Current UserId Profile; *** Updated as per Connect5 Requirement ***
                User userStatus = Util.currentUser;

                Lead newLead = new Lead(Id = leadId);
                newLead.IsRuleRunForWebUser__c = userStatus.Web_User__c == True ? true : qualifiedLeads.get(leadId).IsRuleRunForWebUser__c;
                newLead.setOptions(dmo);
                lstLeadForAssignment.add(newLead);
            }

        }

        // shareLeadRecordsAfterInsertAndUpdate
        // Utility_Lead.qualifyLeadForShare(l, LeadDataContainer data);
        Utility_Lead.processLeadForShare(leadListNew, leadIdSetToInsertLS, leadIdToDeleteLS, leadIdToDeleteNALS,
                                         leadIDSetToInsertNALS, leadListToInsertLS,
                                         leadShareToBeDeleted, leadShareToBeInserted);

        Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {

        Diagnostics.push('LeadAfterInsert finish');

        if (fromStart) {
           
            if (lstCampaignMember != null && lstCampaignMember.size() > 0) {
                insert lstCampaignMember;
            }

                if( !leadsForALR.isEmpty()){
                    if (LeadDealerUtility.CanUseFutureContext()){
                        System.debug(LoggingLevel.ERROR, '************Can Use Future for # of Leads: ' + leadsForALR.size());
                        LeadDealerUtility.futureLeadAutoConvertSPD(leadsForALR);
                    } else {
                        Id jobId = System.enqueueJob(new AsyncConvertLead(leadsForALR));
                    }
                }

            // All the following business logic is skipped based on user Id
            //if (UserInfo.getUserId() == '00580000003XtZw' || UserInfo.getUserId() == '00580000003Xtm2' || UserInfo.getUserId() == '00580000003XrG4') {
             if(Util.isSkipTrigger('LeadAfterInsertHandlerNonAutoConvert',null)){
                return;
            }

/*            if (lstCampaignMember != null && lstCampaignMember.size() > 0) {
                insert lstCampaignMember;
            }*/

            if (lstLeadForAssignment != null && lstLeadForAssignment.size() > 0) {
                update lstLeadForAssignment;
            }

            // The following two DMLs are used to replace the old trigger method
            // LeadManagement.shareLeadRecordsAfterInsertAndUpdate(Trigger.new, Trigger.oldMap);
            if (leadShareToBeDeleted != null && leadShareToBeDeleted.size() > 0)
                delete leadShareToBeDeleted;

            if (leadShareToBeInserted != null && leadShareToBeInserted.size() > 0)
                Database.SaveResult[] leadShareInsertResult = Database.insert(leadShareToBeInserted, false);

            ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(leadListNew);
        }

        Diagnostics.pop();
    }
    // -------- Internal Classes --------
    // None
}