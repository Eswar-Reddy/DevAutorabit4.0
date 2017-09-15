public with sharing class LeaseCalculationsController 
{
	public LeasePayment__c leasePayment {get; private set;}
	
	public LeaseCalculationsController( ApexPages.StandardController stdc )
	{
		this.leasePayment = (LeasePayment__c) stdc.getRecord();
	}
	
	public PageReference runCalculations( )
	{
		//run the trigger to recreate lease schedule summary
		//first need to retreive lease payment
		PageReference summaryPageRef = null;
				
		Map<Id, LeasePayment__c> newMap = new Map<Id, LeasePayment__c>();
		newMap.put( leasePayment.Id, leasePayment );
		newMap.get( leasePayment.Id ).Create_Lease_Summary__c = true;
		
		Map<Id, LeasePayment__c> oldMap = newMap.deepClone();
		oldMap.get( leasePayment.Id ).Create_Lease_Summary__c = false;
		 
		try
		{ 
				//then run the lease payment through trigger logic
			LeasePaymentService.createLeaseScheduleSummary( newMap );
			
		}
		catch( Exception ex )
		{
			ApexPages.addMessages( ex );
			return summaryPageRef;
		}
		
			//retreive lease schedule summary id
		List<Lease_Schedule_Summary__c> scheduleSummary = [SELECT Id FROM Lease_Schedule_Summary__c WHERE Quote__c = :leasePayment.Quote__c];

		LeaseCalculator leaseCalculator;
		if ( scheduleSummary.size() == 1 )
		{
			try
			{
				//this ensures all the required fields are queried from the database
				leaseCalculator = new LeaseCalculator( new List<Id>{ scheduleSummary[0].Id } );
	    		
	    		leaseCalculator.recordCalculations();

				Lease_Schedule_Summary__c calculatedSummary = leaseCalculator.leaseCalcModels[0].leaseScheduleSummary;
				
				summaryPageRef = new PageReference( '/' + calculatedSummary.Id );

				summaryPageRef.setRedirect( true );
				
				return summaryPageRef;
			}
			catch( Exception ex )
			{
				ApexPages.addMessages( ex );
			}
		}
		else
		{   
			ApexPages.Message msg = new ApexPages.Message( ApexPages.Severity.ERROR, 'There is no quote associated to this lease payment.');
			ApexPages.addMessage( msg );
		} 
		
		return summaryPageRef;
	} 
}