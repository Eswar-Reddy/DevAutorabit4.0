trigger beforeTerritoryDefinitionInsert on Territory_Definition__c (before Insert) {

	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    TerritoryManagement.beforeTerritoryDefinitionInsert (Trigger.new);
    

}