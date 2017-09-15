/*************************
*************************/
trigger beforeTerritoryDefinitionUpdate on Territory_Definition__c (before update) {

    if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
    TerritoryManagement.beforeTerritoryDefinitionUpdate (Trigger.new, Trigger.old);
 
}