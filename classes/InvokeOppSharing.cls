public class InvokeOppSharing {
    //Case #00516452 - complete partner sharing fix as owner sharing changes were being bypassed upon lead conversion SPD release 6/4/2015
    
    @InvocableMethod
    public static void callSharingRule(List<Id> oppIds) {
        System.debug('Lead Conversion context: ' + Util.isInContextOfLeadConversion());
        if(!Util.isInContextOfLeadConversion()) return;
        
        List<Exception_Log__c> logs = new List<Exception_Log__c>();
        if(oppIds != null && oppIds.size() > 0) {
            
            try {
                addOppSharingRules(oppIds);
            } catch (Exception e) {
                for(Id i : oppIds) {
                    Exception_Log__c log = new Exception_Log__c();
                    log.Opportunity_Id__c = i;
                    log.Error_Message__c = e.getMessage();
                    log.Stack_Trace__c = e.getStackTraceString();
                    logs.add(log);
                }
                try {
                    insert logs;
                } catch (Exception logException) {}
            }
        }
    }
    
    public static void addOppSharingRules(List<Id> OppList){
        
        Map<Id, Id> nOppPAcc = new Map<Id, Id>(); //Opp Id vs New Partner Account Id
        boolean isUpdate = false;
        
        Map<ID,Opportunity> NewOppMap = new Map<Id, Opportunity>([Select Id, OwnerId, Partner_Account_Id__c, PartnerAccountId, Partner_Account_Id__r.Name, PartnerAccount.Name
                                                                  FROM Opportunity
                                                                  WHERE Id IN: oppList]);
        
       Map<Id, String> idForRoleNames = new Map<Id, String>();
        Map<Id, String> mapIDvRoleName= new Map<Id, String>(); //Contains Account Id vs Executive Role name to share
        for(Opportunity o : NewOppMap.values()) {
            idForRoleNames.put(o.PartnerAccountId == null ? o.Partner_Account_Id__c : o.PartnerAccountId, o.PartnerAccount.Name == null ? o.Partner_Account_Id__r.Name : o.PartnerAccount.Name);
            nOppPAcc.put(o.Id, o.PartnerAccountId == null ? o.Partner_Account_Id__c : o.PartnerAccountId);
        }        
        for(Id i : idForRoleNames.keySet()) {
			if(idForRoleNames.get(i) != null) {
				String shareName = (idForRoleNames.get(i) + ' Partner Executive');
				mapIdvRoleName.put(i, shareName);
			}
		}      
        
/*        List<OpportunityShare> allManuaShare = new List<OpportunityShare>([SELECT Id, OpportunityId
                                                                           FROM OpportunityShare
                                                                           WHERE OpportunityId IN: NewOppMap.keySet() ANd RowCause ='Manual']);
        
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
*/
        Map<Id, Id> oOppPAcc = new Map<Id, Id>(); //Opp Id vs Old Partner Account Id
        if(!NewOppMap.isEmpty()){//If there are valid records to process
         /*   if(oppShareMap != null && !oppShareMap.isEmpty()) {
				isUpdate = true;
            } */
            if(!mapIDvRoleName.isEmpty()) {
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
                for(Opportunity opp : NewOppMap.values()){
                    if(nOppPAcc.containsKey(Opp.ID) && nOppPAcc.get(Opp.ID) != null &&
                       mapIDvRoleName.containsKey(nOppPAcc.get(Opp.ID)) && mapIDvRoleName.get(nOppPAcc.get(Opp.ID)) != null &&
                       mRoleNamevsId.containskey(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) && mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID))) != null &&
                       mRoleIdvsGroupId.containsKey(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) && mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))) != null){
                           nOppShare.add(new OpportunityShare(OpportunityId = opp.Id,
                                                              UserOrGroupID = mRoleIdvsGroupId.get(mRoleNamevsId.get(mapIDvRoleName.get(nOppPAcc.get(Opp.ID)))),
                                                              OpportunityAccessLevel= 'Edit'));
                       }
                }
                
           /*     if(isUpdate) {
                    List<OpportunityShare> oppSharesToDelete = new List<OpportunityShare>();
                    for(Id i : oppShareMap.keySet()) {
                        for(List<OpportunityShare> os : oppShareMap.values()) {
                            oppSharesToDelete.addAll(os);
                        }
                    }
                    delete oppSharesToDelete;
                } */
                try {
                    insert nOppShare;
                } catch(Exception e){
                    Exception_Log__c log = new Exception_Log__c();
                    log.Error_Message__c = e.getMessage();
                    log.Stack_Trace__c = e.getStackTraceString();
                    insert log;
                }
            }
        }
    } 
}