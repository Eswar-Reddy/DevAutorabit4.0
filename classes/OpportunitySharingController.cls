global class OpportunitySharingController{
//public Account accountRecord{get;set;}
//public String isOwnerChnaged {get;set;}

webservice static void shareOpportunities(String accID){  
system.debug('++++enter++++++');  
    if(accID==null || accID==''){
        return;
    }    
    Account accountRecord = new Account(ID=accID);
    String roleName = '';
    List<Account> acc = new List<Account>();
    acc = [Select id,owner.UserType,owner.ContactID,owner.Contact.AccountID,owner.Contact.Account.Name,owner.Contact.Account.Allow_all_to_view_Opportunities__c from Account where ID=:accountRecord.ID];
    if(acc.size()>0){
        if(acc[0].owner.ContactID!=null){
            if(!acc[0].owner.Contact.Account.Allow_all_to_view_Opportunities__c)
            {
                return;
            }
        }
        if(acc[0].owner.UserType=='PowerPartner' && acc[0].owner.ContactID!=null){
            roleName = acc[0].owner.Contact.Account.Name+' Partner User';
        }        
    }
    
    
    UserRole roleRecord = null;
    Group grpRecord = null; 
    List<UserRole> lstUserRoles = new List<UserRole>();
    System.debug('Enter in addSharing Rules 2');
    lstUserRoles = [select Id, Name from UserRole where Name = :roleName];
    
    if(lstUserRoles != null && lstUserRoles.size() > 0){
      System.debug('Enter in addSharing Rules 3');
      roleRecord = lstUserRoles[0];
      //get group
      List<Group> lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id];
      if(lstGrps != null && lstGrps.size() > 0){
        grpRecord = lstGrps[0];
      }        
    }
    System.debug('Enter in addSharing Rules 4::'+grpRecord);
    if(grpRecord == null){
      return;
    }
    Set<Id> setOppIds = new Set<Id>();
    List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
    Set<Id> setOppShareIds = new Set<Id>();
    List<OpportunityShare> lstOppShareInsert = new List<OpportunityShare>();
    //get group id
    for(List<Opportunity> lstOpps : [select Id, Name 
      from Opportunity 
      where PartnerAccountId = :acc[0].owner.Contact.AccountID]){
      //holds Opportunity ids
      setOppIds.clear();
      for(Opportunity oppObj : lstOpps){
        setOppIds.add(oppObj.Id);
      }
      System.debug('Enter in addSharing Rules 5::'+setOppIds);
      //fetch the sharing rules already created for avoiding conflict
      lstOppShare.clear();
      lstOppShare = [select Id, OpportunityId 
                     from OpportunityShare 
                     where OpportunityId in :setOppIds 
                     and OpportunityAccessLevel = 'Edit' 
                     and UserOrGroupId = :grpRecord.Id];
      
      setOppShareIds.clear();
      for(OpportunityShare oppShare : lstOppShare){
        setOppShareIds.add(oppShare.OpportunityId);
      }
      System.debug('Enter in addSharing Rules 6::'+setOppShareIds);      
      //create sharing rules
      lstOppShareInsert.clear();
      for(Opportunity oppObj : lstOpps){
        //if sharing rule is not already created
        if(!setOppShareIds.contains(oppObj.Id)){
          //create sharing rule  
          OpportunityShare oppShare = new OpportunityShare();
          oppShare.OpportunityId = oppObj.Id;
          oppShare.OpportunityAccessLevel = 'Edit';
          oppShare.UserOrGroupId = grpRecord.Id;
          //insert in the list
          lstOppShareInsert.add(oppShare);  
        }
      }
      if(lstOppShareInsert.size() > 0){
         System.debug('Enter in addSharing Rules 7::(going to insert)::'+lstOppShareInsert);
        //insert list
        insert lstOppShareInsert;
      }                           
    }
}

}