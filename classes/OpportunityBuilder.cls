public with sharing class OpportunityBuilder implements NodeConsumer
{
	
	public Map<String, List<String>> CPRfieldTosObjectField;
	public Map<String , String> nodesToStore;
	
	public OpportunityBuilder(List<CPRFieldMapping__c> allMappings)
	{
		CPRfieldTosObjectField = new Map<String, List<String>>();
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Opportunity')
			{
				CPRfieldTosObjectField.put(theMapping.CPR_FieldName__c , new List<String>{theMapping.sObjectField__c , theMapping.Type__c});
			}
		}
		initData();
	}
	
	public void initData()
	{
		nodesToStore = new Map<String,String>();
	}
	
	public void consumeNode(TG_XmlNode theNode)
	{
		String CPRFieldName = theNode.getAttribute('Name');
		if(CPRfieldTosObjectField.containsKey(CPRFieldName))
		{
			String theValue = theNode.getAttribute('Value');	
			nodesToStore.put(CPRFieldName,theValue);
		}
	}
	
	public Opportunity constructOpportunity()
	{
		//TODO::ErrorHandling
		String id = nodesToStore.get('OpportunityID');
		Opportunity opportunityToBuild = new Opportunity(Id = id );
		
		Contact theLessee = new Contact(CPR_ID__c = nodesToStore.get('CustomerID'));//[SELECT Id FROM Contact WHERE Name = :lesee];
		system.debug('lllll'+theLessee);
		opportunityToBuild.Primary_Contact__r = theLessee;
		
		User theOwner = new User(CPR_Salesperson_ID__c = nodesToStore.get('SalespersonId'));
		opportunityToBuild.Owner = theOwner;
		
		return opportunityToBuild;
	}
}