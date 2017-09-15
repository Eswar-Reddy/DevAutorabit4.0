/*========================================================================================================================================================
    Date                Last Modified By                Comment         
========================================================================================================================================================
  3-24-2015             Niket Chandane                  ALR for Lead Dealer Assignment
  10/7/2015				Crystal							Updated to add Warm Transfer functionality
  08/11/2015			Debasish						#121540093 - Lead Routing logic should not favor master dealers
														Updated buildDealerListRaw() [Master Dealer Priority Assignment]
*/
public with sharing class LeadDealerUtility{
    
    /************** Static Variable ******************/
    public static Boolean isALREnabled      = ALRConfiguration.isALREnabled();       
    public static String REC_RESIDENTIAL    = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
    public static String DEALERASSIGNMENT   = 'Dealer Assignment ';
    public static String DLER_ASG_REASON_DEALERLOCATOR   = 'Dealer Locator';
    public static Boolean inReassignmentContext = false;
    private static List<SpectrumDebugUtility.debugLog> debuglogs = new List<SpectrumDebugUtility.debugLog>();    
	public static Boolean SPDAlrTestSwitch = false;
	public static Boolean userIsSAProfile = UserInfo.getProfileId() == SFDCSpecialUtilities.getProfileIdByName('Solar Advisor');    
    public static List<Messaging.SingleEmailMessage> alertEmails = new List<Messaging.SingleEmailMessage>();
    
    /**************************************************************************************************************************************************************
        Function : configureLeadDealerAssignmentAudit
        Summary  : function configures Dealer Assignment audit
    ***************************************************************************************************************************************************************/
    public static Lead_Dealer_Assignment_Audit__c configureLeadDealerAssignmentAudit(string Name, Id AccountId, Id LeadId, String Reason, String RuleApplied, Id campaignId) {
        Lead_Dealer_Assignment_Audit__c daa = new Lead_Dealer_Assignment_Audit__c();
        daa.Name                            = Name;
        daa.Dealer_Assigned__c              = AccountId;
        daa.Lead__c                         = LeadId;
        daa.Reason__c                       = Reason;
        daa.ALR_Rule_Applied__c             = RuleApplied;
        daa.Assignment_Date__c              = System.today();
        if(campaignId != null)
        	daa.Campaign__c = campaignId; 
        return daa;
    }
    
    @future(callout=true)
    public static void futureLeadAutoConvertSPD(Set<Id> setLeadId)
    {
        if(setLeadId == null || setLeadId.isEmpty()) return;
        ReferralManagementCallout.inBatchContext = true;
        map<Id,LeadAssignmentWrapper> mapLeadIdVsDealerResult = new map<Id,LeadAssignmentWrapper>();    // Storing Lead Vs Dealer Assignment Result
        map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();                                // Storing Lead Vs Lead Dealer Assignment Count
        list<Lead> lstSPDLead = new list<Lead>();                                                       // Storing SPD Lead
        List<LeadAssignmentWrapper> leadObjsForFive9 = new List<LeadAssignmentWrapper>();
        
        /*=== gather lead and previously assigned dealer information ===*/
        List<Lead> lstLead = DealerSOQLUtil.getLeadbyId(setLeadId);
        mapLeadDealerAssignment = DealerSOQLUtil.GetPreviouslyAssignedDealersCount(SetLeadId);
        
        /*=== getting the geolocation from Google via HTTP callout ===*/
        /*=== we can not do more than 100 http callout in single Context ===*/
        Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap = getLeadGeoInfo(lstLead);
        
        //filtering out valid/invalid leads based on geo response to be passed for competing partner indicator code and assignment
        LeadAssignmentWrappInfo objLeadAsgnWrappInfo = distributeValidLeadInfo(leadGeoMap);
        
        //Pass the list - objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper and get same list with updating the competing partner indicator code
        objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper = ALRConfiguration.calculateCompetition(objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper);
        
        // Pass the lead information for Dealer Assignment
        mapLeadIdVsDealerResult = AutoAssignLead(objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper);
        
        //distributeValidLeadInfo
        for(Id leadId : mapLeadIdVsDealerResult.keySet()){
            LeadAssignmentWrapper leadInfo = mapLeadIdVsDealerResult.get(leadId);
            
            if(leadInfo.isSPD != null && leadInfo.isSPD){
                //lstSPDLead.add(leadInfo.lead);
                leadObjsForFive9.add(leadInfo);
            }
        }

        // Five 9 call out for SPD leads
        //if(!lstSPDLead.isEmpty()){
        if(!leadObjsForFive9.isEmpty()) {
            //map<Lead,F9Web2CampaignResult> mapF9Web2CampaignResult = ALRConfiguration.callfive9forSPDLead(lstSPDLead);
            Map<Lead, F9Web2CampaignResult> mapF9Web2CampaignResult = ALRConfiguration.callfive9forSPDLead(leadObjsForFive9);
            
            if(!mapF9Web2CampaignResult.isEmpty()){
                for(LeadAssignmentWrapper objLeadInfo : objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper){
                    if(mapF9Web2CampaignResult.ContainsKey(objLeadInfo.lead))
                        objLeadInfo.lead.Sent_to_Five9__c = true;
                }
            }
        }
        
        //DML Operations
        try {
            UpdateLeadInformation(objLeadAsgnWrappInfo);
        } catch(Exception e) {
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = e.getMessage();
            log.Stack_Trace__c = e.getStackTraceString();
            insert log;
        }
    }
    
    //methods for assign new dealer feature
    public static void leadReassignment(Set<Id> setLeadId)
    {
        
        if(setLeadId == null || setLeadId.isEmpty()) return;
        ReferralManagementCallout.inBatchContext = true;
        Util.setInContextOfLeadConversion();
        
        map<Id,LeadAssignmentWrapper> mapLeadIdVsDealerResult = new map<Id,LeadAssignmentWrapper>();    // Storing Lead Vs Dealer Assignment Result
        map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();                                // Storing Lead Vs Lead Dealer Assignment Count
        list<Lead> lstSPDLead = new list<Lead>();                                                       // Storing SPD Lead
        List<LeadAssignmentWrapper> leadObjsForFive9 = new List<LeadAssignmentWrapper>();
        // get Lead 
        List<Lead> lstLead = DealerSOQLUtil.getLeadbyIdforReassignment(setLeadId);
        
        // getting the geolocation from Google via HTTP callout 
        Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap = getLeadGeoInfo(lstLead);
        
        //filtering only valid leads for the Opportunity Competing Colour code
        LeadAssignmentWrappInfo objLeadAsgnWrappInfo = distributeValidLeadInfo(leadGeoMap);
        
        // Pass the lead information for Dealer Assignment/Reassignment
        mapLeadIdVsDealerResult = reassignAssignLead(objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper);
        
		//Distribute Lead info and pass to Five9 list
        for(Id leadId : mapLeadIdVsDealerResult.keySet()){
            LeadAssignmentWrapper leadInfo = mapLeadIdVsDealerResult.get(leadId);
            
            if(leadInfo.isSPD != null && leadInfo.isSPD){
                leadObjsForFive9.add(leadInfo);
            }
        }

        // Five 9 call out for SPD leads
        if(!leadObjsForFive9.isEmpty() && userIsSAProfile != true) {//CRYSTAL - added skip for Solar Advisors as the have no need to resend to Five9 if they already called
            Map<Lead, F9Web2CampaignResult> mapF9Web2CampaignResult = ALRConfiguration.callfive9forSPDLead(leadObjsForFive9);
            if(!mapF9Web2CampaignResult.isEmpty()){
                for(LeadAssignmentWrapper objLeadInfo : objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper){
                    if(mapF9Web2CampaignResult.ContainsKey(objLeadInfo.lead))
                        objLeadInfo.lead.Sent_to_Five9__c = true;
                }
            }
        }
        
        //DML Operations
        try {
           UpdateLeadInformation(objLeadAsgnWrappInfo);
        } catch(Exception e) {
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = e.getMessage();
            log.Stack_Trace__c = e.getStackTraceString();
            insert log;
        }
    }
    
    /*
        Method      : futureLeadAutoConvert
        Parameter   : Set<Id> lstLeadId
        Summary     : Method get's called by trigger (After Lead Insert)
    */
    //for queueable method
    public static void futureLeadAutoConvert(Set<Id> setLeadId){
        if(setLeadId == null || setLeadId.isEmpty()) return;
        
        map<Id,LeadAssignmentWrapper> mapLeadIdVsDealerResult = new map<Id,LeadAssignmentWrapper>();    // Storing Lead Vs Dealer Assignment Result
        map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();                        // Storing Lead Vs Lead Dealer Assignment Count
        list<Lead> lstSPDLead = new list<Lead>();
        List<LeadAssignmentWrapper> leadObjsForFive9 = new List<LeadAssignmentWrapper>();
        
        // get google geo location by using google API 
        List<Lead> lstLead = DealerSOQLUtil.getLeadbyId(setLeadId);
        
        if(lstLead.isEmpty()) return;
        
        mapLeadDealerAssignment = DealerSOQLUtil.GetPreviouslyAssignedDealersCount(SetLeadId);
        
        // getting the geolocation from Google via HTTP callout 
        /*================ we can not do more than 10 http callout in single Context ===============================*/
        Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap = getLeadGeoInfo(lstLead);
        
        //filtering only valid leads for the Opportunity Competing Colour code
        LeadAssignmentWrappInfo objLeadAsgnWrappInfo = distributeValidLeadInfo(leadGeoMap);
        
        // TODO : pass the list = objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper and get same list with updating the clr code
        objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper = ALRConfiguration.calculateCompetition(objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper);
        
        // Pass the Valid lead information for Dealer Assignment
        mapLeadIdVsDealerResult = AutoAssignLead(objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper);
        
        for(Id leadId : mapLeadIdVsDealerResult.keySet()){
            LeadAssignmentWrapper leadInfo = mapLeadIdVsDealerResult.get(leadId);
            
            if(leadInfo.isSPD != null && leadInfo.isSPD){
                //lstSPDLead.add(leadInfo.lead);
                leadObjsForFive9.add(leadInfo);
            }
        }
        
        // Five 9 call out for SPD leads
        //if(!lstSPDLead.isEmpty()){
        if(!leadObjsForFive9.isEmpty()) {
            //map<Lead,F9Web2CampaignResult> mapF9Web2CampaignResult = ALRConfiguration.callfive9forSPDLead(lstSPDLead);
            Map<Lead, F9Web2CampaignResult> mapF9Web2CampaignResult = ALRConfiguration.callfive9forSPDLead(leadObjsForFive9);
            if(!mapF9Web2CampaignResult.isEmpty()){
                for(LeadAssignmentWrapper objLeadInfo : objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper){
                    if(mapF9Web2CampaignResult.ContainsKey(objLeadInfo.lead))
                        objLeadInfo.lead.Sent_to_Five9__c = true;
                }
            }
        }
        
        //DML Operations
        UpdateLeadInformation(objLeadAsgnWrappInfo);
        
        //if not -> convert
    }
    
    /****************************************************************************************************************************************************
        Method      : reassignAssignLead
        Parameter   : list<LeadAssignmentWrapper> lstLeadAssignmentWrapper
        Return Type : map<Id,LeadAssignmentWrapper>
        Summary     : This function is basically for lead reassignment
    *****************************************************************************************************************************************************/
   public static map<Id,LeadAssignmentWrapper> reassignAssignLead(list<LeadAssignmentWrapper> lstLeadAssignmentWrapper){
        
        inReassignmentContext = true;
        map<Id,LeadAssignmentWrapper> mapLeadIdVsDealerResult = new map<Id,LeadAssignmentWrapper>();
        set<Id> SetLeadId = new Set<Id>();
        
        if(lstLeadAssignmentWrapper == null || lstLeadAssignmentWrapper.isEmpty()) return mapLeadIdVsDealerResult;
        
        try{
            // Update Campaign Information 
            lstLeadAssignmentWrapper = updateCampaignInformation(lstLeadAssignmentWrapper);
            list<DealerResult> listDealersRaw = new list<DealerResult>();
                
            list<Lead_Dealer_Assignment_Audit__c> listPrevious = new list<Lead_Dealer_Assignment_Audit__c>();
            
            map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();
            set<String> setDealerLocator = new set<String>();
            
            // Validate Lead Information is entitled for ALR , its update the Dealer_Assignment_Status__c field accordingly
            lstLeadAssignmentWrapper = ALRConfiguration.isLeadValidforALR(lstLeadAssignmentWrapper);
            Id leadId;
            // If lead valid as per ALR configuration.
            for(LeadAssignmentWrapper objLeadInfo : lstLeadAssignmentWrapper){
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('***Begin Assign New Dealer Function***');
                SetLeadId.add(objLeadInfo.lead.Id);
                
                leadId = objLeadInfo.lead.Id;

                if(objLeadInfo.lead.Dealer_Locator_Selection__c != null || objLeadInfo.lead.Dealer_Name__c != null)
                    setDealerLocator.add(objLeadInfo.lead.Dealer_Locator_Selection__c == null ? objLeadInfo.lead.Dealer_Name__c : objLeadInfo.lead.Dealer_Locator_Selection__c);
                
                if(!objLeadInfo.isValid)
                    objLeadInfo.lead.Status = 'Failed Conversion';
            }
            
            mapLeadDealerAssignment = DealerSOQLUtil.GetPreviouslyAssignedDealersCount(SetLeadId);
           
            // Special Dealers : 
            map <Id, Account> mapPredealer = DealerSOQLUtil.getDealerByNameOrId(setDealerLocator);
            
            /************************ Dealer Assignment Section ******************************/
            for(LeadAssignmentWrapper objLeadInfo : lstLeadAssignmentWrapper)
            {
                list<DealerResult> listDealers = new list<DealerResult>();
                listDealersRaw  = getDealersForAssignmentWithoutGeoCode(objLeadInfo.lead.Latitude, objLeadInfo.lead.Longitude, objLeadInfo.lead.State, objLeadInfo.lead.Country);
                
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Eligible Dealers: ' + objLeadInfo.listDealers.size());
                
                // Get Previously Assigned Dealer
                listPrevious = DealerSOQLUtil.GetPreviouslyAssignedDealers(objLeadInfo.lead.Id);
                
                //Remove previously assigned for reassignment
                listDealersRaw = RemovePreviousDealers(listDealersRaw, listPrevious);
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealers remaining after removal of previously assigned: ' + listDealersRaw.size());                
                
                //clean the list for master dealers first - will return only master dealers, else the original list sent in
                listDealersRaw = masterDealerPrioritization(listDealersRaw);
                objLeadInfo.listDealers = listDealersRaw;
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealers remaining after Master Dealer Prioritization: ' + listDealersRaw.size());
                
                // Collect all the dealer : Gobal Dealer Map 
                map<Id,Account> dealerMap = ALRConfiguration.getDealermappingbyDealerResult(listDealersRaw);
                
                /*======================= Valid Lead Routing Assignment Started ==================================*/
                integer iLeadAssignCount = 1;
                String DAAName = '';
                
                //get the existing Dealer assignment count by Lead Id
                if(!listPrevious.isEmpty())
                    iLeadAssignCount += listPrevious.size();
                    
                objLeadInfo.lead.Requires_Manual_Assignment__c = false;
                DAAName = DEALERASSIGNMENT + String.valueOf(iLeadAssignCount);
                
                // Check if DealerName or Dealer Locator Selection already is in audit 
				Boolean isDealerAlreadySelected = false;
                if(listPrevious != null && !listPrevious.isEmpty())
                	isDealerAlreadySelected = isDealerAlreadySelected(objLeadInfo,listPrevious);
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('isDealerAlreadySelected? ' + isDealerAlreadySelected);
            
                /**************** If Lead already comes with Dealer_Selection__c name and assignment first time ***************/
                if((objLeadInfo.lead.Dealer_Locator_Selection__c != null 
                    || objLeadInfo.lead.Dealer_Name__c != null) 
                    && !isDealerAlreadySelected)
                {
                    // Get Dealer from Dealer Locator Id
                    Account objDealer = New Account();
                    Id dealerId = objLeadInfo.lead.Dealer_Locator_Selection__c == null ? objLeadInfo.lead.Dealer_Name__c : objLeadInfo.lead.Dealer_Locator_Selection__c;
                    if(dealerId != null && mapPredealer != null && mapPredealer.get(dealerId) != null) {         
                        objDealer = mapPredealer.get(dealerId);
                        if(objLeadInfo.lead.Dealer_Locator_Selection__c == null) {
                            objLeadInfo.lead.Dealer_Locator_Selection__c = mapPredealer.get(dealerId).Id;
                            objLeadInfo.lead.Dealer_Name__c = null;
                        }
                        //See if we have a matching campaign partner so we can set the warm transfer if it is
                        if(objLeadInfo.campaign.Campaign_Partners__r != null && objLeadInfo.campaign.Campaign_Partners__r.size() > 0) {
                            for(Campaign_Partner__c cpr : objLeadInfo.campaign.campaign_Partners__r) {
                                if(cpr.Partner__c == objLeadInfo.lead.Dealer_Locator_Selection__c) {
                                    if(cpr.Partner_Type__c == 'Warm Transfer')
                                        objLeadInfo.isWarmTransfer = true;
                                }
                            }
                        }
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Unassigned Pre-Selected Dealer: ' + objDealer.Name);
                    }
                    // Create Dealer Assignment Audit Log
                    objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objDealer.Id,
                                                        objLeadInfo.lead.Id,
                                                        DLER_ASG_REASON_DEALERLOCATOR,
                                                        DLER_ASG_REASON_DEALERLOCATOR, null);
                    
                    //Assign Bulk 
                    objLeadInfo = AssignOwner(mapPredealer,objLeadInfo);
                }/************************ If Lead comes with Campgain Information ******************************/
                else if(objLeadInfo.bIscampaign && objLeadInfo.campaign != null)
                {
                    // Update the dealer locator as null for reassignemnt
                    objLeadInfo.lead.Dealer_Locator_Selection__c = null;
                    
                    //Get Campaign information
                    Campaign c = DealerSOQLUtil.getCampaignById(objLeadInfo.campaign.Id);
                    objLeadInfo.objAuditAssign.Campaign__c = objLeadInfo.campaign.Id;
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Campaign Assignment - ' + objLeadInfo.campaign.Id);
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Pre-qualification ' + objLeadInfo.bIsLeadQualificationCampaign);
                    //Warm Handoff Just to add audit for is Exclusive Campaign
                     objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Exclusive Campaign' + objLeadInfo.bIsExclusiveCampaign);
                     /*========================================= If it's a paid Campaign   ===========================================*/
                    if(objLeadInfo.Campaign.AssignRandomPartner__c == TRUE){
                        
                        //Find Campaign partner for Paid Campaign
                        listDealers = ALRConfiguration.findCampaignDealers(listDealersRaw,objLeadInfo.campaign.Id);
                        
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Paid Campaign');
						//Perform assignment
                        objLeadInfo.lead.Dealer_Locator_Selection__c = ALRConfiguration.GetSingleDealerBasedOnRandomEvenDistribution(listDealers,objLeadInfo.campaign.Id);
                        objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                        objLeadInfo.lead.ALR_Assignment_Audit_trail__c += ALRConfiguration.auditUpdate('Dealer Selected by Random Even Dealer Distribution: ' + objLeadInfo.lead.Dealer_Locator_Selection__c);
                        if(objLeadInfo.lead.Dealer_Locator_Selection__c != null && objLeadInfo.campaign.Campaign_Partners__r != null && objLeadInfo.campaign.Campaign_Partners__r.size() > 0) {
                            for(Campaign_Partner__c cpr : objLeadInfo.campaign.campaign_Partners__r) {
                                if(cpr.Partner__c == objLeadInfo.lead.Dealer_Locator_Selection__c) {
                                    if(cpr.Partner_Type__c == 'Warm Transfer')
                                        objLeadInfo.isWarmTransfer = true;
                                }
                            }
                        }
                        //AssignOwner
                        objLeadInfo = AssignOwner(dealerMap,objLeadInfo);
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Paid Campaign',
                                                        'Random Even Distribution',
                                                        objLeadInfo.campaign.Id);
                       
                    }
                    /*========================================= If it's a Alliance Campaign ===========================================*/
                    else if(objLeadInfo.Campaign.Type == 'Alliance'){
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Alliance Campaign - ' + objLeadInfo.campaign.Id);
                                               
                        listDealers = DealerUtility.findAllianceCampaignDealers(listDealersRaw, c);
                        
                        if(listDealers.size() == 0)
                           listDealers = DealerUtility.findAllianceDealers(listDealersRaw);
                        
                        objLeadInfo.lead.Dealer_Locator_Selection__c = DealerUtility.GetSingleDealerBasedOnWeightedScore(listDealers, null);
                        objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                        objLeadInfo = AssignOwner(dealerMap,objLeadInfo);
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Alliance Campaign',
                                                        'Weighted Score Distribution',
                                                        objLeadInfo.campaign.Id);
                       objLeadInfo.objAuditAssign.Campaign__c = objLeadInfo.campaign.Id;                                 
                    }
                    /*========================================= If it's a Non-Paid Campaign ===========================================*/
                    else{ 
                        
                        system.debug('============================ Inside Non-Paid =============================='+listDealersRaw.size());                        
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Non-Paid Campaign');
                        //objLeadInfo = nonPaidCampaignAssignment(objLeadInfo, assignCountMap, dealerMap);
                        listDealers = DealerUtility.findCampaignDealers(listDealersRaw, objLeadInfo.campaign.Id);

                        if (listDealers.size() > 0)
                            objLeadInfo.lead.Dealer_Locator_Selection__c = DealerUtility.GetSingleDealerBasedOnWeightedScore(listDealers, null);
                        
                        objLeadInfo = AssignOwner(dealerMap,objLeadInfo);
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Non-Paid Campaign',
                                                        'Weighted Score Distribution',
                                                        objLeadInfo.campaign.Id);
                        objLeadInfo.objAuditAssign.Campaign__c = objLeadInfo.campaign.Id;
                     }
                }
                
                // Try to reassign the dealer with a less restrictive dealer list
                if(objLeadInfo.lead.Dealer_Locator_Selection__c == null || (isDealerAlreadySelected && !objLeadInfo.bIscampaign))
                {
                    if(!objLeadInfo.bIscampaign)
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No campaign found, proceeding with assignment');
                    else objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer not assigned. Attempting to retry.');
                    
                   // Build the raw list again
                    objLeadInfo.listDealers = listDealersRaw;
                    objLeadInfo = reassignmentTry(objLeadInfo, DAAName, objLeadInfo.listDealers, dealerMap);
                }
                
                // Manual Assignment Flag
                if (objLeadInfo.lead.Dealer_Locator_Selection__c == null){
                    objLeadInfo.lead.Dealer_Assignment_Date__c = null;
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer not assigned. Failed.');
                    objLeadInfo = ALRConfiguration.failedAssignment(objLeadInfo, DAAName);
                    objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Requires Manual Assignment',
                                                        '', null);
                }
                else{
                    objLeadInfo = ALRConfiguration.successfulAssignment(objLeadInfo);
                }
                
                objLeadInfo = finalizeAssignment(objLeadInfo);
                
                //Add LeadInformation in Map
                mapLeadIdVsDealerResult.put(objLeadInfo.lead.Id,objLeadInfo);
            }
            
        }catch(exception ex){
            // Exception Need to handle
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = ex.getMessage();
            log.Stack_Trace__c = ex.getStackTraceString();
            try{ insert log; } catch(Exception e2) {}
        }
        return mapLeadIdVsDealerResult;
    }
    
    /******************************************************************************************************************************************************
        Method : RemovePreviousDealers
        
    *******************************************************************************************************************************************************/
    public static list<DealerResult> RemovePreviousDealers(list<DealerResult> listDealersRaw, list<Lead_Dealer_Assignment_Audit__c> listPrevious) {
        list<DealerResult> listDealersToReturn           = new list<DealerResult>();
        boolean bFound = false;
        
        for(DealerResult dr:listDealersRaw){
            bFound = false;
            for (Lead_Dealer_Assignment_Audit__c da : listPrevious) {
                if (dr.AccountId == da.Dealer_Assigned__c) bFound = true;
            }
            if (bFound == false) listDealersToReturn.add(dr);
        }
        return listDealersToReturn;
    }
    
    
    /*
        Method      : isDealerAlreadySelected()
        Parameter   : LeadAssignmentWrapper objLeadInfo,list<Lead_Dealer_Assignment_Audit__c> lstPreviousDealer
        return      : Boolean
        Summary     : Method find the Lead Dealer Assigned name and Dealer locator is already tracked in Assignedment log or not.
    */
    public static Boolean isDealerAlreadySelected(LeadAssignmentWrapper objLeadInfo,list<Lead_Dealer_Assignment_Audit__c> lstPreviousDealer){
        Boolean bIsDealerSelected = false;
        
        if(lstPreviousDealer == null || lstPreviousDealer.isEmpty()) return false;
        
        if(objLeadInfo.lead.Dealer_Locator_Selection__c == null && objLeadInfo.lead.Dealer_Name__c == null) return false; 
        
        for(Lead_Dealer_Assignment_Audit__c objLeadDealer : lstPreviousDealer)
        {
    		if(objLeadDealer.Dealer_Assigned__c != null &&
               ((objLeadInfo.lead.Dealer_Locator_Selection__c != null && objLeadDealer.Dealer_Assigned__c == objLeadInfo.lead.Dealer_Locator_Selection__c)  
    		   || (objLeadInfo.lead.Dealer_Name__c != null && objLeadDealer.Dealer_Assigned__c == objLeadInfo.lead.Dealer_Name__c)))
                bIsDealerSelected = true;
    	}
        
        return bIsDealerSelected;
    }
    
    public static List<DealerResult> getDealersForAssignmentWithoutGeoCode(Decimal lat, Decimal lon, String State, String Country){
        list<DealerResult> dealerRawResults = new list<DealerResult>();
        list<DealerResult> dealerResults = new list<DealerResult>();
          
        if (lat != null){
            GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
            info.State = State;
            //info.Country = Country;
            info.Lat = lat;
            info.Lon = lon;
            dealerRawResults = DealerUtility.getTopDealers(lat, lon, info, Country, 1000);
        }
        
        if (Test.isRunningTest()){
            GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
            info.State = 'CO';
            //info.Country = 'United States';
            info.Lat = 39.721956;
            info.Lon = -104.974382;
            
            dealerRawResults = DealerUtility.getTopDealers(39.721956, -104.974382, info, 'United States', 1000);
        }
        
        for (DealerResult dr :dealerRawResults){
            if (dr.LeadFlowOptOut == false ) 
                dealerResults.add(dr);
        }
        return dealerResults;
    }
    
    /**************************************************************************************************************************************************************
        Function : AutoAssignLead 
        Parameter: List<LeadAssignmentWrapper>
        Return   : map<Id,LeadAssignmentWrapper>
        Summary  : Initial assignment logic
    ***************************************************************************************************************************************************************/
    public static map<Id,LeadAssignmentWrapper> AutoAssignLead(list<LeadAssignmentWrapper> lstLeadAssignmentWrapper){
        
        map<Id,LeadAssignmentWrapper> mapLeadIdVsDealerResult = new map<Id,LeadAssignmentWrapper>();
        
        if(lstLeadAssignmentWrapper == null || lstLeadAssignmentWrapper.isEmpty()) return mapLeadIdVsDealerResult;
        
        try{
            // Update Campaign Information 
            lstLeadAssignmentWrapper = updateCampaignInformation(lstLeadAssignmentWrapper);
            
            map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();
            set<String> setDealerLocator = new set<String>();
            
            
            // Validate Lead Information is entitled for ALR , its update the Dealer_Assignment_Status__c field accordingly
            lstLeadAssignmentWrapper = ALRConfiguration.isLeadValidforALR(lstLeadAssignmentWrapper);
            
            // If lead not valid as per ALR configuration.
            for(LeadAssignmentWrapper objLeadInfo : lstLeadAssignmentWrapper){
                                
                if(objLeadInfo.lead.Dealer_Name__c != null)
                    setDealerLocator.add(objLeadInfo.lead.Dealer_Name__c);
                else if(objLeadInfo.lead.Dealer_Locator_Selection__c != null)
                    setDealerLocator.add(objLeadInfo.lead.Dealer_Locator_Selection__c);
                
                if(!objLeadInfo.isValid){
                    objLeadInfo.lead.Status = 'Disqualified';
                    objLeadInfo.lead.Dealer_Assignment_Status__c = 'Failed Assignment - Invalid Geolocation';
                }
            }
            
            // Collect all the dealer : Gobal Dealer Map 
            Map<Id, Account> allDealersMap = DealerSOQLUtil.buildAllDealersMap();
            Map <Id, Account> dealerMap = new Map<Id, Account>();
            if(allDealersMap.size() > 0) {
                for(Account a : allDealersMap.values()) {
                    if(a.Lead_Flow_opt_out__c == false) {
                        dealerMap.put(a.Id, a);
                    }
                }
            } 
            // Special Dealers : 
            map <Id, Account> mapPredealer = DealerSOQLUtil.getDealerByNameOrId(setDealerLocator);           
            
            // Dealer Audit Count Map per Dealer
            map <Id, map<Id, Integer>> assignCountMap = DealerSOQLUtil.buildCampaignAssignmentCountMap(dealerMap);        
            /***************** Dealer Assignment Section *******************/
            for(LeadAssignmentWrapper objLeadInfo : lstLeadAssignmentWrapper)
            {
                List <DealerResult> listDealers = new List <DealerResult>();
                
                /*================ Valid Lead Routing Assignment Started ==================*/
                Boolean bReassignment = (objLeadInfo.lead.Dealer_Assignment_Date__c != null);
                integer iLeadAssignCount = 1;
                String DAAName = '';
                
                system.debug('4. bReassignment ====>'+bReassignment);
                objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(' Is Reassigment? ' + bReassignment);
                // If lead is coming for re-Assignment
                if(bReassignment){
                    
                    //get the existing Dealer assignment count by Lead Id
                    if(!mapLeadDealerAssignment.isEmpty())
                        iLeadAssignCount += mapLeadDealerAssignment.get(objLeadInfo.lead.Id);
                    
                    objLeadInfo.lead.Requires_Manual_Assignment__c = false;
                }
                DAAName = DEALERASSIGNMENT + String.valueOf(iLeadAssignCount);
                
                /*===== If Lead is New Homes Campaign Lead =====*/
                if(objLeadInfo.blnNewHomeCampaign) {
                    objLeadInfo.objAuditAssign.Campaign__c = objLeadInfo.campaign.Id;
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Campaign Assignment - ' + objLeadInfo.campaign.Id);
                    
                    assignNewHomesDealer(objLeadInfo, allDealersMap);
                    
                    
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer Assigned: ' + objLeadInfo.lead.Dealer_Locator_Selection__c);
                    objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                    objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                                                    objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                                                    objLeadInfo.lead.Id,
                                                                                    'Is New Homes Campaign',
                                                                                    'Random Even Distribution',
                                                                                    objLeadInfo.campaign.Id);
                    objLeadInfo = AssignOwner(allDealersMap, objLeadInfo);
                    
                }
                
                /*===== If Lead already comes with Dealer_Selection__c name and assignment first time ======*/
                if((objLeadInfo.lead.Dealer_Locator_Selection__c != null || objLeadInfo.lead.Dealer_Name__c != null) //&& !bReassignment){ - CR Fix                 
                && !bReassignment && !objLeadInfo.blnNewHomeCampaign){
                    
                    system.debug('6. Lead comes with Dealer Name ====>'+objLeadInfo.lead.Dealer_Name__c);
                    
                    // Get Dealer from Dealer Locator Id
                    Account objDealer = New Account();
                    if(objLeadInfo.lead.Dealer_Name__c != null && mapPredealer != null && mapPredealer.ContainsKey(objLeadInfo.lead.Dealer_Name__c)){
                        objDealer = mapPredealer.get(objLeadInfo.lead.Dealer_Name__c);
                        objLeadInfo.lead.Dealer_Locator_Selection__c = objLeadInfo.lead.Dealer_Name__c;
                    }
                    else if(objLeadInfo.lead.Dealer_Locator_Selection__c != null && mapPredealer != null && mapPredealer.get(objLeadInfo.lead.Dealer_Locator_Selection__c) != null)
                        objDealer = mapPredealer.get(objLeadInfo.lead.Dealer_Locator_Selection__c);
                    
                    system.debug('objDealer ================>'+ objDealer);
                    
                    // Create Dealer Assignment Audit Log
                    objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objDealer.Id,
                                                        objLeadInfo.lead.Id,
                                                        DLER_ASG_REASON_DEALERLOCATOR,
                                                        DLER_ASG_REASON_DEALERLOCATOR, null);
                    //Assign Bulk 
                    objLeadInfo = AssignOwner(mapPredealer,objLeadInfo);
                }
                /************************ If Lead comes with Campgain Information ******************************/
                else if(objLeadInfo.bIscampaign && objLeadInfo.campaign != null && !objLeadInfo.blnNewHomeCampaign)
                {
                    objLeadInfo.objAuditAssign.Campaign__c = objLeadInfo.campaign.Id;
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Campaign Assignment - ' + objLeadInfo.campaign.Id);
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Campaign is pre-qualification campaign? ' + objLeadInfo.bIsLeadQualificationCampaign);
                    //Warm Handoff Just to add audot for is Exclusive Campaign
                     objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Exclusive campaign ?' + objLeadInfo.bIsExclusiveCampaign); 
                     /*========================================= If it's a paid Campaign   ===========================================*/
                    if(objLeadInfo.Campaign.AssignRandomPartner__c == TRUE)
                    {
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Paid Campaign');
                        objLeadInfo = paidCampaignAssignment(objLeadInfo, assignCountMap, dealerMap);
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer Assigned: ' + objLeadInfo.lead.Dealer_Locator_Selection__c);
                        objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Paid Campaign',
                                                        'Random Even Distribution',
                                                        objLeadInfo.campaign.Id);
                    }
                    /*========================================= If it's a Alliance Campaign ===========================================*/
                    else if(objLeadInfo.Campaign.Type == 'Alliance'){
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Alliance Campaign - ' + objLeadInfo.campaign.Id);
                        objLeadInfo = allianceCampaignAssignment(objLeadInfo, assignCountMap, dealerMap);
                        objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Alliance Campaign',
                                                        'Weighted Score Distribution',
                                                        objLeadInfo.campaign.Id);
                    }
                    /*========================================= If it's a Non-Paid Campaign ===========================================*/
                    else{ 
                        objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Is Non-Paid Campaign');
                        objLeadInfo = nonPaidCampaignAssignment(objLeadInfo, assignCountMap, dealerMap);
                        objLeadInfo.objAuditAssign.Dealer_Assigned__c = objLeadInfo.lead.Dealer_Locator_Selection__c;
                        objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Is Non-Paid Campaign',
                                                        'Weighted Score Distribution',
                                                        objLeadInfo.campaign.Id);
                    }
                    
                }
                
                // Try to reassign the dealer with a less restrictive dealer list !objLeadInfo.blnNewHomeCampaign && 
               // if((objLeadInfo.lead.Dealer_Locator_Selection__c == null || bReassignment) && objLeadInfo.lead.Requires_Manual_Assignment__c == false && objLeadInfo.bIsLeadQualificationCampaign != true)
                //Warm HandOff 
                if((objLeadInfo.lead.Dealer_Locator_Selection__c == null || bReassignment) && objLeadInfo.lead.Requires_Manual_Assignment__c == false && objLeadInfo.bIsExclusiveCampaign!=true )
                {   
                    if(bReassignment) 
                    	objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Reassignment attempt');
                    else objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer not assigned. Attempting to retry.');
                        
                    // Build the raw list again
                    listDealers = buildDealerListRaw(dealerMap, objLeadInfo, NULL, NULL);          
                        
                    objLeadInfo.listDealers = listDealers;
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Eligible Dealers: ' + listDealers.size());
                    objLeadInfo = reassignmentTry(objLeadInfo, DAAName, listDealers, dealerMap);
                }   
                
                if (objLeadInfo.lead.Dealer_Locator_Selection__c == null) 
                {
                    objLeadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer not assigned. Failed.');
                    objLeadInfo.lead.Dealer_Assignment_Date__c = null;
                    objLeadInfo = ALRConfiguration.failedAssignment(objLeadInfo, DAAName);
                    objLeadInfo.objAuditAssign = ConfigureLeadDealerAssignmentAudit(DAAName,
                                                        objLeadInfo.lead.Dealer_Locator_Selection__c,
                                                        objLeadInfo.lead.Id,
                                                        'Requires Manual Assignment',
                                                        '', null);
                }  
                else 
                {
                    objLeadInfo = ALRConfiguration.successfulAssignment(objLeadInfo);
                }
                
                    objLeadInfo = finalizeAssignment(objLeadInfo);
                
                // Add LeadInformation in Map
                mapLeadIdVsDealerResult.put(objLeadInfo.lead.Id,objLeadInfo);
            }
            
        }catch(exception ex){
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = ex.getMessage();
            log.Stack_Trace__c = ex.getStackTraceString();
            try{ insert log; } catch(Exception e2) {}
        }
        return mapLeadIdVsDealerResult;
    }
    
    /**************************************************************************************************************************************************************
        Function : reassignmentTry 
        Parameter: LeadAssignmentWrapper ,map<Id,map<Id, Integer>> ,map<Id,Account>
        Return   : LeadAssignmentWrapper
        Summary  : After assigning the Dealor Locator value on we update the lead owner same as dealer Opportunity Recipient
    ***************************************************************************************************************************************************************/
    private static LeadAssignmentWrapper reassignmentTry(LeadAssignmentWrapper objLeadInfo, String DAAName, List <DealerResult> listDealers, Map <Id, Account> dealerMap){
        
        objLeadInfo.lead.Dealer_Locator_Selection__c = ALRConfiguration.GetSingleDealerBasedOnWeightedScore(listDealers, objLeadInfo.objAuditAssign);
        if(objLeadInfo.lead.Dealer_Locator_Selection__c != null) 
            objLeadInfo.lead.Dealer_Assignment_Date__c = system.now();

        if (objLeadInfo.campaign != null) 
            objLeadInfo.objAuditAssign = configureLeadDealerAssignmentAudit(DAAName, objLeadInfo.lead.Dealer_Locator_Selection__c, objLeadInfo.lead.Id, 'Weighted Score Distribution','All Partners', objLeadInfo.campaign.Id );
        else {
            objLeadInfo.objAuditAssign = configureLeadDealerAssignmentAudit(DAAName, objLeadInfo.lead.Dealer_Locator_Selection__c, objLeadInfo.lead.Id,'Weighted Score Distribution','Generic Lead', null);
        }

        objLeadInfo = AssignOwner(dealerMap, objLeadInfo);  // Update the Owner of the Lead

        return objLeadInfo;
    }
    
    /**************************************************************************************************************************************************************
        Function : nonPaidCampaignAssignment 
        Parameter: LeadAssignmentWrapper ,map<Id,map<Id, Integer>> ,map<Id,Account>
        Return   : LeadAssignmentWrapper
        Summary  : After assigning the Dealor Locator value on we update the lead owner same as dealer Opportunity Recipient
    ***************************************************************************************************************************************************************/
    private static LeadAssignmentWrapper nonPaidCampaignAssignment(LeadAssignmentWrapper objLead,map<Id,map<Id, Integer>> assignCountMap,map<Id,Account> dealerMap){
        DealerGeneral__c dealerSetting = ALRConfiguration.getDealerGeneral();
        
        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Begining search for Campaign Partners');
        List <DealerResult> listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, 'Campaign Partners');
        if(listDealers.size() == 0) {
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No campaign partners found, searching all dealers');
            listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, NULL);
        }
          
        objLead.objAuditAssign.Reason__c            = 'Weighted Score Distribution';
        objLead.objAuditAssign.ALR_Rule_Applied__c  = 'Non-Paid Campaign';
        objLead.objAuditAssign.Campaign__c = objLead.campaign.Id;
        
        objLead.lead.Dealer_Locator_Selection__c    = ALRConfiguration.GetSingleDealerBasedOnWeightedScore(listDealers, objLead.objAuditAssign);
        objLead.lead.Dealer_Assignment_Date__c      = system.now();
        objLead.objAuditAssign.Dealer_Assigned__c   = objLead.lead.Dealer_Locator_Selection__c;
        objLead.listDealers = listDealers;
        if(listDealers != null || listDealers.size() > 0) {
            if(objLead.campaignPartnerIds == null) objLead.campaignPartnerIds = new Set<Id>();
            for(DealerResult dr : listDealers) {
                objLead.campaignPartnerIds.add(dr.AccountId);
            } 
        }

        objLead = AssignOwner(dealerMap, objLead);  // Update the Owner of the Lead
        return objLead;
    }
    
    /**************************************************************************************************************************************************************
        Function : allianceCampaignAssignment 
        Parameter: LeadAssignmentWrapper ,map<Id,map<Id, Integer>> ,map<Id,Account>
        Return   : LeadAssignmentWrapper
        Summary  : After assigning the Dealor Locator value on we update the lead owner same as dealer Opportunity Recipient
    ***************************************************************************************************************************************************************/
    private static LeadAssignmentWrapper allianceCampaignAssignment(LeadAssignmentWrapper objLead,map<Id,map<Id, Integer>> assignCountMap,map<Id,Account> dealerMap){
        DealerGeneral__c dealerSetting = ALRConfiguration.getDealerGeneral();
        
         objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Begining search for Alliance Parnters');
        List <DealerResult> listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, 'Alliance Partners');
        
        if(listDealers.size() == 0) {
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No campaign partners found, searching all dealers');
            listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, NULL);
        } 

        objLead.objAuditAssign.Reason__c            = 'Weighted Score Distribution';
        objLead.objAuditAssign.ALR_Rule_Applied__c  = 'Alliance Campaign';
        objLead.objAuditAssign.Campaign__c = objLead.campaign.Id;
        
        objLead.lead.Dealer_Locator_Selection__c    = ALRConfiguration.GetSingleDealerBasedOnWeightedScore(listDealers, objLead.objAuditAssign);
        objLead.lead.Alliance_Program_Lead__c       = true;
        objLead.lead.Dealer_Assignment_Date__c      = system.now();

        if(objLead.lead.Dealer_Locator_Selection__c == NULL) { 
            objLead.lead.Requires_Manual_Assignment__c = true;
            objLead.lead.Dealer_Assignment_Date__c = null;
        }
        else {
            if(objLead.campaignPartnerIds == null) objLead.campaignPartnerIds = new Set<Id>();
            for(DealerResult dr : listDealers) {
                objLead.campaignPartnerIds.add(dr.AccountId);
            } 
        }
        
        objLead.listDealers = listDealers; 
        objLead = AssignOwner(dealerMap, objLead);  // Update the Owner of the Lead
        
        return objLead;
    }
    
    /**************************************************************************************************************************************************************
        Function : paidCampaignAssignment 
        Parameter: LeadAssignmentWrapper ,map<Id,map<Id, Integer>> ,map<Id,Account>
        Return   : LeadAssignmentWrapper
        Summary  : After assigning the Dealor Locator value on we update the lead owner same as dealer Opportunity Recipient
    ***************************************************************************************************************************************************************/
    public static LeadAssignmentWrapper paidCampaignAssignment(LeadAssignmentWrapper objLead,map<Id,map<Id, Integer>> assignCountMap,map<Id,Account> dealerMap){
        
        DealerGeneral__c dealerSetting = ALRConfiguration.getDealerGeneral();
        
        // Update the Dealer Audit record 
        objLead.objAuditAssign.Reason__c = 'Round Robin Distribution';
        objLead.objAuditAssign.ALR_Rule_Applied__c = 'Paid Campaign';
        objLead.objAuditAssign.Campaign__c = objLead.campaign.Id;
        
        // Collect Dealers who are Campaign Partner for same Campaign in Past 
        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Begining search for Campaign Partners');
        List <DealerResult> listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, 'Campaign Partners');
        
        //if no priority dealers, check master dealers - CRYSTAL
        if(listDealers.isEmpty()) {
        	listDealers = buildDealerListRaw(dealerMap, objlead, objLead.campaign.Id, 'Master Dealers');
        }
        
        // check if listDealers for Campaign Partners is empty
        if(listDealers.isEmpty()) {
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_NoDealerFound);
             objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No campaign partners found, searching all dealers');
            listDealers = buildDealerListRaw(dealerMap, objLead, objLead.campaign.Id, NULL);          
        }
        
        //if not empty proceed with assignment
        else if(assignCountMap.containskey(objLead.campaign.Id)){
            if(listDealers != null && listDealers.size() > 0) {
            
                if(objLead.campaignPartnerIds == null) objLead.campaignPartnerIds = new Set<Id>();
                for(DealerResult dr : listDealers) {
                    objLead.campaignPartnerIds.add(dr.AccountId);
                }    
            }
            //If only one dealer to assign to, then they get it
            if(listDealers.size() == 1){
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_OneDealerFound);
                objLead.lead.Dealer_Locator_Selection__c = listDealers[0].AccountId;
                objLead.isWarmTransfer = listDealers[0].isWarmTransferPartner == null ? false : listDealers[0].isWarmTransferPartner;
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer assigned from Dealer List size of ' + listDealers.size() + ' ' + objLead.lead.Dealer_Locator_Selection__c);
            }else { 
                //If more than one dealer to assign to, then proceed to random assignment
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_MultipleDealerFound);
                Set <Id> mostAssignedIds = new Set <Id>();
                Integer mostAssigned = 0;
                
                for(DealerResult dr : listDealers) {
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('dealer ' + dr.AccountName + ' has ' + assignCountMap.get(objLead.campaign.Id).get(dr.AccountId) + ' assigned for campaign.');
                    if(assignCountMap.get(objLead.campaign.Id).get(dr.AccountId) > mostAssigned)
                        mostAssigned = assignCountMap.get(objLead.campaign.Id).get(dr.AccountId);
                }
                
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('highest assigned was ' + mostAssigned);
                
                // Find out what the highest assignment count is for campaign
                for(DealerResult dr : listDealers) {
                    if(mostAssigned == assignCountMap.get(objLead.campaign.Id).get(dr.AccountId)) {
                        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('' + dr.AccountName + ' has the most assigned at ' + assignCountMap.get(objLead.campaign.Id).get(dr.AccountId) + '.');
                        mostAssignedIds.add(dr.AccountId);
                    }
                }
                
                List <DealerResult> originalList = new List <DealerResult>(listDealers);
                Integer i = 0;
                
                // Remove dealers who match highest assignment count
                while(i < listDealers.size()){
                    if(mostAssignedIds.contains(listDealers[i].AccountId)){
                        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('removing ' + listDealers[i].AccountName);
                        listDealers.remove(i);
                    }
                    else {
                        i++;
                    }
                }
                
                if(listDealers.size() == 1) {
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('clean dealer list has 1 dealer. Random assignment not needed.');
                    objLead.lead.Dealer_Locator_Selection__c = listDealers[0].AccountId;
                    objLead.isWarmTransfer = listDealers[0].isWarmTransferPartner == null ? false : listDealers[0].isWarmTransferPartner;
                }
                else if(listDealers.size() != 0){
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('clean dealer list has multiple dealers. Random assignment needed.');
                    Integer randomInt = ALRConfiguration.getRandomNumber(listDealers.size()-1);
                    objLead.lead.Dealer_Locator_Selection__c = listDealers[randomInt].AccountId;
                    objLead.isWarmTransfer = listDealers[randomInt].isWarmTransferPartner == null ? false : listDealers[randomInt].isWarmTransferPartner;
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer assigned from Dealer List size of ' + listDealers.size() + ' ' + objLead.lead.Dealer_Locator_Selection__c);
                }
                else if(originalList.size() != 0){
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('clean dealer list has 0 dealers. Using original list.');
                    objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Original list: ' + originalList.size());
                    Integer randomInt = ALRConfiguration.getRandomNumber(originalList.size()-1);
                    objLead.lead.Dealer_Locator_Selection__c = originalList[randomInt].AccountId;
                    objLead.isWarmTransfer = originalList[randomInt].isWarmTransferPartner == null ? false : originalList[randomInt].isWarmTransferPartner;
                }
            }
        }else
        {
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Campaign Id ' + objLead.campaign.Id + ' has not been assigned yet.');
            Integer randomInt = ALRConfiguration.getRandomNumber(listDealers.size()-1);
            objLead.lead.Dealer_Locator_Selection__c = listDealers[randomInt].AccountId;
            objLead.isWarmTransfer = listDealers[randomInt].isWarmTransferPartner == null ? false : listDealers[randomInt].isWarmTransferPartner;
        }
        
        objLead = AssignOwner(dealerMap, objLead);  // Update the Owner of the Lead
        
        objLead.listDealers = listDealers;      // Added dealer result in LeadDealerWrapper class
        
        return objLead;
    }
    
    /**************************************************************************************************************************************************************
        Function : assignNewHomesDealer 
        Parameter: LeadAssignmentWrapper objLead, Map<Id, Account> allDealersMap 
        Return   : List <DealerResult>
        Summary  : method create the potential raw dealer list
    ***************************************************************************************************************************************************************/ 
    public static LeadAssignmentWrapper assignNewHomesDealer(LeadAssignmentWrapper objLead, Map<Id, Account> allDealersMap) {
        DealerGeneral__c dealerSetting = ALRConfiguration.getDealerGeneral();
        
        // Update the Dealer Audit record 
        objLead.objAuditAssign.Reason__c = 'Round Robin Distribution';
        objLead.objAuditAssign.ALR_Rule_Applied__c = 'New Homes Campaign';
        objLead.objAuditAssign.Campaign__c = objLead.campaign.Id;
        
        // Collect Dealer who are Campaign Partner 
        List<DealerResult> listDealers = new List<DealerResult>();
        List<Campaign_Partner__c> listPartners = new List<Campaign_Partner__c>();
        listPartners.addAll(objLead.Campaign.Campaign_Partners__r);
        
        // Update dealer number in Lead
        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('listPartners (Campaign Partners) size: ' + listPartners.size());
        
        // check if listPartners for Campaign Partners is empty
        if(listPartners.isEmpty()) {
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_NoDealerFound);

            return objLead;
        }

        if(listPartners.size() > 0) {
            List <DealerResult> result = new List <DealerResult>();
            result = ALRConfiguration.buildNewHomesDealerList(allDealersMap, objLead, String.valueOf(objLead.Campaign.Id), listPartners);   
            System.debug('result: ' + result);
            //If only one dealer to assign to, then they get it
            if(listPartners.size() == 1){
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_OneDealerFound);
                objLead.lead.Dealer_Locator_Selection__c = listPartners[0].Partner__c;
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Only one eligible partner. Random assignment not needed.');
            }else { 
                //If more than one dealer to assign to, then proceed to random assignment
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate(system.label.ALR_Lead_MultipleDealerFound);
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Clean dealer list has multiple dealers. Random assignment needed.');
                Integer randomInt = ALRConfiguration.getRandomNumber(listPartners.size()-1);
                objLead.lead.Dealer_Locator_Selection__c = listPartners[randomInt].Partner__c;
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer assigned from Dealer List size of ' + listPartners.size() + ' ' + objLead.lead.Dealer_Locator_Selection__c);
            }
            objLead.listDealers = result;      // Added dealer result in LeadDealerWrapper class
        }

        return objLead;
    }  
    
    /**************************************************************************************************************************************************************
        Function : buildDealerListRaw 
        Parameter: map<Id, Account> dealerMap, LeadAssignmentWrapper objLead, String foundCampaignId, String resultType
        Return   : List <DealerResult>
        Summary  : method create the potential raw dealer list
    ***************************************************************************************************************************************************************/
    public static List <DealerResult> buildDealerListRaw(map<Id, Account> dealerMap, LeadAssignmentWrapper objLead, String foundCampaignId, String resultType)
    {
        DealerGeneral__c DealerGeneral = ALRConfiguration.getDealerGeneral();
        
        List <DealerResult> result = new List <DealerResult>();

        // Build the raw list, prioritize SunPower Direct Dealers first.
        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Searching Sunpower Direct Dealers below minimum.'); 
        result = ALRConfiguration.buildCoreDealerList(dealerMap, objLead, DealerGeneral, foundCampaignId, 'SunPower Direct', TRUE, FALSE, TRUE);
        result = ALRConfiguration.cleanDealerList(resultType, result);
        
        // If there are no SunPower Direct Dealers, prioritize the Prioritized Dealers next
        if(result.isEmpty()){
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Searching Prioritized Dealers below minimum.');
            result = ALRConfiguration.buildCoreDealerList(dealerMap, objLead, DealerGeneral, foundCampaignId, 'Prioritized Dealer', TRUE, FALSE, TRUE);
            result = ALRConfiguration.cleanDealerList(resultType, result);
        }else return result;
        
       // If there are no prioritized dealers still, build the raw list with all dealers that have not hit their maximum yet
        if(result.isEmpty()){
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No Prioritized Dealers below minimum found.');
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Searching all dealers below maximum.');
            result = ALRConfiguration.buildCoreDealerList(dealerMap, objLead, DealerGeneral, foundCampaignId, 'Prioritized Dealer', FALSE, TRUE, TRUE);
            result = ALRConfiguration.cleanDealerList(resultType, result);
        }else return result;
        
        /****Master Dealer Priority Assignment****/
        //if(result.isEmpty()){
        if(result.isEmpty()){
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No Prioritized Dealers below minimum or maximum found.');
            if(DealerGeneral.MasterDealerPriority__c) {
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Searching Master Dealers.');
                result = ALRConfiguration.buildCoreDealerList(dealerMap, objLead, DealerGeneral, foundCampaignId, 'Master', FALSE, FALSE, TRUE);
                result = ALRConfiguration.cleanDealerList(resultType, result);
            } 
            else {
                objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Bypassing Master Dealer Prioritization.' + DealerGeneral.MasterDealerPriority__c);
            }
        }else return result;

       // If there are no prioritized dealers still, build the raw list with all dealers, even the ones that hit their maximum
        if(result.isEmpty()){
            objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('No priority dealers found. Beginning search of all campaign partners');
            result = ALRConfiguration.buildCoreDealerList(dealerMap, objLead, DealerGeneral, foundCampaignId, NULL, FALSE, FALSE, TRUE);
            result = ALRConfiguration.cleanDealerList(resultType, result);
        }
        return result;
    }
    
    /**************************************************************************************************************************************************************
        Function : masterDealerPrioritization 
        Parameter: List<DealerResult>
        Return   : List <DealerResult>
        Summary  : method clean potential dealer list for master dealers first, else just return the original list
    ***************************************************************************************************************************************************************/
    public static List<DealerResult> masterDealerPrioritization(List<DealerResult> listRaw) {
        List<DealerResult> results = new List<DealerResult>();
        
        if(listRaw == null || listRaw.isEmpty()) return results;
        
        for(DealerResult dr : listRaw) {
            if(dr.Type != null && dr.Type.startsWithIgnoreCase('Master'))
                results.add(dr);
        }

        if(!results.isEmpty()) return results;
        else return listRaw;
    }
    
    /**************************************************************************************************************************************************************
        Function : AssignOwner 
        Parameter: Map <Id, Account> , LeadAssignmentWrapper
        Return   : LeadAssignmentWrapper
        Summary  : After assigning the Dealor Locator value on we update the lead owner same as dealer Opportunity Recipient
    ***************************************************************************************************************************************************************/
    public static LeadAssignmentWrapper AssignOwner(Map <Id, Account> dealerMap, LeadAssignmentWrapper objLead){

        objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Assign Owner: Dealer Selection: ' + objLead.lead.Dealer_Locator_Selection__c + ' ' + dealerMap.size());
        try{
            DealerGeneral__c dealerSetting = ALRConfiguration.getDealerGeneral();
           
            if(objLead.lead.Dealer_Locator_Selection__c == NULL)
            {
                if (dealerSetting.Default_Owner_of_Opportunities_Id__c != NULL && dealerSetting.Default_Owner_of_Opportunities_Id__c != '')
                {
                    objLead.lead.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;
                    objLead.lead.Status = 'Disqualified';
                    objLead.lead.Dealer_Assignment_Status__c = 'Failed Assignment - No Dealer Found';
                    objLead.lead.Dealer_Assignment_Date__c = null;
                    objLead.lead.IsAutoConvert__c = false;
                    objLead.lead.Reason__c = objLead.lead.Dealer_Assignment_Status__c;
                }
            }
            else if(objLead.lead.Dealer_Locator_Selection__c != null)
            {
                //Establish Consultation Type, warm transfer or null if anything else
                if(objLead.isWarmTransfer != null && objLead.isWarmTransfer == true)
                    objLead.lead.Consultation_Type__c = 'Warm Transfer';
                
                
                // Added for LeadQualificationCampaign
             //   if((objLead.bIsLeadQualificationCampaign != null && objLead.bIsLeadQualificationCampaign == true)
             //Warm Handoff replacing bIsLeadQualificationCampaign with isExclusive as   validateLeadQualificationCampaign need to skip for LeadPrequalification
                   if((objLead.bIsLeadQualificationCampaign != null && objLead.bIsExclusiveCampaign == true)
                   || (objLead.blnNewHomeCampaign != null && objLead.blnNewHomeCampaign == true)) {
                       objLead.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Dealer Assigned, validating Campaign Partners');
                       objLead =  ALRConfiguration.validateLeadQualificationCampaign(objLead); 
                }
                
                if(dealerMap.containsKey(objLead.lead.Dealer_Locator_Selection__c) 
                && dealerMap.get(objLead.lead.Dealer_Locator_Selection__c) != null
                && dealerMap.get(objLead.lead.Dealer_Locator_Selection__c).Opportunity_Recipient__c != NULL)
                {
                    // If Dealer Locator is available and get dealer from the dealer map and assiged lead owner same as Opportunity Recipient.
                        objLead.lead.OwnerId = dealerMap.get(objLead.lead.Dealer_Locator_Selection__c).Opportunity_Recipient__c;
                        objLead.lead.Res_Opp_Recip_Email__c = dealerMap.get(objLead.lead.Dealer_Locator_Selection__c).Opportunity_Recipient__r.Email;
                    if(dealerMap.get(objLead.lead.Dealer_Locator_Selection__c).Additional_Opportunity_Email_Recipient__c != null) {
                        objLead.lead.Res_Opp_Recip_CC_Email__c = dealerMap.get(objLead.lead.Dealer_Locator_Selection__c).Additional_Opportunity_Email_Recipient__c;
                    } else {
                        objLead.lead.Res_Opp_Recip_CC_Email__c = null; //CRYSTAL - added b/c on reassignment if new selection doesn't have cc email, old value not being removed
                    }
                        objLead.lead.Dealer_Assignment_Date__c = system.now();
                        objLead.lead.Dealer_Assignment_Status__c = 'Dealer Assigned';
                        objLead.lead.IsAutoConvert__c = true;
                }
                else{
                    
                    // If Dealer is present but Opportunity Opportunity_Recipient__c field is blank assig Lead to default Owner
                    objLead.lead.Dealer_Assignment_Status__c = 'Dealer Assigned';
                    objLead.lead.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;
                    objLead.lead.Dealer_Assignment_Date__c = system.now();
                    objLead.lead.IsAutoConvert__c = true;
                    
                    
                    Messaging.SingleEmailMessage mail = ALRConfiguration.SendEmailAlert('ALR - Dealer missing Opportunity Recipient', 
                        'During the Dealer Assignment of a lead (' + objLead.lead.Id + '), the Opportunity Recipient of the assigned dealer was missing.'+
                        +'\nThis lead needs to have it\'s owner set to a recipent of the assigned dealer.');
					alertEmails.add(mail);
                }
                
                // If Dealer is SPD
                Set<String> spdIds = getSpdIds();
                
                
               //To avoid isSPD ->True when  no dealer Assign 
                if(spdIds.contains(objLead.lead.Dealer_Locator_Selection__c) 
                   || (objLead.bIsLeadQualificationCampaign == true && objLead.lead.Dealer_Locator_Selection__c != null)
                   || objLead.blnNewHomeCampaign || (objLead.bIsExclusiveCampaign == true && objLead.lead.Dealer_Locator_Selection__c != null)) {  
                        objLead.isSPD       = true;
                        if(userIsSAProfile != true)
                        	objLead.lead.Status = 'Marketing Qualified';
                        objLead.lead.IsAutoConvert__c = false;
                        objLead.lead.Dealer_Name__c = null;
                        objLead.lead.Reason__c = null;
                }else{
                    if(objLead.lead.Dealer_Locator_Selection__c != null) {
                        objLead.lead.Status = 'Ready for Conversion';
                        objLead.isSPD       = false;
                        objLead.lead.IsAutoConvert__c = true;
                    }
                }
            }
            
        } catch(Exception ex) {
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = ex.getMessage();
            log.lead__c = objLead.lead.Id;
            log.Stack_Trace__c = ex.getStackTraceString();
            try{ insert log; } catch(Exception e2) {}
        }
        return objLead;
    }
    
    /**************************************************************************************************************************************************************
        Function : updateCampaignInformation 
        Summary  : update Campaign information in LeadAssignmentWrapper instance
    ***************************************************************************************************************************************************************/
    public static list<LeadAssignmentWrapper> updateCampaignInformation(list<LeadAssignmentWrapper> lstLeadInfo){
        
        // Collect the Lead Id from lead Assigned Wrapper class 
        Set<Id> SetleadId = getLeadIDFromLeadAssignmentWrapper(lstLeadInfo);
        Set<String> setCampaignId = new Set<String>();
        
        // Pass Set Lead Id to collect Campaign information from the Data base from CampaignMember table
       map<Id,CampaignMember> MapCampaignMember = DealerSOQLUtil.getCampaignMemberByLeadId(SetleadId);
        
        // Update the Campaign information in Lead Assigned Wrapper class
        for(LeadAssignmentWrapper objLeadInfo : lstLeadInfo)
        {
            if(MapCampaignMember.ContainsKey(objLeadInfo.lead.Id)){
                objLeadInfo.bIscampaign             = true;
                objLeadInfo.bIsLeadQualificationCampaign = MapCampaignMember.get(objLeadInfo.lead.Id).Campaign.Requires_Lead_Pre_Qualification__c;
                 objLeadInfo.bIsExclusiveCampaign = MapCampaignMember.get(objLeadInfo.lead.Id).Campaign.isExclusive__c;
                CampaignMember objCampaignMember    = MapCampaignMember.get(objLeadInfo.lead.Id);
                if(objCampaignMember.Campaign.Five9__Five9List__c != null)
                    	objLeadInfo.five9ListName = objCampaignMember.Campaign.Five9__Five9List__c;
                if(objCampaignMember.Campaign.NH_Community__c != null)
                    	objLeadInfo.blnNewHomeCampaign = true;
                setCampaignId.add(objCampaignMember.CampaignId);
                objLeadInfo.campaign                = new Campaign(Id = objCampaignMember.CampaignId,
                                                          Type = objCampaignMember.Campaign.Type,
                                                          AssignRandomPartner__c = objCampaignMember.Campaign.AssignRandomPartner__c,
                                                                  ParentId = objCampaignMember.Campaign.ParentId);//TEST - CRYSTAL
            }
            else{
                objLeadInfo.bIscampaign             = false;
                objLeadInfo.campaign                = new Campaign();
            }
        }
        
        map<Id,Campaign> mapCampaignPartner = DealerSOQLUtil.getCampaignById(setCampaignId);
        
        // Update Campaign Information with campaign partner
        for(LeadAssignmentWrapper objLeadInfo : lstLeadInfo)
        {
            if(!objLeadInfo.bIscampaign) continue;
            
            if(mapCampaignPartner.ContainsKey(objLeadInfo.campaign.Id))
                objLeadInfo.campaign = mapCampaignPartner.get(objLeadInfo.campaign.Id); // No need of any changes here already chnaged the soql query to get Parent Id
                
        }
        
        return lstLeadInfo;
    }
    
    public static Set<Id> getLeadIDFromLeadAssignmentWrapper(list<LeadAssignmentWrapper> lstLeadAssignmentWrapper){
        
        if(lstLeadAssignmentWrapper == null || lstLeadAssignmentWrapper.isEmpty()) return new Set<Id>();
        
        Set<Id> setLeadid = new Set<Id>();
        
        for(LeadAssignmentWrapper objLeadAssWrp : lstLeadAssignmentWrapper)
            setLeadid.add(objLeadAssWrp.lead.Id);
        
        return setLeadid;
    }
    
    /*
        function    : distributeValidLeadInfo()
        return type : LeadAssignmentWrappInfo 
        Summary     : distribute leads with valid geolocation and Invalid geolocation; 
    */
    public static LeadAssignmentWrappInfo distributeValidLeadInfo(Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap){
        LeadAssignmentWrappInfo objLeadAssignmentWrappInfo = new LeadAssignmentWrappInfo();
        
        system.debug('###### Geo Location map##'+leadGeoMap.size());
        
        for(Lead lead: leadGeoMap.keySet())
        {
            GeocodeAsyncHandler.GeoInfo info = leadGeoMap.get(lead);
            //MessageUtil.DebugLog(' Lead as key '+lead);
            
            LeadAssignmentWrapper objLeadAssignmentWrapper = new LeadAssignmentWrapper();
            objLeadAssignmentWrapper.GeoInfo = info;
            objLeadAssignmentWrapper.lead = lead;
            objLeadAssignmentWrapper.isSPD = false;
            
            // Geo location is not valid : we are adding instance in Invalid list
            if(info.ZeroResults || info.Lat == null){
                objLeadAssignmentWrapper.isValid = false;
                objLeadAssignmentWrapper.lead.Status = 'Disqualified';
                objLeadAssignmentWrapper.lead.Dealer_Assignment_Status__c = 'Failed Assignment - Invalid Geolocation';
                objLeadAssignmentWrapper.lead.Reason__c = 'Lost-Incorrect Contact Info';
                objLeadAssignmentWrappInfo.lstInValidLeadAssignmentWrapper.add(objLeadAssignmentWrapper);
            }
            else { // Geo location is not valid : we are adding instance in Valid list
                objLeadAssignmentWrapper.isValid = true;
                objLeadAssignmentWrappInfo.lstValidLeadAssignmentWrapper.add(objLeadAssignmentWrapper);
            }
        }
        
        return objLeadAssignmentWrappInfo;
    }
    
    public static map<Lead, GeocodeAsyncHandler.GeoInfo> getLeadGeoInfo(List<Lead> lstLead){
        map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap = new map<Lead, GeocodeAsyncHandler.GeoInfo>();
        
       
        for (Lead l : lstLead){            
            try{               
                String cleanAddress = GeocodeAsyncHandler.cleanAddress(l.Street, l.City, l.State, l.PostalCode, l.Country);
                GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCode(cleanAddress);
                
                //Create the spectrum object for logging
                SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                log.jsonPayload = info.sentMsg;
                log.leadId = l.Id;
                log.Service = 'GeoCallOut to Google';
                log.Response = info.calloutRes;

                debugLogs.add(log);
                
                if (info.ZeroResults == true){
                    Lead LeadToUpdate                       = new Lead(id=l.id);
                    LeadToUpdate.IsAutoConvert__c           = false;
                    LeadToUpdate.Lead_Conversion_Status__c  = 'Failed Conversion - Address not Found';
                    LeadToUpdate.Status                     = 'Disqualified';
                    leadToUpdate.Reason__c                  = 'Lost-Incorrect Contact Info';
                    leadGeoMap.put(LeadToUpdate,info);
                }
                else if (info.Lat != null){
                    // Update Latitude and Longitude on Lead
                    l.Latitude__c  = String.valueOf(info.Lat);
                    l.Longitude__c = String.valueOf(info.Lon);
                    l.Latitude     = info.Lat;
                    l.Longitude    = info.Lon;
                    l.Log__c       = info.Lon;
                    l.Lat__c       = info.Lat;
                    leadGeoMap.put(l, info); 
                }
            }
            catch(Exception ex){
                System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: Exception thrown while geocoding: ' + ex.getMessage());
                Lead LeadToUpdate                       = new Lead(id=l.id);
                LeadToUpdate.IsAutoConvert__c           = false;
                LeadToUpdate.Status                     = 'Failed Conversion';
                LeadToUpdate.Lead_Conversion_Status__c  = 'Failed Conversion - Address cannot be cleaned';
                leadGeoMap.put(LeadToUpdate,null);
                Exception_Log__c log = new Exception_Log__c();
                log.Error_Message__c = ex.getMessage();
                log.Stack_Trace__c = ex.getStackTraceString();
                try{ insert log; } catch(Exception e2) {}
            }
        }
        return leadGeoMap;
    }
    
    
    /***********************************************************************************************************************************************
    Class   : LeadAssignmentWrappInfo
    Summary : Inner class created to distributed the lead which are valid by geolocation result 
    ***********************************************************************************************************************************************/
    public class LeadAssignmentWrappInfo{
        public list<LeadAssignmentWrapper> lstValidLeadAssignmentWrapper {
            get{
                if(lstValidLeadAssignmentWrapper == null) 
                    lstValidLeadAssignmentWrapper = new list<LeadAssignmentWrapper>(); 
                return lstValidLeadAssignmentWrapper;
            }set;
        }
        
        public list<LeadAssignmentWrapper> lstInValidLeadAssignmentWrapper {
            get{
                if(lstInValidLeadAssignmentWrapper == null) 
                    lstInValidLeadAssignmentWrapper = new list<LeadAssignmentWrapper>(); 
                return lstInValidLeadAssignmentWrapper;
            }set;
        }
    }
    
    
    private static LeadAssignmentWrapper finalizeAssignment(LeadAssignmentWrapper leadInfo){
        if(leadInfo.listDealers == null || leadInfo.listDealers.isEmpty()) return leadInfo;
        
        for (DealerResult r : leadInfo.listDealers){
            Lead_Eligible_Dealers__c ed   = new Lead_Eligible_Dealers__c();
            ed.Name                       = r.AccountName.left(80);
            ed.Dealer__c                  = r.AccountId;
            ed.Score__c                   = (r.Score != null ? r.Score : 0);
            ed.Distance__c                = r.Distance;
            ed.Selected__c                = (r.AccountId == leadInfo.objAuditAssign.Dealer_Assigned__c ? true : false);
            leadInfo.lstEligible_Dealers.add(ed);
        }
        
        return leadInfo;
    }
    
    private static void UpdateLeadInformation(LeadAssignmentWrappInfo objLeadAsgnWrappInfo){
        list<Lead> lstLead = new list<Lead>();
        list<Lead_Dealer_Assignment_Audit__c> lstleadDlrAudit = new list<Lead_Dealer_Assignment_Audit__c>();
        list<Lead_Eligible_Dealers__c> lstLeadElgDlrs = new list<Lead_Eligible_Dealers__c>();
        set<Id> setAuditResultId = new Set<Id>();
        
        //go ahead and insert spectrum logs so they don't interferre with the rest of the processes
        if (debugLogs != null && !debugLogs.isEmpty()){
            try {
                SpectrumDebugUtility.generateDebugLog(debugLogs);   
            } catch (Exception e) {
                system.debug(LoggingLevel.ERROR,'Debug logging failed');
            }
        }
        //Send alert emails if any exist
        if(alertEmails != null && !alertEmails.isEmpty()) {
            try {
                Messaging.sendEmail(alertEmails, true);
            } catch (Exception me) {
                System.debug(LoggingLevel.ERROR, 'Email alert sending failed');
            }
        }
        system.debug('objLeadAsgnWrappInfo.lstInValidLeadAssignmentWrapper ===>'+objLeadAsgnWrappInfo.lstInValidLeadAssignmentWrapper.size());    
        for(LeadAssignmentWrapper objLeadAssignmentWrapper : objLeadAsgnWrappInfo.lstInValidLeadAssignmentWrapper)
            lstLead.add(objLeadAssignmentWrapper.lead);
        
        system.debug('objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper ===>'+objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper.size());
        // Update valid Lead records with Dealor Locator and Updated Owners
        for(LeadAssignmentWrapper objLeadAssignmentWrapper : objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper){
            lstLead.add(objLeadAssignmentWrapper.lead);
            
            if(objLeadAssignmentWrapper.objAuditAssign.Lead__c != null)
                lstleadDlrAudit.add(objLeadAssignmentWrapper.objAuditAssign);
        }
        
        if(!lstLead.isEmpty())
        {
                        
            // Insert Lead Dealer Assignment Audit
            list<Database.Saveresult> lstleaddlrauditResult = database.insert(lstleadDlrAudit);
            
            for(Database.Saveresult dbresult : lstleaddlrauditResult){
                if(dbresult.isSuccess())
                    setAuditResultId.add(dbresult.getId());
            }
            
            if(!setAuditResultId.isEmpty()){
                map<Id,Lead_Dealer_Assignment_Audit__c> mapLeadVsDealerAssign = DealerSOQLUtil.getLeadDealerAssAudit(setAuditResultId);
                
                for(LeadAssignmentWrapper objLeadAssignmentWrapper : objLeadAsgnWrappInfo.lstValidLeadAssignmentWrapper){
                    
                    if(mapLeadVsDealerAssign.get(objLeadAssignmentWrapper.lead.Id) != null){
                        Lead_Dealer_Assignment_Audit__c objLeadDlrAssgnAdt = mapLeadVsDealerAssign.get(objLeadAssignmentWrapper.lead.Id);
                        
                        for(Lead_Eligible_Dealers__c objEligibleDlr : objLeadAssignmentWrapper.lstEligible_Dealers){
                            if(objEligibleDlr.Dealer__c != objLeadAssignmentWrapper.lead.Dealer_Locator_Selection__c){
                                objEligibleDlr.Lead_Dealer_Assignment_Audit__c = objLeadDlrAssgnAdt.Id;
                                lstLeadElgDlrs.add(objEligibleDlr);
                            }else{
                                objEligibleDlr.Selected__c = true;
                                objEligibleDlr.Lead_Dealer_Assignment_Audit__c = objLeadDlrAssgnAdt.Id;
                                lstLeadElgDlrs.add(objEligibleDlr);
                            }
                        }
                    }
                }
                
                if(!lstLeadElgDlrs.isEmpty()){
                    list<Database.Saveresult> lstSaveRslt = database.insert(lstLeadElgDlrs);
                }
            }
            list<Database.Saveresult> lstLeadUpdateRslt = database.update(lstLead);
        }        
    }
    
    // Can we run future calls right now?
    public static boolean CanUseFutureContext() {
        boolean callStackLimitExceeded = Limits.getFutureCalls() >= Limits.getLimitFutureCalls();
        
        if (!callStackLimitExceeded) {
            return GetNumFutureCallsInLast24Hours() < getMaxFutureCallsAllowed();
        } else return false;
    }
    
    public static Integer getMaxFutureCallsAllowed() {
        Integer usersCount = [
            SELECT
            COUNT()
            FROM
            User 
            WHERE
            Profile.UserLicense.LicenseDefinitionKey IN ('SFDC','AUL','PID_FDC_FREE')];
        return Math.max(250000, usersCount*200);
    }
    
    public static Integer GetNumFutureCallsInLast24Hours() {
        return [select count() from AsyncApexJob 
                where CreatedDate >= :Datetime.now().addHours(-24) 
                and JobType = 'Future'];
    }

    public static Set<String> getSpdIds() {
        Set<String> spdIDSet = new Set<String>();
         spdIDSet.addAll(Label.SPDIds.split(','));
        return spdIDSet;
    }    
}