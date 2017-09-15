/* **************************************************************************************
* Class Name     : OpportunityTeamMember_Trigger_Utility 
* Version           : 1.0 
* Created Date   : 12 Aug 2015
* Function          : It's a class to store the Function being called from OpportinityTeamMemeber Trigger. 
                        
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ankit                        12 Aug 2015          Original Version
*************************************************************************************/
public class OpportunityTeamMember_Trigger_Utility {

/*
@Name        : fCheckUIinsert 
@description : It's function to throw an error if OppTeamMember is being modified through UI.
@parameters  : (sTriggerAction,Trigger.Old,Trigger.New)
@returns        :  Void.
*/
public static boolean bUIcheck = true;
// Opportunity Team member Role need to be checked. 
public static Set<string> sRoleToCheck = new set<string> {Label.IP_Partner_Role,Label.DRIP_Partner_Role};

public static void fCheckUIDelete(map<Id,OpportunityTeamMember> TriggerOldMap,List<OpportunityTeamMember>TriggerNewList){
    system.debug('----TriggerNewList---' + TriggerNewList);
    if(bUIcheck){
            for(OpportunityTeamMember OTM : TriggerNewList){
                 if(sRoleToCheck.Contains(OTM.TeamMemberRole))
                       OTM.addError('DRIP and IP deletion are not allowed. Please go to alliance partner for modification');
                }
            }
  }

/*
@Name        : fPartnerRoleDuplicateCheck 
@description : It's function to identify duplicate role in OpportunityTeamMember.
@parameters  : (Trigger.Old,Trigger.New)
@returns        :  Void.
*/

public static void fPartnerRoleDuplicateCheck (map<Id,OpportunityTeamMember> TriggerOldMap, List<OpportunityTeamMember>TriggerNewList ) {
      
     // Set to store all the OpportunityIds
      Set<ID> sOppIds = new set<Id> (); 
      set<Id> sRelatedUserId = new set<Id> ();
      // Map to store the Opportunity ID and related roles.
      Map<Id,set<string>> mOppWithRole = new map<Id,set<string>>();
      // Map to store the UserId with Account Id
      Map <Id,Id> mUserIdAccountId = new map <Id,Id> ();
      
      // Loop the Opportunity Team Member and store all Opp Id
      for (OpportunityTeamMember oOppTeamMemNew : TriggerNewList) {
            if(TriggerOldMap == null || ( oOppTeamMemNew.TeamMemberRole <> TriggerOldMap.get(oOppTeamMemNew.Id).TeamMemberRole))
               sOppIds.add(oOppTeamMemNew.OpportunityId);
               sRelatedUserId.add(oOppTeamMemNew.UserId);
      }
      // Looping through the user to store the userID with AccountId
      for( user u : [select Id,Contact.AccountId from user where Id IN : sRelatedUserId]) {
                  mUserIdAccountId.put(u.Id,u.Contact.AccountId);
          }    
      
      // Populating Map of Opp Id and related roles of Opportunity Team member.
      for (OpportunityTeamMember oOTMs : [select Id,Name,TeamMemberRole,OpportunityId from OpportunityTeamMember where OpportunityId IN : sOppIds]){
                if(!mOppWithRole.Containskey(oOTMs.OpportunityId))
                    mOppWithRole.put(oOTMs.OpportunityId,new set<string> ());
                mOppWithRole.get(oOTMs.OpportunityId).add(oOTMs.TeamMemberRole);
         } 
      system.debug('mOppWithRole' + mOppWithRole);
      //  Checking if the Role of New Opportunity already exist in the Opp. 
       if(!mOppWithRole.IsEmpty())
         for (OpportunityTeamMember oOppTeamMem : TriggerNewList){
               
                if (sRoleToCheck.Contains(oOppTeamMem.TeamMemberRole)){  // check if the Role exist in the Role to check list
                         if (mUserIdAccountId.get(oOppTeamMem.userId) == Null)
                                 oOppTeamMem.addError('This is not a Partner user'); //add Error Message. 
                         if(mOppWithRole.get(oOppTeamMem.OpportunityId).Contains(oOppTeamMem.TeamMemberRole)){ // Check if the opp has already has that Role
                                oOppTeamMem.addError(oOppTeamMem.TeamMemberRole + ' Role already exist for this Opportunity'); //add Error Message. 
                         }
                }
         }  
}


}