public with sharing class QuoteLeaseLinesBuilder implements NodeConsumer
{
	static final Set<String> moduleFields = new Set<String>{
		'Module',
		'Module Quantity',
		'Module Oracle Item Number'};
		
	static final Set<String> inverterFields = new Set<String>{	
		'Inverter Model Roof 1',
		'Inverter Quantity Roof 1',
		'Inverter Oracle Item Number Roof 1'};
		
	static final Set<String> inverterFields2 = new Set<String>{	
		'Inverter Model Roof 2',
		'Inverter Quantity Roof 2',
		'Inverter Oracle Item Number Roof 2'};
	static final Set<String> inverterFields3 = new Set<String>{	
		'Inverter Model Roof 3',
		'Inverter Quantity Roof 3',
		'Inverter Oracle Item Number Roof 3'};
	static final Set<String> inverterFields4 = new Set<String>{	
		'Inverter Model Roof 4',
		'Inverter Quantity Roof 4',
		'Inverter Oracle Item Number Roof 4'};
	
	static final String RACKING_NAME = 'Racking';
	static final Set<String> rackingFields = new Set<String>{	
		'Racking Kit Model Numbers',
		'Racking Quantity',
		'Racking Kit Oracle Item Numbers'};
		
	static final String MONITORING_NAME = 'Monitoring';
	static final Set<String> monitoringFields = new Set<String>{
		'Monitoring System Model',
		'Monitoring System Quantity',
		'Monitoring System Oracle Item Numbers'};
	
	public Map<String, Quote_Line__c> theLeaseLines;
	public Map<String, List<String>> CPRfieldTosObjectField;
	
	public QuoteLeaseLinesBuilder(List<CPRFieldMapping__c> allMappings)
	{
		CPRfieldTosObjectField = new Map<String, List<String>>();
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Quote_Line__c')
			{
				CPRfieldTosObjectField.put(theMapping.CPR_FieldName__c , new List<String>{theMapping.sObjectField__c , theMapping.Type__c});
			}
		}
		
		initData();
	}
	
	
	public void initData()
	{
		theLeaseLines = new Map<String, Quote_Line__c>();
		theLeaseLines.put('Module',new Quote_Line__c());
		theLeaseLines.put('Inverter',new Quote_Line__c());
		theLeaseLines.put('Inverter2',new Quote_Line__c());
		theLeaseLines.put('Inverter3',new Quote_Line__c());
		theLeaseLines.put('Inverter4',new Quote_Line__c());
		//will dynamically add monitoring and racking lines
	}
	
	public void consumeNode(TG_XmlNode theNode)
	{
		String CPRFieldName = theNode.getAttribute('Name');
		String theValue = theNode.getAttribute('Value');
		if(CPRfieldTosObjectField.get(CPRFieldName) != null)
		{	
			String sObjectFieldName = CPRfieldTosObjectField.get(CPRFieldName)[0];
			String theType = CPRfieldTosObjectField.get(CPRFieldName)[1];
			Quote_Line__c theQLL;
			
			if(moduleFields.contains(CPRFieldName))
			{
				theQLL = theLeaseLines.get('Module');
				theQLL = constructQuoteLine	( theQLL, CPRFieldName, sObjectFieldName, theValue, theType );
			}
			else if(inverterFields.contains(CPRFieldName))
			{
				theQLL = theLeaseLines.get('Inverter');
				theQLL = constructQuoteLine( theQLL, CPRFieldName, sObjectFieldName, theValue, theType );
			}
			else if(inverterFields2.contains(CPRFieldName))
			{
				theQLL = theLeaseLines.get('Inverter2');
				theQLL = constructQuoteLine( theQLL, CPRFieldName, sObjectFieldName, theValue, theType );
			}
			else if(inverterFields3.contains(CPRFieldName))
			{
				theQLL = theLeaseLines.get('Inverter3');
				theQLL = constructQuoteLine( theQLL, CPRFieldName, sObjectFieldName, theValue, theType );
			}
			else if(inverterFields4.contains(CPRFieldName))
			{
				theQLL = theLeaseLines.get('Inverter4');
				theQLL = constructQuoteLine( theQLL, CPRFieldName, sObjectFieldName, theValue, theType );
			}
			else if(rackingFields.contains(CPRFieldName))
			{
				handleTheCrappyFormat( theQLL, CPRFieldName, RACKING_NAME, sObjectFieldName, theValue, theType );
			}
			else if(monitoringFields.contains(CPRFieldName))
			{
				
				handleTheCrappyFormat( theQLL, CPRFieldName, MONITORING_NAME, sObjectFieldName, theValue, theType );
			}
			else
			{
				return; //we don't use this yet
			}
		}
	}
	
	public void handleTheCrappyFormat( Quote_Line__c theQLL, String CPRFieldName, String lineTypeName, String sObjectFieldName, String theValue, String theType )
	{
		try
		{
			//must handle multiple
			String splitChar;
			if ( CPRFieldName.contains( 'Model' ) )
			{
				splitChar = ',';
			}
			else
			{
				splitChar = ';';
			}
			
			List<String> theValues = theValue.split( splitChar );
			
			for ( Integer i=0; i < theValues.size(); i++ )
			{
				
				if ( !theLeaseLines.containsKey( lineTypeName + i ) )
				{
					theLeaseLines.put( lineTypeName + i, new Quote_Line__c() );
				}
				
				theQLL = theLeaseLines.get( lineTypeName + i );
				
				constructQuoteLine( theQLL, CPRFieldName, sObjectFieldName, theValueS[i], theType );
			}
		}
		catch ( Exception ex )
		{
			return;
			//fail silently as the data should be integrated anyways on a failure in this component
		}
	}
	
	public List<Quote_Line__c> getQuoteLines()
	{
		List<Quote_Line__c> quoteLines = new List<Quote_Line__c>();
		
		for ( Quote_Line__c theLine : theLeaseLines.values() )
		{
			Boolean isValid = ( theLine != null && theLine.Item__r != null && theLine.Item__r.Item_ID__c != null && theLine.Item__r.Item_ID__c != '' );
			if ( isValid )
			{
				quoteLines.add( theLine );
			}
		}
		
		return quoteLines;
	}
	
	private Quote_Line__c constructQuoteLine( Quote_Line__c theQLL, String CPRFieldName, String sObjectFieldName, String theValue, String theType )
	{
		if(theType == 'Number')
	 	{
	 		if(theValue == '' || theValue == null)
	 		{
	 			theQLL.put(sObjectFieldName , null);
	 		}
	 		else
	 		{
				theQLL.put(sObjectFieldName , Integer.valueOf(theValue));
	 		}
	 	}
	 	else if(theType == 'ExternalId')
	 	{
	 		Item__c theItem = new Item__c(Item_ID__c = theValue);
	 		System.debug('OHHH' + theItem);
	 		if ( theValue != null || theValue != '' )
	 		{
	 			theQLL.Item__r = theItem;//Qli needs to look up to item.Instanciate Item with external id and set the relationship with Qli
	 		}
	 	}
	 	else
	 	{
	 		theQLL.put(sObjectFieldName , theValue);
	 	}
	 	
	 	return theQLL;
	}
	
}