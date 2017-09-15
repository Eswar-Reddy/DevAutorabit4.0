public with sharing class LeaseScheduleBuilder implements NodeConsumer
{
	public Map<String , List<TG_XmlNode>> rowNameToAllRows;
	public Map<String,List<String>> CPRfieldTosObjectField ;
	
	public LeaseScheduleBuilder(List<CPRFieldMapping__c> allMappings)
	{
		CPRfieldTosObjectField = new Map<String,List<String>>();
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Lease_Schedule__c')
			{
				CPRfieldTosObjectField.put(theMapping.CPR_FieldName__c , new List<String>{theMapping.sObjectField__c , theMapping.Type__c});
			}
		}
		
		initData();
	}
	
	public void initData()
	{
		rowNameToAllRows = new Map<String, List<TG_XmlNode>>();
	}
	
	public void consumeNode(TG_XmlNode theNode)
	{
	   
	    String CPRFieldName = theNode.getAttribute('Name');
   		Integer lastIndex = CPRFieldName.lastIndexOf(':');
		Integer firstIndex = CPRFieldName.indexOf('Row');
		String rowNum = CPRFieldName.subString(firstIndex , lastIndex).trim(); //Row0, Row1 , Row2
		
		if(!rowNameToAllRows.containsKey(rowNum))
		{
			rowNameToAllRows.put(rowNum , new List<TG_XmlNode>());
		}
		rowNameToAllRows.get(rowNum).add(theNode);
	}
	
	public Map<String, Lease_Schedule__c> constructLeaseSchedules()
	{
		Map<String , Lease_Schedule__c> leaseScheduleToCreate = new Map<String, Lease_Schedule__c>();
		
		for(String rowNum : rowNameToAllRows.keySet())
		{
			List<TG_XmlNode> allNodes = rowNameToAllRows.get(rowNum);
			Lease_Schedule__c lSchedule = new Lease_Schedule__c();
			for(TG_XmlNode theNode : allNodes)
			{
				
				String theName = theNode.getAttribute('Name').trim();
				String theValue = theNode.getAttribute('Value').trim();
				String theUniqueName = getUniqueName(theName);
				
				if(CPRfieldTosObjectField.containsKey(theUniqueName))
				{
					if(CPRfieldTosObjectField.get(theUniqueName)[1] == 'Decimal')
					{
						
						if(theValue == '' || theValue == null)
				 		{
				 			lSchedule.put(CPRfieldTosObjectField.get(theUniqueName)[0] , null);
				 		}
				 		else
				 		{
				 			String replaced = theValue.replace('$',''); //some of these things may contain dollar signs
							lSchedule.put(CPRfieldTosObjectField.get(theUniqueName)[0] , Decimal.valueOf(replaced));
				 		}
					}
					else if(CPRfieldTosObjectField.get(theUniqueName)[1] == 'Number')
					{
						lSchedule.put(CPRfieldTosObjectField.get(theUniqueName)[0] , Integer.valueOf(theValue));
					}
					else
						lSchedule.put(CPRfieldTosObjectField.get(theUniqueName)[0] , theValue);
				}
			}
			
			leaseScheduleToCreate.put(rowNum , lSchedule);
		}
		return leaseScheduleToCreate;
	}
	
	public static String getUniqueName(String theName)
	{
		List<String> splittedName = theName.split(':'); //System Production: Row0: Approximate Price per kWh
		String theUniqueName =  splittedName[0].trim()+'-'+splittedName[2].trim();
		
		return theUniqueName;		
	}
	
	public static Boolean isLeaseScheduleField(String fieldName)
	{
		String regexMatch = '^.+: Row\\d+:.+$';
        return Pattern.matches(regexMatch , fieldName);
	}
}