public with sharing class QuoteBuilder implements NodeConsumer
{
	public Quote quoteToBuild;
	public Map<String, List<String>> CPRfieldTosObjectField;
	
	public QuoteBuilder(List<CPRFieldMapping__c> allMappings)
	{
		CPRfieldTosObjectField = new Map<String, List<String>>();
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Quote')
			{
				CPRfieldTosObjectField.put(theMapping.CPR_FieldName__c , new List<String>{theMapping.sObjectField__c , theMapping.Type__c});
			}
		}
		initData();
	}
	
	public void initData()
	{
		quoteToBuild = new Quote();
		//quoteToBuild.Name = 'CPR-WebTest Quote';
	}
	
	public void consumeNode(TG_XmlNode theNode)
	{
		 String CPRFieldName = theNode.getAttribute('Name');
		 System.debug( CPRFieldName );
		 System.debug( quoteToBuild );
		 System.debug( CPRfieldTosObjectField );
		 if(CPRfieldTosObjectField.containsKey(CPRFieldName))
		 {
		 	String theValue = theNode.getAttribute('Value');	
		 	String sObjectFieldName = CPRfieldTosObjectField.get(CPRFieldName)[0];
		 	String theType = CPRfieldTosObjectField.get(CPRFieldName)[1];
		 	
		 	if(theType == 'Date')
		 	{
		 		Date theDateValue = Date.parse(theValue); 
		 		quoteToBuild.put(sObjectFieldName , theDateValue);
		 	}
		 	else if(theType == 'Decimal')
		 	{
		 		String replaced = theValue.replace('$',''); //some of these things may contain dollar signs
		 		if(theValue == '' || theValue == null)
		 		{
		 			quoteToBuild.put(sObjectFieldName , null);
		 		}
		 		else
		 		{
					quoteToBuild.put(sObjectFieldName , Decimal.valueOf(replaced));
		 		}
		 	}
		 	else if(theType == 'Number')
		 	{
		 		quoteToBuild.put(sObjectFieldName , Integer.valueOf(theValue));
		 	}
		 	else if(theType == 'Boolean')
		 	{
		 		quoteToBuild.put(sObjectFieldName , Boolean.valueOf(theValue));
		 	}
		 	else if(theType == 'ExternalId')
		 	{
		 		Item__c theItem = new Item__c(Item_ID__c = theValue);
		 		if ( theValue != null )
		 		{
		 			quoteToBuild.putSObject(sObjectFieldName, theItem );
		 		}
		 	}
		 	else
		 	{
		 		quoteToBuild.put(sObjectFieldName , theValue);
		 	}
		 		
		 }
		
	}
	
}