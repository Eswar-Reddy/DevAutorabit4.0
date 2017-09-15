trigger afteAccountGeographyDelete on Account_Geography__c (after Delete)
{
	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    TerritoryManagement.afterAccountGeographyDelete (Trigger.old);     
    
}