/*...
Class Name		:	ManageOpportunityAccessController2
Author			:	Appirio Offshore(Prakash)
Created Date	:	Nov 07, 2009
Related PR	 	:	PR-03088
Purpose			:	page will have 2 links:
					>> Allow all to see opportunities
					>> Restore default opportunity access rules
	
					(1) Allow all to see opportunities
					When this link is clicked, a sharing rule is created for each of the partner account's opportunities. The sharing rule is

					Portal Role:[account] Partner User
					Opportunity Access: Read/Write
					
					Apply the same code as the "Allow Partner Executives to see all opportunities" link.
					
					There's a check box called "Allow all to see opportunities" on the account object, which will track whether this functionality has been invoked.
					
					
					(2) Restore default opportunity access rules
					
					This link is similar to the other link with the same name. The only difference is this link will delete all opportunity sharing rules for Partner User Role. 
..*/

public class ManageOpportunityAccessController2 {
	
  //properties
  public Id accountId {get; set;}
  public Account currentAccount {get; set;}
  public String roleName {get; set;}
  public ApexPages.StandardController currentController {get ;set;}
  public Boolean alreadyCreated {get; set;}
  public Boolean alreadyDeleted {get; set;}
  
  //constructor
  public ManageOpportunityAccessController2(ApexPages.StandardController controller){
  	this.accountId = controller.getId();
  	this.currentController = controller;
  	this.alreadyCreated = false;
  	this.alreadyDeleted = false;
  	this.queryRecord();
  }
  /* Function
  	Responsible for fetching Cuurent Account Record Fields and 
  	populate the Exact Role Name which is going to Save
  */
  public void queryRecord(){
  	List<Account> lstAccounts = new List<Account>();
  	lstAccounts = [select Id, Name, Allow_all_to_view_Opportunities__c 
  		from Account where Id = :this.accountId];
  		
  	if(lstAccounts.size() > 0){
  	  this.currentAccount = lstAccounts[0];
  	  this.roleName = this.currentAccount.Name + ' Partner User';	
  	}
  }
  /*	Function
  		Responsible for redirecting to the same Account Page Layout 
  */
  
  public PageReference redirectToAccount(){  	
    return this.currentController.view();	  	  	
  }
  
 /*	Function
 	Responsible for add Sharing Roles regarding the all related Opportunities for Partner Account
 */
  public void addSharingRules(){ 
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
  	this.alreadyCreated = true;
  	this.alreadyDeleted = false;  	
  }
  /*	Function
 		Responsible for delete Sharing Roles regarding the all related Opportunities for Partner Account
 */
  public void deleteSharingRules(){  	
  	
  	//get role
  	UserRole roleRecord = null;
  	Group grpRecord = null; 
  	List<UserRole> lstUserRoles = new List<UserRole>();
  	lstUserRoles = [select Id, Name from UserRole where Name = :this.roleName];
  	if(lstUserRoles.size() > 0){
  	  roleRecord = lstUserRoles[0];
  	  //get group
  	  List<Group> lstGrps = [select Id, Name from Group where RelatedId = :roleRecord.Id];
  	  if(lstGrps.size() > 0){
  	  	grpRecord = lstGrps[0];
  	  }  	  	
  	}
  	if(grpRecord == null){  	  	
  	  return;  	  	
  	}
  	
  	Set<Id> setOppIds = new Set<Id>();
  	List<OpportunityShare> lstOppShare = new List<OpportunityShare>();
  	for(List<Opportunity> lstOpps : [select Id, Name from Opportunity where PartnerAccountId = :this.accountId]){
  
  	  //holds Opportunity ids
  	  setOppIds.clear();
  	  for(Opportunity oppObj : lstOpps){
  	  	setOppIds.add(oppObj.Id);
  	  }
  	  //fetch all sharing rule 
  	  lstOppShare.clear();
  	  lstOppShare = [select Id, OpportunityId 
  	                 from OpportunityShare 
  	                 where OpportunityId in :setOppIds 
  	                 and OpportunityAccessLevel = 'Edit' 
  	                 and UserOrGroupId = :grpRecord.Id];
  	  
  	  if(lstOppShare.size() > 0){
  	  	delete lstOppShare;
  	  }
  	                
  	}
  	
  	if(this.currentAccount.Allow_all_to_view_Opportunities__c){
  		this.currentAccount.Allow_all_to_view_Opportunities__c = false;
  		update this.currentAccount;
  	}
  	this.alreadyDeleted = true;
  	this.alreadyCreated = false;  	
  
  }
	
}