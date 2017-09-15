/*********************************************************************************
Class Name : ManageOpportunityAccessController
Created By : Appirio Offshore
Created On : 2nd Oct 2009
Modified On: 7th Oct 2009
Usage      : Controller class for VF page 'ManageOpportunityAccess' 
Revision History:
11.FEB.2015  MAM Fix for case 00464568 - Portal Roles Issue
**********************************************************************************/
public class ManageOpportunityAccessController{
  //properties
  public Id accountId {get; set;}
  public Account currentAccount {get; set;}
  public String roleName {get; set;}
  public ApexPages.StandardController currentController {get ;set;}
  
  public Boolean alreadyDeleted {get; set;}  
  public Boolean alreadyCreatedForAll {get; set;} 
  public Boolean alreadyCreatedForExecutives {get; set;}
 
  //constructor
  public ManageOpportunityAccessController(ApexPages.StandardController controller){
    this.accountId = controller.getId();
    this.currentController = controller;
    
    this.alreadyCreatedForExecutives = false;       
    this.alreadyCreatedForAll = false;
    
    this.alreadyDeleted = false;
    
    this.queryRecord();
  }
  
  public void queryRecord(){
    List<Account> lstAccounts = new List<Account>();
    lstAccounts = [select Id, Name, Executives_view_all_Opportunities__c,Allow_all_to_view_Opportunities__c 
        from Account where Id = :this.accountId];
        
    if(lstAccounts.size() > 0){
      this.currentAccount = lstAccounts[0];
     
    }
  }
  
  //redirects to the account
  public PageReference redirectToAccount(){     
    return this.currentController.view();           
  }
  
  // Function Created By Niket to remove Role and Subordinate access
  public void deleteRolesandSubOrdinates(UserRole roleRecord){
  	
  	Set<String> setGrp = new Set<String>();
  	List<Group> lstGrps = new List<Group>();
  	Set<Id> setOppId = new Set<Id>();
  	
  	lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id AND Type='RoleAndSubordinates']; //MAM 11.FEB.2015 Case 00464568 - Set the Group type to "Role"
    
    if(lstGrps.isEmpty()) return;
    
    for(Group Objgrp : lstGrps)
    	setGrp.add(Objgrp.Id);
    
    for(Opportunity ObjOpps : [select Id, Name from Opportunity where PartnerAccountId = :this.accountId]){
    	setOppId.add(ObjOpps.Id);
    }
      
    if(setOppId.IsEmpty()) return;
    
    //fetch the sharing rules already created for avoiding conflict
      List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
      
      lstOppShare = [select Id, OpportunityId 
                     from OpportunityShare 
                     where OpportunityId in :setOppId 
                     and UserOrGroupId in : setGrp];
      
      if(lstOppShare.isempty()) return;
      
