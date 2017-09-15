/*

Child of HandlerBase for handling opportunity trigger actions

Class:              OpportunityAfterInsertHandler
Date:               1/19/2015
Version:            1
Last Updated:       1/19/2015

Updated Praveen K Emmadi 1/20/2015 Copied the OppTrigger.trigger
                                              OpportunityTriggerSharingAndSurvey.Trigger  

////////////////////////////////////////////////////////////////////////////////
*/

public without sharing  class OpportunityAfterInsertHandler extends TriggerHandlerBase{

    // -------- Constants --------
    // None
    
    // -------- Constructor --------
    public OpportunityAfterInsertHandler() {}

    // -------- Variables --------
    private Id homeOwnerRecordTypeId = OpportunityUtilities.homeOwnerRecordTypeId;
    private Id homeOwnerAccRT = AccountHandlerUtilities.ResidentialRecTypeId;
    DealerGeneral__c dg = OpportunityUtilities.DealerGeneralInstance;
    
    // -------- Properties --------

    // ----Qualified records for actions----
    private Map<ID, Opportunity> newOpportunityMap;
    private Map<ID, Opportunity> oldOpportunityMap;
    private List<Opportunity> newOpportunityList;
    private List<Opportunity> oldOpportunityList;
    private Map<Id, Opportunity> qualifiedOpportunities;

    private List<Opportunity> oppsToRollup;
    private List<Opportunity> oppShare;
    private Set<Id> dealerComplianceSet;
    private Map<Id, Opportunity> queryforAccountInfoMap;
    private List<Opportunity> sharingRuleList;
  
    private Map<Id, Opportunity> mapOppsForSalesSurvey;
    private Map<Id, Opportunity> mapOppsForInstallSurvey;
    private Map<Id, Opportunity> mapOppsFor1YCheckInSurvey;

    //--------Collections for callouts-----
    private Set<Id> five9CalloutSet;

    //-------Collections for DML--------
    private List<Opportunity> oppsForDealerCompliance;
    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        newOpportunityMap = (Map<ID, Opportunity>)newMap;
        oldOpportunityMap = (Map<ID, Opportunity>)oldMap;
        newOpportunityList = (List<Opportunity>)newList;
        oldOpportunityList = (List<Opportunity>)oldList;
        qualifiedOpportunities = new Map<Id, Opportunity>();

        five9CalloutSet = new Set<Id>();
        oppsToRollup = new List<Opportunity>();
        oppShare = new List<Opportunity>();
        mapOppsForInstallSurvey = new Map<Id, Opportunity>();
        mapOppsFor1YCheckInSurvey = new Map<Id, Opportunity>();
        mapOppsForSalesSurvey = new Map<Id, Opportunity>();
        dealerComplianceSet = new Set<Id>();
        queryforAccountInfoMap = new Map<Id, Opportunity>();
        Map<Id, Id> accOppComplianceMap; 
		sharingRuleList = new List<Opportunity>();
        
        Set<String> spdIDSet = new Set<String>();
            spdIDSet.addAll(Label.SPDIds.split(','));

        List<Five9WebserviceCalloutSettings__c> fcs = Five9WebserviceCalloutSettings__c.getall().values(); 
        
        for(Opportunity o: newOpportunityList){

            //Start afterOpportunityInsert trigger: Five9CallHandler class
            if(!fcs.isEmpty() && fcs[0].MasterSwitchOn__c && spdIDSet.contains(o.Partner_Account_Id__c)){
                five9CalloutSet.add(o.Id);
            }

            //if(o.Lead_Manufacturer__c == 'SunPower'){
            if(o.Lead_Manufacturer__c == 'SunPower' && o.StageName != 'New Opportunity') {
                oppsToRollup.add(o);
                qualifiedOpportunities.put(o.Id, o);
            }//end afterOpportunityInsert

            //Start opportunityTriggerSharingAndSurvey
            if(o.RecordTypeId == homeOwnerRecordTypeId && o.OwnerId != null && o.Partner_Account_Id__c != null){
                if(SurveyUtility.isValidOppForSalesSurvey(o)) {             
                   mapOppsForSalesSurvey.put(o.Id, o); 
                }
                if(SurveyUtility.isValidOppForInstallSurvey(o)) {
                   mapOppsForInstallSurvey.put(o.Id, o);   
                }
                if(SurveyUtility.isValidOppFor1YrSurveys(o)) {
                   mapOppsFor1YCheckInSurvey.put(o.Id, o);    
                }
            } //end opportunityTriggerSharingAndSurvey

            //Start OpportunitySharingTrigger
            System.debug('o.OwnerId: ' + o.OwnerId);
            System.debug('o.PartnerAccountId: ' + o.PartnerAccountId);
            System.debug('o.Partner_Account_Id__c: ' + o.Partner_Account_Id__c);
            if((util.isInContextOfLeadConversion() != true) &&
               ((o.RecordTypeId == homeOwnerRecordTypeId && o.OwnerId != null) 
               || (o.RecordTypeId == homeOwnerRecordTypeId && o.Partner_Account_Id__c != null)
               || (o.RecordTypeId == homeOwnerRecordTypeId && o.PartnerAccountId != null))){
                sharingRuleList.add(o);
                   System.debug('Sharing Added');
               }//end OpportunitySharingTrigger
               
            //Start OpportunityAfteInsertTrigger trigger
            if(o.AccountId != null && o.RecordTypeId == homeOwnerRecordTypeId 
               && o.Account.RecordTypeId == homeOwnerAccRT && (o.Theater__c == 'North America' || o.Theater__c == 'Australia')){
                   qualifiedOpportunities.put(o.Id, o);
            }


            if(o.RecordTypeId == homeOwnerRecordTypeId && (o.Theater__c == 'North America' || o.Theater__c == 'Australia')) {
                queryforAccountInfoMap.put(o.AccountId, o);
                qualifiedOpportunities.put(o.Id, o);
            }
        }
    }

	// Start processing
	public override void start() {
        List<Account> accListForDealerCompliance = new List<Account>();
        oppsForDealerCompliance = new List<Opportunity>();
        if(!queryForAccountInfoMap.isEmpty()) {
           accListForDealerCompliance = [SELECT Id, RecordTypeId 
                                         FROM Account 
                                         WHERE Id IN: queryforAccountInfoMap.keySet() 
                                         AND RecordTypeId =: homeOwnerAccRT];   
        }

        for(Account a : accListForDealerCompliance) {
            for(Id i : queryforAccountInfoMap.keySet()) {
                if(a.Id == i) {
                    dealerComplianceSet.add(queryForAccountInfoMap.get(i).Id);
                }
            }
        }

        //afterOpportunityInsert trigger: DealerUtility.updateContactRole
        if(!ReferralManagementCallout.inBatchContext)
        	OpportunityUtilities.updateContactRoleFuture(newOpportunityMap.keySet());
        
         
        if(qualifiedOpportunities.size() > 0){
            for(Opportunity o : qualifiedOpportunities.values()){
                
                if(dealerComplianceSet.contains(o.Id)){
                    //if(DealerComplianceUtility.isValidForDealerCompliance(o, o.Account.RecordTypeId, o.RecordTypeId)){
                    system.debug('creating dealer compliance');
                    DealerComplianceUtility.createDealerComplianceRecords(o);//inserts individual records, too many dmls if mass inserting these
                }
            }
        }		
    }

	public override void finish(Boolean fromStart){
           
        if (fromStart) {
            if(!oppsToRollup.isEmpty() && dg != null && dg.Enable_ALR_Dealer_Scoring__c == true){
                CalculateDealerRollups.calculateRollupsInsert(oppsToRollup);
            }
            //afterOpportunityInsert trigger: OpportunityManagement2.afterOpportunityInsert
            if(!sharingRuleList.isEmpty() && !Util.isInContextOfLeadConversion()){
                OpportunityUtilities.addSharingRule3(sharingRuleList, null, false);
            }

            if(!five9CalloutSet.isEmpty() && !Util.isInContextOfLeadConversion()) {
                Five9CallHandler.calloutfive9(five9CalloutSet);  //does callout.  Could move callout method(s) in handler (also used in after update)
            }
            if(!mapOppsForSalesSurvey.isEmpty()){
                system.debug('mapOppsForSalesSurvey Size: ' + mapOppsForSalesSurvey.size());
                SurveyUtility.createSalesSurvey(mapOppsForSalesSurvey);   
            }
            //Call Install Survey Creation/Updation Functionality
            if(!mapOppsForInstallSurvey.isEmpty()){
                SurveyUtility.createInstallSurvey(mapOppsForInstallSurvey); 
            }
            //Call 1st Year Checkin Survey Creation/Updation Functionality
            if(!mapOppsFor1YCheckInSurvey.isEmpty()){
                SurveyUtility.create1YCheckInSurvey(mapOppsFor1YCheckInSurvey); 
            }

            //afterOpportunityInsert trigger: 
            ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(newOpportunityList);
            
    	}
    
    }

	// -------- Internal Classes --------

    
}