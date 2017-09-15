trigger afterAccountGeographyUpdate on Account_Geography__c(after update)
{
    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    TerritoryManagement.afterAccountGeographyUpdate (Trigger.new, Trigger.old);
    
}