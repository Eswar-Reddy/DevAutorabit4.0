public with sharing class QuoteSummaryBuilder implements NodeConsumer
{
	//This class will build the Quote Summary
	
	public Quote_Summary__c quoteSummary;
	
	public Map<String, List<String>> CPRfieldTosObjectField;
	
	public QuoteSummaryBuilder(List<CPRFieldMapping__c> allMappings)
	{
		CPRfieldTosObjectField = new Map<String, List<String>>();
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Quote_Summary__c')
			{
				CPRfieldTosObjectField.put(theMapping.CPR_FieldName__c , new List<String>{theMapping.sObjectField__c , theMapping.Type__c});
			}
		}
		initData();
	}
	
	public void initData()
	{
		quoteSummary = new Quote_Summary__c();
	}
	
	public void consumeNode(TG_XmlNode theNode)
	{
		 String CPRFieldName = theNode.getAttribute('Name');
		 if(CPRfieldTosObjectField.containsKey(CPRFieldName))
		 {
		 	String theValue = theNode.getAttribute('Value');	
		 	String sObjectFieldName = CPRfieldTosObjectField.get(CPRFieldName)[0];
		 	String theType = CPRfieldTosObjectField.get(CPRFieldName)[1];
		 	
		 	
		 	if(theType == 'Date')
		 	{
		 		Date theDateValue = Date.parse(theValue); 
		 		quoteSummary.put(sObjectFieldName , theDateValue);
		 	}
		 	else
		 	{
		 		quoteSummary.put(sObjectFieldName , theValue);
		 			
		 	}
		 		
		 }
		 
	}

}