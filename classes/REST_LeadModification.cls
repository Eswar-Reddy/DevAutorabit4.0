/*

Service for updating and create "leads" from external systems

Class:              REST_LeadData
Date:               06/12/2014
Version:            1
Last Updated:       2/11/2015
    * 	Stubbed
    *	Completed
Updates: 
Modified By : Crystal, RedPoint
			Modified On : 2/11/2015
			Summary : added optional Annual Income amount and sales tax rate for accounts as needed for quote api service

			Crystal, RedPoint
			Modified On : 3/3/2015
			Summary : reworked incoming payloads to run through JSON parser, 
					  added logic across all Lead Api classes to create Spectrum Debug logs to store calls/responses
////////////////////////////////////////////////////////////////////////////////
*/

@RestResource(urlMapping='/LeadModification/v0/*')
global with sharing class REST_LeadModification
{
	// -------- Constants --------
    public static String jsonPayload {get;set;}
    
	// -------- Constructor --------
    // None
    
    // -------- Variables --------
    // Handler for all response
	private static REST_LeadDataHandler processResults = new REST_LeadDataHandler();
    
    // -------- Properties --------
	// None
	
	// -------- Methods --------
	@HttpPost
	global static REST_LeadDataResults createUpdateLead()
	{
		Diagnostics.push('createUpdateLead');
        String companyID;
        List<LeadRecord> records = new List<LeadRecord>();

        
        RestRequest req = RestContext.request;
        jsonPayload = req.requestBody.toString();
        
        JSONParser parser = JSON.createParser(jsonPayload);
        while(parser.nextToken() != null) {
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && parser.getText() == 'companyID') {
                parser.nextToken();
                companyId = parser.getText();                
                
            } else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && parser.getText() == 'records') {
                if(parser.nextValue() == JSONToken.START_ARRAY) {
                    while(parser.nextToken() != null) {
                        if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
							LeadRecord r = (LeadRecord)parser.readValueAs(LeadRecord.class);
                            records.add(r);
                        }
                    }
                }
            }
        }
        
        
		REST_LeadDataResults result;
		
		if(processResults.confirmAccessID(companyID))
		{
			result = processResults.upsertLeadRecordData(companyID, records);
		}
		else
		{
			result = processResults.throwError(REST_LeadDataHandler.ErrorResponseType.ECUCOMPANYID);
		}
		
		Diagnostics.pop();
		return result;	
	}
	
	// -------- Internal Classes --------
	// Incoming records
	@TestVisible
	global class LeadRecord
	{
		// APIID__c on Opp for Updates
		public String recordID {get; set;}
		
		// Primarly contact record info, first and last name is applied to account
		public String firstName {get; set;}
		public String lastName {get; set;}
		public String phone {get; set;}
		public String email {get; set;}
		
		// Primarly account record info, billing address is applied to contact
		public String billingAddress {get; set;}
		public String billingCity {get; set;}
		public String billingState {get; set;}
		public String billingZipCode {get; set;}
		public String billingCountry {get; set;}
		public String shippingAddress {get; set;}
		public String shippingCity {get; set;}
		public String shippingState {get; set;}
		public String shippingZipCode {get; set;}
		public String shippingCountry {get; set;}
        	//added sales tax and annual income optional fields for quote REST service
        public Decimal salesTaxRate {get; set;}
        public Decimal annualIncome {get; set;}
		
		// Opportunity record info
		public Date closeDate {get; set;}
		public String opportunityName {get; set;}
		public String creditCheckStatus {get; set;}
		public String averageMonthlyElectricBill {get; set;}
		public String shading {get; set;}
		public Decimal amount {get; set;}
		public String stageName {get; set;}
		public String reasonWonLost {get; set;}
		public Date installationCompletedDate {get; set;}
		public String referredByFirstName {get; set;}
		public String referredByLastName {get; set;}
		public String referralProgramStatus {get; set;}
		public String description {get; set;}
		public String bestTimeToCall {get; set;}
	}
    
    
}