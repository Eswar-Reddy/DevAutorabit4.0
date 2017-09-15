@RestResource(urlMapping='/CPRWebService/*')
global with sharing class CPRWebService {

	public static final String PARSE_FAILURE = 'There was a failure parsing the request xml.';
	public static final String OPPORTUNITY_ERROR = 'There was a failure updating the opportunity, ensure an opportunity is linked to this quote.';

	@HttpPost
	global static String recieveCPRXML(RestRequest req, RestResponse res)
	{
		ScenarioParser scenarioParser;
		try
		{
			String requestBody = req.requestBody.toString();
			System.debug('DAMN' + requestBody);
			
			//have to scrub the xml of special characters which break the TG_XmlDom constructor
			requestBody = TG_XmlUtils.scrubIncomingXml( requestBody );
			System.debug( 'DAMN2' + requestBody );
			
			String responseMessage = '';
			TG_XmlDom dom = new TG_XmlDom( requestBody );
			
		    TG_XmlNode root = dom.root;
		    String rootname = root.nodeName;
			System.debug(requestBody);
			
			//create the instance of Scenario parser
			scenarioParser = new ScenarioParser();
			//call the init method of that instance and construct the map of fields to builder
			
			List<TG_XmlNode> scenarios = root.getElementsByTagName('Scenario');
			List<QuoteModel> quoteModels = new List<QuoteModel>();
			
			for(TG_XmlNode theScenario : scenarios)
			{
				//pass each of the scenario to a method
				scenarioParser.parseScenario(theScenario);
				scenarioParser.constructQuoteModel();			
			}
		}
		catch ( Exception ex )
		{
			String messageStr = PARSE_FAILURE + '  ' + ex.getMessage();
			
			throw new QuoteIntegrationException( messageStr );
		}
		
		Savepoint sp = Database.setSavepoint();
		
		Opportunity opp;
		List<Lease_Schedule__c> allLeaseSchedules = new List<Lease_Schedule__c>();
		List<Quote_Line__c> allQuoteLeaseLines = new List<Quote_Line__c>();
		List<Quote> existingQuotes = new List<Quote>();
		try
		{
			opp = scenarioParser.updateOpportunity();
		}
		catch ( Exception ex )
		{
			Database.rollback(sp);
			
			String messageStr = OPPORTUNITY_ERROR + '  ' + ex.getMessage();
			
			throw new QuoteIntegrationException( messageStr );
		}
		
		try
		{
			//because we used the external id to set the contact we need to query back for the rest
			opp = [SELECT Id , Primary_Contact__c, AccountId, OwnerId FROM Opportunity WHERE Id =: opp.Id];
			Quote_Summary__c quoteSummary = scenarioParser.createQuoteSummary(opp);
			
			for(QuoteModel qModel : scenarioParser.quoteModels)
			{
				qModel.saveQuote(opp , quoteSummary);
				allQuoteLeaseLines.addAll(qModel.quoteLeaseLines);
				allLeaseSchedules.addAll(qModel.leaseSchedules);
				existingQuotes.add( qModel.quote );
			}
			
			clearExistingSchedulesLines( existingQuotes );
			
			System.debug('Lease Schedule' + allLeaseSchedules);
			insert allLeaseSchedules;
			
			System.debug('Lease lines' + allQuoteLeaseLines);
			insert allQuoteLeaseLines;
			
		}
		catch(DMLException dmlEx)
		{
			//rollback here
			Database.rollback(sp);
			
			throw new QuoteIntegrationException( 'ERROR '+ dmlEx.getMessage()+'\n'+dmlEx.getLineNumber()+'\n'+dmlEx.getStackTraceString() );
		}
		
		return 'Success';
	}
	
	public static void clearExistingSchedulesLines( List< Quote > existingQuotes )
	{
		//query related
		List<Quote_Line__c> oldQuoteLines = [SELECT Id FROM Quote_Line__c WHERE Quote__c IN :existingQuotes];
		
		List<Lease_Schedule__c> oldLeaseSchedules = [SELECT Id FROM Lease_Schedule__c WHERE Quote__c IN :existingQuotes];
		
		if ( !oldQuoteLines.isEmpty() )
		{
			delete oldQuoteLines;
		}
		
		if ( !oldLeaseSchedules.isEmpty() )
		{
			delete oldLeaseSchedules;
		}
	}
	
	global class QuoteIntegrationException extends Exception {}
}