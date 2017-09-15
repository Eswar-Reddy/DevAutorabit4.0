public with sharing class ScenarioParser
{
	private Map<String,Map<String,NodeConsumer>> CPRFieldNameToBuilders = new Map<String,Map<String,NodeConsumer>>();
	private QuoteSummaryBuilder  quoteSummaryBuilder;
	private LeaseScheduleBuilder leaseBuilder;
	private QuoteBuilder quoteBuilder;
	private QuoteLeaseLinesBuilder quoteLeaseLineBuilder;
	private OpportunityBuilder opportunityBuilder;
	public List<QuoteModel> quoteModels;
	
	
	public ScenarioParser()
	{
		List<CPRFieldMapping__c> allMappings = CPRFieldMapping__c.getAll().values();
		quoteModels = new List<QuoteModel>();
		
		quoteSummaryBuilder = new QuoteSummaryBuilder(allMappings);
		leaseBuilder = new LeaseScheduleBuilder(allMappings);
		quoteBuilder = new QuoteBuilder(allMappings);
		quoteLeaseLineBuilder = new QuoteLeaseLinesBuilder(allMappings);
		opportunityBuilder = new OpportunityBuilder(allMappings);
		
		for(CPRFieldMapping__c theMapping : allMappings)
		{
			if(theMapping.sObjectName__c == 'Lease_Schedule__c')
			{
				if(CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c) == null)
				{
					CPRFieldNameToBuilders.put(theMapping.CPR_FieldName__c, new Map<String,NodeConsumer>());
				}
				
				if(!CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).containsKey(theMapping.sObjectName__c ))
				{
					CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).put(theMapping.sObjectName__c,leaseBuilder);
				}
			}
			else if(theMapping.sObjectName__c == 'Quote_Summary__c')
			{
				if(CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c) == null)
				{
					CPRFieldNameToBuilders.put(theMapping.CPR_FieldName__c, new Map<String,NodeConsumer>());
				}
				
				if(!CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).containsKey(theMapping.sObjectName__c ))
				{
					CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).put(theMapping.sObjectName__c,quoteSummaryBuilder);
				}
			}
			else if(theMapping.sObjectName__c == 'Quote')
			{
				if(CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c) == null)
				{
					CPRFieldNameToBuilders.put(theMapping.CPR_FieldName__c, new Map<String,NodeConsumer>());
				}
				
				if(!CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).containsKey(theMapping.sObjectName__c ))
				{
					CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).put(theMapping.sObjectName__c,QuoteBuilder);
				}
			}
			else if(theMapping.sObjectName__c == 'Opportunity')
			{
				if(CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c) == null)
				{
					CPRFieldNameToBuilders.put(theMapping.CPR_FieldName__c, new Map<String,NodeConsumer>());
				}
				
				if(!CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).containsKey(theMapping.sObjectName__c ))
				{
					CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).put(theMapping.sObjectName__c,OpportunityBuilder);
				}
			}
			else if(theMapping.sObjectName__c == 'Quote_Line__c')
			{
				if(CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c) == null)
				{
					CPRFieldNameToBuilders.put(theMapping.CPR_FieldName__c, new Map<String,NodeConsumer>());
				}
				
				if(!CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).containsKey(theMapping.sObjectName__c ))
				{
					CPRFieldNameToBuilders.get(theMapping.CPR_FieldName__c).put(theMapping.sObjectName__c,quoteLeaseLineBuilder);
				}
			}
		}
							
	}
	
	public void parseScenario(TG_XmlNode scenario)
	{
		leaseBuilder.initData();
		quoteLeaseLineBuilder.initData();
		leaseBuilder.initData();
		quoteSummaryBuilder.initData();
		opportunityBuilder.initData();
		quoteBuilder.initData();
		
		List<TG_XmlNode> listOfNameValuePairs = scenario.getElementsByTagName('NameValuePair');
		for(TG_XmlNode nameValue : listOfNameValuePairs)
		{
			String nodeName = nameValue.getAttribute('Name');
			
			for(NodeConsumer builder : getBuildersForNode(nodeName))
			{
				builder.consumeNode(nameValue);
			}
		}		
	}
	
	private List<NodeConsumer> getBuildersForNode(String nodeName)
	{
		List<NodeConsumer> builders = new List<NodeConsumer>();
		if(LeaseScheduleBuilder.isLeaseScheduleField(nodeName))
		{
			builders.add(leaseBuilder);	
		}
		
		Map<String , NodeConsumer> fieldNameToNodeConsumer = CPRFieldNameToBuilders.get(nodeName);
		if(fieldNameToNodeConsumer != null)
			builders.addAll(CPRFieldNameToBuilders.get(nodeName).values());
		return builders;
	}
	
	public Opportunity updateOpportunity()
	{
		Opportunity opp = opportunityBuilder.constructOpportunity();
		System.debug('OPPA' + opp);
		update opp;
		return opp;
		
	}
	
	public Quote_Summary__c createQuoteSummary(Opportunity theOpportunity)
	{
		system.debug('clovis'+theOpportunity);
		Quote_Summary__c quoteSummary = QuoteSummaryBuilder.quoteSummary;
		quoteSummary.Opportunity__c = theOpportunity.Id;
		quoteSummary.Account_Name__c = theOpportunity.AccountId;
		quoteSummary.Lessee__c = theOpportunity.Primary_Contact__c;
		quoteSummary.Dealer_Installer__c = theOpportunity.OwnerId;
		System.debug( quoteSummary );
		upsert quoteSummary CPR_QuoteID__c;
		
		return quoteSummary;
		
	}
	
	
	public void constructQuoteModel()
	{
		QuoteModel qModel = new QuoteModel();
		
		qModel.quote = quoteBuilder.quoteToBuild;
		System.debug('DAMN Quote :' +quoteBuilder.quoteToBuild );
		qModel.quoteLeaseLines = quoteLeaseLineBuilder.getQuoteLines();
		qModel.leaseSchedules = leaseBuilder.constructLeaseSchedules().values();
		
		quoteModels.add(qModel);		
	}
	
	
}