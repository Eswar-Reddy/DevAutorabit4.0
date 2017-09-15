public with sharing class QuoteModel
{
	public Quote quote;
	public List<Quote_Line__c> quoteLeaseLines;
	public List<Lease_Schedule__c> leaseSchedules;
	//public Quote_Summary__c quoteSummary;
	//public Opportunity opportunity;
	
	
	
	public void saveQuote(Opportunity opp , Quote_Summary__c quoteSummary)
	{
		//update opportunity
		
		
		quote.OpportunityId = opp.id;
		quote.Quote_Summary__c = quoteSummary.Id;
		quote.Lessee__c = opp.Primary_Contact__c;
		quote.Scenario_Id__c = quote.Quote_ID__c + String.valueOf( quote.Scenario_Index__c );
		system.debug('llll'+quote);
		upsert quote Scenario_Id__c; //try catch is outside the function
		
		if(quote.Is_Locked__c)
		{
			quoteSummary.Locked_Scenario__c = quote.Id;
			update quoteSummary;
		}
		
		System.debug('HHHH' + leaseSchedules);
		for(Quote_Line__c qli : quoteLeaseLines)
		{
			qli.Quote__c = quote.Id;
		}
		for(Lease_Schedule__c leaseSchedule : leaseSchedules)
		{
			leaseSchedule.Quote__c = quote.Id;
		}
	}
	
}