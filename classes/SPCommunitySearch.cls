public with sharing class SPCommunitySearch
{
	public String searchTerm{get;set;}
	public Map<String, String> tabNames{get;set;}
	public Map<String, List<SearchResultsWrapper>> resultsWrapper{get;set;}
	public Map<String, List<String>> fieldsMap{get;set;}

	private List<Community_Search_Object__c> searchObjs{get;set;}
	private List<Community_Search_Field__c> searchFields{get;set;}

	public SPCommunitySearch()
	{
		searchTerm = ApexPages.currentPage().getParameters().get('searchString');
		if(searchTerm != null)
		{
			searchObjs = [select Id, Name from Community_Search_Object__c];
			searchFields = [select Id, Name, Search_Object__r.Id, Search_Object__r.Name, Search_Order__c from Community_Search_Field__c];
			fieldsMap = new Map<String, List<String>>();

			if(searchObjs != null && searchObjs.size() > 0)
			{
				for(Community_Search_Object__c obj : searchObjs)
				{
					List<String> fieldStrings = new List<String>();
					fieldStrings.add('Id');

					if(obj.Name != 'Task')
						fieldStrings.add('Name');

					for(Community_Search_Field__c field : searchFields)
					{
						if(field.Name == 'Id' || field.Name == 'Name') // these are always to the query, so don't add them if the user did
				    		continue;

						if(field.Search_Object__r.Id == obj.Id)
						{
							fieldStrings.add(field.Name);
						}
					}
					fieldsMap.put(obj.Name, fieldStrings);
				}
			}
			else
			{
				searchTerm = null;
			}
		}
	}

	public void search()
	{
		if(searchTerm == null || searchTerm.length() <= 3)
		{
			resultsWrapper = null;
			return;
		}

		String queryStr = 'FIND \''+searchTerm+'*\' IN ALL FIELDS RETURNING ';
		Integer objIndex = 0;
		for(String objName : fieldsMap.keySet())
		{
			if(objName == 'Task')
				queryStr = queryStr + objName +'(Id,';
			else
				queryStr = queryStr + objName +'(Id,Name,';

			Integer index = 0;
			List<String> fields = fieldsMap.get(objName);
			for(String field : fields)
			{
				if(field == 'Id' || field == 'Name') // these added above, so don't add them again
				{
					index++;
				    continue;
				}

				queryStr = queryStr + field;
				if(index < fields.size()-1)
					queryStr = queryStr + ',';

				index++;
			}
			queryStr = queryStr + ')';
			if(objIndex < fieldsMap.keySet().size()-1)
				queryStr = queryStr + ',';

			objIndex++;
		}

		try
		{
			List<List<SObject>> results = search.query(queryStr);
			resultsWrapper = new Map<String, List<SearchResultsWrapper>>();
			tabNames = new Map<String, String>();

			objIndex = 0;
			for(String objTypeName : fieldsMap.keySet()) // this works because SOSL results are in the order they're submitted
			{
				List<SearchResultsWrapper> wraps = new List<SearchResultsWrapper>();
				List<SObject> objList = results.get(objIndex);
				if(objList != null && objList.size() > 0)
				{
					for(SObject obj : objList)
					{
						SearchResultsWrapper wrapper = new SearchResultsWrapper(objTypeName, obj);
						for(String field : fieldsMap.get(objTypeName))
						{
							if(field == 'Id' || field =='Name' || field=='Subject')
								continue; // done automatically

							wrapper.addValue(field, obj.get(field), getSearchField(objTypeName, field));
						}
						wrapper.sortColumns();
						wraps.add(wrapper);
					}
					resultsWrapper.put(objTypeName,wraps); // all of the wrappers for the object type
					tabNames.put(objTypeName, convertObjectLabel(objTypeName));
				}
				objIndex++;
			}

			if(resultsWrapper.size() <=0 )
				resultsWrapper = null;
		}
		catch(Exception e)
		{
			resultsWrapper = null;
		}
	}

	public Community_Search_Field__c getSearchField(String objectType, String fieldName)
	{
		for(Community_Search_Field__c searchField : searchFields)
		{
			if(searchField.Search_Object__r.Name == objectType && searchField.Name == fieldName)
				return searchField;
		}

		return null;
	}

	public String convertObjectLabel(String inLabel)
	{
		String objectLabel = inLabel;
		objectLabel = objectLabel.replaceAll('__c', '');
		objectLabel = objectLabel.replaceAll('_', ' ');

		return objectLabel;
	}

	public class SearchResultsWrapper
	{
		public String objectType{get;set;}
		public Map<String, Object> dataFieldMap{get;set;}
		public List<String> fieldNames{get;set;}
		public List<String> fieldValues{get;set;}
		public List<Community_Search_Field__c> searchFields{get;set;}
		public String objectId{get;set;}
		public String objectName{get;set;}

		public SearchResultsWrapper(String type, SObject obj)
		{
			objectType = type;

			dataFieldMap = new Map<String, Object>();
			objectId = (String)obj.get('Id');

			if(objectType == 'Task')
				objectName = (String)obj.get('Subject');
			else
				objectName = (String)obj.get('Name');

			fieldNames = new List<String>();
			fieldValues = new List<String>();
			searchFields = new List<Community_Search_Field__c>();
		}

		public void addValue(String fieldName, Object value, Community_Search_Field__c searchField)
		{
			fieldNames.add(fieldName);
			searchFields.add(searchField);
			if(value == null)
				fieldValues.add('');
			else
				fieldValues.add(String.valueOf(value));
		}

		public void sortColumns()
		{
			List<String> columnNames = new List<String>();
			List<String> columnFieldValues = new List<String>();

			String nextField = null;
			for(Integer i=0;i<fieldNames.size();i++)
			{
				if(i == 0)
					nextField = getNextField(null);
				else
					nextField = getNextField(nextField);

				Integer index = -9;
				for(Integer j=0;j<fieldNames.size();j++)
				{
					if(fieldNames.get(j) == nextField)
					{
					    index = j;
					    break;
					}
				}

				String value = fieldValues.get(index);

				columnNames.add(nextField);
				columnFieldValues.add(value);
			}

			fieldNames = columnNames;
			fieldValues = columnFieldValues;
		}

		public String getNextField(String lastField)
		{
			if(lastField == null)
			{
				Integer lowest = 999;
				for(Community_Search_Field__c searchField : searchFields)
				{
					lowest = Math.min(lowest, (Integer)searchField.Search_Order__c);
				}
				return getSearchFieldForOrder(lowest).Name;
			}
			else
			{
				Community_Search_Field__c lastSearchField = null;
				for(Community_Search_Field__c searchField : searchFields)
				{
					if(searchField.Name == lastField)
					{
						lastSearchField = searchField;
						break;
					}
				}


				Integer lowest = 999;
				for(Community_Search_Field__c searchField : searchFields)
				{
					if(searchField.Name != lastSearchField.Name && searchField.Search_Order__c > lastSearchField.Search_Order__c)
						lowest = Math.min(lowest, (Integer)searchField.Search_Order__c);
				}

				return getSearchFieldForOrder(lowest).Name;
			}
		}

		public Community_Search_Field__c getSearchFieldForOrder(Integer order)
		{
			for(Community_Search_Field__c searchField : searchFields)
			{
				if((Integer)searchField.Search_Order__c == order)
				{
					return searchField;
				}
			}

			return null;
		}
	}
}