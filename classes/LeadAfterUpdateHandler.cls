//cdevarapalli    11/03/2014    GetHealthy
//UPDATES: 
//BY:       Crystal - Redpoint 4/8/2015 - SPD
//COMMENTS: added logic to for new lead conversion process at the end of new ALR for Leads
public with sharing class LeadAfterUpdateHandler extends TriggerHandlerBase {
    // -------- Constants --------
     private static Set<String> spdIds = Utility_Lead.getSpdIds();//Case #00528317 - updated to only send specific failed leads back through ALR

    // -------- Constructor --------
    public LeadAfterUpdateHandler() {}

    // -------- Variables --------
    private List<Lead> leadListNew;

    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Lead> qualifiedLeads;
    private Set<Id> setAutoConvertLeads;
    private Set<Id> setCompaignLeads;
    private Set<Id> setAssignmentLeads;
    private Set<Id> setAutoStatusUpdateLeads;
    private List<Lead> competitionList;
    // private LeadDataContainer leadData;
    private Set<String> setPromoCode;
    private List<Lead> leadListToInsertLS;
    private Set<Id> leadIdSetToInsertLS;
    private Set<Id> leadIdToDeleteNALS;
    private Set<Id> leadIdToDeleteLS;
    private Set<Id> leadIDSetToInsertNALS;
    
    
    // records for final DML operations
    private Set<Id> resendToALR = new Set<Id>();
    private List<Lead> lstLeadForAutoConvert;
    private  List<CampaignMember> lstCampaignMember;
    private  List<Lead> lstLeadForAssignment;
    private  List<LeadShare> leadShareToBeInserted;
    private  List<LeadShare> leadShareToBeDeleted;
    private Set<Id> leadsForALR;
    
    // -------- Methods --------
    // Cast and determine qualified records for various field updates
    public override void qualifyStartingRecords(List<sObject> newList,
            List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        Diagnostics.push('LAU qualifyStartingRecords');

        List<Lead> newLeads = (List<Lead>)newList;
        leadListNew = newList;
        qualifiedLeads = new Map<Id, Lead>();

        setAutoStatusUpdateLeads = new Set<Id>();
        setAutoConvertLeads = new Set<Id>();
        setCompaignLeads    = new Set<Id>();
        setAssignmentLeads  = new Set<Id>();        
        leadListToInsertLS = new List<Lead>();
        leadIdSetToInsertLS = new Set<Id>();
        leadIdToDeleteNALS = new Set<Id>();
        leadIdToDeleteLS = new Set<Id>();
        leadIDSetToInsertNALS = new Set<Id>();
        competitionList = new List<Lead>();
        leadsForALR = new Set<Id>();
        
        // Code Block to set the value of the static variable to TRUE in context of the Lead Update i.e. Lead Conversion.
        If (newLeads[0].IsConverted) {
            util.setInContextOfLeadConversion();
        }

        ID leadRecordTypeId;

        //Lead RecordTypeId
        Map <String, ID> leadRecordTypes = new Map<String, ID>();
        // Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        // Map<Id,Schema.RecordTypeInfo> leadMapById = d.getRecordTypeInfosById();
        Map<Id, Schema.RecordTypeInfo> leadMapById = Leadmanagement.idToLeadRecordTypeInfoMap;
        for (ID i : leadMapById.keySet()) {
            leadRecordTypes.put(leadMapById.get(i).name, string.valueOf(i));
        }
        if (leadRecordTypes.get('Systems') != null) {
            leadRecordTypeId = leadRecordTypes.get('Systems');
        }

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
            
            //list for conversion
            if (!l.isConverted && l.IsAutoConvert__c == true) {
                
                // To avoid Marketing Qualified leads being converted : SPD leads should not pass for conversion
                if(l.Status != null && !String.ValueOf(l.Status).equalsIgnoreCase('Marketing Qualified')){
                    setAutoConvertLeads.add(l.Id);  
                    qualifiedLeads.put(l.Id, l);
                    System.debug('Added to conversion list');
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
            
            Map<Id, Lead> mapOldLeads = (Map<Id, Lead>)oldMap;
            // for assignment rule
            if (!util.isInContextOfLeadConversion() && (l.Status == 'Open' && mapOldLeads.containsKey(l.Id) && (mapOldLeads.get(l.Id).Status == 'Archived'
                            || mapOldLeads.get(l.Id).Status == 'Disqualified' || mapOldLeads.get(l.Id).Status == 'Nurture') ) ||
                (Util.currentUser.Web_User__c == True && !l.IsRuleRunForWebUser__c) ) {
                // map for the qualified lead
                qualifiedLeads.put(l.Id, l);
                setAssignmentLeads.add(l.Id);
            }
            
            //resend to ALR after manual assignment to assign owner and complete conversion
            //also sends manually assigned SPD leads through alr for partner competition and Five9 callout
            //collect leads qualified to go through new alr process
            //Scenario 1: Is now SPD lead, but wasn't before - needs Five9 callout
            //Scenario 2: Was unable to assign dealer, dealer manually set by internal user - needs assigned to owner and converted
            if(spdIds != null && !spdIDs.contains(l.Dealer_Locator_Selection__c) && l.Theater__c != null && !l.isConverted && l.RecordTypeId == Utility_Lead.ResidentialRecordTypeId && Utility_Lead.VALIDCOUNTRIES.contains(l.Theater__c)) {
                if((!l.isConverted && mapOldLeads.get(l.Id).Status != null && mapOldLeads.get(l.Id).Status != 'Marketing Qualified' && l.Status == 'Marketing Qualified' 
                   && l.Status != 'Disqualified' && l.Status != 'Awaiting Qualification Review' && l.Status != 'Awaiting Duplicate Review') || (l.Status == 'Ready for Assignment - EU Only')) {
                       System.debug('Lead Added to leadsForALR');
                       leadsForALR.add(l.Id); 
                   }
            }
             if(l.Theater__c == 'Europe' && l.Status != 'Ready for Assignment - EU Only') {//remove EU leads as they are pre qualified
                leadsForALR.remove(l.Id);
            }            

            // shareLeadRecordsAfterInsertAndUpdate
            // Utility_Lead.qualifyLeadForShare(l, LeadDataContainer data);
            Utility_Lead.qualifyLeadForShare(l, (Map<Id, Lead>)oldMap, leadIdSetToInsertLS,
                                             leadIdToDeleteLS, leadIdToDeleteNALS,
                                             leadIDSetToInsertNALS, leadListToInsertLS);

            if (l.Status == 'Qualified' && l.IsConverted == false && (l.status != ((Lead)oldMap.get(l.Id)).Status)
                    && l.RecordTypeId == leadRecordTypeId) {
                qualifiedLeads.put(l.Id, l);
            }

        }

        Diagnostics.pop();
    }

    // Start processing field changes and assignments
    public override void start() {

        Diagnostics.push('LeadAfterUpdateHandler start');        
        
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
      
        for (Id leadId : qualifiedLeads.keySet()) 
        {

            if (setAutoConvertLeads.contains(leadId)) 
            {
                lstLeadForAutoConvert.add(qualifiedLeads.get(leadId));
                System.debug(LoggingLevel.ERROR, 'Lead added to lstLeadForAutoConvert');
            }
            
            // business logic for set lead compain
            if ( setCompaignLeads.contains(leadId)) {
                //If Campaign exist for promo code
                if (!mapPromoCampaign.isEmpty() && mapPromoCampaign.containskey(qualifiedLeads.get(leadId).Promo_code__c)) {
                    CampaignMember m = new CampaignMember(leadID = qualifiedLeads.get(leadId).Id,
                                                          CampaignID = mapPromoCampaign.get(qualifiedLeads.get(leadId).Promo_code__c));
                    lstCampaignMember.add(m);
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

        Diagnostics.push('LeadAfterUpdateHandler finish');

        if (fromStart) {

            //LeadAutoConvert business logic
            if (lstLeadForAutoConvert != null && lstLeadForAutoConvert.size() > 0) {
                if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
                    DealerUtility.ScheduleLeadAutoConvert(lstLeadForAutoConvert);
                } else {
                    System.debug('# of Autoconvert leads going to bulk convert: ' + lstLeadForAutoConvert.size());
                    Utility_Lead.BulkConvert(lstLeadForAutoConvert);
                }
            }
            
            //Check if future call is possible
           if(leadsForALR != null && leadsForALR.size() > 0 && LeadDealerUtility.inReassignmentContext != true) { 
                if (LeadDealerUtility.CanUseFutureContext()){
                    System.debug(LoggingLevel.ERROR, '************Can Use Future for # of Leads After Update: ' + leadsForALR.size());
                    LeadDealerUtility.futureLeadAutoConvertSPD(leadsForALR);
                } else {
                    Id jobId = System.enqueueJob(new AsyncConvertLead(leadsForALR));
                }
            }

            if(Util.isSkipTrigger('LeadAfterInsertHandlerNonAutoConvert',null)){
                return;
            }

            if (lstCampaignMember != null && lstCampaignMember.size() > 0) {
                insert lstCampaignMember;
            }

            if (lstLeadForAssignment != null && lstLeadForAssignment.size() > 0) {
                update lstLeadForAssignment;
            }

            // The following two DMLs are used to replace the old trigger method
            // LeadManagement.shareLeadRecordsAfterInsertAndUpdate(Trigger.new, Trigger.oldMap);
            if (leadShareToBeDeleted != null && leadShareToBeDeleted.size() > 0)
                delete leadShareToBeDeleted;

            if (leadShareToBeInserted != null && leadShareToBeInserted.size() > 0)
                Database.SaveResult[] leadShareInsertResult = Database.insert(leadShareToBeInserted, false);

            Utility_Lead.after_Lead_Update(leadListNew);
            
            ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(leadListNew);

        }

        Diagnostics.pop();
    }


    // -------- Internal Classes --------
    // None
    // 
    
    
}