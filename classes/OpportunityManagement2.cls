public class OpportunityManagement2 {

    // public static final Integer DEFAULT_LIMIT_ProjectedDeliveryDate;
    public static final ID COMMERCIAL_RecordType_ID;
    private static final String ERROR_MSG_ProjectedDeliveryDate;


    static {
        // DEFAULT_LIMIT_ProjectedDeliveryDate = 120;
        ERROR_MSG_ProjectedDeliveryDate = 'PROJECTED DELIVERY is required.';

        COMMERCIAL_RecordType_ID = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial');
    }

    public static void beforeOpportunityInsert (List<Opportunity> opportunityList){

        //PARITOSH - CONDITION ADDED FOR BYPASSING THE STEPS TO REDUCE QUERIES DURING LEADCONVERSION AND IN CONTEXT OF TEST CLASS
        if(Test.isrunningtest() && util.isInContextOfLeadConversion()){
         return;
        }
        List<Opportunity> lstOppOld = new List<Opportunity>();
        setStatus_Date(opportunityList,lstOppOld);
        CalculateCalendarWeek(opportunityList);
        setTheaterVal(opportunityList);
        setOwnerFromLead(opportunityList);// for Case# 00060281
        // checkProjectedDeliveryDateBeforeInsert(opportunityList);
    }

    public static void beforeOpportunityUpdate (List<Opportunity> opportunityList,
            List<Opportunity> oldOpportunityList, Map<ID, Opportunity> newOpportunityMap,
            Map<ID, Opportunity> oldOpportunityMap) {
        setCommercialOppStage(opportunityList,oldOpportunityList);
        //New function added by Appirio Offshore (Prakash) Case:00011332

        // checkProjectedDeliveryDateBeforeUpdate(newOpportunityMap, oldOpportunityMap);
        // Done for case # 00063181 (set Opportunity Status on Installation Completed Stage)
        setOppStatus(opportunityList ,oldOpportunityMap);
        // Done for case # 00064999
        //validationRuleForProductSchedule(opportunityList ,oldOpportunityMap);
    }

    public static void afterOpportunityInsert (List<Opportunity> opportunityList){
SYSTEM.DEBUG('### afterOpportunityInsert ###');
      //PARITOSH - CONDITION ADDED FOR BYPASSING THE STEPS TO REDUCE QUERIES DURING LEADCONVERSION AND IN CONTEXT OF TEST CLASS
      if(Test.isrunningtest() && util.isInContextOfLeadConversion()){
      return;
      }
      System.debug('in after update opportunity controller #123');
      //addSharingRule(opportunityList, null, false); //*** DEPRICATED *** see  addSharingRule3() for new functionality
      addSharingRule3(opportunityList, null, false);

      SetFields(opportunityList);
    }

    public static void afterOpportunityUpdate (List<Opportunity> opportunityList,
      List<Opportunity> oldOpportunityList){
SYSTEM.DEBUG('### afterOpportunityUpdate  ###');
      if(!System.isfuture() && !System.isbatch()){
      //addSharingRule(opportunityList, oldOpportunityList, true);  //*** DEPRICATED *** see  addSharingRule3() for new functionality
      //addSharingRule3(opportunityList, oldOpportunityList, true);
      updateOppRSM(opportunityList, oldOpportunityList);

      //Case 83101 - Comment following method 'createSurveyRowAndMail' and call after removing workflow
      //for Case# 00046578
      createSurveyRowAndMail(opportunityList,oldOpportunityList);

      //updateRelatedAccount(opportunityList);
      Set<Id> oppIds = new Set<Id>();
      for(Opportunity Opp : opportunityList){
        oppIds.add(opp.Id);
      }
      updateRelatedAccount(oppIds);
      }
    }

    //Start for Case# 00060281
    public static void setOwnerFromLead (List<Opportunity> opportunityList){
      for(Opportunity newOpportunity : opportunityList){
        if(newOpportunity.Converted_Lead_Opp_Owner__c==null)
            newOpportunity.Converted_Lead_Opp_Owner__c = newOpportunity.OwnerId;
      }
    }
    //End for Case# 00060281
    private static void checkProjectedDeliveryDateBeforeInsert(List<Opportunity> newOpportunityList) {
        // Date defaultProjDelDate = Date.today().addDays(DEFAULT_LIMIT_ProjectedDeliveryDate);

        // Show error message if "Projected Delivery Date" is null
        for (Opportunity newOpportunity : newOpportunityList) {
            if (newOpportunity.RecordTypeId == COMMERCIAL_RecordType_ID
                    && newOpportunity.Projected_Delivery_Date__c == null) {
                // newOpportunity.Projected_Delivery_Date__c = defaultProjDelDate;
                newOpportunity.Projected_Delivery_Date__c.addError(ERROR_MSG_ProjectedDeliveryDate);
            }
        }
    }

    private static void checkProjectedDeliveryDateBeforeUpdate(Map<ID, Opportunity> newOpportunityMap,
            Map<ID, Opportunity> oldOpportunityMap) {

        // Add error message to updated opportunity if "Opportunity Status" is not "Closed Lost",
        // user is not updating record owner and "Projected Delivery Date" is blank
        for (Opportunity newOpportunity : newOpportunityMap.values()) {
            if (newOpportunity.Opportunity_Status__c != 'Closed Lost'
                    && newOpportunity.RecordTypeId == COMMERCIAL_RecordType_ID
                    && newOpportunity.OwnerId == oldOpportunityMap.get(newOpportunity.Id).OwnerId
                    && newOpportunity.Projected_Delivery_Date__c == null) {
                newOpportunity.Projected_Delivery_Date__c.addError(ERROR_MSG_ProjectedDeliveryDate);
            }
        }
    }

    private static void SetFields(List<Opportunity> opportunityList){
        List<Opportunity> lstOppsToUpdate = new List<Opportunity>();
        lstOppsToUpdate = SetRegionTheaterRSMFields(opportunityList);
        if(lstOppsToUpdate.size()>0){
            update lstOppsToUpdate;
        }
    }

    //Set fields Region__c,Theater__c,RSM_Name__c for opportunity
    private static List<Opportunity> SetRegionTheaterRSMFields(List<Opportunity> opportunityList){

        List<Opportunity> oppToUpdate = new List<Opportunity>();

        //Prepare set of Opportunities Account,partner account and owner IDs
        Set<String> setOppAccount = new Set<String>();
        Set<String> setOppPartnerAccount = new Set<String>();

        for(Opportunity opp:opportunityList){
            setOppAccount.Add(opp.AccountID);
            setOppPartnerAccount.Add(opp.PartnerAccountID);


        }

        //Prepare map for AccountID and Account detail
        List<Account> lstAcc = new List<Account>();
        Set<String> setZip = new Set<String>();
        lstAcc = [Select id,billingpostalCode,Territory__c,Theater__c,RSM__c,CRSM__c, Type
            from Account
            where id in :setOppAccount or id in :setOppPartnerAccount limit 1000];

        map<ID,Account> mapAccount = new map<ID,Account>();
        for(Account acc:lstAcc){
            mapAccount.put(acc.ID,acc);
        }


        //Traverse through each opportunity
        for(Opportunity opp:opportunityList){
            Opportunity oppNew = new Opportunity(id=opp.ID);
            boolean isRegionSet = false;
            boolean isTheaterSet = false;
            boolean isRSMSet = false;
            boolean isCRSMSet = false;
            boolean isHiddenPartnerAccountSet = false;
            system.debug('+++++0++++++');
            //Set Region__c,Theater__c,RSMName__c field from partner account
            if(opp.PartnerAccountID!=null && mapAccount.containsKey(opp.PartnerAccountID)){
                //Set Region__c
                if(mapAccount.get(opp.PartnerAccountID).territory__c!=null && mapAccount.get(opp.PartnerAccountID).territory__c!=''){
                    oppNew.Region__c = mapAccount.get(opp.PartnerAccountID).territory__c;
                    isRegionSet = true;
                }

                //Set Theater__c
                if(mapAccount.get(opp.PartnerAccountID).Theater__c!=null && mapAccount.get(opp.PartnerAccountID).Theater__c!=''){
                    String theater = mapAccount.get(opp.PartnerAccountID).Theater__c;
                    oppNew.Theater__c=theater;
                    isTheaterSet = true;
                }

                if(mapAccount.get(opp.PartnerAccountID) !=null ){
                    oppNew.RSMName__c = mapAccount.get(opp.PartnerAccountID).RSM__c;
                    isRSMSet = true;
                }

                // newly added code for case # 00045462 to populate CRSM__c
                if(mapAccount.get(opp.PartnerAccountID).CRSM__c !=null  && opp.RecordTypeId == COMMERCIAL_RecordType_ID  ){
                    oppNew.CRSM__c = mapAccount.get(opp.PartnerAccountID).CRSM__c;
                    isCRSMSet = true;
                }

                //newly added code for case #12129
                oppNew.Partner_Account_Id__c = opp.PartnerAccountID;
                isHiddenPartnerAccountSet = true;
            }

            //Set Region__c,Theater__c,RSMName__c field from account if not set from partner account
            if(opp.AccountID!=null && mapAccount.containsKey(opp.AccountID)){
                system.debug('+++++2++++++');
                //Set Region__c
                if(!isRegionSet){
                    oppNew.Region__c = mapAccount.get(opp.AccountID).territory__c;
                    isRegionSet = true;
                }

                //Set Theater__c
                if(!isTheaterSet){
                    String theater = mapAccount.get(opp.AccountID).Theater__c;
                    oppNew.Theater__c=theater;
                    isTheaterSet = true;
                }


                //RSM should only be set from partner account otherwise it is set to null
                if(!isRSMSet){
                    oppNew.RSMName__c = null;
                    isRSMSet  = true;
                }

                /*// set CRSM for case # 00045462 from account if partner account is null
                if(!isCRSMSet && mapAccount.get(opp.AccountID).CRSM__c !=null  && opp.RecordTypeId == COMMERCIAL_RecordType_ID){
                    oppNew.CRSM__c = mapAccount.get(opp.AccountID).CRSM__c;
                    isCRSMSet = true;
                }*/

            }
            if(isRegionSet || isTheaterSet || isRSMSet || isCRSMSet || isHiddenPartnerAccountSet){
                //Start 97082
                Set<String> stageSet = new Set<String>{'New Opportunity', 'Contacted', 'Visit Completed', 'Contract Signed', 'Opportunity Lost'};
                if(!util.byPassValidation() && opp != null && opp.RecordTypeId == COMMERCIAL_RecordType_ID && stageSet.contains(opp.Stage_Name_Duplicate__c)){
                    opp.addError('You cannot create a Commercial Opportunity Deal, Please change record type.');
                    continue;
                }
                Set<String> typeSet = new Set<String>{'Authorized-Partner-Residential', 'Premier-Partner-Residential', 'Elite-Partner-Residential'};
                if(!util.byPassValidation() && opp != null && opp.RecordTypeId == COMMERCIAL_RecordType_ID && mapAccount.get(opp.PartnerAccountID) != null && mapAccount.get(opp.AccountID)!= null && typeSet.contains(mapAccount.get(opp.PartnerAccountID).Type)
                    && mapAccount.get(opp.AccountID).Theater__c == 'North America'){
                    opp.addError('You cannot create a Commercial Opportunity Deal - please change record type.');
                    continue;
                }
                //End 97082
                oppToUpdate.Add(oppNew);
            }
        }
        return oppToUpdate;
    }


/***** DEPRICATED ******/
/*** See addSharingRule3() with regard to the new functionality. ***/

    private static void addSharingRule(List<Opportunity> opportunityList, List<Opportunity> oldOpportunityList, Boolean isUpdate){
      /**
      1. for each opportunity check for partner account field
      2. if the field has value, add that value to a set
      3. Fetch all Accounts whose id is in the set
      4. Add all accounts to a map as value and their ids as key
      5. for each opportunity, create sharing rule and insert it
      **/
/******
      List<Opportunity> opportunityListNew;
      System.debug('TEST@@@8 : ' + opportunityList);
      System.debug('TEST@@@9 : ' + oldOpportunityList);

      if(isUpdate){
        opportunityListNew = new List<Opportunity>();
        Map<Id,String> mapParnerAccount = new Map<Id,String>();
        Map<Id,String> mapOwner = new Map<Id,String>();
        //check whether partnerAccount/owner chanegs in case of update
        if(oldOpportunityList != null && oldOpportunityList.Size()>0){
            for(Opportunity opp : oldOpportunityList){
                mapParnerAccount.put(opp.Id , opp.PartnerAccountId);
                mapOwner.put(opp.Id, opp.OwnerId);
            }
        }

        if(opportunityList.Size()>0){
            System.debug('TEST@@@13 : ' + mapParnerAccount);
            System.debug('TEST@@@14 : ' + mapOwner);
            Boolean needToAdd;
            for(Opportunity opp : opportunityList){
                needToAdd = false;
                System.debug('TEST@@1 : ' + opp.PartnerAccountId +' TEST@@2 : ' + mapParnerAccount.get(opp.Id));
                System.debug('TEST@@3 : ' + opp.Owner.Name +' TEST@@4 : ' + mapOwner.get(opp.Id));
                if(opp.PartnerAccountId != mapParnerAccount.get(opp.Id)){
                    needToAdd = true;
                }

                if(opp.OwnerId != mapOwner.get(opp.Id)){
                    needToAdd = true;
                }

                if(needToAdd){
                    opportunityListNew.add(opp);
                }
            }

            System.Debug('TEST@@@15: ' + opportunityListNew.Size());
            if(opportunityListNew.Size()>0){
                System.Debug('TEST@@@5: ' + opportunityListNew);
                System.Debug('TEST@@@20: ' + opportunityList);
                opportunityList = opportunityListNew;
                System.Debug('TEST@@@6: ' + opportunityListNew);
            }
            else{
                System.Debug('TEST@@@7 : IN Return');
                return;
            }
        }
      }

      //holds account ids
      Set<Id> setAccountIds = new Set<Id>();

      //holds Opportunity Ids
      Set<Id> setOppIds = new Set<Id>();

      //holds Group Ids
      Set<Id> setGroupIds = new Set<Id>();

      //holds opportunity ids for the sharing rules already created
      Set<Id> setOppShareIds = new Set<Id>();

      //holds role names
      Set<String> setRoleName = new Set<String>();

      //holds role name for partner user
      Set<String> setRoleNameUser = new Set<String>();

      //holds Account records
      List<Account> lstAccounts = new List<Account>();

      //holds UserRole records
      List<UserRole> lstUserRole = new List<UserRole>();

      //holds Account id as key and Account record a value
      Map<Id, Account> mapAccountRecords = new Map<Id, Account>();

      //holds a list of OpportunityShare records to insert / upsert
      List<OpportunityShare> lstOpportunityShare = new List<OpportunityShare>();

      //holds Account record
      Account accountRecord = null;

      //holds Group record
      Group userGroupRecord = null;

      //for each opportunity check for partner account field
      for(Opportunity oppObj : opportunityList){
        //if the field has value, add that value to a set
        if(oppObj.PartnerAccountId != null){
          setAccountIds.add(oppObj.PartnerAccountId);
          setOppIds.add(oppObj.Id);
        }
      }

      //Fetch all Accounts whose id is in the set
      //lstAccounts = [select Id, Name, Executives_view_all_Opportunities__c from Account where Id in :setAccountIds Limit 1000];
      lstAccounts = [select Id, Name, Executives_view_all_Opportunities__c, Allow_all_to_view_Opportunities__c from Account where Id in :setAccountIds Limit 1000];

      //Add all accounts to a map as value and their ids as key
      for(Account accountObj : lstAccounts){
        mapAccountRecords.put(accountObj.Id, accountObj);
        if(accountObj.Executives_view_all_Opportunities__c == true){
          String roleName = accountObj.Name + ' Partner Executive';
          setRoleName.add(roleName);
        }
        if(accountObj.Allow_all_to_view_Opportunities__c == true){
          String roleName = accountObj.Name + ' Partner User';
          setRoleNameUser.add(roleName);
        }
      }

      //fetch all user roles whose name is in the set
      Map<Id, UserRole> mapUserRole = new Map<Id, UserRole>([select Id, Name from UserRole where Name in :setRoleName or Name in :setRoleNameUser Limit 1000]);

      List<Group> lstGroup = new List<Group>();
      lstGroup = [select Id, Name, RelatedId from Group where Type = 'Role' and RelatedId in :mapUserRole.keySet() Limit 1000];

      Map<String, Group> mapUserRoleGroup = new Map<String, Group>();

      for(Group userGroup : lstGroup){
        if(mapUserRole.containsKey(userGroup.RelatedId)){
          String roleName = mapUserRole.get(userGroup.RelatedId).Name;
          mapUserRoleGroup.put(roleName, userGroup);
          setGroupIds.add(userGroup.Id);
        }
      }

      //get all Opportunity Share records already created for these opportunities
      List<OpportunityShare> lstOppShareCreated = new List<OpportunityShare>();
      lstOppShareCreated = [select Id, OpportunityId, OpportunityAccessLevel, UserOrGroupId
                            from OpportunityShare
                            where OpportunityId in :setOppIds
                            and UserOrGroupId in :setGroupIds
                            and OpportunityAccessLevel = 'Edit' ];

      for(OpportunityShare oppShare : lstOppShareCreated){
        setOppShareIds.add(oppShare.OpportunityId);
      }

      //for each opportunity, create sharing rule and upsert it
      for(Opportunity oppObj : opportunityList){
        //if the parent account id is not null
        if(oppObj.PartnerAccountId != null){
          //if map contains the parent account id
          if(mapAccountRecords.containsKey(oppObj.PartnerAccountId)){
            accountRecord = mapAccountRecords.get(oppObj.PartnerAccountId);
            //if the checkbox field is true
            if(accountRecord.Executives_view_all_Opportunities__c == true){
              String userRoleName = accountRecord.Name + ' Partner Executive';
              if(mapUserRoleGroup.containsKey(userRoleName)){
                //if sharing rule not already created
                if(!setOppShareIds.contains(oppObj.Id)){
                  userGroupRecord = mapUserRoleGroup.get(userRoleName);
                  //create sharing rule
                  OpportunityShare oppShareObj = new OpportunityShare();
                  oppShareObj.OpportunityId = oppObj.Id;
                  oppShareObj.OpportunityAccessLevel = 'Edit';
                  oppShareObj.UserOrGroupId = userGroupRecord.Id;
                  lstOpportunityShare.add(oppShareObj);

                  if(lstOpportunityShare.size() == 200){
                    insert lstOpportunityShare;
                    lstOpportunityShare.clear();
                  }
                }
              }
            }
            //code for partner user
            if(accountRecord.Allow_all_to_view_Opportunities__c == true){
              String userRoleName = accountRecord.Name + ' Partner User';
              if(mapUserRoleGroup.containsKey(userRoleName)){
                //if sharing rule not already created
                if(!setOppShareIds.contains(oppObj.Id)){
                  userGroupRecord = mapUserRoleGroup.get(userRoleName);
                  //create sharing rule
                  OpportunityShare oppShareObj = new OpportunityShare();
                  oppShareObj.OpportunityId = oppObj.Id;
                  oppShareObj.OpportunityAccessLevel = 'Edit';
                  oppShareObj.UserOrGroupId = userGroupRecord.Id;
                  lstOpportunityShare.add(oppShareObj);

                  if(lstOpportunityShare.size() == 200){
                    insert lstOpportunityShare;
                    lstOpportunityShare.clear();
                  }
                }
              }
            }
            //end code for partner user
          }
        }
      }
      if(lstOpportunityShare.size() > 0){
        insert lstOpportunityShare;
      }
******/

    }



    public static void updateOppRSM(List<Opportunity> opportunityList, List<Opportunity> oldOpportunityList ){

        map<Id,String> mapOppNew = new map<Id,String>();

        Set<Id> setOpp = new Set<Id>();

        //Prepare set of Opportunities Account,partner account and owner IDs
        Set<String> setOppAccount = new Set<String>();
        Set<String> setOppPartnerAccount = new Set<String>();

        /***New**/
        Map<Id,String> mapParnerAccount = new Map<Id,String>();
        Map<Id,String> mapAccountId = new Map<Id,String>();
        /***New**/

        //to check whether need to update RSM or not
        //only required to update RSM if Account or Parther Account updates

        List<Opportunity> opportunityListNew = new List<Opportunity>();

        if(oldOpportunityList != null && oldOpportunityList.Size()>0){
            for(Opportunity opp : oldOpportunityList){
                mapParnerAccount.put(opp.Id , opp.PartnerAccountId);
                mapAccountId.put(opp.Id, opp.AccountId);
                //mapOppOld.put(opp.Id, opp.OwnerId);
            }
        }

        if(opportunityList.Size()>0){
            Boolean needToAdd;
            for(Opportunity opp : opportunityList){
                needToAdd = false;
                if(opp.PartnerAccountId != mapParnerAccount.get(opp.Id)){
                    needToAdd = true;
                }

                if(opp.AccountId != mapAccountId.get(opp.Id)){
                    needToAdd = true;
                }
                if(mapParnerAccount.get(opp.Id)!=null){
                    if(opp.Partner_Account_Id__c==null || opp.Partner_Account_Id__c != mapParnerAccount.get(opp.Id)){
                        needToAdd = true;
                    }
                }
                if(needToAdd){
                    opportunityListNew.add(opp);
                }
            }

            if(opportunityListNew.Size() == 0){ //Acccount and partner account not updated in this case
                return;
            }
        }


        if(opportunityListNew.Size()>0){
            for(Opportunity opp:opportunityListNew){
                setOppAccount.Add(opp.AccountID);
                setOppPartnerAccount.Add(opp.PartnerAccountID);
                mapOppNew.put(opp.Id, opp.OwnerId);
                setOpp.add(opp.Id);
            }
        }
        //changed for case #12129
        List<Opportunity> oppListNew =
            new List<Opportunity>([Select Id,PartnerAccountID,AccountID,Region__c,Theater__c,RSMName__c,OwnerId, Call_Trigger__c,Partner_Account_Id__c,owner.manager.email,CRSM__c,RecordTypeId from Opportunity where Id in : setOpp]);

         /*****Commented
        //iterate old opportunities
        for(Opportunity opp:oldOpportunityList){
            mapOppOld.put(opp.Id, opp.OwnerId);
        }
        ******************/
        //Prepare map for AccountID and Account detail
        map<ID,Account> mapAccount = new map<ID,Account>([Select id,Territory__c,Theater__c,RSM__c,CRSM__c
            from Account
            where id in :setOppAccount or id in :setOppPartnerAccount limit 1000]);



        boolean isChanged = false;
        //Traverse through each opportunity
        for(Opportunity opp:oppListNew){
            boolean isRSMSet = false;
            boolean isRegionSet = false;
            boolean isTheaterSet = false;
            boolean isHiddenPartnerAccountSet  = false;
            boolean isCRSMSet = false;
                //Set Region__c,Theater__c,RSMName__c field from partner account
                if(opp.PartnerAccountID!=null && mapAccount.containsKey(opp.PartnerAccountID)){
                    //Set Region__c
                    if(mapAccount.get(opp.PartnerAccountID).territory__c!=null && mapAccount.get(opp.PartnerAccountID).territory__c!=''){
                        if(opp.Region__c!=mapAccount.get(opp.PartnerAccountID).territory__c){
                            opp.Region__c = mapAccount.get(opp.PartnerAccountID).territory__c;
                            isChanged = true;
                        }
                        isRegionSet = true;
                    }

                    //Set Theater__c
                    if(mapAccount.get(opp.PartnerAccountID).Theater__c!=null && mapAccount.get(opp.PartnerAccountID).Theater__c!=''){
                        if(opp.Theater__c!=mapAccount.get(opp.PartnerAccountID).Theater__c){
                            String theater = mapAccount.get(opp.PartnerAccountID).Theater__c;
                            opp.Theater__c=theater;
                            isChanged = true;
                        }
                        isTheaterSet = true;
                    }

                    if(mapAccount.get(opp.PartnerAccountID) !=null ){
                        if(opp.RSMName__c != mapAccount.get(opp.PartnerAccountID).RSM__c){
                            opp.RSMName__c = mapAccount.get(opp.PartnerAccountID).RSM__c;
                            isChanged = true;
                        }
                        isRSMSet = true;
                    }

                    // newly added code for case # 00045462 to populate CRSM__c on afterOppUpdate
                    if(mapAccount.get(opp.PartnerAccountID).CRSM__c !=null && opp.RecordTypeId == COMMERCIAL_RecordType_ID ){
                        opp.CRSM__c = mapAccount.get(opp.PartnerAccountID).CRSM__c;
                        isChanged = true;
                        isCRSMSet = true;
                    }

                    //set hidden field Partner Account Id as Partner Account
                   if(opp.Partner_Account_Id__c !=mapAccount.get(opp.PartnerAccountID).id){
                        opp.Partner_Account_Id__c = mapAccount.get(opp.PartnerAccountID).id;
                        isChanged = true;
                   }


                }

                //Set Region__c,Theater__c,RSMName__c field from account if not set from partner account
                if(opp.AccountID!=null && mapAccount.containsKey(opp.AccountID)){
                     //Set Region__c
                    if(!isRegionSet){
                        if(opp.Region__c != mapAccount.get(opp.AccountID).territory__c){
                            opp.Region__c = mapAccount.get(opp.AccountID).territory__c;
                            isChanged = true;
                        }
                    }

                    //Set Theater__c
                    if(!isTheaterSet){
                        String theater = mapAccount.get(opp.AccountID).Theater__c;
                        if(opp.Theater__c!=theater){
                            opp.Theater__c=theater;
                            isChanged = true;
                        }
                    }

                    //RSM should only be set from partner account otherwise it is set to null
                    if(!isRSMSet){
                        if(opp.RSMName__c != null){
                            opp.RSMName__c = null;
                            isChanged  = true;
                        }
                    }

                    /*//Set CRSM__c field from account if not set from partner account for case #00045462
                    if(!isCRSMSet && mapAccount.get(opp.AccountID).CRSM__c !=null && opp.RecordTypeId == COMMERCIAL_RecordType_ID ){
                        opp.CRSM__c = mapAccount.get(opp.AccountID).CRSM__c;
                        isChanged = true;
                    }  */

                }

        }//for end

        if(isChanged){
            System.debug('TEST updateOppRSM:: ' + oppListNew);
            update oppListNew;
        }

    }
     /*
        Name:: setStatus_Date
        Author:: Appirio (Prakash)
        Purpose::Function for update/set the Status and Date for Opportunity
        Requester & PR:: Richard Wu , PR-02414
        Date:: Aug 26,2009

    */
    private static void setStatus_Date(List<Opportunity> opportunityList,List<Opportunity> opportunityListOld){
        String ResiRecordTypeID = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Home_Owner');
        String CommRecordTypeID = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial');
        map<String,Opportunity> mapOldOpp = new map<String,Opportunity>();
        for(Opportunity opp:opportunityListOld){
            mapOldOpp.put(opp.ID,opp);
        }

        //Start 00103412
        Set<ID> setOppOwner = new Set<ID>();
        for(Opportunity opp : opportunityList){
            if(opp.ownerID!=null)
                setOppOwner.add(opp.ownerID);
        }

        Map<ID,User> mapOppOwner = new Map<ID,User>();
        if(setOppOwner.size()>0){
            mapOppOwner =  new Map<ID,User>([Select id,email,manager.email from user where ID in :setOppOwner]);
        }
        //End 00103412

        //Loop for Changing Status and Date
        for(Opportunity opp: opportunityList){
            //Start 00103412
            if(mapOppOwner.containsKey(opp.OwnerID)){
                opp.Opportunity_Owner_s_Manager__c = mapOppOwner.get(opp.OwnerID).manager.email;
                opp.Owner_Email__c  = mapOppOwner.get(opp.OwnerID).email;
            }
            //End 00103412

            //Case#00082899
            //Set date when opportunity is assigned with campaign for the first time
            if(opp.CampaignID!=null && ((mapOldOpp.size()==0) || (mapOldOpp.containsKey(opp.ID) && mapOldOpp.get(opp.ID).CampaignID==null))){
                opp.Campaign_Source_Date__c = DateTime.now();
            }
            //Start 89065
            //Set date when opportunity is actually closed
            system.debug('-------opp.isClosed-----------'+opp.isClosed);
            if(opp.isClosed && ((mapOldOpp.size()==0) || (mapOldOpp.containsKey(opp.ID) && !mapOldOpp.get(opp.ID).isClosed))){
                opp.Actual_Close_Date__c = DateTime.now();
            }
            else if(!opp.isClosed && ((mapOldOpp.size()==0) || (mapOldOpp.containsKey(opp.ID) && mapOldOpp.get(opp.ID).isClosed))){
                opp.Actual_Close_Date__c = null;
            }
            //End 89065
            if(opp.StageName == null) continue;
            //Residential Starts
            if(opp.RecordTypeId == ResiRecordTypeID){

                 if(opp.StageName == '10% - Qualified Opportunity'){
                    opp.Opportunity_Status__c = 'Qualified';

                    if (opp.Qualified_Date__c == null)
                        opp.Qualified_Date__c = Date.today();
                }else if(opp.StageName == '30% - Opportunity Contacted'){
                    opp.Opportunity_Status__c = 'Active';

                    if (opp.Opportunity_Contacted_Date__c == null)
                        opp.Opportunity_Contacted_Date__c = Date.Today();

                }else if (opp.StageName == '60% - Visit Completed'){
                    opp.Opportunity_Status__c = 'Active';

                    if (opp.Visit_Completed_Date__c == null)
                        opp.Visit_Completed_Date__c = Date.today();


                }else if(opp.StageName.startsWith('100%'))
                    opp.Opportunity_Status__c = 'Closed Won';

                else if(opp.StageName.startsWith('0%'))
                    opp.Opportunity_Status__c = 'Closed Lost';

                else if(opp.StageName == 'Future Follow-up'){
                    opp.Opportunity_Status__c = 'On Hold';

                    if (opp.Future_Follow_up_Date__c == null)
                        opp.Future_Follow_up_Date__c = Date.today();
                }

                //if opportunity stage is changed to future follow up or from uture follow up then set following dates to null
                //Following is done against the case 00011588
                if(mapOldOpp.containsKey(opp.ID)){
                    Opportunity oldOpp = mapOldOpp.get(opp.ID);
                    if(opp.StageName == 'Future Follow-up' && oldOpp.StageName != 'Future Follow-up'){
                        opp.Opportunity_Contacted_Date__c = null;
                        opp.Visit_Completed_Date__c = null;
                    }
                    if(opp.StageName != 'Future Follow-up' && oldOpp.StageName == 'Future Follow-up'){
                        opp.Future_Follow_up_Date__c = null;
                    }
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
            //Commercial ends
        }//for loop ends
    }//function ends

   /*********** Start for Case # 00075405 ******Added By: Madhuri ***********/
  /*  public static void chkOpportunityDuplicate(List<Opportunity> OpportunityList){


     //Check for duplicates for new records
        map<String,Opportunity> mapNameOpportunityWithOppNo = new map<String,Opportunity>();
        map<String,Opportunity> mapNameOpportunityWithoutOppNo = new map<String,Opportunity>();

        for(Opportunity opp:OpportunityList){

            mapNameOpportunityWithOppNo.put(opp.Name,opp);

            String oppName = opp.Name;
            Integer index = oppName.indexof('-')+1;
            String editOppName = oppName.substring(index);


            system.debug('=== mapNameOpportunityWithoutOppNo ==='+mapNameOpportunityWithoutOppNo);
            system.debug('=== editOppName ==='+editOppName);

            if(mapNameOpportunityWithoutOppNo.containsKey(editOppName)){

                opp.addError('A duplicate Opportunity has been found in the system');
            }

            mapNameOpportunityWithoutOppNo.put(editOppName,opp);


        }
        system.debug('=== mapNameOpportunityWithOppNo==='+mapNameOpportunityWithOppNo.keyset());
        system.debug('=== mapNameOpportunityWithoutOppNo==='+mapNameOpportunityWithoutOppNo.keyset());

        //Check duplicate in existing records
        map<String,Opportunity> OpportunityMatch = new map<String,Opportunity>();
        for(Opportunity opp:[Select Name,Opportunity_Number1__c from Opportunity where Name in :mapNameOpportunityWithOppNo.KeySet()]){

            String oppName = opp.Name;
            Integer index = oppName.indexof('-')+1;
            String editOppName = oppName.substring(index);

            system.debug('madhuri===='+editOppName);

            OpportunityMatch.put(editOppName,opp);
        }

        for(Opportunity opp:Trigger.New){
            String oppName = opp.Name;
            Integer index = oppName.indexof('-')+1;
            String editOppName = oppName.substring(index);
            system.debug('=== OpportunityMatch ==='+OpportunityMatch);
            system.debug('=== editOppName ==='+editOppName);
            if(OpportunityMatch.containsKey(editOppName)){
                opp.addError('A duplicate Opportunity has been found in the system');
            }

        }
        for(Opportunity opp:Trigger.New){
            String oppName = opp.Name;
            Integer index = oppName.indexof('-')+1;
            String editOppName = oppName.substring(index);
            system.debug('=== OpportunityMatch ==='+OpportunityMatch);
            system.debug('=== editOppName ==='+editOppName);
            if(OpportunityMatch.containsKey(editOppName)){
                opp.addError('A duplicate Opportunity has been found in the system Please Choose Existing Name from OpportunityName');
            }

        }
    }*/

    /******************** End for Case # 00075405 *****************/

    /**
    Populates values in fields:
      1. Opportunity_CreatedDate_Text__c
      2. SP_Week__c
    **/
    public static void CalculateCalendarWeek(List<Opportunity> OpportunityList){
      DateTime opportunityCreatedDateTime;
      Date opportunityCreatedDate;

      Set<String> setDates;
      List<SP_Week_Lookup__c> lstSPWeeks;
      Map<String, Double> mapSPWeeks;

      setDates = new Set<String>();

      //for each opportunity
      for(Opportunity opportunityObj : OpportunityList){
        //populate value in the field Opportunity_CreatedDate_Text__c
        if(opportunityObj.Opportunity_CreatedDate__c == null){
          opportunityCreatedDateTime = DateTime.now();
        }
        else{
          opportunityCreatedDateTime = opportunityObj.Opportunity_CreatedDate__c;
        }
        if(opportunityObj.Opportunity_CreatedDate_Text__c == null){

        opportunityCreatedDate = Date.newInstance(opportunityCreatedDateTime.year(), opportunityCreatedDateTime.month(), opportunityCreatedDateTime.day());
        opportunityObj.Opportunity_CreatedDate_Text__c = String.valueOf(opportunityCreatedDate).replace('-', '');

        }

        //create a set of opportunityCreatedDates
        if(!setDates.contains(opportunityObj.Opportunity_CreatedDate_Text__c)){
          setDates.add(opportunityObj.Opportunity_CreatedDate_Text__c);
        }
      }//end for loop


      //query SP_Week__c for Text_Date__c and SP_week__c fields
      lstSPWeeks = new List<SP_Week_Lookup__c>();
      lstSPWeeks = [select Id, Name, SP_Week__c, Text_Date__c from SP_Week_Lookup__c where Text_Date__c in :setDates];

      //create a map Map<String, String> with key as Text_Date__c and value as SP_Week__c
      mapSPWeeks = new Map<String, Double>();
      for(SP_Week_Lookup__c spWeekObj : lstSPWeeks){
        if(!mapSPWeeks.containsKey(spWeekObj.Text_Date__c)){
          mapSPWeeks.put(spWeekObj.Text_Date__c, spWeekObj.SP_Week__c);
        }
      }

      //for each opportunity get week number from the Map
      for(Opportunity opportunityObj : opportunityList){
        if(mapSPWeeks.containsKey(opportunityObj.Opportunity_CreatedDate_Text__c)){
        if(opportunityObj.SP_Week__c == null){
          opportunityObj.SP_Week__c = mapSPWeeks.get(opportunityObj.Opportunity_CreatedDate_Text__c);
          }
        }
        else{
          opportunityObj.SP_Week__c = 0;
        }
      }//end for loop
    }

    /*
        New Function added for Auto Populating theater value accrding to partner user contact.
        This Functuion will be called on Before Opportunity insert
        Author :: Appirio Offshore (Lokesh)
        Date :: July 15, 2010
        Case :: 00029642
        Case Owner :: Lokesh
    */

     public static void setTheaterVal(List<Opportunity> opportunityList) {

         Map<String, Id> opportunityRecordTypes = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType);

         Id homeOwnerAccountRecordTypeId = opportunityRecordTypes.get('Home_Owner');
         if (UserInfo.getUserType() == 'PowerPartner') {
               List<User> userList = new List<User>([Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Id = :userInfo.getUserId() and Profile.Name like 'Partner%' ]);
               User currentUser;
               if(userList!=null && userList.size()>0){
                 currentUser = userList.get(0);
               }
               for(Opportunity opp : opportunityList){
                   if(currentUser!=null && opp.RecordTypeId == homeOwnerAccountRecordTypeId ){
                       opp.Theater__c = currentUser.Contact.Account.Theater__c;
                   }
                   //Start 00108873
                  if(opp.Theater__c == 'North America' && opp.RecordTypeId==COMMERCIAL_RecordType_ID){
                        opp.business_unit__c = 'RLC';
                        opp.RLC_type__c = 'Light Commercial';
                  }
                  if(opp.Theater__c == 'North America' && opp.Theater__c =='Central America and the Caribbean'){
                        opp.Customer_Satisfaction_survey_opt_in__c = TRUE;
                  }else if(opp.Theater__c != 'North America' && opp.Theater__c !='Central America and the Caribbean')
                        opp.Customer_Satisfaction_survey_opt_in__c = False;

                  //End 00108873
               }
         }
    }


   /*
        New Function added for Auto Populating Stage Values as per the Value populated on related Fields.
        This Functuion will be called on Before Opportunity Update
        Author :: Appirio Offshore (Prakash)
        Date :: Nov 16, 2009
        Case :: 00011332
        Case Owner :: Anuradha Suthar
   */
   private static void setCommercialOppStage(List<Opportunity> newList , List<Opportunity> oldList){

       //1. Populating Old List as Map for further fetching reference
        Map<ID,Opportunity> oldMap = new Map<ID,Opportunity>();
        for(Opportunity opp: oldList)
            oldMap.put(opp.Id,opp);

        //2. Loop for each new Opp
        String CommRecordTypeID = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial');
        if(CommRecordTypeID == null)
            return;
        for(Opportunity opp:newList){
            //Update field submitter for case # 00068696
            if(opp.Opportunity_Status__c == 'In Review' && opp.Opportunity_Status__c != oldMap.get(opp.id).Opportunity_Status__c){
                opp.Submitter__c = userinfo.getUserID();
            }
            //IF Opportunity is Commercial Opportunity
            if(opp.RecordTypeID ==  CommRecordTypeID){
                //Case 1 When New Opportunity Saved so it is authomatically  '12% - Qualified Opportunity'
                /* Commented for Sunpower Case # 00030248 */
                /*
                //Case 2 When "Site Audit Submitted" date filled then Stage will be "20% - Site Audit Received/PV&I Only"
                if(opp.Site_Audit_Submitted__c != null && opp.Site_Audit_Submitted__c != oldMap.get(opp.ID).Site_Audit_Submitted__c){
                    opp.StageName = '20% - Site Audit Received/PV&I Only';
                }// ends of if condition
                //Case 3 When "EPA Generated" field populated "35% - EPA/Quote Issued"
                else if(opp.EPA_Generated__c != null && opp.EPA_Generated__c != oldMap.get(opp.ID).EPA_Generated__c){
                    opp.StageName = '35% - EPA/Quote Issued';
                }
                //Case 4
                else if(opp.Financing_in_Place__c != null && opp.Financing_in_Place__c != oldMap.get(opp.ID).Financing_in_Place__c && opp.Financing_in_Place__c){
                    //Value In Sandbox
                        //opp.StageName = '50% - Financing in Place';
                    //Value In Production
                    opp.StageName = '50% - Financing & Rebate in Place';
                }
                //Case 5
                else if(opp.Verbal_Commitment__c != null && opp.Verbal_Commitment__c != oldMap.get(opp.ID).Verbal_Commitment__c && opp.Verbal_Commitment__c){
                    if(opp.EPA_Generated__c != null)
                        opp.StageName = '75% - Verbal commitment of imminent PO';
                }
                //Case 6
                else if(opp.PO_Receipt_Date__c != null && opp.PO_Receipt_Date__c != oldMap.get(opp.ID).PO_Receipt_Date__c){
                    if(opp.EPA_Generated__c != null)
                        opp.StageName = '85% - PO Received by SPWR';
                }
                //Cae 7
                else if(opp.X5_Down_Payment_Received__c != null && opp.X5_Down_Payment_Received__c != oldMap.get(opp.ID).X5_Down_Payment_Received__c && opp.X5_Down_Payment_Received__c){
                    opp.StageName = '95% - Down Payment Received by SPWR';
                }
                //Case 8
                else if(opp.Delivery_Date__c != null && opp.Delivery_Date__c != oldMap.get(opp.ID).Delivery_Date__c){
                    opp.StageName = '100% - Delivered';
                }
                */
                /**************************************/
                //Case 9
                /* Changed following statement from "else if" to "if" for Sunpower Case # 00030248 */
                if(opp.Opportunity_Status__c != null && opp.Opportunity_Status__c != oldMap.get(opp.ID).Opportunity_Status__c && (opp.Opportunity_Status__c == 'Closed Lost' || opp.Opportunity_Status__c == 'Dead')){
                    opp.StageName = '0% - Dead, Lost';
                }
                //Case 10
                else if(opp.Opportunity_Status__c != null && opp.Opportunity_Status__c != oldMap.get(opp.ID).Opportunity_Status__c && opp.Opportunity_Status__c == 'On Hold'){
                    opp.StageName = 'Future Follow-up';
                }
            }//ends of If COMMERCIAL OPP
        }//ends of for loop

    }

    //Case 83101 - Comment following method after removing respective workflows
    /*
        New Function added for Creating a Row in Post_Visit_Follow_Up_Survey__c object and send a mail to Opportunity related contacts.
        This Function will be called on After Opportunity Update
        Date :: Nov 17, 2010
        Case :: 00046578
        Case Owner :: Aashish Mathur
   */
    public static void createSurveyRowAndMail (List<Opportunity> opportunityList, List<Opportunity> oldOpportunityList){
        Integer i=0;
        Set<Id> oppMail = new Set<Id>();
        Set<Id> idset = new Set<Id>();
        Map<Id,Id> setsurvey = new Map<Id,Id>();
        List<Post_Visit_Follow_Up_Survey__c> surveyList = new List<Post_Visit_Follow_Up_Survey__c>();
        for(Opportunity opp : opportunityList){
            system.debug(loggingLevel.INFO, 'System Date -> ' + System.today());
            system.debug(loggingLevel.INFO, 'Opp Date -> ' + opp.CreatedDate.date());
            system.debug(loggingLevel.INFO, 'Days between both -> ' + System.today().daysBetween(opp.CreatedDate.date()));
            if(opp.Send_Mail__c && opp.Send_Mail__c != oldOpportunityList.get(i).Send_Mail__c
                 &&  System.today().daysBetween(opp.CreatedDate.date()) == -31
                 //Field required for survey
                 && opp.PartnerAccountId!= null
                ){
                Post_Visit_Follow_Up_Survey__c survey = new Post_Visit_Follow_Up_Survey__c();
                survey.Status_Survey__c = 'Sent';
                survey.Name = 'Survey for ' + opp.Name;
                survey.Opportunity_ID__c = opp.Id;
                //survey.Partner_Contact__c = opp.PartnerAccountId;
                survey.Partner_Account__c = opp.PartnerAccountId;
                survey.Customer_Contact__c = opp.Primary_Contact__c;
                survey.Customer_Account__c = opp.AccountId;
                surveyList.add(survey);
                oppMail.add(opp.Id);
                idset.add(opp.AccountId);
                system.debug(loggingLevel.INFO, 'Opp Name -> ' + opp.AccountId);
            }
            i++;
        }
        system.debug(loggingLevel.INFO, 'Opp mail size -> ' + oppMail.size());
        system.debug(loggingLevel.INFO, 'survey list size -> ' + surveyList.size());
        if(surveyList.size()>0)
            upsert surveyList;
    }

    /*
        New Function added for updating Account opt in fields according to related Opp opt in fields
        This Function will be called on After Opportunity Update
        Date :: Sept 16 2011
        @Author ::  Anjali Khandelwal
   */
    @future
    public static void updateRelatedAccount(Set<Id> oppIds){
        List<Account> accList = new List<Account>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Account> accountMap = new Map<Id,Account>();

        for(Opportunity opp : [Select id, AccountId,Account.SunPower_Products_and_Services_Contact__c,Account.Warranty_Signed_Italy__c,Account.Participate_in_Inspection_Survey__c,Account.Participate_in_Customer_Survey__c,Marketing_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Quality_Inspection_opt_in__c,Warranty_Signed_Italy__c from Opportunity where id in: oppIds]){
            if(opp.AccountId != null){
                opportunityList.add(opp);
                accountMap.put(opp.AccountId,opp.Account);
            }
        }

        List<Account> accountToUpdate = new List<Account>();
        Account acc;
        String isMarketingOptin;
        for(Opportunity opp : opportunityList){
            if(accountMap.get(opp.AccountId) != null){

                if(opp.Marketing_opt_in__c)
                    isMarketingOptin = 'Yes';
                else
                    isMarketingOptin = 'false';
                if(accountMap.get(opp.AccountId).Participate_in_Customer_Survey__c != opp.Customer_Satisfaction_survey_opt_in__c ||
                    accountMap.get(opp.AccountId).Participate_in_Inspection_Survey__c != opp.Quality_Inspection_opt_in__c ||
                    accountMap.get(opp.AccountId).SunPower_Products_and_Services_Contact__c != isMarketingOptin ||
                    accountMap.get(opp.AccountId).Warranty_Signed_Italy__c != opp.Warranty_Signed_Italy__c){

                        acc = accountMap.get(opp.AccountId);
                        acc.Participate_in_Customer_Survey__c = opp.Customer_Satisfaction_survey_opt_in__c;
                        acc.SunPower_Products_and_Services_Contact__c = isMarketingOptin;
                        acc.Participate_in_Inspection_Survey__c = opp.Quality_Inspection_opt_in__c;
                        acc.Warranty_Signed_Italy__c = opp.Warranty_Signed_Italy__c;

                        accountToUpdate.add(acc);
                    }

            }
        }
        if(accountToUpdate.size() > 0){
            try{
                update accountToUpdate;
            }catch(Exception ex){
                system.debug('update failed');
            }
        }
    }


    // Done for case # 00063181
    /* Sets Opportunity Status to 'Closed Won' when Stage is set Installation Completed */
    private static void setOppStatus(List<Opportunity> newOppList, Map<ID, Opportunity> oldOppMap){
        for(Opportunity opp : newOppList){
            if(opp.StageName == 'Installation Completed' && oldOppMap.get(opp.Id).stagename != opp.StageName)
                opp.Opportunity_Status__c = 'Closed Won';
        }
    }

    // Done for case # 00064999
    // validation Rule such that Product Schedule is required for product on the opportunity where 'Quantity Scheduling Enabled' is True.
    private static void validationRuleForProductSchedule (List<Opportunity> opportunityList,Map<ID, Opportunity> oldOpportunityMap) {

        Map<Id,Opportunity> oppOLIMap = new Map<Id,Opportunity>([Select id ,(Select Id, HasQuantitySchedule ,PricebookEntry.Product2.CanUseQuantitySchedule , PricebookEntry.Name From OpportunityLineItems) From Opportunity where Id IN : opportunityList]);
        String productNames = '';
        for(Opportunity opp : opportunityList){
            // [Note: pls deploy this change done under case # 00066557 also]Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
            // if( (opp.Business_Unit__c == 'UPP Intl' || opp.Business_Unit__c == 'Components' || opp.Business_Unit__c == 'IBD')
            if( (opp.Business_Unit__c == 'UPP Intl')
                    && (opp.Contract_Type__c == 'PV Only' || opp.Contract_Type__c == 'Development' || opp.Contract_Type__c == 'EPC'|| opp.Contract_Type__c == 'BOS+PV')
                    && oldOpportunityMap.get(opp.Id) != null && oldOpportunityMap.get(opp.Id).StageName != '03 – Binding Offer' && opp.StageName == '03 – Binding Offer'
                    && oppOLIMap.get(opp.Id).OpportunityLineItems.size() > 0 ){
                for(OpportunityLineItem oli : oppOLIMap.get(opp.Id).OpportunityLineItems){
                    if(oli.PricebookEntry.Product2.CanUseQuantitySchedule && !oli.HasQuantitySchedule){
                        productNames += oli.PricebookEntry.Name + '  ';
                    }
                }
                if(productNames != '')
                    opp.addError('Product Schedule is required for Opportunity Products: '+ productNames +' to set the stage Binding Offer.');
           }
        }
    }

/**
 ** Credit Check Application update on account
 ** Developed by: Shree Prashant, 26 Mar 2013
 ** Takes two Parameter: 1. Trriger.newMap; 2. Trigger.oldMap
 ** Is being called from Opportunity after update
 **/
    public static void CreditCheckProcessing(Map<Id, Opportunity> mNewOpp, Map<Id, Opportunity> mOldOpp)
    {
        Map<Id, Account> mrelatedAccUp = new Map<Id, Account>();
        for(Id oppId: mNewOpp.keySet()){
            boolean bHasChange = false;
            Account tAcc = new Account(id= mNewOpp.get(oppId).AccountId);
            if(mNewOpp.get(oppId).Credit_Application_Status__c != mOldOpp.get(oppId).Credit_Application_Status__c){
                tAcc.Credit_Check_status__c= mNewOpp.get(oppId).Credit_Application_Status__c;

                if(String.isNotBlank(mNewOpp.get(oppId).Credit_Application_Status__c) && mNewOpp.get(oppId).Credit_Application_Status__c.toLowerCase() == 'approved'){
                    tAcc.Credit_Check_Approval_Date__c = Date.today(); //GMT?
                    tAcc.Credit_check_Passed__c = true;
                }

                bHasChange = true;
            }
            if(String.isNotBlank(mNewOpp.get(oppId).Credit_Application_ID__c) && String.isBlank(mOldOpp.get(oppId).Credit_Application_ID__c)){
                tAcc.Credit_Check_submission_Date__c = Date.today(); //GMT?
                bHasChange = true;
            }

            if(bHasChange){
                mrelatedAccUp.put(mNewOpp.get(oppId).AccountId, tAcc);
            }
        }
        if(!mrelatedAccUp.isEmpty())
            update mrelatedAccUp.values();
    }

/**
 ** Method to Add/remove Opportunity Sharing Rules for Partner and Partner Change.
 ** As per the new requirement, The Customer Opportunity will only be Shared and Editeable by Partner owners having "Partner Executive" Role
 ** All the old sharing record in the Opportunity shairng table need to be removed when owner changes
 ** Developed: Birlasoft Support, 12th Sep 2013
 ** Sunpower Owner: Paul Huynh
 **/

public static void addSharingRule3(List<Opportunity> OppList, List<Opportunity> OppListOld, Boolean isUpdate)
{
    //Map<id, Boolean> mapbool = new Map<id, boolean>();
SYSTEM.DEBUG('### In Sharing ###' + '\nOppList::: ' + OppList + '\nOppListOld:: ' + OppListOld + '\nisUpdate:: ' + isUpdate);
    Map<ID,Opportunity> NewOppMap=new Map<ID,Opportunity>(); //New map of the Trigger.new
    Map<ID,Opportunity> OldOppMap=new Map<ID,Opportunity>(); //Old map of the Trigger.old
    //RedPoint DebugTracker__c tracker = new DebugTracker__c();
    if(!isUpdate){
        for(Opportunity opp: OppList)
            NewOppMap.put(opp.Id, opp);
    }
    else{
        for(Opportunity opp: OppList)
            NewOppMap.put(opp.Id, opp);
        for(Opportunity oppO: OppListOld)
            OldOppMap.put(oppO.Id, oppO);
    }

    Map<ID,Opportunity> nOppMap= new Map<ID,Opportunity>(); //Contains all the opportunity Ids & Opportunity for which Owner is changed.
    Map<ID,Opportunity> oOppMap= new Map<ID,Opportunity>(); //Contains the Older Version of the record, for which Owner is changed.
    Map<Id, Id> nOppPAcc = new Map<Id, Id>(); //Opp Id vs New Partner Account Id
    Map<Id, Id> oOppPAcc = new Map<Id, Id>(); //Opp Id vs Old Partner Account Id

    if(!isUpdate){//INSERT SCENARIO
        nOppMap = NewOppMap;
        for(Opportunity opp : NewOppMap.Values()){
            nOppPAcc.put(opp.Id, opp.PartnerAccountId);
            //mapbool.put(opp.id, false);
        }
SYSTEM.DEBUG('### In Sharing INSERT ###' +  nOppPAcc);
 //RedPoint tracker.DebugTracker__c += '### In Sharing INSERT ###' +  String.valueOf(nOppPAcc);
    }
    else{//UPDATE SCENARIO
        List<OpportunityShare> allManuaShare = new List<OpportunityShare>([SELECT Id, OpportunityId from OpportunityShare where OpportunityId in :NewOppMap.keySet() ANd RowCause ='Manual']);
        Map<Id, List<OpportunityShare>> oppShareMap = new Map<Id, List<OpportunityShare>>();
        for(Opportunity opp : NewOppMap.Values()){
            List<OpportunityShare> relatedShare = new List<OpportunityShare>();
            for(OpportunityShare oppShare : allManuaShare){
                if(opp.Id == oppShare.OpportunityId){
                    relatedShare.add(oppShare);
                }
            }
            oppShareMap.put(opp.id, relatedShare);
        }

        for(Opportunity opp : NewOppMap.Values())
        {
            //RedPoint tracker.DebugTracker__c += ' new Acc ' + opp.PartnerAccountId + ' Old Acc ' + OldOppMap.get(opp.Id).PartnerAccountId;
            //RedPoint tracker.DebugTracker__c += ' new own ' + opp.OwnerId + ' Old own ' + OldOppMap.get(opp.Id).OwnerId;
            if(opp.PartnerAccountId != null &&
               opp.PartnerAccountId != OldOppMap.get(opp.Id).PartnerAccountId &&
               opp.OwnerId != OldOppMap.get(opp.Id).OwnerId)
            {
                nOppMap.put(opp.ID,opp);
                oOppMap.put(opp.ID, oldOppMap.get(opp.Id));
                nOppPAcc.put(opp.Id, opp.PartnerAccountId);
                oOppPAcc.put(opp.Id, oldOppMap.get(opp.Id).PartnerAccountId);
                //mapbool.put(opp.id, false);
            }
            else{
                if(oppShareMap.containsKey(opp.Id) && oppShareMap.get(opp.Id).size() == 0){
                    nOppMap.put(opp.ID,opp);
                    nOppPAcc.put(opp.Id, opp.PartnerAccountId);
                        //mapbool.put(opp.id, true);
                }
            }
        }
SYSTEM.DEBUG('### In Sharing UPDATE ###\n' +  nOppMap + '\n' + oOppMap + '\n' + nOppPAcc + '\n' + oOppPAcc);
//RedPoint tracker.DebugTracker__c += ' ### In Sharing UPDATE ###\n' +  String.valueOf(nOppMap) + '\n' + String.valueOf(oOppMap) + '\n' + String.valueOf(nOppPAcc) + '\n' + String.valueOf(oOppPAcc);
    }
SYSTEM.DEBUG(Logginglevel.error,'### nOppMap CHK ###' + nOppMap);
    if(!nOppMap.isEmpty())//If there are valid records to process
    {
SYSTEM.DEBUG('### IN SHARING CHK ### ');
        Map<Id, String> mapIDvRoleName= new Map<Id, String>(); //Contains Account Id vs Executive Role name to share
        for(Account acc:[SELECT id, Name
                         FROM Account
                         WHERE id IN: nOppPAcc.values() OR id IN: oOppPAcc.values()])
            mapIDvRoleName.put(acc.id, acc.name + ' Partner Executive');

            System.debug(Logginglevel.error,' mapIDvRoleName is : ' + mapIDvRoleName);
            //RedPoint tracker.DebugTracker__c += ' mapIDvRoleName is : ' + String.valueOf(mapIDvRoleName);
        if(!mapIDvRoleName.isEmpty())
        {
            Map<String, Id> mRoleNamevsId = new Map<String, Id>();//Role Name vs Role Id
            for(UserRole usr: [SELECT id, name
                               FROM UserRole
                               WHERE Name IN: mapIDvRoleName.values()])
                mRoleNamevsId.put(usr.Name, usr.Id);

                System.debug(Logginglevel.error,' mRoleNamevsId is : ' + mRoleNamevsId);
                //RedPoint tracker.DebugTracker__c += ' mRoleNamevsId is : ' + String.valueOf(mRoleNamevsId);

            Map<Id, Id> mRoleIdvsGroupId = new Map<Id, Id>(); //Role Id vs Group Id
            for(Group grp: [SELECT ID, RelatedID
                            FROM Group
                            WHERE Type='Role' AND RelatedId IN: mRoleNamevsId.values()])    //R.A. 10.FEB.2015 - Case 00464568 - Set the Group type to "Role".
                mRoleIdvsGroupId.put(grp.RelatedId , grp.Id);

                System.debug(Logginglevel.error,' mRoleIdvsGroupId is : ' + mRoleIdvsGroupId);
                //RedPoint tracker.DebugTracker__c += ' mRoleIdvsGroupId is : ' + String.valueOf(mRoleIdvsGroupId);
            List<OpportunityShare> nOppShare=new List<OpportunityShare>();//Share record that need to be created/inserted
            for(Opportunity opp:nOppMap.values())
            {
                if(nOppPAcc.containsKey(Opp.ID) && nOppPAcc.get(Opp.ID) != null &&
                   mapIDvRoleName.containsKey(nOppPAcc.get(Opp.ID)) && mapIDvRoleName.get(nOppPAcc.get(Opp.ID)) != null &&
                   mRoleNamevsId.containskey(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) && mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) != null &&
                   mRoleIdvsGroupId.containsKey(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) && mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) != null)
                {
                    nOppShare.add(new OpportunityShare(OpportunityId= opp.Id,
                                                          UserOrGroupID= mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))),
                                                          OpportunityAccessLevel= 'Edit'));
                }
            }

                            System.debug(Logginglevel.error,' nOppShare is : ' + nOppShare);
                    //RedPoint tracker.DebugTracker__c +=  'nOppShare is : ' + String.valueOf(nOppShare);

            if(isUpdate)//UPDATE SCENARIO
            {
                List<OpportunityShare> oldOppShare = new List<OpportunityShare>();//Existing Share record that need to be removed
                Set<ID> setGroupIds=new Set<ID>();
                for(ID oOppID: oOppPAcc.keySet())
                {
                    if(oOppPAcc.containsKey(oOppId) && oOppPAcc.get(oOppId) != null &&
                       mapIDvRoleName.containsKey(oOppPAcc.get(oOppId)) && mapIDvRoleName.get(oOppPAcc.get(oOppId)) != null &&
                       mRoleNamevsId.containsKey(mapIDvRoleName.get(oOppPAcc.get(oOppId))) && mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId))) != null &&
                       mRoleIdvsGroupId.containsKey(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))) && mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))) != null)
                    {
                        setGroupIds.add(mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))));
                    }
                }

                System.debug(Logginglevel.error,' setGroupIds is : ' + setGroupIds);

                if(!oOppPAcc.isEmpty() && !setGroupIds.isEmpty())
                {
                    oldOppShare= [SELECT ID
                                  FROM OpportunityShare
                                  WHERE OpportunityId IN: oOppPAcc.keySet() AND
                                        UserOrGroupID IN: setGroupIds AND
                                        OpportunityAccessLevel IN ('Edit','Read')];
                }
SYSTEM.DEBUG(Logginglevel.error,'### In Sharing UPDATE ###' + nOppShare + '\n' + oldOppShare);
//RedPoint tracker.DebugTracker__c += '### In Sharing UPDATE ###' + String.valueOf(nOppShare) + '\n' + String.valueOf(oldOppShare);
                if(!nOppShare.isEmpty())//Insert New Sharing
                    insert nOppShare;
                if(!oldOppShare.isEmpty())//Delete Old Sharing
                    delete oldOppShare;
            }
            else{//INSERT SCENARIO
            //RedPoint tracker.DebugTracker__c += '### In Sharing INSERT ###' + String.valueOf(nOppShare);
SYSTEM.DEBUG('### In Sharing INSERT ###' + nOppShare);
                if(!nOppShare.isEmpty())//Insert New Sharing
                    insert nOppShare;
            }
        }
    }
    try{
    //RedPoint insert tracker;
    }
    catch(Exception e){}
}//End Func addSharingRule3
}