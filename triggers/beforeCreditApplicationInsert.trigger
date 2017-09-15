trigger beforeCreditApplicationInsert on Credit_Application__c(before insert) {
    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
   CreditApplicationManagement.beforeCreditApplicationInsert(Trigger.new);
   
}