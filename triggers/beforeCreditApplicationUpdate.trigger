trigger beforeCreditApplicationUpdate on Credit_Application__c (before update) {    
	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    CreditApplicationManagement.beforeCreditApplicationUpdate(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
    
    
}