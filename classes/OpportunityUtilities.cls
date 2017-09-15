/*

This will be the Opportunity Utilities class for all handlers when Get Healthy
commences. Currently this is used for the Opportunity trigger for the prioritized
Spectrum launch, with methods written to be moved into the framework.

Class:              OpportunityUtilities
Date:               08/21/2014
Version:            1
Last Updated:       08/21/2014
    *   Stubbed / 

////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class OpportunityUtilities
{   
    // -------- Constants --------
    public static DealerGeneral__c DealerGeneralInstance = DealerGeneral__c.getInstance();
    public static Id homeOwnerRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Home_Owner');
    public static Id commercialOppRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial');    
    public static Id systemOppRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Systems'); //Added by Raee$:: COMMERCIAL PROJECT-PRO (PIVOTAL #120583041) 
  
    public static User currentOppUser = [SELECT Id, Contact.Account.Theater__c, Contact.Account.Territory__c 
                                    FROM User WHERE Id =: userInfo.getUserId() LIMIT 1];// and Profile.Name LIKE 'Partner%' LIMIT 1];
    
    public static List<OpportunityLineItem> allOpportunityProducts;
    public static Map<Id, User> oppUserMap;
    
    
    // -------- Variables --------

    // None
    
    // -------- Properties --------
    //public static Boolean isIntegrationRunning = false;
    // Qualified record lists
    public static Map<Integer, Opportunity> qualifiedOpportunitiesBI {get; set;}
    //public static Map<Integer, Opportunity> qualifiedSpectrumSync {get; set;}
    
    // Associated records for various evaluations - MOVE TO ACCOUNT UTILITIES WHEN GH STARTS
    private static Map<ID, Account> partnerAccounts {get; set;}
    
    // -------- Methods --------
    // Qualify records; partnerAccountToOpportunity stores the one to many relationship for opps belonging 
    // to partner accounts; which is used to build the qualifiedSpectrumSync
    //public static void qualifySpectrumRecords(List<Opportunity> newOpps)
    //{
    //    if(isIntegrationRunning != null && isIntegrationRunning == true)
    //        return;
    //    Diagnostics.push('qualifySpectrumRecords');
        
    //    qualifiedOpportunitiesBI = new Map<Integer, Opportunity>();
    //    qualifiedSpectrumSync = new Map<Integer, Opportunity>();
    //    partnerAccounts = new Map<ID, Account>();
        
    //    Map<ID, List<Integer>> partnerAccountToOpportunity = new Map<ID, List<Integer>>();
        
    //    Set<Id> accountIds = new Set<Id>();
    //    for(Opportunity opp : newOpps){
    //        if(opp.Dealer_Selection__c != null)
    //            accountIds.add(opp.Dealer_Selection__c);
    //        else if(opp.Partner_Account_Id__c != null)
    //            accountIds.add(opp.Partner_Account_Id__c);
                    
    //    }
    //    Set<Id> partnerAccountIDs = SpectrumJSONServices.isSpectrumPartner(accountIds);

    //    for(Opportunity opp : newOpps){
    //        Id partnerAccId = opp.Dealer_Selection__c != null?opp.Dealer_Selection__c:opp.Partner_Account_Id__c;
    //        if(partnerAccountIDs != null && partnerAccountIDs.size() > 0 && partnerAccountIDs.contains(partnerAccId)){
    //            opp.SyncWithSpectrum__c = 'New';
    //        }
    //    }   
    //    Diagnostics.pop();
    //}
    
    //// Start processing
    //public static void start()
    //{
    //    Diagnostics.push('Opportunity before insert handler start');
    //    if(isIntegrationRunning != null && isIntegrationRunning == true)
    //        return;
        
    //    Diagnostics.debug('qualifiedOpportunitiesBI: ' + qualifiedOpportunitiesBI.size());
    //    Diagnostics.debug('partnerAccounts: ' + partnerAccounts.size());
    //    Diagnostics.debug('qualifiedSpectrumSync: ' + qualifiedSpectrumSync.size());
        
    //    for(Integer oppCount : qualifiedOpportunitiesBI.keySet())
    //    {
    //        if(qualifiedSpectrumSync.containsKey(oppCount))
    //        {
    //            qualifiedSpectrumSync.get(oppCount).SyncWithSpectrum__c = 'New';
    //        }
    //    }
        
    //    Diagnostics.pop();
    //}
    
    //// Load accounts base don various criteria - MOVE TO ACCOUNT UTILITIES WHEN GH STARTS
    //private static Map<ID, Account> loadPartnerAccounts(Set<ID> accountIDs)
    //{
    //    Map<ID, Account> result = new Map<ID, Account>();
        
    //    try
    //    {
    //        result = new Map<ID, Account>([SELECT ID, isSpectrumPartner__c FROM Account WHERE ID =: accountIDs]);
    //    }
    //    catch(QueryException error)
    //    {
    //        result = new Map<ID, Account>();
    //        Diagnostics.exception(error);
    //        SunPowerException.recordError('OpportunityUtilities', 'loadPartnerAccounts', error);
    //    }
        
    //    return result;
    //}
    
    // The following will be moved to the before update handlers
    //public static void qualifySpectrumRecordsBU(Map<ID, Opportunity> newMap, Map<ID, Opportunity> oldMap)
    //{
    //    if(isIntegrationRunning != null && isIntegrationRunning == true)
    //        return;
    //    SpectrumJSONServices checkChangedSpectrumData = new SpectrumJSONServices();
        
    //    Set<Id> accountIds = new Set<Id>(); 

    //    for(Opportunity o : newMap.values()){
    //        opportunity oldOpp = oldMap.get(o.id);   
              
    //        if(o.Partner_Account_Id__c != null)
    //            accountIds.add(o.Partner_Account_Id__c);
    //        if(oldOpp.Partner_Account_Id__c != null)                 
    //            accountIds.add(oldOpp.Partner_Account_Id__c);       
    //    }
    //    Map<Id,Account> partnerAccountMap = loadPartnerAccounts(accountIds);
        
    //    for(Opportunity newOpp : newMap.values())
    //    {
    //        try{
    //            if((newOpp.Partner_Account_Id__c != null && partnerAccountMap != null && partnerAccountMap.containsKey(newOpp.Partner_Account_Id__c) && 
    //                             (partnerAccountMap.get(newOpp.Partner_Account_Id__c).isSpectrumPartner__c || partnerAccountMap.get(oldMap.get(newOpp.Id).Partner_Account_Id__c).isSpectrumPartner__c)) || ((newOpp.Partner_Account_Id__c == null || newOpp.PartnerAccountId == null) && partnerAccountMap.get(oldMap.get(newOpp.Id).Partner_Account_Id__c).isSpectrumPartner__c)){     
    //                checkChangedSpectrumData.evaluateSpectrumChangedDataOpportunity(newOpp,oldMap.get(newOpp.Id),partnerAccountMap.get(oldMap.get(newOpp.Id).Partner_Account_Id__c).isSpectrumPartner__c);
    //            }
    //        }    
    //        catch(Exception e){
                
    //        }
    //    }
    //}
    
    
    

    //@future(callout=true)
    //public static void sendOpportunities(Set<Id> opportunityIds){
    //        List<Opportunity> spectrumStatusUpdates = new List<Opportunity>();
    //    SpectrumOutboundREST connection = new SpectrumOutboundREST();
    //    List<SpectrumOutboundREST.SpectrumResult> syncResults;
        
    //    Map<ID, String> syncRecordErrors = new Map<ID, String>();
    //    Boolean totalSyncFailure = false;
        
    //    try
    //    {
    //        syncResults = connection.sendRecordsToSpectrum(opportunityIds);
    //    }
    //    catch(Exception error)
    //    {
    //        Diagnostics.exception(error);
    //        syncResults = new List<SpectrumOutboundREST.SpectrumResult>();
    //    }
        
    //    if(!syncResults.isEmpty())
    //    {
    //        for(SpectrumOutboundREST.SpectrumResult result : syncResults)
    //        {
    //            if(result.isSuccess)
    //            {
    //                spectrumStatusUpdates.add(new Opportunity(Id = result.recordId,SyncWithSpectrum__c='Complete'));
    //            }
    //            else
    //            {
    //                spectrumStatusUpdates.add(new Opportunity(Id = result.recordId,SyncWithSpectrum__c='Failed'));
    //                syncRecordErrors.put(result.recordId, result.result);
    //            }
                
    //            //spectrumStatusUpdates.add(opps.get(result.recordId));
    //        }
    //    }
    //   if(!syncRecordErrors.isEmpty())
    //    {
    //        String error = 'The following opportunity records failed to sync with Spectrum: \n';
            
    //        for(ID erroredOpp : syncRecordErrors.keySet())
    //        {
    //            error += erroredOpp + ' for ' + syncRecordErrors.get(erroredOpp) + '\n';
    //        }
            
    //        SunPowerException.recordErrorService('Account Utilities','sendOpportunities',error,'Outbound Lead Service Call');
    //    }
        
    //    try
    //    {
    //        OpportunityUtilities.isIntegrationRunning = true;
    //        update spectrumStatusUpdates;
    //    }
    //    catch(DMLException error)
    //    {
    //        SunPowerException.recordErrorService('Account Utilities','sendOpportunities',error,'Outbound Lead Service Call');
    //    }
    //}
    
    
    
    
    // -------- Internal Classes --------
    //
    public static void addSharingRule3(List<Opportunity> OppList, List<Opportunity> OppListOld, Boolean isUpdate){

        Map<ID,Opportunity> NewOppMap = new Map<ID,Opportunity>(); 
        Map<ID,Opportunity> OldOppMap = new Map<ID,Opportunity>(); 

        System.debug('Is sharing for Update: ' + isUpdate);
        if(!isUpdate){
            for(Opportunity opp: OppList)
                NewOppMap.put(opp.Id, opp);
        } else {
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
            }
        } else {//UPDATE SCENARIO
            List<OpportunityShare> allManuaShare = new List<OpportunityShare>([SELECT Id, OpportunityId
                                                                               FROM OpportunityShare
                                                                               WHERE OpportunityId IN: NewOppMap.keySet() ANd RowCause ='Manual']);
            
            Map<Id, List<OpportunityShare>> oppShareMap = new Map<Id, List<OpportunityShare>>();
            List<OpportunityShare> oldSharesForDeletion = new List<OpportunityShare>();
            
            for(Opportunity opp : NewOppMap.Values()){
                List<OpportunityShare> relatedShare = new List<OpportunityShare>();
                for(OpportunityShare oppShare : allManuaShare){
                    if(opp.Id == oppShare.OpportunityId){
                        relatedShare.add(oppShare);
                    }
                }
                if(opp.PartnerAccountId == null) {
                    oldSharesForDeletion.addAll(relatedShare);
                }
                oppShareMap.put(opp.id, relatedShare);
            }

            if(oldSharesForDeletion != null && !oldSharesForDeletion.isEmpty())
                delete oldSharesForDeletion;

            for(Opportunity opp : NewOppMap.Values()){
                if(opp.PartnerAccountId != null &&
                   opp.PartnerAccountId != OldOppMap.get(opp.Id).PartnerAccountId &&
                   opp.OwnerId != OldOppMap.get(opp.Id).OwnerId)
                {
                    nOppMap.put(opp.ID,opp);
                    oOppMap.put(opp.ID, oldOppMap.get(opp.Id));
                    nOppPAcc.put(opp.Id, opp.PartnerAccountId);
                    oOppPAcc.put(opp.Id, oldOppMap.get(opp.Id).PartnerAccountId);
                } else {
                    if(oppShareMap.containsKey(opp.Id) && oppShareMap.get(opp.Id).size() == 0){
                        nOppMap.put(opp.ID,opp);
                        nOppPAcc.put(opp.Id, opp.PartnerAccountId);
                    }
                }
            }
        }
        if(!nOppMap.isEmpty()){//If there are valid records to process
            System.debug('+++ Partner User Running');
            Map<Id, String> mapIDvRoleName= new Map<Id, String>(); //Contains Account Id vs Executive Role name to share
            for(Account acc:[SELECT id, Name
                             FROM Account
                             WHERE id IN: nOppPAcc.values() OR id IN: oOppPAcc.values()])
                mapIDvRoleName.put(acc.id, acc.name + ' Partner Executive');

            if(!mapIDvRoleName.isEmpty()){
                Map<String, Id> mRoleNamevsId = new Map<String, Id>();//Role Name vs Role Id
                for(UserRole usr: [SELECT id, name
                                   FROM UserRole
                                   WHERE Name IN: mapIDvRoleName.values()])
                    mRoleNamevsId.put(usr.Name, usr.Id);

                Map<Id, Id> mRoleIdvsGroupId = new Map<Id, Id>(); //Role Id vs Group Id
                for(Group grp: [SELECT ID, RelatedID
                                FROM Group
                                WHERE Type='Role' AND RelatedId IN: mRoleNamevsId.values()])    //R.A. 10.FEB.2015 - Case 00464568 - Set the Group type to "Role".
                    mRoleIdvsGroupId.put(grp.RelatedId , grp.Id);

                List<OpportunityShare> nOppShare = new List<OpportunityShare>();//Share record that need to be created/inserted
                for(Opportunity opp:nOppMap.values()){
                    if(nOppPAcc.containsKey(Opp.ID) && nOppPAcc.get(Opp.ID) != null &&
                            mapIDvRoleName.containsKey(nOppPAcc.get(Opp.ID)) && mapIDvRoleName.get(nOppPAcc.get(Opp.ID)) != null &&
                            mRoleNamevsId.containskey(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) && mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) != null &&
                            mRoleIdvsGroupId.containsKey(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) && mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) != null){
                        nOppShare.add(new OpportunityShare(OpportunityId = opp.Id,
                                                           UserOrGroupID = mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))),
                                                           OpportunityAccessLevel= 'Edit'));
                    }
                }

                if(isUpdate){//UPDATE SCENARIO
                    System.debug('+++ Partner User Running in Update');
                /*    List<OpportunityShare> oldOppShare = new List<OpportunityShare>();//Existing Share record that need to be removed
                    Set<ID> setGroupIds=new Set<ID>();
                    for(ID oOppID: oOppPAcc.keySet()){
                        if(oOppPAcc.containsKey(oOppId) && oOppPAcc.get(oOppId) != null &&
                                mapIDvRoleName.containsKey(oOppPAcc.get(oOppId)) && mapIDvRoleName.get(oOppPAcc.get(oOppId)) != null &&
                                mRoleNamevsId.containsKey(mapIDvRoleName.get(oOppPAcc.get(oOppId))) && mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId))) != null &&
                                mRoleIdvsGroupId.containsKey(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))) && mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))) != null){
                            setGroupIds.add(mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(oOppPAcc.get(oOppId)))));
                        }
                    }

                    System.debug('oOppPAcc:'+oOppPAcc);//MAM 16.FEB.2015 debug
                    if(!oOppPAcc.isEmpty() && !setGroupIds.isEmpty()){
                        oldOppShare= [SELECT ID
                                      FROM OpportunityShare
                                      WHERE OpportunityId IN: oOppPAcc.keySet() AND
                                            UserOrGroupID IN: setGroupIds AND
                                            OpportunityAccessLevel = 'Edit'];
                    } */ 
                    
                    if(!nOppShare.isEmpty())//Insert New Sharing
                        insert nOppShare;
                    //if(!oldOppShare.isEmpty())//Delete Old Sharing
                        //delete oldOppShare;
                } else {//INSERT SCENARIO
                    if(!nOppShare.isEmpty())//Insert New Sharing
                        System.debug('inserting ' + nOppShare.size() + ' Shares');
                        insert nOppShare;
                }
            }
        }
    }
    
    @future (callout=false)
    public Static void updateContactRoleFuture(Set <Id> oppIds){
        updateContactRole(oppIds);
    }
    
    public Static void updateContactRole(Set <Id> oppIds){
        list<OpportunityContactRole> listOpportunityContactRole = new list<OpportunityContactRole>();
        for(OpportunityContactRole objOpportunityContactRole :[Select id,IsPrimary,Role 
                                                               from OpportunityContactRole 
                                                               where OpportunityId in: oppIds 
                                                               AND Opportunity.recordtypeid =:homeOwnerRecordTypeId
                                                               AND (Role =: null OR Role =: '')
                                                               AND isPrimary =: true]){
                                                                   
                                                                   objOpportunityContactRole.Role= 'Borrower';
                                                                   listOpportunityContactRole.add(objOpportunityContactRole);
                                                               }
        update listOpportunityContactRole;
    }
    
    public static List<OpportunityLineItem> getLineItems(Map<Id, Opportunity> newOppMap) {
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>([SELECT Id, Opportunity.SyncedQuoteId, Opportunity.stagename, PriceBookEntryId,
                                                            PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, Product_Type__c,
                                                            Estimate__c, Design__c, Site__c, Cost__c, opportunityId, kWp_Components__c,
                                                            Design_Link__c, Design_Name__c, Estimate_Link__c, Estimate_Name__c
                                                     FROM OpportunityLineItem
                                                     WHERE opportunityId IN: newOppMap.keySet()]);
        allOpportunityProducts = oppProducts;
        return allOpportunityProducts;
    }
    
    public static Map<Id, User> getOppUserMap(Set<Id> oppOwnerIds) {
        oppUserMap = new Map<Id, User>();
        Map<Id, User> mapOppOwner = new Map<ID,User>([SELECT Id, Email, Manager.Email 
                                                      FROM User WHERE Id IN: oppOwnerIds]);
        oppUserMap = mapOppOwner;
        
        return oppUserMap;
    }
           
}