/***
****/
trigger beforePartnerPerformanceUpdate on PartnerPerformance__c (before update) {
	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    PartnerPerformanceManagement.beforePartnerPerformanceUpdate(Trigger.New, Trigger.Old);
    
    
}