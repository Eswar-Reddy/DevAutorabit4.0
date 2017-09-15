/*

Child of HandlerBase for handling opportunity trigger actions

Class:              OpportunityBeforeInsertHandler
Date:               1/19/2015
Version:            1
Last Updated:       1/19/2015


Refactor By: Chaitanya, Crystal
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing  class OpportunityBeforeInsertHandler extends TriggerHandlerBase{

    // -------- Constants --------
    Id resiRecordTypeId = OpportunityUtilities.homeOwnerRecordTypeId;
    Id CommRecordTypeID = OpportunityUtilities.commercialOppRecTypeId;
    User currentUser = OpportunityUtilities.currentOppUser;
    DealerGeneral__c dg = OpportunityUtilities.DealerGeneralInstance;
    
    // -------- Constructor --------
    public OpportunityBeforeInsertHandler() {}

    // -------- Variables --------
    // None
    
    // -------- Properties --------
    private List<Opportunity> newOpportunityList;
    private List<Opportunity> oppsToCalculate;
    
    
    // ----Qualified records for actions----
    private Map<Integer, Opportunity> qualifiedOpportunities;
    Set<Id> oppOwnerIds;
    Set<Opportunity> oppsForEmails;
    Set<Opportunity> oppsForSPWeeks = new Set<Opportunity>();
    Set<Opportunity> oppsForTheaterFields;
    Set<Opportunity> oppsForNameFix;
    Map<Id, Account> mapAccount;
    //---------Collections for queries----
    Map<ID,User> mapOppOwner;
    Set<String> setDates = new Set<String>();
    Map<String, Double> mapSPWeeks;
    Set<Id> setOppAccount;
    Set<Id> setOppPartnerAccount;
    Set<Integer> setOppsFromAcc;
    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        Map<ID, Opportunity> newOpportunityMap = (Map<ID, Opportunity>)newMap;
        Map<ID, Opportunity> oldOpportunityMap = (Map<ID, Opportunity>)oldMap;
        newOpportunityList = (List<Opportunity>)newList;
        List<Opportunity> oldOpportunityList = (List<Opportunity>)oldList;
        qualifiedOpportunities = new Map<Integer, Opportunity>();
        oppOwnerIds = new Set<Id>();
        oppsForEmails = new Set<Opportunity>();
        oppsToCalculate = new List<Opportunity>();
        oppsForTheaterFields = new Set<Opportunity>();
        oppsForNameFix = new Set<Opportunity>();
        setOppAccount = new Set<Id>();
        setOppPartnerAccount = new Set<Id>();
        setOppsFromAcc = new Set<Integer>();
        
        //launch Sepctrum logic qualifier
        //OpportunityUtilities.qualifySpectrumRecords(newOpportunityList);
        
        //Begin qualificaiton loop 
        for(Integer i=0;i<newOpportunityList.size();i++){
            Opportunity o = newOpportunityList[i];
            
            //From beforeOpportunityInsert Trigger, OpportunityManagement2.beforeOpportunityInsert, setStatus_Date(), CalculateCalendarWeek()
            setStatusAndDates(o);//passing all opportunites for multiple field updates/setting scenarios; most if not all opps need this
            
            //From beforeOpportunityInsert Trigger, OpportunityManagement2.beforeOpportunityInsert, setTheaterVal()
            if(UserInfo.getUserType() == 'PowerPartner' && (o.RecordTypeId == resiRecordTypeId || o.RecordTypeId == CommRecordTypeID)) {
                oppsForTheaterFields.add(o);
                qualifiedOpportunities.put(i,o);
            }
                
            //Pulled from OpportunityManagement2.setStatus_Date() segregation of query usage
            //case 00103412
            if(o.OwnerId != null) {
                oppOwnerIds.add(o.OwnerId);
                oppsForEmails.add(o);
                qualifiedOpportunities.put(i,o);
            }
            
            //from beforeOpportnityInsert Trigger, ln. 12-19
            if(o.Lead_Manufacturer__c == 'SunPower') {
                oppsToCalculate.add(o);
                qualifiedOpportunities.put(i,o);
            }
            //From ... Trigger, DealerUtility.FixOpportunityName()
            if(o.RecordTypeId == resiRecordTypeId && String.valueOf(o.Name).contains(String.valueOf(System.today()))){
                oppsForNameFix.add(o);
                //system.debug('added a record to name fix set');
                qualifiedOpportunities.put(i,o);
            }

            //Moved from after insert
            //afterOpportunityInsert trigger: OpportunityManagement2.afterOpportunityInsert
            if(o.AccountID != null || o.Dealer_Selection__c != null || o.PartnerAccountId != null){
                setOppAccount.add(o.AccountID);
                if(o.Dealer_Selection__c != null) {
                    setOppPartnerAccount.add(o.Dealer_Selection__c);
                } else if(o.PartnerAccountID != null) {
                    setOppPartnerAccount.add(o.PartnerAccountId);
                }
                setOppsFromAcc.add(i);
                qualifiedOpportunities.put(i, o);
            }
            
            //Added PT#134622273 - WW05 2017 - Commercial workstream: Pre-Validate Opportunity Score and Products before standard validations (UX improvement)
            if(!Util.currentUser.BypassValidation__c && o.RecordTypeId == OpportunityUtilities.systemOppRecTypeId 
                && o.Business_Unit__c == 'NA Commercial' && o.StageName == '02 - Finalize SSO') {
                validateNACRequirements(o);
            }
        }
    }

    // Start processing
    public override void start() {
        //Launch Spectrum Start
      //  OpportunityUtilities.start();
        
         
        //Pulled from OpportunityManagement2.setStatus_Date() segregation of query usage
        //case 00103412
        if(!oppOwnerIds.isEmpty()) {
            mapOppOwner = new Map<ID,User>([SELECT Id, Email, Manager.Email FROM User WHERE Id IN: oppOwnerIds]);
        }
        
        //query SP_Week__c for Text_Date__c and SP_week__c fields
        if(!setDates.isEmpty()) {
            //query SP_Week__c for Text_Date__c and SP_week__c fields
            List<SP_Week_Lookup__c> lstSPWeeks = new List<SP_Week_Lookup__c>();
            lstSPWeeks = [SELECT Id, Name, SP_Week__c, Text_Date__c FROM SP_Week_Lookup__c WHERE Text_Date__c IN: setDates];

            //create a map Map<String, String> with key as Text_Date__c and value as SP_Week__c
            mapSPWeeks = new Map<String, Double>();
            for(SP_Week_Lookup__c spWeekObj : lstSPWeeks){
                if(!mapSPWeeks.containsKey(spWeekObj.Text_Date__c)){
                    mapSPWeeks.put(spWeekObj.Text_Date__c, spWeekObj.SP_Week__c);
                }
            }
        }

        //System.debug('ACCTSETS*****:'+setOppAccount+'  '+setOppPartnerAccount);
        //Diagnostics.debug('ACCTSETS*****:'+setOppAccount+'  '+setOppPartnerAccount);
        if(!setOppAccount.isEmpty() || !setOppPartnerAccount.isEmpty()){
            mapAccount = new Map<Id, Account>([SELECT Id, BillingPostalCode, Territory__c, Theater__c, RSM__c, CRSM__c, Type
                                                       FROM Account
                                                       WHERE Id IN: setOppAccount OR Id IN: setOppPartnerAccount]);
            //System.debug('*MAPACCT****:'+mapAccount);
        }
        
        //begin qualifiedOpportunity loop processing
        system.debug('qualified Opportunites to process: ' + qualifiedOpportunities.size());
        if(qualifiedOpportunities.size() > 0){
            for(Integer i : qualifiedOpportunities.keySet()){
                Opportunity o = qualifiedOpportunities.get(i);               
      
                if(oppsForSPWeeks.contains(o)) {
                    if(mapSPWeeks.containsKey(o.Opportunity_CreatedDate_Text__c)){
                        if(o.SP_Week__c == null){
                            o.SP_Week__c = mapSPWeeks.get(o.Opportunity_CreatedDate_Text__c);
                        }
                    }
                    else{
                        o.SP_Week__c = 0;
                    }
                }
                if(oppsForTheaterFields.contains(o)){
                    setTheaterVals(o);
                }
                if(oppsForEmails.contains(o)) {
                    setOwnerEmails(o);
                }
                if(oppsForNameFix.contains(o)) {
                    //system.debug('fixing name');
                    String currentName = o.Name;
                    o.Name = currentName.Replace(String.valueOf(System.today()),'');
                    //system.debug(o.Name + ' is the new name ;)');
                }
                if(setOppsFromAcc.contains(i)){
                    setRegionTheaterRSMFields(o);
                }
            }
        }
    }

    public override void finish(Boolean fromStart){
           
        if (fromStart) {

            //TimelyUpdate Calculation from beforeOpportunityInsert trigger
            if (dg != null && !oppsToCalculate.isEmpty() && dg.Enable_ALR_Dealer_Scoring__c == true)
                DealerUtility.CalculateTimelyUpdateOnOpportunity(oppsToCalculate);
        }
    }

    // -------- Internal Classes --------
    private Opportunity validateNACRequirements(Opportunity opp) {
        /*KM_05042017: removing validation; pivotal#144136083
        if(opp.Opportunity_Score_Rollup__c == null || opp.Opportunity_Score_Rollup__c < 1) {
            opp.addError('Missing Opportunity Score Card record.');
        }*/
        if(opp.System_SizePV__c == null || opp.System_SizePV__c == 0 || opp.System_SizeBOS__c == null || opp.System_SizeBOS__c == 0) {
            opp.addError('Mounting and PV Module is required to be added under Products.');
        }
        return opp;
    }
    
    private Opportunity setStatusAndDates(Opportunity opp) {
        // ALR Change
        if(opp.Dealer_Selection__c != null)
            opp.Partner_Account_Id__c = opp.Dealer_Selection__c;
        //DateTime var for setting text fields
        DateTime opportunityCreatedDateTime;
        Date opportunityCreatedDate;
        //from OpportunityManagement2.setOwnerFromLead()
        if(opp.Converted_Lead_Opp_Owner__c == null && opp.OwnerId != null)
            opp.Converted_Lead_Opp_Owner__c = opp.OwnerId;
        //from OpportunityManagement2.setStatus_Date()
        if(opp.CampaignId != null){
            opp.Campaign_Source_Date__c = DateTime.now();
        } 
        if(opp.isClosed && opp.Actual_Close_Date__c == null){
            opp.Actual_Close_Date__c = DateTime.now();
        }   
        if(opp.RecordTypeId == ResiRecordTypeID){
            if(opp.StageName == '10% - Qualified Opportunity') {
                opp.Opportunity_Status__c = 'Qualified';
                
                if(opp.Qualified_Date__c == null)
                    opp.Qualified_Date__c = Date.today();
            } else if(opp.StageName == '30% - Opportunity Contacted') {
                opp.Opportunity_Status__c = 'Active';
                
                if (opp.Opportunity_Contacted_Date__c == null)
                    opp.Opportunity_Contacted_Date__c = Date.Today();
                
            } else if(opp.StageName == '60% - Visit Completed') {
                opp.Opportunity_Status__c = 'Active';
                
                if(opp.Visit_Completed_Date__c == null)
                    opp.Visit_Completed_Date__c = Date.today();
                
            } else if(opp.StageName.startsWith('100%'))
                opp.Opportunity_Status__c = 'Closed Won';
            
            else if(opp.StageName.startsWith('0%'))
                opp.Opportunity_Status__c = 'Closed Lost';
            
            else if(opp.StageName == 'Future Follow-up'){
                opp.Opportunity_Status__c = 'On Hold';
                if (opp.Future_Follow_up_Date__c == null)
                    opp.Future_Follow_up_Date__c = Date.today();
            }
            if(opp.StageName == 'Future Follow-up'){
                opp.Opportunity_Contacted_Date__c = null;
                opp.Visit_Completed_Date__c = null;
            }
            //Residential ends
            //Commercial starts
        }else if(opp.RecordTypeId == CommRecordTypeID){
            if(opp.StageName == '12% - Qualified Opportunity')
                opp.Opportunity_Status__c = 'Qualified';
            else if(opp.StageName == '20% - Site Audit Received/PV&I Only'
                    || opp.StageName == '20% - Site Audit Received'
                    || opp.StageName == '35% - EPA/Quote Issued'
                    || opp.StageName == '50% - Financing & Rebate in Place'
                    || opp.StageName == '75% - Verbal commitment of imminent PO')
                opp.Opportunity_Status__c = 'Active';
            else if(opp.StageName == '85% - PO Received by SPWR'
                    || opp.StageName == '95% - Down Payment Received by SPWR'
                    || opp.StageName == '95% - PO Submitted'
                    || opp.StageName.startsWith('100%'))
                opp.Opportunity_Status__c = 'Closed Won';
            else if(opp.StageName.startsWith('0%'))
                opp.Opportunity_Status__c = 'Closed Lost';
            else if(opp.StageName == 'Future Follow-up')
                opp.Opportunity_Status__c = 'On Hold';
        }
        if(opp.Opportunity_CreatedDate__c == null){
            opportunityCreatedDateTime = DateTime.now();
        } else {
            opportunityCreatedDateTime = opp.Opportunity_CreatedDate__c;
        }
        System.debug(LoggingLevel.ERROR,'----------opp.Opportunity_CreatedDate_Text__c'+opp.Opportunity_CreatedDate_Text__c);
        if(opp.Opportunity_CreatedDate_Text__c == null) {
            opportunityCreatedDate = Date.newInstance(opportunityCreatedDateTime.year(), opportunityCreatedDateTime.month(), opportunityCreatedDateTime.day());
            opp.Opportunity_CreatedDate_Text__c = String.valueOf(opportunityCreatedDate).replace('-', '');
            //System.debug('opp added to SP Weeks set');
         }
        setDates.add(opp.Opportunity_CreatedDate_Text__c);
        oppsForSPWeeks.add(opp);
        return opp;
    }
    
    private Opportunity setOwnerEmails(Opportunity opp) {
        if(mapOppOwner.containsKey(opp.OwnerID)) {
            opp.Opportunity_Owner_s_Manager__c = mapOppOwner.get(opp.OwnerID).manager.email;
            opp.Owner_Email__c  = mapOppOwner.get(opp.OwnerID).email;
        }
        return opp;
    }
    
    //From OpportunityManagement2.setTheaterVal()
    private Opportunity setTheaterVals(Opportunity opp) {
        if(currentUser != null && opp.RecordTypeId == resiRecordTypeId ){
            opp.Theater__c = currentUser.Contact.Account.Theater__c;
        }
        //Start 00108873
        if(opp.Theater__c == 'North America' && opp.RecordTypeId == CommRecordTypeId){
            opp.business_unit__c = 'RLC';
            opp.RLC_type__c = 'Light Commercial';
        }
        if(opp.Theater__c == 'North America' && opp.Theater__c =='Central America and the Caribbean'){
            opp.Customer_Satisfaction_survey_opt_in__c = TRUE;
        }else if(opp.Theater__c != 'North America' && opp.Theater__c !='Central America and the Caribbean')
            opp.Customer_Satisfaction_survey_opt_in__c = False;
        //End 00108873
        return opp;
    }

    private void setRegionTheaterRSMFields(Opportunity opp){
        boolean isRegionSet = false;
        boolean isTheaterSet = false;
        boolean isRSMSet = false;
        boolean isCRSMSet = false;
        boolean isHiddenPartnerAccountSet = false;

        //Set Region__c,Theater__c,RSMName__c field from partner account
        if(mapAccount!= null && opp.Dealer_Selection__c != null && mapAccount.containsKey(opp.Dealer_Selection__c)){
            //Set Region__c
            if(mapAccount.get(opp.Dealer_Selection__c).territory__c != null && mapAccount.get(opp.Dealer_Selection__c).territory__c != '') {
                opp.Region__c = mapAccount.get(opp.Dealer_Selection__c).territory__c;
                isRegionSet = true;
            } else {
                if(mapAccount != null && mapAccount.get(opp.PartnerAccountID) != null && mapAccount.get(opp.PartnerAccountID).territory__c != null && mapAccount.get(opp.PartnerAccountID).territory__c != ''){
                    opp.Region__c = mapAccount.get(opp.Dealer_Selection__c).territory__c;
                    isRegionSet = true;
                }
            }

            //Set Theater__c
            if(mapAccount.get(opp.Dealer_Selection__c).Theater__c!=null && mapAccount.get(opp.Dealer_Selection__c).Theater__c!=''){
                String theater = mapAccount.get(opp.Dealer_Selection__c).Theater__c;
                opp.Theater__c=theater;
                isTheaterSet = true;
            } else {
                 if(mapAccount.get(opp.PartnerAccountID).Theater__c!=null && mapAccount.get(opp.PartnerAccountID).Theater__c!=''){
                     String theater = mapAccount.get(opp.PartnerAccountID).Theater__c;
                     opp.Theater__c=theater;
                     isTheaterSet = true;
                 }
            }
            //Set RSM
            if(mapAccount.get(opp.Dealer_Selection__c) !=null ){
                opp.RSMName__c = mapAccount.get(opp.Dealer_Selection__c).RSM__c;
                isRSMSet = true;
            } else {
                if(mapAccount.get(opp.PartnerAccountID) !=null ){
                    opp.RSMName__c = mapAccount.get(opp.PartnerAccountID).RSM__c;
                    isRSMSet = true;
                }
            }

            // newly added code for case # 00045462 to populate CRSM__c
            if(mapAccount.get(opp.Dealer_Selection__c).CRSM__c !=null  && opp.RecordTypeId == CommRecordTypeID  ){
                opp.CRSM__c = mapAccount.get(opp.Dealer_Selection__c).CRSM__c;
                isCRSMSet = true;
            } else {
                if(mapAccount != null && mapAccount.get(opp.PartnerAccountID) != null && mapAccount.get(opp.PartnerAccountID).CRSM__c !=null  && opp.RecordTypeId == CommRecordTypeID  ){
                    opp.CRSM__c = mapAccount.get(opp.PartnerAccountID).CRSM__c;
                    isCRSMSet = true;
                }
            }

            //newly added code for case #12129 - updated as per ALR updates
            if(opp.PartnerAccountId != null) {
                opp.Partner_Account_Id__c = opp.PartnerAccountID;
                isHiddenPartnerAccountSet = true;
            }else if(opp.Dealer_Selection__c != null) {
                opp.Partner_Account_Id__c = opp.Dealer_Selection__c;
                isHiddenPartnerAccountSet = true;
            }
            
        }

        //Set Region__c,Theater__c,RSMName__c field from account if not set from partner account
        if(opp.AccountID!=null && mapAccount.containsKey(opp.AccountID)){
            system.debug('+++++2++++++');
            //Diagnostics.debug('ACCRSMSET****'+opp);
            //Set Region__c
            if(!isRegionSet){
                opp.Region__c = mapAccount.get(opp.AccountID).territory__c;
                isRegionSet = true;
            }

            //Set Theater__c
            if(!isTheaterSet){
                String theater = mapAccount.get(opp.AccountID).Theater__c;
                opp.Theater__c=theater;
                isTheaterSet = true;
            }


            //RSM should only be set from partner account otherwise it is set to null
            if(!isRSMSet){
                opp.RSMName__c = null;
                isRSMSet  = true;
            }

            /*// set CRSM for case # 00045462 from account if partner account is null
            if(!isCRSMSet && mapAccount.get(opp.AccountID).CRSM__c !=null  && opp.RecordTypeId == CommRecordTypeID){
                oppNew.CRSM__c = mapAccount.get(opp.AccountID).CRSM__c;
                isCRSMSet = true;
            }*/

        }
        if(isRegionSet || isTheaterSet || isRSMSet || isCRSMSet || isHiddenPartnerAccountSet){
            //Start 97082
            Set<String> stageSet = new Set<String>{'New Opportunity', 'Contacted', 'Visit Completed', 'Contract Signed', 'Opportunity Lost'};
            if(!util.byPassValidation() && opp != null && opp.RecordTypeId == CommRecordTypeID && stageSet.contains(opp.Stage_Name_Duplicate__c)){
                opp.addError('You cannot create a Commercial Opportunity Deal, Please change record type.');
            }
            Set<String> typeSet = new Set<String>{'Authorized-Partner-Residential', 'Premier-Partner-Residential', 'Elite-Partner-Residential'};
            if(!util.byPassValidation() && opp != null && opp.RecordTypeId == CommRecordTypeID && mapAccount.get(opp.PartnerAccountID) != null 
                && mapAccount.get(opp.AccountID)!= null && typeSet.contains(mapAccount.get(opp.PartnerAccountID).Type)
                && mapAccount.get(opp.AccountID).Theater__c == 'North America'){
                opp.addError('You cannot create a Commercial Opportunity Deal - please change record type.');
            }
   
        }
    
    }
  
    //
}