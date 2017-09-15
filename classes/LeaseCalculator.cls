public with sharing class LeaseCalculator 
{
	public List<LeaseCalcModel> leaseCalcModels {get; private set;}
	
	public LeaseCalculator( List<Lease_Schedule_Summary__c> leaseScheduleSummaries )
	{
		this.leaseCalcModels = LeaseCalcModel.retrieveLeaseCalcModels( leaseScheduleSummaries );
	}
	
	public LeaseCalculator( List<Id> leaseScheduleSummarIds )
	{
		this.leaseCalcModels = LeaseCalcModel.retrieveLeaseCalcModels( leaseScheduleSummarIds );
	}
	
	public void recordCalculations()
	{
		List<Lease_Schedule_Summary__c> leaseScheduleSummaries = new List<Lease_Schedule_Summary__c>();
		
		for ( LeaseCalcModel calcModel : leaseCalcModels )
		{
			try
			{
				calcModel.runCalculations();
				
				calcModel.leaseScheduleSummary.Date_Of_Last_Calculations_Attempt__c = Date.today();
				
				leaseScheduleSummaries.add( calcModel.leaseScheduleSummary );
			}
			catch ( Exception ex )
			{
				//write error message to record
				String exceptionString = ex.getMessage();
				exceptionString += '  \n  Line Number: ' + ex.getLineNumber();
				exceptionString += '  \n  ' + ex.getStackTraceString();
				
				Lease_Schedule_Summary__c leaseScheduleSummary = new Lease_Schedule_Summary__c( Id = calcModel.leaseScheduleSummary.Id );
				
				leaseScheduleSummary.Error_Message__c = exceptionString;
				
				leaseScheduleSummary.Date_Of_Last_Calculations_Attempt__c = Date.today();
				
				//should happen as the field is 32k chars long, but just in case
				Database.DMLOptions dml = new Database.DMLOptions();
				dml.allowFieldTruncation = true;
				leaseScheduleSummary.setOptions( dml );
				
				//need to add this to the update list, so the error is recorded.
				leaseScheduleSummaries.add( leaseScheduleSummary );
			}
		}
		
		update leaseScheduleSummaries;
	}
}