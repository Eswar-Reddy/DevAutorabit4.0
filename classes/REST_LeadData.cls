/*

Service for retrieving various pieces of information for third part systems

Class:              REST_LeadData
Date:               06/03/2014
Version:            1
Last Updated:       06/30/2014
    * 	Stubbed
    *	Completed

////////////////////////////////////////////////////////////////////////////////
*/

@RestResource(urlMapping='/LeadData/v0/*')
global with sharing class REST_LeadData
{
	// -------- Constants --------
	// Acceptable service calls
	private static final String PING = 'ping';
	private static final String FOR_COMPANY = 'companyID';
	private static final String DAYS_BACK = 'withinDays';
	private static final String HOURS_BACK = 'withinHours';
	private static final String ID = 'ids';
	
	// Acceptable known parameters
	private static final String PING_TRUE = 'true';
	
	// -------- Constructor --------
    // None
    
    // -------- Variables --------
	// Handler for all response
	private static REST_LeadDataHandler processResults = new REST_LeadDataHandler();
    public static String getJSONPayload {get;set;}
    
	// -------- Properties --------
	// None
	
	// -------- Methods --------
	// Service for all incoming requests, including an error response when none of the parameters passed are expected
	@HttpGet
	global static REST_LeadDataResults getLeadData()
	{
		Diagnostics.push('getLeadData request');
		
		REST_LeadDataResults result;
		
		String pingRequest = RestContext.request.params.get(PING);
		String companyID = RestContext.request.params.get(FOR_COMPANY);
		String withinDays = RestContext.request.params.get(DAYS_BACK);
		String withinHours = RestContext.request.params.get(HOURS_BACK);
		String ids = RestContext.request.params.get(ID);
        getJSONPayload = String.valueOf(RestContext.request.params);
        
        
		Diagnostics.debug('pingRequest: ' + pingRequest);
		Diagnostics.debug('companyID: ' + companyID);
		Diagnostics.debug('withinDays: ' + withinDays);
		Diagnostics.debug('withinHours: ' + withinHours);
		Diagnostics.debug('ids: ' + ids);
		
		if(pingRequest != null)
		{
			if(pingRequest.toLowerCase() == PING_TRUE)
			{
				result = processResults.getLeadData(true);
			}
			else
			{
				result = processResults.throwError(REST_LeadDataHandler.ErrorResponseType.EPING);
			}
		}
		else if(companyID != null)
		{
			if(processResults.confirmAccessID(companyID))
			{
				if(withinDays != null)
				{
					Integer validDayCount;
					
					try
					{
						validDayCount = Integer.valueOf(withinDays);
						validDayCount = (validDayCount > 30) ? 30 : validDayCount;
						
						result = processResults.getLeadData(companyID, validDayCount, true);
					}
					catch(TypeException error)
					{
						Diagnostics.exception(error);
						result = processResults.getLeadData(companyID);
					}
				}
				else if(withinHours != null)
				{
					Integer validHourCount;
					
					try
					{
						validHourCount = Integer.valueOf(withinHours);
						validHourCount = (validHourCount > 23) ? 23 : validHourCount;
						
						result = processResults.getLeadData(companyID, validHourCount, false);
					}
					catch(TypeException error)
					{
						Diagnostics.exception(error);
						result = processResults.getLeadData(companyID);
					}
					
				}
				else if(ids != null)
				{
					Set<String> parsedIDs = new Set<String>();
					
					try
					{
						parsedIDs = (Set<String>)JSON.deserialize(ids, Set<String>.class);
						system.debug('Parsed ids: ' + parsedIDs);
					}
					catch(JSONException error)
					{
						Diagnostics.exception(error);
						result = processResults.throwError(REST_LeadDataHandler.ErrorResponseType.EIDSMALFORMED);
                        try {
                            List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
                            SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                            log.jsonPayload = REST_LeadData.getJSONPayload;
                            log.Service = 'Lead (Get Leads)';
                            log.Response = JSON.serializePretty(result);
                            logs.add(log);
                            SpectrumDebugUtility.generateDebugLog(logs);
                        } catch(Exception e) {}
					}
					
					if(!parsedIDs.isEmpty())
					{
						result = processResults.getLeadData(companyID, parsedIDs);
					}
				}
				else
				{
					result = processResults.getLeadData(companyID);
				}
			}
			else
			{
				result = processResults.throwError(REST_LeadDataHandler.ErrorResponseType.ECOMPANYID);
                try {
                    List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
                    SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                    log.jsonPayload = REST_LeadData.getJSONPayload;
                    log.Service = 'Lead (Get Leads)';
                    log.Response = JSON.serializePretty(result);
                    logs.add(log);
                    SpectrumDebugUtility.generateDebugLog(logs);
                } catch(Exception e) {}
			}
		}
		else
		{
			result = processResults.throwError(REST_LeadDataHandler.ErrorResponseType.EPARAMETERS);
            try {
                List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
                SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                log.jsonPayload = REST_LeadData.getJSONPayload;
                log.Service = 'Lead (Get Leads)';
                log.Response = JSON.serializePretty(result);
                logs.add(log);
                SpectrumDebugUtility.generateDebugLog(logs);
            } catch(Exception e) {}
		}
		
		Diagnostics.pop();
		return result;
	}
	
	// -------- Internal Classes --------
	// None
}