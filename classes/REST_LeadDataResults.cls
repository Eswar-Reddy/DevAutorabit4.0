/*

Parent response for all lead data children within the REST_LeadDataHandler

Class:              REST_LeadDataResults
Date:               06/03/2014
Version:            1
Last Updated:       06/03/2014
    * 	Stubbed / Completed

////////////////////////////////////////////////////////////////////////////////
*/

global abstract with sharing class REST_LeadDataResults
{	
	// -------- Constants --------
	// None
		
	// -------- Constructor --------
    public REST_LeadDataResults(Boolean successResult)
    {
    	success = successResult;
    }
    
    // -------- Variables --------
	// None
	
	// -------- Properties --------
	// Get success value for reference
	public Boolean success {get; private set;}
	
	// -------- Methods --------
	// None
	
	// -------- Internal Classes --------
	// None
}