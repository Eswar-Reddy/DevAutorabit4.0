public with sharing class RecordTypeController
{
	public String objectTypeString{get;set;}
	public Id selectedRecordTypeId{get;set;}

	public List<SelectOption> getRecordTypes()
	{
		Schema.SObjectType objType = null;

		if(objectTypeString == 'Account')
			objType=Account.SObjectType;
		else if(objectTypeString == 'Contact')
			objType=Contact.SObjectType;
		else if(objectTypeString == 'Opportunity')
			objType=Opportunity.SObjectType;
		else if(objectTypeString == 'Quote')
			objType=Quote.SObjectType;
		else if(objectTypeString == 'Document__c')
			objType=Document__c.SObjectType;
		else if(objectTypeString == 'Task')
			objType=Task.SObjectType;
		else if(objectTypeString == 'Event')
			objType=Event.SObjectType;
		else if(objectTypeString == 'echosign_dev1__SIGN_Agreement__c')
			objType=echosign_dev1__SIGN_Agreement__c.SObjectType;
		else if(objectTypeString == 'X1Y_Satisfaction_Survey_Result__c')
			objType=X1Y_Satisfaction_Survey_Result__c.SObjectType;
		else if(objectTypeString == 'Customer_Survey_Result__c')
			objType=Customer_Survey_Result__c.SObjectType;
		else if(objectTypeString == 'Post_Visit_Follow_Up_Survey__c')
			objType=Post_Visit_Follow_Up_Survey__c.SObjectType;
		else if(objectTypeString == 'Credit_Application__c')
			objType=Credit_Application__c.SObjectType;

		if(objType != null)
		{
			//Map<String, Id> types = getAvailableRecordTypeNamesForSObject(objType);
			List<RecordTypeInfo> infos = getAvailableRecordTypeNamesForSObject(objType);
			if(infos != null && infos.size() > 0)
			{
				List<SelectOption> options = new List<SelectOption>();
				// We want the default record type to be the first on in the list. Find it and add it.
				for(RecordTypeInfo info : infos)
				{
					if(info.isDefaultRecordTypeMapping())
					{
						options.add(new SelectOption(info.getRecordTypeId(), info.getName()));
						break;
					}
				}
				// Add the rest of them
				for(RecordTypeInfo info : infos)
				{
					if(!info.isDefaultRecordTypeMapping())
					{
						options.add(new SelectOption(info.getRecordTypeId(), info.getName()));
					}
				}

				return options;
			}
			else
				return new List<SelectOption>{new SelectOption('No Record Types Found','No Record Types Found')};
		}
		else
			return new List<SelectOption>{new SelectOption('No Record Types Found','No Record Types Found')};
	}

	public Map<String, String> getRecordTypeDescriptions()
	{
		Schema.SObjectType objType = null;

		if(objectTypeString == 'Account')
			objType=Account.SObjectType;
		else if(objectTypeString == 'Contact')
			objType=Contact.SObjectType;
		else if(objectTypeString == 'Opportunity')
			objType=Opportunity.SObjectType;
		else if(objectTypeString == 'Quote')
			objType=Quote.SObjectType;
		else if(objectTypeString == 'Document__c')
			objType=Document__c.SObjectType;
		else if(objectTypeString == 'Task')
			objType=Task.SObjectType;
		else if(objectTypeString == 'Event')
			objType=Event.SObjectType;
		else if(objectTypeString == 'echosign_dev1__SIGN_Agreement__c')
			objType=echosign_dev1__SIGN_Agreement__c.SObjectType;
		else if(objectTypeString == 'X1Y_Satisfaction_Survey_Result__c')
			objType=X1Y_Satisfaction_Survey_Result__c.SObjectType;
		else if(objectTypeString == 'Customer_Survey_Result__c')
			objType=Customer_Survey_Result__c.SObjectType;
		else if(objectTypeString == 'Post_Visit_Follow_Up_Survey__c')
			objType=Post_Visit_Follow_Up_Survey__c.SObjectType;
		else if(objectTypeString == 'Credit_Application__c')
			objType=Credit_Application__c.SObjectType;

		if(objType != null)
		{
			Map<String, String> types = getAvailableRecordTypeDescriptionsForSObject(objType);
			if(types != null && types.size() > 0)
			{
				return types;
			}
		}
		return null;
	}

	public static List<RecordTypeInfo> getAvailableRecordTypeNamesForSObject(Schema.SObjectType objType)
	{
	    List<RecordTypeInfo> retInfos= new List<RecordTypeInfo>();
	    List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
	    // If there are multiple RecordTypes...
	    if (infos.size() > 1)
	    {
	        for (RecordTypeInfo info : infos)
	        {
	            if (info.isAvailable() && !info.isMaster())
	            {
	                retInfos.add(info);
	            }
	        }
	    }
	    else
	    {
	    	// Otherwise there's just the Master record type,
	    	// so add it in, since it MUST always be available
	    	retInfos.add(infos[0]);
	    }

	    return retInfos;
	}

	// Returns a List of the Descriptions of all RecordTypes
	// available to the running user for a given SOBject type
	public static Map<String, String> getAvailableRecordTypeDescriptionsForSObject(Schema.SObjectType objType)
	{
	    Map<String, String> nameMap = new Map<String, String>();
	    List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();

	    List<Id> recIds = new List<Id>();
	    for(RecordTypeInfo info : infos)
	    	recIds.add(info.getRecordTypeId());

	    Map<Id, RecordType> recTypes = new Map<Id, RecordType>([select Id, Name, Description from RecordType where Id in: recIds]);
        for (RecordTypeInfo info : infos)
        {
            if (info.isAvailable())
            {
            	RecordType type = recTypes.get(info.getRecordTypeId());
            	if(type != null)
        			nameMap.put(info.getName(), (type.Description != null ? type.Description : ''));
            }
        }

	    return nameMap;
	}

	public PageReference submit()
	{
		PageReference result;
		if(objectTypeString == 'Account')
		{
			result = new PageReference('/apex/AccountNew?ent=Account&nooverride=1&RecordType='+selectedRecordTypeId);
		}
		else if(objectTypeString == 'Contact')
		{
			String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
			String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
			result = new PageReference('/apex/SPCommunityContactNew?objecttype=Contact&accid='+accId+'&RecordType='+selectedRecordTypeId+'&retURL='+returnURL);
		}
		else if(objectTypeString == 'Task')
		{
			String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
			String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
			String whatId = ApexPages.currentPage().getParameters().get('what_id') != null ? ApexPages.currentPage().getParameters().get('what_id') : '';
			result = new PageReference('/apex/SPCommunityTaskNew?objecttype=Task&retURL='+returnURL+'&what_id='+whatId+'&RecordType='+selectedRecordTypeId);
		}
		else if(objectTypeString == 'Event')
		{
			String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
			String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
			String whatId = ApexPages.currentPage().getParameters().get('what_id') != null ? ApexPages.currentPage().getParameters().get('what_id') : '';
			result = new PageReference('/apex/SPCommunityEventNew?objecttype=Event&retURL='+returnURL+'&what_id='+whatId+'&RecordType='+selectedRecordTypeId);
		}
		else if(objectTypeString == 'echosign_dev1__SIGN_Agreement__c')
		{
			String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
			String oppId = ApexPages.currentPage().getParameters().get('oppid') != null ? ApexPages.currentPage().getParameters().get('oppid') : '';
			result = new PageReference('/apex/AgreementNew?ent=echosign_dev1__SIGN_Agreement__c&nooverride=1&RecordType='+selectedRecordTypeId+'&accid='+accId+'&oppid='+oppId);
		}
		else if(objectTypeString == 'X1Y_Satisfaction_Survey_Result__c') {
			result = new PageReference('/apex/SPCommunitySatSurveyNew?objecttype=X1Y_Satisfaction_Survey_Result__c&RecordType='+selectedRecordTypeId+'&'+buildURLParamString());
		}
		else if(objectTypeString == 'Customer_Survey_Result__c') {
			result = new PageReference('/apex/SPCommunityCusSurveyNew?objecttype=Customer_Survey_Result__c&RecordType='+selectedRecordTypeId+'&'+buildURLParamString());
		}
		else if(objectTypeString == 'Post_Visit_Follow_Up_Survey__c') {
			result = new PageReference('/apex/SPCommunityPVFUSurveyNew?objecttype=Post_Visit_Follow_Up_Survey__c&RecordType='+selectedRecordTypeId+'&'+buildURLParamString());
		}
		else if(objectTypeString == 'Credit_Application__c') {
			String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
			result = new PageReference('/apex/SPCommunityCreditApplicationNew?objecttype=Credit_Application__c&RecordType='+selectedRecordTypeId+'&retURL='+returnURL);
		}

		result.getParameters().putAll(ApexPages.currentPage().getParameters());

		return result;
	}

	public PageReference cancel()
	{
		PageReference result;
		String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
		if(returnURL != '')
		{
			result = new PageReference(EncodingUtil.urlDecode(returnURL, 'UTF-8'));
		}
		else
		{
			result = new PageReference('/apex/SPCommunityAccounts');
		}

		return result;
	}

	private static String buildURLParamString() {
		String result = '';
        for(String s : ApexPages.currentPage().getParameters().keySet()) {
            result += s + '=' + ApexPages.currentPage().getParameters().get(s) + '&';
        }
        result.removeEnd('&');
        return result;
	}
}