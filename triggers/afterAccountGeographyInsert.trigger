trigger afterAccountGeographyInsert on Account_Geography__c(after insert)
{
    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    TerritoryManagement.afterAccountGeographyInsert (Trigger.new);
    
}