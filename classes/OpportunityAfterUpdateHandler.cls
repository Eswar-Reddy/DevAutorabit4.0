/*

Child of HandlerBase for handling opportunity trigger actions

Class:              OpportunityAfterUpdateHandler
Date:               1/19/2015
Version:            1
Last Updated:       1/19/2015


CHANGE HISTORY:

version: KCM_03072016
author: Kane Chelster Macaspac
last modified date/time: 03-08-2016 06:55AM Pacific
details:
1. change is to address issues reported in cases 00673302 and 00674000 due to a null object reference
2. with the help of Sangita and Crystal, modified code to ensure a call will not be made to a null object
3. please use the version name above as a search term in order to identify the parts of the code that is 
   specific to this change/version.
      
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class OpportunityAfterUpdateHandler extends TriggerHandlerBase{

    // -------- Constants --------
    private static Id idHomeOwnerRT = OpportunityUtilities.homeOwnerRecordTypeId;
    private Id homeOwnerAccRT = AccountHandlerUtilities.ResidentialRecTypeId;
    DealerGeneral__c dg = OpportunityUtilities.DealerGeneralInstance;
    // -------- Constructor --------
    public OpportunityAfterUpdateHandler() {}

    // -------- Variables --------
    // None
    
    // -------- Properties --------

    // ----Qualified records for actions----
    private Map<ID, Opportunity> newOpportunityMap;
    private Map<ID, Opportunity> oldOpportunityMap;
    private List<Opportunity> newOpportunityList;
    private List<Opportunity> oldOpportunityList;
    private List<Opportunity> delOppList;
    private Map<Id, Opportunity> qualifiedOpportunities;
    private Set<Id> oppsToAddSurvey;
    private Map<ID,set<ID>> mapAccountInstaller;
    private Map<ID,set<ID>> mapOppInstaller;
    private List<Opportunity> oppsToRollup;
    private List<Opportunity> sharingRuleList;
    private List<Opportunity> sharingRuleListOld;
    private Map<Id, Opportunity> newOppsForSalesSurvey;
    private Map<Id, Opportunity> newOppsForInstallSurvey;
    private Map<Id, Opportunity> newOppsFor1YCheckInSurvey;
    private Set<Id> oppHomeOwnerId;


    //---------Collections for queries----
    private Set<Id> accQuerySet;
    private Set<Id> accUpdateQuerySet;
    private Set<Id> oppDesignQuerySet;
    private Set<Id> installeridQuerySet;
    private Set<Id> setAccountShareid;
    private Set<Id> setOpportunityShareid;
    private Set<Id> setInstallerQueryDel;
    private Set<Id> setOppShareDelete;
    private Set<Id> ownerNotifyQuerySet;

    //--------Collections for callouts-----
    private Set<Id> oppIdfive9Set;

    //--------Collections for DML---------
    private List<AccountShare> listAccountShare;
    private List<OpportunityShare> listOpportunityShare;
    private List<OpportunityShare> listOpportunityShareDelete;
    private List<Post_Visit_Follow_Up_Survey__c> surveyList;
    //private List<Account> accountsToUpdate;
    private Map<Id, Account> accountsToUpdate;
    private List<Opportunity_Design__c> odsUpdateList;
    private List<Opportunity_Design__c> odsInsertList;
    
    //Co branding
        Set<string> tempList = new Set<string>();
        List<Account> tempAccList = new List<Account>();
    set<Id> AllAccid = new set<Id>();
    set<Id> Accid = new set<Id>();
    set<Id> LeaseAccid = new set<Id>();

    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

        newOpportunityMap = (Map<ID, Opportunity>)newMap;
        oldOpportunityMap = (Map<ID, Opportunity>)oldMap;
        newOpportunityList = (List<Opportunity>)newList;
        oldOpportunityList = (List<Opportunity>)oldList;
        qualifiedOpportunities = new Map<Id, Opportunity>();
        
        //accountsToUpdate = new List<Account>();
        accountsToUpdate = new Map<Id, Account>();
        installeridQuerySet = new Set<Id>();
        oppsToAddSurvey = new Set<Id>();
        mapAccountInstaller = new Map<ID,set<ID>>();
        mapOppInstaller = new Map<ID,set<ID>>();
        setAccountShareid = new Set<Id>();
        setOpportunityShareid = new Set<Id>();
        delOppList = new List<Opportunity>();
        setOppShareDelete = new Set<Id>();
        setInstallerQueryDel = new Set<Id>();
        oppIdfive9Set = new Set<Id>();
        oppsToRollup = new List<Opportunity>();
        ownerNotifyQuerySet = new Set<Id>();
        sharingRuleList = new List<Opportunity>();
        sharingRuleListOld = new List<Opportunity>();
        newOppsForSalesSurvey = new Map<Id, Opportunity>();
        newOppsForInstallSurvey = new Map<Id, Opportunity>();
        newOppsFor1YCheckInSurvey = new Map<Id, Opportunity>();
        oppDesignQuerySet = new Set<Id>();
        listAccountShare = new List<AccountShare>();
        oppHomeOwnerId = new Set<Id>();

        Map<String,InstallerSharingCountries__c> iscMap = InstallerSharingCountries__c.getAll();

        //afterOpportunityUpdate trigger:  Five9CallHandler class
        //Initialization for callout
        Set<String> spdIDSet = new Set<String>();
        spdIDSet.addAll(Label.SPDIds.split(','));
        Set<String> oppStageSet = new Set<String>();
        List<Five9WebserviceCalloutSettings__c> fcs = Five9WebserviceCalloutSettings__c.getall().values();
        if(!fcs.isEmpty() && !ReferralManagementCallout.inBatchContext ){
            oppStageSet.addAll(fcs[0].OpportunityStages__c.split(','));
        }

        for(Opportunity o: newOpportunityList){

            //afterOpportunityUpdate trigger: OpportunityMangement2.createSurveyRowAndMail
            system.debug('Sangita---1-Calling survey');
            if(o.Send_Mail__c && o.Send_Mail__c != oldOpportunityMap.get(o.Id).Send_Mail__c &&  System.today().daysBetween(o.CreatedDate.date()) == -31 && o.PartnerAccountId!= null){
               system.debug('Sangita---2-Calling survey');
                qualifiedOpportunities.put(o.Id, o);
                oppsToAddSurvey.add(o.Id);
            }

            
            if(o.AccountId != null && 
               ((o.Customer_Satisfaction_survey_opt_in__c != oldOpportunityMap.get(o.Id).Customer_Satisfaction_survey_opt_in__c) ||
               (o.Quality_Inspection_opt_in__c != oldOpportunityMap.get(o.Id).Quality_Inspection_opt_in__c) ||
               (o.Marketing_opt_in__c != oldOpportunityMap.get(o.Id).Marketing_opt_in__c) ||
               (o.Warranty_Signed_Italy__c != oldOpportunityMap.get(o.Id).Warranty_Signed_Italy__c) ||
               (o.Credit_Application_Status__c != oldOpportunityMap.get(o.Id).Credit_Application_Status__c) ||
               (String.isNotBlank(o.Credit_Application_ID__c) && String.isBlank(oldOpportunityMap.get(o.Id).Credit_Application_ID__c)))) {
                   setRelatedAcctFields(o, oldOpportunityMap.get(o.Id));
              } //CRYSTAL - TESTING
                
        
            //afterOpportunityUpdate trigger: OpportunityDesignUpdate.opptyAfterUpdate
            if(o.Design_Photo__c != oldOpportunityMap.get(o.Id).Design_Photo__c){
                oppDesignQuerySet.add(o.Id);
                qualifiedOpportunities.put(o.Id, o);
            }

            //afterOpportunityUpdate trigger: InstallerSharingUtil.prepOpportunitySharing/insertOpportunitySharing
            if((o.Installer__c!=null && o.Installer__c!=o.AccountId && o.Installer__c!=o.PartnerAccountId && iscMap.containsKey(o.Theater__c) && o.Installer__c!=oldOpportunityMap.get(o.Id).Installer__c) || (o.OwnerId!=oldOpportunityMap.get(o.Id).OwnerId && o.Installer__c!=null)){
                
                Id installerID = null;
                if(o.inStaller__r.Parent != null)
                    installerID = o.inStaller__r.Parent.id;
                else
                    installerID = o.Installer__c;

                installeridQuerySet.add(installerID);

                if(o.AccountId!= null){ 
                    setAccountShareid.add(o.AccountId);
                    if(mapAccountInstaller.containsKey(installerID)){
                        mapAccountInstaller.get(installerID).add(o.AccountId);
                    }else
                        mapAccountInstaller.put(installerID,new set<id>{o.AccountId});
                }
                setOpportunityShareid .add(o.Id);
                if(mapOppInstaller.containsKey(installerID)){
                    mapOppInstaller.get(installerID).add(o.Id);
                }else
                    mapOppInstaller.put(installerID,new set<id>{o.Id});
            }

            //afterOpportunityUpdate trigger: InstallerSharingUtil.deleteOpportunitySharing
            if(o.Installer__c!=oldOpportunityMap.get(o.Id).Installer__c && oldOpportunityMap.get(o.Id).Installer__c!=null && iscMap.containsKey(o.Theater__c)){
                setOppShareDelete.add(o.Id);
                delOppList.add(oldOpportunityMap.get(o.Id));
                /*if(o.inStaller__r.Parent != null)
                    setInstallerQueryDel.add(o.inStaller__r.Parent.id);
                else
                    setInstallerQueryDel.add(o.Installer__c);
                */
                /*** R. Alega Case 00544758 START
                24.JULY.2015 
                Problem: Previous sharing is not deleted when Installer field gets updated with the new IP.
                Resolution: Replaced the New Opportunity map with the Old Opportunity Map to get the Old value of Installer field to get the previous sharing that needs to be deleted. 
                START
                ***/
                if(oldOpportunityMap.get(o.id).inStaller__r.Parent != null)
                    setInstallerQueryDel.add(oldOpportunityMap.get(o.id).inStaller__r.Parent.id);
                else
                    setInstallerQueryDel.add(oldOpportunityMap.get(o.id).inStaller__c);
                /*** R. Alega Case 00544758 END ***/

            } 
    
            //afterOpportunityUpdate trigger:  Five9CallHandler class
            //Did processOpportunities method in this handler, so went straight to calloutFive9 method with proper set of oppIds
            if(!fcs.isEmpty() && fcs[0].MasterSwitchOn__c==true){
                if((o.Partner_Account_Id__c!=oldOpportunityMap.get(o.Id).Partner_Account_Id__c) && spdIDSet.contains(o.Partner_Account_Id__c) && oppStageSet.contains(o.StageName)){
                    oppIdfive9Set.add(o.Id);
                }
            }

            //afterOpportunityUpdate trigger
            //Uses functionality in CaculateDealerScore
            if((o.StageName != oldOpportunityMap.get(o.Id).StageName || 
                o.Pass_SLA__c != oldOpportunityMap.get(o.Id).Pass_SLA__c || 
                o.SFDC_Timely_Updates__c != oldOpportunityMap.get(o.Id).SFDC_Timely_Updates__c ||
                o.SFDC_Timely_Update_Stages__c != oldOpportunityMap.get(o.Id).SFDC_Timely_Update_Stages__c ||
                o.PartnerAccountId != oldOpportunityMap.get(o.Id).PartnerAccountId ||
                o.Partner_Account_Id__c != oldOpportunityMap.get(o.Id).Partner_Account_Id__c ||
                o.OwnerId != oldOpportunityMap.get(o.Id).OwnerId ||
                o.Is_Excluded_From_SLA_Score__c != oldOpportunityMap.get(o.Id).Is_Excluded_From_SLA_Score__c) && o.Lead_Manufacturer__c == 'SunPower'){
                    if(!string.isBlank(o.PartnerAccountId)){
                        oppsToRollup.add(o);
                        oppsToRollup.add(oldOpportunityMap.get(o.Id));
                    }else if(!string.isBlank(o.Partner_Account_Id__c)){
                        oppsToRollup.add(o);
                        oppsToRollup.add(oldOpportunityMap.get(o.Id));
                    }
                }
            //end afterOpportunityUpdate trigger qualifications

            //start OpportunityNotificationTrigger
            if(o.OwnerId != null && o.OwnerId != oldOpportunityMap.get(o.Id).OwnerId && o.PartnerAccountID != null && o.PartnerAccountID != oldOpportunityMap.get(o.Id).PartnerAccountID 
                    && (o.Lead_Manufacturer__c == 'SunPower') && (o.StageName == 'New Opportunity') && (o.RecordTypeId == idHomeOwnerRT)){
                ownerNotifyQuerySet.add(o.Id);
                qualifiedOpportunities.put(o.Id, o);
            }//end OpportunityNotificationTrigger

            //Start OpportunitySharingTrigger
            System.debug('O.ownerId: ' + o.OwnerId);
            System.debug('OldMap ownerId: ' + oldOpportunityMap.get(o.Id).OwnerId);
            System.debug('Partner_Account_Id__c: ' + o.Partner_Account_Id__c);
            System.debug('OldMap Partner_Account_Id__c: ' + oldOpportunityMap.get(o.Id).Partner_Account_Id__c);
            //if(!util.isInContextOfLeadConversion() &&
            if((util.isInContextOfLeadConversion() != true) &&
               ((o.RecordTypeId == idHomeOwnerRT && o.OwnerId != oldOpportunityMap.get(o.Id).OwnerId) 
               || (o.RecordTypeId == idHomeOwnerRT && o.Partner_Account_Id__c != oldOpportunityMap.get(o.id).Partner_Account_Id__c)
               || (o.RecordTypeId == idHomeOwnerRT && o.PartnerAccountId != oldOpportunityMap.get(o.Id).PartnerAccountId))){
                   sharingRuleList.add(o);
                   sharingRuleListOld.add(oldOpportunityMap.get(o.Id));
                   System.debug('After Update Sharing added');
            }//end OpportunitySharingTrigger
            
            //Start OpportunityTriggerSharingAndSurvey
            if(o.RecordTypeId == idHomeOwnerRT ){
                
                if(SurveyUtility.isValidOppForSalesSurvey(o)) { 
                    system.debug('Sangita---4-Calling survey');            
                    newOppsForSalesSurvey.put(o.Id, o);                       
                }
                // Collect valid Records for "Opportunity for Install Survey"
                if(SurveyUtility.isValidOppForInstallSurvey(o)) {
                    system.debug('Sangita---5-Calling survey');
                    newOppsForInstallSurvey.put(o.Id, o);
                }
                // Collect valid Records for "Opportunity for 1st Year Check In Survey"
                if(SurveyUtility.isValidOppFor1YrSurveys(o)) {
                    system.debug('Sangita---6-Calling survey');
                    newOppsFor1YCheckInSurvey.put(o.Id, o); 
                }
            }//end OpportunityTriggerSharingAndSurvey

            //Start opportunityAfterUpdateTrigger
            if(o.AccountId != null && o.RecordTypeId == idHomeOwnerRT){
                oppHomeOwnerId.add(o.Id);
            }
            
            //case #00641878  Co Branding Starts
            
            if(oldOpportunityMap.get(o.Id).StageName != o.StageName && (o.StageName == 'Contract signed' || o.StageName =='Installation Completed' )){
                
                AllAccid.add(o.AccountId);
                qualifiedOpportunities.put(o.Id, o);
                system.debug('-------in side co branding 1-----'+AllAccid);
            }
            
            
            
        }
    }

    // Start processing
    public override void start() {

        surveyList = new List<Post_Visit_Follow_Up_Survey__c>();
        odsinsertList = new List<Opportunity_Design__c>();
        odsUpdateList = new List<Opportunity_Design__c>();
        listOpportunityShare = new List<OpportunityShare>();
        listOpportunityShareDelete = new List<OpportunityShare>();
        List<Opportunity_Design__c> oppDesignList = new List<Opportunity_Design__c>();
        Map<Id, Opportunity_Design__c> odsMap = new Map<Id, Opportunity_Design__c>();
        Map<ID,List<AccountShare>> mapAccountShare = new Map<ID,List<AccountShare>>();
        Map<ID,List<OpportunityShare>> mapOpportunityShare = new Map<ID,list<OpportunityShare>>();
        Map<ID,UserRole> mapUserRole = new Map<ID,UserRole>();
        Map<ID,Group> mapGroup = new Map<ID,Group>();
        

        if(!oppDesignQuerySet.isEmpty()){
            oppDesignList = [SELECT Id, Opportunity__c FROM Opportunity_Design__c WHERE Opportunity__c IN: oppDesignQuerySet];
            for(Opportunity_Design__c ods : oppDesignList){
                odsMap.put(ods.Opportunity__c,ods);
            }
        }
        
        Map<ID,UserRole> mapUserRoleDel= new Map<ID,UserRole>();
        Map<ID,UserRole> mapUserRoleReg = new Map<ID,UserRole>();
        Map<ID,Group>  mapGroupDel=new Map<ID,Group>();
        Map<ID,Group>  mapGroupReg=new Map<ID,Group>();
        Map<ID,set<ID>> mapAccountIDGroupDel = new Map<ID,set<ID>>();
        List<OpportunityShare> oppShareList = new List<OpportunityShare>();
        if(!installeridQuerySet.isEmpty() || !setInstallerQueryDel.isEmpty()){
            mapUserRole = new Map<ID,UserRole>([SELECT Id, PortalAccountId, Name 
                    FROM UserRole
                    WHERE (PortalAccountId IN: installeridQuerySet OR PortalAccountId IN: setInstallerQueryDel) AND name LIKE '%Partner Executive%']);    //R.ALEGA [07/20/2015] - Case 00544758 - Replaced the partner role from 'Partner User' to 'Partner Executive' 
            for(UserRole ur:mapUserRole.values()){
                if(installerIdQuerySet.contains(ur.PortalAccountId)){
                    mapUserRoleReg.put(ur.Id, ur);
                }else if(setInstallerQueryDel.contains(ur.PortalAccountId)){
                    mapUserRoleDel.put(ur.Id, ur);   
                }
            }
            if((mapUserRoleReg!=null && !mapUserRoleReg.isEmpty()) || (mapUserRoleDel!=null && !mapUserRoleDel.isEmpty())){
                mapGroup = new Map<ID,Group>([Select Id, RelatedId
                                                            From Group g
                                                            where g.Type='Role' 
                                                            and (g.RelatedId =: mapUserRoleReg.keySet() OR g.RelatedId =: mapUserRoleDel.keySet())]);
                for(Group gr: mapGroup.values()){
                    if(mapUserRoleReg.keySet().contains(gr.RelatedId)){
                        mapGroupReg.put(gr.Id, gr);
                    }else if(mapUserRoleDel.keySet().contains(gr.RelatedId)){
                        mapGroupDel.put(gr.Id, gr);   
                    }
                }
            }
            if(!installeridQuerySet.isEmpty()){
                if(!setAccountShareid.isEmpty() && !mapGroupReg.isEmpty()){
                for(AccountShare accshare : [SELECT Id, AccountID, UserorGroupID, AccountAccessLevel
                                             FROM AccountShare 
                                             WHERE accountID IN: setAccountShareid
                                             AND UserorGroupID IN: mapGroupReg.keySet()]){
                    if(mapAccountShare.containsKey(accshare.accountID)){
                        listAccountShare = mapAccountShare.get(accshare.accountID);
                        listAccountShare.add(accshare);
                        mapAccountShare.put(accshare.accountID,listAccountShare);
                    }else
                        mapAccountShare.put(accshare.accountID,new list<AccountShare>{accshare});
                    }
                }
                for(OpportunityShare oppshare : [Select Id, OpportunityId, UserorGroupID, OpportunityAccessLevel
                                                 FROM OpportunityShare
                                                 WHERE OpportunityId IN: setOpportunityShareid
                                                 AND UserorGroupID IN: mapGroupReg.keySet()]){
                    if(mapOpportunityShare.containsKey(oppshare.OpportunityId)){
                        listOpportunityShare = mapOpportunityShare.get(oppshare.OpportunityId);
                        listOpportunityShare.add(oppshare);
                        mapOpportunityShare.put(oppshare.OpportunityId,listOpportunityShare);
                    }else
                        mapOpportunityShare.put(oppshare.OpportunityId,new list<OpportunityShare>{oppshare});
                }
                oppAccShareFieldSet(mapUserRoleReg, mapGroupReg, mapAccountShare, mapOpportunityShare); 
            }
            if(!setInstallerQueryDel.isEmpty()){
                for(UserRole objUserRole : mapUserRoleDel.values()){
                    for(Group objGroup: mapGroupDel.values()){
                        if(objGroup.RelatedId == objUserRole.Id){
                            if(mapAccountIDGroupDel.containsKey(objuserRole.PortalAccountId)){
                                set<ID> setID = mapAccountIDGroupDel.get(objuserRole.PortalAccountId);
                                setID.add(objGroup.Id);
                                mapAccountIDGroupDel.put(objuserRole.PortalAccountId,setID);
                            }else
                                mapAccountIDGroupDel.put(objuserRole.PortalAccountId,new set<id>{objGroup.Id});
                        }
                    }
                }
                Set<Id> userorGroupIDSet = new Set<Id>();
                for(Opportunity opp: delOppList){
                    if(mapAccountIDGroupDel.containsKey(opp.Installer__c))
                        userorGroupIDSet.addAll(mapAccountIDGroupDel.get(opp.Installer__c));
                }
                oppShareList = [SELECT UserorGroupId, OpportunityId, RowCause
                                FROM OpportunityShare 
                                WHERE OpportunityId in: setOppShareDelete
                                AND UserorGroupID in: UserorGroupIDSet and RowCause='Manual'];
            }
        }

        Map<String, Dealer_Notification__c> notificationMap = new Map<String, Dealer_Notification__c>();
        Map<Id, User> ownerMap;
        if(!ownerNotifyQuerySet.isEmpty()){
            for(Dealer_Notification__c note : [SELECT Id, RelatedObjectId__c, Type__c, isSent__c, sendTo__c, Activity__c FROM Dealer_Notification__c WHERE RelatedObjectId__c in :ownerNotifyQuerySet]) {
                String key = note.RelatedObjectId__c + '-' + note.Type__c + '-' + note.Activity__c + '-' + note.IsSent__c;
                notificationMap.put(key, note);
            }
            ownerMap = new Map<Id, User>([SELECT Id, FirstName, Email, MobilePhone, Phone 
                                          FROM User 
                                          WHERE Id IN: ownerNotifyQuerySet 
                                          AND (UserType = 'Partner' OR UserType = 'PowerPartner')]);

        }

        if(!newOppsForSalesSurvey.isEmpty()){
            system.debug('Sangita---8-Calling survey');
            SurveyUtility.createSalesSurvey(newOppsForSalesSurvey);  //has bug 
        }
        //Call Install Survey Creation/Updation Functionality
        if(!newOppsForInstallSurvey.isEmpty()) {
            system.debug('Sangita---9-Calling survey');
            SurveyUtility.createInstallSurvey(newOppsForInstallSurvey);
        }
            
        //Call 1st Year Checkin Survey Creation/Updation Functionality
        if(!newOppsFor1YCheckInSurvey.isEmpty()){
            system.debug('Sangita---10-Calling survey');
            SurveyUtility.create1YCheckInSurvey(newOppsFor1YCheckInSurvey);
        }

        Map<Id, Opportunity> oppstoAddDCR = new Map<Id, Opportunity>();
        if(!oppHomeOwnerId.isEmpty()){
            //Get Existing DC (Dealer Compliance) records
            Map<String,String> MapOpptytoDCR = new Map<String,String>();
            
            for (Dealer_Compliance_Requirement__c DCR :[Select id, Opportunity__c 
                                                        From Dealer_Compliance_Requirement__c Where Opportunity__c in : (oppHomeOwnerId)]){
                MapOpptytoDCR.put(DCR.Opportunity__c,DCR.id);
            }
            
            //query opps to get acc rt (added conditions from DealerComplianceUtility.isValidForDealerCompliance() right into query)
            Map<Id, Opportunity> oppstoAddDCRTemp = new Map<Id, Opportunity>([SELECT Id, Account.Partner_Account__c, AccountId, Name,  Theater__c,  //R.A. 26.SEPT.2014 - Added AccountId on Opportunity Query - Case  00353484
                                         Account.RecordTypeId, RecordTypeId, OwnerId, Owner.IsPortalEnabled 
                                  FROM Opportunity 
                                  WHERE Id IN: oppHomeOwnerId AND Id NOT IN: MapOpptytoDCR.keySet() 
                                  AND (Account.RecordTypeId =: homeOwnerAccRT) AND (Theater__c = 'North America' OR Theater__c = 'Australia')]);
            oppstoAddDCR = oppstoAddDCRTemp; 
        }

        if(qualifiedOpportunities.size() > 0){
            for(Opportunity o : qualifiedOpportunities.values()){

                if(oppsToAddSurvey.contains(o.Id)){
                system.debug('Sangita---11-Calling survey');
                    Post_Visit_Follow_Up_Survey__c survey = new Post_Visit_Follow_Up_Survey__c();
                    survey.Status_Survey__c = 'Sent';
                    survey.Name = 'Survey for ' + o.Name;
                    survey.Opportunity_ID__c = o.Id;
                    //survey.Partner_Contact__c = o.PartnerAccountId;  //Was commented originally
                    survey.Partner_Account__c = o.PartnerAccountId;
                    survey.Customer_Contact__c = o.Primary_Contact__c;
                    survey.Customer_Account__c = o.AccountId;
                    surveyList.add(survey);
                }


                if(oppDesignQuerySet.contains(o.Id)){

                    if(odsMap.containsKey(o.Id)){
                        Opportunity_Design__c odsUpdate = odsMap.get(o.Id);
                        odsUpdate.Design_Photo__c=o.Design_Photo__c;
                        odsUpdateList.add(odsUpdate);
                    }else{
                        Opportunity_Design__c odsInsert = new Opportunity_Design__c(Opportunity__c=o.Id,Design_Photo__c=o.Design_Photo__c);
                        odsinsertList.add(odsInsert);
                    }
                }

                if(setOppShareDelete.contains(o.Id)){
                    for(OpportunityShare oppShare:oppShareList){
                        /*** R. Alega Case 00544758 START ***/
                        if(oppShare.OpportunityId==o.Id && mapAccountIDGroupDel.containsKey(oldOpportunityMap.get(o.Id).Installer__c) && mapAccountIDGroupDel.get(oldOpportunityMap.get(o.Id).Installer__c).contains(oppShare.UserorGroupID))
                            listOpportunityShareDelete.add(oppShare);
                        /*** R. Alega Case 00544758 END ***/
                    }
                }

                if(ownerMap != null && ownerMap.containsKey(o.OwnerId)) {
                    String key = o.Id + '-Chatter-OpportunityAssignment';
                    if(!notificationMap.containsKey(key)){
                        ChatterNotificationUtility.createOppAssignmentPost(o, 'OpportunityAssignment', null);
                    }
                }
                
                if(oppstoAddDCR != null && oppstoAddDCR.containsKey(o.Id)){
                    DealerComplianceUtility.createDealerComplianceRecords(o);
                }
            }
        }
        
        // Co Branding
            if(AllAccid.size()>0){
                
                for( Account a: [Select id,DSE_CustomerType__c from Account where id in :AllAccid]){
                    
                    if(a.DSE_CustomerType__c =='Cash' ){
                        Accid.add(a.Id);
                    }
                    if(a.DSE_CustomerType__c =='Lease' ){
                        LeaseAccid.add(a.Id);
                    }
                }
            }
            // Co Branding Cash only
            if(Accid.size() > 0){
            
                system.debug('-------in side co branding 2-----');
                 List<Co_Branding_Patner__c> CB = Co_Branding_Patner__c.getall().values();
              
                for(Opportunity  opp : [ Select Id,AccountId,Account.DSE_IsCustomer__c,StageName,Account.BillingState,Account.DSE_CustomerType__c,Account.Partner_Account__r.Name from Opportunity where AccountId in :Accid]){
                    
                    system.debug('-------in side co branding 3-----');
                    for(Co_Branding_Patner__c  cp :CB ){
                        
                        system.debug('-------in side -----'+opp.StageName);
                        system.debug('-------in side -----'+cp.OPPORTUNITY_STAGE__c);
                        
                        system.debug('-------in side -----'+opp.Account.DSE_CustomerType__c);
                        system.debug('-------in side -----'+cp.DEAL_TYPE__c);
                        
                        if( opp.Account.DSE_IsCustomer__c==true && cp.State__c.contains(opp.Account.BillingState) && cp.DEAL_TYPE__c.contains(opp.Account.DSE_CustomerType__c) && (cp.SELLING_ENTITY__c == 'ALL' || opp.Account.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) && cp.OPPORTUNITY_STAGE__c.contains(opp.StageName)) {
                            
                            tempList.add( opp.AccountId +','+cp.CO_BRAND_Partner__c);
                            system.debug('-------in side co branding satisf-----');
                                
                        }   
                    }   
                    
                }
                system.debug('-------in side co branding 4-----'+tempList);
            }
            // Co Branding Lease only
            if(LeaseAccid.size() > 0){
            
                system.debug('-------in side co branding 2-----');
                 List<Co_Branding_Patner__c> CB = Co_Branding_Patner__c.getall().values();
              
                for(LeasePayment__c  Lpo : [ Select Id,Funding_Tranche__c,Opportunity__r.StageName,Account__c,Account__r.BillingState,Account__r.DSE_CustomerType__c,Account__r.DSE_IsCustomer__c ,Account__r.Partner_Account__r.Name from LeasePayment__c where Account__c in :LeaseAccid ]){
                    
                    system.debug('-------in side co branding 3-----');
                    for(Co_Branding_Patner__c  cp :CB ){
                             
                        //KCM_03072016: Sangita commented out old code causing issue
                        /*   if( (cp.Financier__c=='' || cp.Financier__c.contains(Lpo.Funding_Tranche__c) ) && cp.State__c.contains(Lpo.Account__r.BillingState) && cp.DEAL_TYPE__c.contains(Lpo.Account__r.DSE_CustomerType__c) && (cp.SELLING_ENTITY__c == 'ALL' || Lpo.Account__r.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) && cp.OPPORTUNITY_STAGE__c.contains(Lpo.Opportunity__r.StageName)) {*/
                       
                       //KCM_03072016: the modified code to eliminate runtime null object references                       
                       if(( cp.Financier__c=='' || 
                             (cp.Financier__c != null && Lpo.Funding_Tranche__c!= null && cp.Financier__c.contains(Lpo.Funding_Tranche__c) )) && 
                             cp.State__c.contains(Lpo.Account__r.BillingState) && 
                             cp.DEAL_TYPE__c.contains(Lpo.Account__r.DSE_CustomerType__c) && 
                             (cp.SELLING_ENTITY__c == 'ALL' || 
                             Lpo.Account__r.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) && 
                             cp.OPPORTUNITY_STAGE__c.contains(Lpo.Opportunity__r.StageName)) {
                           
                            tempList.add( Lpo.Account__c +','+cp.CO_BRAND_Partner__c);
                            system.debug('-------in side co branding satisf-----');
                                
                        }   
                    }   
                    
                }
                system.debug('-------in side co branding 4-----'+tempList);
            }
            
            
    }

    public override void finish(Boolean fromStart){

        if (fromStart) {
            if(!oppsToRollup.isEmpty()){
                if (dg.Enable_ALR_Dealer_Scoring__c == true) CalculateDealerRollups.calculateRollupsInsert(oppsToRollup);
            }
            
            if(!sharingRuleList.isEmpty()){
                OpportunityUtilities.addSharingRule3(sharingRuleList, sharingRuleListOld, true);
            }
            
            if(!surveyList.isEmpty()){
            system.debug('Sangita---12- Calling survey');
                upsert surveyList;  //insert?
            }
            if(!accountsToUpdate.isEmpty()){
                update accountsToUpdate.values();
            }
            if(!odsUpdateList.isEmpty()){
                update odsUpdateList;
            }
            if(odsInsertList!=null && odsInsertList.size()>0){
                insert odsInsertList;
            }
            if(!listAccountShare.isEmpty() && false){ //In original code a flag is passed to make this not happen, hence the false condition.  Could probably trim out some code from oppAccShareFieldSet as a result
                insert listAccountShare;
            }
            if(!listOpportunityShare.isEmpty()){
                insert listOpportunityShare;
            }
            if(!listOpportunityShareDelete.isEmpty()){
                delete listOpportunityShareDelete;
            }
            if(!oppIdFive9Set.isEmpty() && !Util.isInContextOfLeadConversion()) {
                Five9CallHandler.calloutfive9(oppIdfive9Set); 
            }

            // co branding
            
            if(tempList.size()>0){
            system.debug('------------'+tempList);
                for(Account acc : [Select id,CO_BRAND_Partner__c from Account Where id in :Accid]){
                    for( string st : tempList){
                            system.debug('------------'+st);
                            string s1 = st.substringBefore(',');
                            string s2 = st.substringAfter(',');
                        
                            if(s1 == acc.Id){
                                
                                    acc.CO_BRAND_Partner__c = s2;
                                    update acc;                             
                                    tempAccList.add(acc);
                                
                            }
                        
                    }
                } 
            //system.debug('-----tempAccList-------'+tempAccList);              

            }
            //if(tempAccList.size()>0){
                
                //update tempAccList;
            //}
            
            ReferralManagementCallout.executeSocialAnnexCalloutsOnUpdate(newOpportunityList, oldOpportunityMap);
            

        }
    }

    // -------- Internal Classes --------

    private void oppAccShareFieldSet(Map<Id, UserRole> mapUserRole, Map<Id, Group> mapGroup, Map<Id, List<AccountShare>> mapAccountShare, Map<ID,List<OpportunityShare>> mapOpportunityShare){
        Map<ID,Set<ID>> mapAccountIDGroup = new Map<ID,Set<ID>>();
        for(UserRole objUserRole : mapUserRole.values()){
            for(Group objGroup: mapGroup.values()){
                if(objGroup.RelatedId == objUserRole.Id){
                    if(mapAccountIDGroup.containsKey(objuserRole.PortalAccountId)){
                        set<ID> setID = mapAccountIDGroup.get(objuserRole.PortalAccountId);
                        setID.add(objGroup.Id);
                        mapAccountIDGroup.put(objuserRole.PortalAccountId,setID);
                    }else
                        mapAccountIDGroup.put(objuserRole.PortalAccountId,new set<id>{objGroup.Id});
                }
            }
        }
        for(ID idInstaller: mapAccountInstaller.keySet()){
            if(!mapAccountInstaller.isEmpty() && mapAccountInstaller.containsKey(idInstaller)){
                for(ID idAccount : mapAccountInstaller.get(idInstaller)){
                    if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                        for(ID idGrup : mapAccountIDGroup.get(idInstaller)){
                            boolean isExstingAccountShare = false;
                            if(!mapAccountShare.isEmpty() && mapAccountShare.containsKey(idAccount)){
                                for(AccountShare objAccountShare : mapAccountShare.get(idAccount)){
                                    if(!isExstingAccountShare && objAccountShare.accountID == idAccount && objAccountShare.UserorGroupID == idGrup && objAccountShare.AccountAccessLevel == 'Read'){
                                        isExstingAccountShare = true;
                                    }
                                }
                            }
                            if(!isExstingAccountShare){
                                AccountShare accountShare =  new AccountShare();
                                accountShare.accountID= idAccount;
                                accountShare.AccountAccessLevel ='Read';
                                accountShare.opportunityAccessLevel ='None';
                                accountShare.UserorGroupID =idGrup;
                                listAccountShare.add(accountShare);
                            }
                        }
                    }
                 
                }
            }
              
             
            if(!mapOppInstaller.isEmpty() && mapOppInstaller.containsKey(idInstaller)){
                for(ID idOpp : mapOppInstaller.get(idInstaller)){
                    if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                        for(ID idGroup : mapAccountIDGroup.get(idInstaller)){
                            boolean isExstingOppShare = false;
                            if(!mapOpportunityShare.isEmpty() && mapOpportunityShare.containsKey(idOpp)){
                                for(OpportunityShare objOpportunityShare : mapOpportunityShare.get(idOpp)){
                                    if(!isExstingOppShare && objOpportunityShare.OpportunityId == idOpp && objOpportunityShare.UserorGroupID == idGroup && objOpportunityShare.OpportunityAccessLevel == 'Edit'){
                                        isExstingOppShare = true;
                                    }
                                }
                            }
                            if(!isExstingOppShare){
                                OpportunityShare opportunityShare =  new OpportunityShare();
                                opportunityShare.OpportunityId= idOpp;
                                opportunityShare.OpportunityAccessLevel = 'Edit';
                                opportunityShare.UserorGroupID =idGroup;
                                listOpportunityShare.add(opportunityShare);
                            }
                        }
                    }
                }
            }
         }
    }
    
    private void setRelatedAcctFields(Opportunity newOpp, Opportunity oldOpp) {
        Boolean accountChanged = false;
        
        if(newOpp.AccountId != null) {
            Account acc = new Account(Id = newOpp.AccountId);
            if((newOpp.Customer_Satisfaction_survey_opt_in__c != oldOpp.Customer_Satisfaction_survey_opt_in__c) ||
               (newOpp.Quality_Inspection_opt_in__c != oldOpp.Quality_Inspection_opt_in__c) ||
               (newOpp.Marketing_opt_in__c != oldOpp.Marketing_opt_in__c) ||
               (newOpp.Warranty_Signed_Italy__c != oldOpp.Warranty_Signed_Italy__c)) {

                   acc.Participate_in_Customer_Survey__c = newOpp.Customer_Satisfaction_survey_opt_in__c;
                   acc.SunPower_Products_and_Services_Contact__c = newOpp.Marketing_opt_in__c == true ? 'Yes' : 'No';
                   acc.Participate_in_Inspection_Survey__c = newOpp.Quality_Inspection_opt_in__c;
                   acc.Warranty_Signed_Italy__c = newOpp.Warranty_Signed_Italy__c;
                   
                   accountChanged = true;
               }
            if(accountChanged){
                //accountsToUpdate.add(acc);
                accountsToUpdate.put(acc.id, acc);
            }
        }
    }
}