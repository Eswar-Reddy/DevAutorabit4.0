/*...................................................
Class: Assign_Opportunity_Controller
Author : Appirio (Prakash)
Date: Aug 24,2009
PR: PR-02394
....................................................*/

public class Assign_Opportunity_Controller {
	public String oppID {get;set;}
	public boolean showAccountDialog{get;set;}
	public boolean showProceedDialog{get;set;}
	public String errorMessage{get;set;}
	public Opportunity opp{get;set;}
	
	public Assign_Opportunity_Controller(ApexPages.StandardController stdController){
		showAccountDialog=false;
		showProceedDialog =false;
		errorMessage ='';
		opp = (Opportunity)stdController.getRecord(); 
		for(Opportunity o:[select id,Name,Ownerid,PartnerAccountId,PartnerAccount.Name,AccountID,Account.BillingPostalCode from Opportunity where id =:opp.ID LIMIT 1]){
			opp = o;	
			oppID = o.ID;
		}
	}
	/*
		Action function calls on Page Load
	*/
	public void onPageLoad(){
		if(opp != null && opp.AccountId == null){
			showAccountDialog =true;
			showProceedDialog =false;
			errorMessage ='The opportunity cannot be assigned because the opportunity does not have an account.';
		}else if(opp.Account.BillingPostalCode == null || opp.Account.BillingPostalCode ==''){
			showAccountDialog =true;
			showProceedDialog =false;
			errorMessage ='The opportunity cannot be assigned because the opportunity does not have a valid postal code.';
		}else if(opp.PartnerAccountId != null){
			showAccountDialog =false;
			showProceedDialog =true;
			errorMessage ='The opportunity has already been assigned to a partner: '+opp.PartnerAccount.Name+'. Do you want to reassign the opportunity? ';
		}else if(opp.PartnerAccountId == null){
			if(doAssign()){
				showAccountDialog =false;
				showProceedDialog =false;	
			} 
		}		
	}
	public PageReference cancel(){
		Pagereference p = new Pagereference('/'+oppID);
		return p;	
	}
	public PageReference proceed(){
		doAssign();
		return null;
	}
	/*..
		Function executes when going to assign 
		the Opportunity on Page Load when PartnerAccount is null or User click on Proceed
	..*/
	private boolean doAssign(){
		String zipCode =opp.Account.BillingPostalCode;
		String accountID = '';
		boolean isUpdateRequired =false;
		boolean skip=false;

		for(Account_Geography__c geos : 
			[select Id,Account__c,Postal_Code__c, Skip__c 
				from Account_Geography__c 
				where Postal_Code__c = :zipCode
					LIMIT 1]){
					
			accountID =geos.Account__c;
			skip=geos.Skip__c;
		}
		if(accountID == null || accountID == ''){
			showAccountDialog =true;
			showProceedDialog =false;
			errorMessage ='The opportunity cannot be assigned because a partner has not been assigned to the postal code: '+zipCode;
		}else if(skip){
			showAccountDialog =true;
			showProceedDialog =false;
			errorMessage ='The opportunity cannot be assigned because this postal code ('+zipCode+') cannot be automatically assigned';
		}else{
			Account acct =null;
			for (Account a:[select Id,Name,Opportunity_Recipient__c from Account where ID =:accountID LIMIT 1])
				acct=a;
			if(acct != null && acct.Opportunity_Recipient__c != null){
				opp.ownerID = acct.Opportunity_Recipient__c;
				isUpdateRequired =true;
				showAccountDialog =false;
				showProceedDialog =false;
			}else{
				User uOwner =null;
				for(User user: [select id,Name from User where contactId != null and contact.Account.ID =:acct.ID and Profile.Name ='Partner Delegated Administrator' LIMIT 1 ]){
					uOwner = user;	
				}
				if(uOwner == null){
					showAccountDialog =true;
					showProceedDialog =false;
					errorMessage ='The opportunity cannot be assigned because an appropriate partner user can\'t be found.';
				}else{
					opp.ownerID = uOwner.ID;
					showAccountDialog =false;
					showProceedDialog =false;
					isUpdateRequired = true;
					errorMessage ='The opportunity has been assigned to ' + uOwner.Name+ '';
				}
			}	
		}//else ends
		if(isUpdateRequired) update opp;
		return isUpdateRequired;
	}
	
}