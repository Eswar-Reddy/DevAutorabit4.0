/*

Child of HandlerBase for handling opportunity trigger actions

Class:              OpportunityBeforeUpdateHandler
Date:               1/19/2015
Version:            1
Last Updated:       1/19/2015


Refactor BY: Crystal, Chaitanya 1/20/2015
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class OpportunityBeforeUpdateHandler extends TriggerHandlerBase{ 

    // -------- Constants --------
    String uType = UserInfo.getUserType();
    Id commercialRecTypeId = OpportunityUtilities.commercialOppRecTypeId;
    DealerGeneral__c dg = OpportunityUtilities.DealerGeneralInstance;
    
    
    // -------- Constructor --------
    public OpportunityBeforeUpdateHandler() {}

    // -------- Variables --------
    private Map<ID, Opportunity> oldOpportunityMap;
    private Map<ID, Opportunity> newOpportunityMap;
    private List<Opportunity> newOpportunityList;
    private List<Opportunity> oldOpportunityList;
    private List<Opportunity> oppsToRollup;

    // None
    
    // -------- Properties --------

    // ----Qualified records for actions----
    private Map<Id, Opportunity> qualifiedOpportunities;
    Set<Id> oppRoleAmountIdSet;
    Set<Opportunity> oppsToRoleUp;
    Map<Id, Opportunity> oppsForFieldUpdates;
    private Set<Id> accountChangedSet;
    private Map<ID,Account> mapAccount;
    private Map <Id, Opportunity> nacRequirementsQualifyMap;
    
    //---------Collections for queries----
    Map<ID,Opportunity_Role__c> mapOppWithOppRole;
    Set<Id> accQuerySet;
    
    //---------Collections For Updates
    List<Opportunity_Role__c> oppRolesToUpdate = new List<Opportunity_Role__c>();

    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        newOpportunityMap = (Map<ID, Opportunity>)newMap;
        oldOpportunityMap = (Map<ID, Opportunity>)oldMap;
        newOpportunityList = (List<Opportunity>)newList;
        oldOpportunityList = (List<Opportunity>)oldList;
        qualifiedOpportunities = new Map<Id, Opportunity>();
        oppsToRoleUp = new Set<Opportunity>();
        oppsForFieldUpdates = new Map<Id,Opportunity>();
        accountChangedSet = new Set<Id>();
        accQuerySet = new Set<Id>();
        oppRoleAmountIdSet = new Set<Id>();
        oppsToRollup = new List<Opportunity>();
        nacRequirementsQualifyMap = new Map<Id, Opportunity>();
        
        //qualify Spectrum beforeUpdate
        //OpportunityUtilities.qualifySpectrumRecordsBU(newOpportunityMap, oldOpportunityMap);
        
        for(Opportunity o: newOpportunityList){
            if(!o.Call_Trigger__c){   //what is this field? Is it still used does this need this condition?                         
                if(uType == 'PowerPartner' && o.type =='Commercial' && o.isApproved__c && (o.System_Size_KwP__c != oldOpportunityMap.get(o.Id).System_Size_KwP__c)){
                    o.addError('Approved Opportunity System Size can not be changed.');
                }
            }
            //OpportunityManagement2.beforeOpportunityUpdate, setCommercialOppStage()
            if((o.Opportunity_Status__c == 'In Review' && o.Opportunity_Status__c != oldOpportunityMap.get(o.Id).Opportunity_Status__c)
                || (o.StageName == 'Installation Completed' && oldOpportunityMap.get(o.Id).stagename != o.StageName)
                || (o.RecordTypeId == commercialRecTypeId && 
                    (o.Opportunity_Status__c != null && o.Opportunity_Status__c != oldOpportunityMap.get(o.ID).Opportunity_Status__c) &&
                    (o.Opportunity_Status__c == 'Closed Lost' || o.Opportunity_Status__c == 'Dead' || o.Opportunity_Status__c == 'On Hold')
                    )) {
                    oppsForFieldUpdates.put(o.Id, o);
                    qualifiedOpportunities.put(o.Id, o);
            }
            //UpdateOpportunityRoleAmountValue Trigger 
            if(o.Amount != null && o.Amount!= oldOpportunityMap.get(o.Id).Amount) {
                oppRoleAmountIdSet.add(o.Id);
                qualifiedOpportunities.put(o.Id, o);
            }
            //BeforeOpportunityUpdate Trigger
            if(o.Lead_Manufacturer__c == 'SunPower' && !string.isBlank(o.PartnerAccountId) && !string.isBlank(o.Partner_Account_Id__c) &&
               (o.StageName != oldOpportunityMap.get(o.Id).StageName || 
                o.Pass_SLA__c != oldOpportunityMap.get(o.Id).Pass_SLA__c || 
                o.SFDC_Timely_Updates__c != oldOpportunityMap.get(o.Id).SFDC_Timely_Updates__c ||
                o.SFDC_Timely_Update_Stages__c != oldOpportunityMap.get(o.Id).SFDC_Timely_Update_Stages__c ||
                o.PartnerAccountId != oldOpportunityMap.get(o.Id).PartnerAccountId ||
                o.Partner_Account_Id__c != oldOpportunityMap.get(o.Id).Partner_Account_Id__c ||
                o.OwnerId != oldOpportunityMap.get(o.Id).OwnerId)) {
                    oppsToRollUp.add(o);
                    qualifiedOpportunities.put(o.Id, o);
                }

            //Moved from after update.  OpportunityManagement2.updateOppRSM
            if((o.PartnerAccountId != oldOpportunityMap.get(o.Id).PartnerAccountId)
                ||(o.AccountId != oldOpportunityMap.get(o.Id).AccountId)
                ||(o.PartnerAccountId!=null && (o.Partner_Account_Id__c==null || o.Partner_Account_Id__c != oldOpportunityMap.get(o.Id).PartnerAccountId))){
                qualifiedOpportunities.put(o.Id, o);
                accountChangedSet.add(o.Id);
                accQuerySet.add(o.PartnerAccountId);
                accQuerySet.add(o.AccountId);
            }
            //Added PT#134622273 - WW05 2017 - Commercial workstream: Pre-Validate Opportunity Score and Products before standard validations (UX improvement)
            if(!Util.currentUser.BypassValidation__c && o.RecordTypeId == OpportunityUtilities.systemOppRecTypeId && o.Business_Unit__c == 'NA Commercial' 
                && o.StageName == '02 - Finalize SSO' && o.StageName != oldOpportunityMap.get(o.Id).StageName) {
                nacRequirementsQualifyMap.put(o.Id, o);
            }       

        }//end of For loop  
    }//end of Qualifying method



    // Start processing
    public override void start() {
        
        if(!accQuerySet.isEmpty()){
            mapAccount = new Map<ID,Account>([Select id,Territory__c,Theater__c,RSM__c,CRSM__c from Account where id in :accQuerySet]);
        }
    
        if(!oppRoleAmountIdSet.isEmpty()) {
            mapOppWithOppRole = new Map<ID,Opportunity_Role__c>([SELECT id, Amount__c, Opportunity__r.Id
                                                                 FROM Opportunity_Role__c 
                                                                 WHERE Opportunity__r.Id IN: oppRoleAmountIdSet]);
        }
        
        //Begin qualifiedOpportunities loop
        if(qualifiedOpportunities.size() > 0){
            for(Opportunity o : qualifiedOpportunities.values()){
                if(oppRoleAmountIdSet.contains(o.Id)) {
                    doUpdateOppRole(o);
                }
                if(accountChangedSet.contains(o.Id)){
                    accountChangedFieldUpdates(o);
                }
                if(oppsForFieldUpdates.containsKey(o.Id)){
                    updateFields(o);
                }
            }
        } 
        
        if (nacRequirementsQualifyMap.size() > 0) {
            validateNACRequirements(nacRequirementsQualifyMap);
        }      
    }// end of start


    public override void finish(Boolean fromStart){   
        if (fromStart){
            //Update Opportunity Roles to new Amount 
            if (!oppRolesToUpdate.isEmpty()) {        
                update oppRolesToUpdate;
            }

            if(!oppsToRollup.isEmpty()){
                if(dg != null && dg.Enable_ALR_Dealer_Scoring__c == true)
                    DealerUtility.CalculateTimelyUpdateOnOpportunity(oppsToRollup);
            }
        }
    }
    

    // -------- Internal Classes --------
    private static void validateNACRequirements(Map <Id, Opportunity>nacRequirementsQualifyMap) {
        for (Opportunity opp : nacRequirementsQualifyMap.values()) {
            if(opp.System_SizePV__c == null || opp.System_SizePV__c == 0 || opp.System_SizeBOS__c == null || opp.System_SizeBOS__c == 0) {
                opp.addError('Mounting and PV Module is required to be added under Products.');
            }
        }

        List <Opportunity> opptyList = [SELECT Id, Name, 
                (SELECT Id FROM OpportunityLineItems WHERE PricebookEntry.Product2.Product_Type__c = 'Storage')
            FROM Opportunity WHERE Id IN :nacRequirementsQualifyMap.keySet()];    
        for (Opportunity oppty : opptyList) {
            if (oppty.OpportunityLineItems == null || oppty.OpportunityLineItems.size() == 0) {
                nacRequirementsQualifyMap.get(oppty.Id).addError('At least one storage product must be added to the opportunity when changing Sales Stage to 2');
            }
        }
    }
     
    private List<Opportunity_Role__c> doUpdateOppRole(Opportunity o) {
        for(Opportunity_Role__c oppRole : mapOppWithOppRole.values()) {
            if(o.Id == oppRole.Opportunity__r.Id) {
                oppRole.Amount__c = o.Amount;
                oppRolesToUpdate.add(oppRole);
            }
        }
        return oppRolesToUpdate;
    }
    
    private Opportunity updateFields(Opportunity o) {
        if(o.Opportunity_Status__c == 'Closed Lost' || o.Opportunity_Status__c == 'Dead') {
            o.StageName = '0% - Dead, Lost';
        } 
        if(o.Opportunity_Status__c == 'On Hold') {
            o.StageName = 'Future Follow-up';
        }
        if(o.StageName == 'Installation Completed') {
            o.Opportunity_Status__c = 'Closed Won';
        }
        return o;
    }

    private void accountChangedFieldUpdates(Opportunity o){
        boolean isRSMSet = false;
        boolean isRegionSet = false;
        boolean isTheaterSet = false;
        boolean isHiddenPartnerAccountSet  = false;
        boolean isCRSMSet = false;
        //Set Region__c,Theater__c,RSMName__c field from partner account
        if(o.PartnerAccountID!=null && mapAccount.containsKey(o.PartnerAccountID)){  
            //Set Region__c
            if(mapAccount.get(o.PartnerAccountID).Territory__c!=null && mapAccount.get(o.PartnerAccountID).Territory__c!=''){
                if(o.Region__c!=mapAccount.get(o.PartnerAccountID).Territory__c){
                    o.Region__c = mapAccount.get(o.PartnerAccountID).Territory__c;
                }
                isRegionSet = true;
            }

            //Set Theater__c
            if(mapAccount.get(o.PartnerAccountID).Theater__c!=null && mapAccount.get(o.PartnerAccountID).Theater__c!=''){
                if(o.Theater__c!=mapAccount.get(o.PartnerAccountID).Theater__c){
                    o.Theater__c = mapAccount.get(o.PartnerAccountID).Theater__c;
                }
                isTheaterSet = true;
            }

            if(mapAccount.get(o.PartnerAccountID) !=null ){
                if(o.RSMName__c != mapAccount.get(o.PartnerAccountID).RSM__c){
                    o.RSMName__c = mapAccount.get(o.PartnerAccountID).RSM__c;
                }
                isRSMSet = true;
            }

            // newly added code for case # 00045462 to populate CRSM__c on afterOppUpdate
            if(mapAccount.get(o.PartnerAccountID).CRSM__c !=null && o.RecordTypeId == commercialRecTypeId){
                o.CRSM__c = mapAccount.get(o.PartnerAccountID).CRSM__c;
                isCRSMSet = true;
            }

            //set hidden field Partner Account Id as Partner Account
           if(o.Partner_Account_Id__c !=mapAccount.get(o.PartnerAccountID).id){
                o.Partner_Account_Id__c = mapAccount.get(o.PartnerAccountID).id;
           }


        }

        //Set Region__c,Theater__c,RSMName__c field from account if not set from partner account
        if(o.AccountID!=null && mapAccount.containsKey(o.AccountID)){
             //Set Region__c
            if(!isRegionSet){
                if(o.Region__c != mapAccount.get(o.AccountID).territory__c){
                    o.Region__c = mapAccount.get(o.AccountID).territory__c;
                }
            }

            //Set Theater__c
            if(!isTheaterSet){
                if(o.Theater__c!= mapAccount.get(o.AccountID).Theater__c){
                    o.Theater__c= mapAccount.get(o.AccountID).Theater__c;
                }
            }

            //RSM should only be set from partner account otherwise it is set to null
            if(!isRSMSet){
                if(o.RSMName__c != null){
                    o.RSMName__c = null;
                }
            }

            /*//Set CRSM__c field from account if not set from partner account for case #00045462
            if(!isCRSMSet && mapAccount.get(opp.AccountID).CRSM__c !=null && opp.RecordTypeId == COMMERCIAL_RecordType_ID ){
                opp.CRSM__c = mapAccount.get(opp.AccountID).CRSM__c;
                isChanged = true;
            }  */

        }
    
    }
    
}