      delete lstOppShare;
  }
  
  
  public void addSharingRules()
  {
  	this.roleName = this.currentAccount.Name + ' Partner Executive';    
    //get role
    UserRole roleRecord = null;
    Group grpRecord = null; 
    List<UserRole> lstUserRoles = new List<UserRole>();
    lstUserRoles = [select Id, Name from UserRole where Name = :this.roleName];
    
    if(lstUserRoles.size() > 0){
      roleRecord = lstUserRoles[0];
      //get group
      List<Group> lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id AND Type='Role']; //MAM 11.FEB.2015 Case 00464568 - Set the Group type to "Role"
      if(lstGrps.size() > 0){
        grpRecord = lstGrps[0];
      }         
    }
    if(grpRecord == null){
      return;
    }
    
    // Deleting role and Subordinate
    deleteRolesandSubOrdinates(roleRecord);
    
    //get group id
    for(List<Opportunity> lstOpps : [select Id, Name 
        from Opportunity 
        where PartnerAccountId = :this.accountId]){
            
      //holds Opportunity ids
      Set<Id> setOppIds = new Set<Id>();
      for(Opportunity oppObj : lstOpps){
        setOppIds.add(oppObj.Id);
      }
      //fetch the sharing rules already created for avoiding conflict
      List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
      
      lstOppShare = [select Id, OpportunityId 
                     from OpportunityShare 
                     where OpportunityId in :setOppIds 
                     and OpportunityAccessLevel = 'Edit' 
                     and UserOrGroupId = :grpRecord.Id];
      
      Set<Id> setOppShareIds = new Set<Id>();
      for(OpportunityShare oppShare : lstOppShare){
        setOppShareIds.add(oppShare.OpportunityId);
      }       
      //create sharing rules
      List<OpportunityShare> lstOppShareInsert = new List<OpportunityShare>();
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
        //insert list
        insert lstOppShareInsert;
      }
      
      // Before sharing on Role basic we have to delete roles and Subordinates
      
                                   
    }
    this.currentAccount.Executives_view_all_Opportunities__c = true;
    update this.currentAccount;
    this.alreadyCreatedForExecutives = true;
        //this.alreadyCreated = true;
    this.alreadyDeleted = false;    
  }
  
  public void deleteExistingRoleShare(){
  	
  	List<UserRole> lstUserRoles = new List<UserRole>();
  	List<Group> lstGrps = new List<Group>();
  	List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
  	
  	Set<String> setOppId = new Set<String>();
  	Set<String> setRoleName = new Set<String>();
  	Set<String> setRoleId = new Set<String>();
  	setRoleName.add(this.currentAccount.Name + ' Partner User');
  	setRoleName.add(this.currentAccount.Name + ' Partner Executive');
  	Set<String> setGrpId = new Set<String>();
  	
  	
    lstUserRoles = [select Id, Name from UserRole where Name In : setRoleName];
    if(lstUserRoles.isEmpty()) return;
    
    for(UserRole objRole : lstUserRoles)
    	setRoleId.add(objRole.Id);
    	
    lstGrps = [select Id, Name from Group where RelatedId in : setRoleId AND Type='Role'];
    
    if(lstGrps.IsEmpty()) return;
    
    for(Group objgrp : lstGrps){
    	setGrpId.add(objgrp.Id);
    }
    
    system.debug('=====1 ==========>'+setGrpId);
    
    
    for(Opportunity ObjOpps : [select Id, Name 
							   from Opportunity 
							   where PartnerAccountId = :this.accountId])
	setOppId.add(ObjOpps.Id);
	
	system.debug('=======2 =========>'+setOppId);
	
	lstOppShare = [select Id, OpportunityId 
                     from OpportunityShare 
                     where OpportunityId in :setOppId 
                     and OpportunityAccessLevel = 'Edit' 
                     and UserOrGroupId In: setGrpId
                     and RowCause = 'Manual'];						    
    
    system.debug('lstOppShare ================>'+lstOppShare);
    
    if(!lstOppShare.IsEmpty())
    	delete lstOppShare;
  }
  
   /*   Function
    Responsible for add Sharing Roles regarding the all related Opportunities for Partner Account
 */
  public void addSharingRules2(){ 
    //this.roleName = this.currentAccount.Name + ' Partner User';
    
    /*
    	Delete Portal Role for "Partner Executive" or "Partner User"
    */ 
    deleteExistingRoleShare();
    
    this.roleName = this.currentAccount.Name + ' Partner Executive'; 
    System.debug('Enter in addSharing Rules 1');    
    //get role
    UserRole roleRecord = null;
    Group grpRecord = null; 
    List<UserRole> lstUserRoles = new List<UserRole>();
    System.debug('Enter in addSharing Rules 2');
    lstUserRoles = [select Id, Name from UserRole where Name = :this.roleName];
    
    if(lstUserRoles != null && lstUserRoles.size() > 0){
        System.debug('Enter in addSharing Rules 3');
      roleRecord = lstUserRoles[0];
      //get group
      List<Group> lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id AND Type='RoleAndSubordinates']; //MAM 11.FEB.2015 Case 00464568 - Set the Group type to "Role"
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
        where PartnerAccountId = :this.accountId]){
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
    if(!this.currentAccount.Allow_all_to_view_Opportunities__c){
         this.currentAccount.Allow_all_to_view_Opportunities__c = true;
         update this.currentAccount;
    }
        this.alreadyCreatedForAll = true;
    //  this.alreadyCreated = true;
    this.alreadyDeleted = false;    
  }
 
  
  public void deleteSharingRules(){
    
    // Method added by Niket
    deleteAllManualSharing();
    
    //get role
    /*this.roleName = this.roleName = this.currentAccount.Name + ' Partner User'; 
    
    deleteManualSharingRules (this.roleName);
    
    if(this.currentAccount.Allow_all_to_view_Opportunities__c){
        this.currentAccount.Allow_all_to_view_Opportunities__c = false;
        this.alreadyCreatedForAll = false;
    
    }*/
    update this.currentAccount;
    this.alreadyDeleted = true;
    //this.alreadyCreated = false;      
    
  }
  
  public void deleteSharingRules2(){
    //get role
    this.roleName = this.currentAccount.Name + ' Partner Executive';
    
    deleteManualSharingRules (this.roleName);
    
    if(this.currentAccount.Executives_view_all_Opportunities__c){
        this.currentAccount.Executives_view_all_Opportunities__c = false;
        this.alreadyCreatedForExecutives = false;
        }
  
    update this.currentAccount;
    this.alreadyDeleted = true;
    //this.alreadyCreated = false;
  }
  
  // Function Created by Niket to delete manual Sharing
  public void deleteAllManualSharing(){
  	
  	//fetch all sharing rule 
      List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
      Set<Id> setOppIds = new Set<Id>();
      
      for(Opportunity oppObj: [select Id, Name from Opportunity where PartnerAccountId = :this.accountId])
	        setOppIds.add(oppObj.Id);
	  
      lstOppShare = [select Id, OpportunityId from OpportunityShare where OpportunityId in :setOppIds and RowCause = 'Manual'];
      //MAM 11.FEB.2015 case 00464568 end
      
      if(lstOppShare.size() > 0){
        	delete lstOppShare;
      	}
  }
  
  //MAM 11.FEB.2015 Case 00464568 - New Method that does the actual record sharing deletion start
  public void deleteManualSharingRules(String strRoleName){
  
    UserRole roleRecord = null;
    //MAM 11.FEB.2015 case 00464568 start
    //Group grpRecord = null;  
    Set<Id> setGrpIds = new Set<Id>();
    //MAM 11.FEB.2015 case 00464568 end
    
    List<UserRole> lstUserRoles = new List<UserRole>();
    lstUserRoles = [select Id, Name from UserRole where Name = : strRoleName];
    
    if(lstUserRoles.size() > 0){
      roleRecord = lstUserRoles[0];
      //get group
      List<Group> lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id];
      if(lstGrps.size() > 0){
        //MAM 11.FEB.2015 case 00464568 - There are 2 Groups that are being returned by this query start
        for(Group g: lstGrps){
            setGrpIds.add(g.id);
        }
        //grpRecord = lstGrps[0];
        //MAM 11.FEB.2015 end
      }        
      
    }
    
    //MAM 11.FEB.2015 case 00464568 - There are 2 Groups that are being returned by this query start
    if(setGrpIds.isEmpty())
        return;
    /*if(grpRecord == null){          
      return;       
    }*/
    //MAM 11.FEB.2015 case 00464568 end
    
    for(List<Opportunity> lstOpps : [select Id, Name from Opportunity where PartnerAccountId = :this.accountId]){
      //holds Opportunity ids
      Set<Id> setOppIds = new Set<Id>();
      for(Opportunity oppObj : lstOpps){
        setOppIds.add(oppObj.Id);
      }
      //fetch all sharing rule 
      List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
      
      //MAM 11.FEB.2015 case 00464568 - There are 2 Groups that are being returned by this query start
      /*lstOppShare = [select Id, OpportunityId 
                     from OpportunityShare 
                     where OpportunityId in :setOppIds 
                     and OpportunityAccessLevel = 'Edit' 
                     and UserOrGroupId = :grpRecord.Id];*/
      lstOppShare = [select Id, OpportunityId from OpportunityShare where OpportunityId in :setOppIds and OpportunityAccessLevel = 'Edit' and UserOrGroupId in : setGrpIds];
      //MAM 11.FEB.2015 case 00464568 end
      
      if(lstOppShare.size() > 0){
        delete lstOppShare;
      }               
    }
  } //End of deleteManualSharingRules method
  //MAM 11.FEB.2015 end
}