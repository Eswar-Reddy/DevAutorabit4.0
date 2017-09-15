trigger AfterCreditApplicationUpdate on Credit_Application__c (after update) {    

    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    CreditApplicationManagement.afterCreditApplicationUpdate(Trigger.new,Trigger.old);
    
    
}