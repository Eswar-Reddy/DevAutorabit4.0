/*

Base handler class for framework triggers, which all handler classes extend

Class:              TriggerHandlerBase
Date:               05/12/2014
Version:            1
Last Updated:       05/12/2014
    * 	Completed
    
////////////////////////////////////////////////////////////////////////////////
*/

global abstract class TriggerHandlerBase implements ITriggerHandler
{	
	// -------- Constants --------
	// None
	
	// -------- Constructor --------
    // None

    // -------- Variables --------
	// Record if running
	private Boolean initiaited = false;
	
	// -------- Properties --------
	// None
	
	// -------- Methods --------
	// Return if the handler is running
	global Boolean isRunning()
	{
		return initiaited;
	}
	
	// Set the running to true, called from the dispatcher
	global void startRunning()
	{
		initiaited = true;
	}
	
	// Set the running back to false, called from the dispatcher
	global void stopRunning()
	{
		initiaited = false;
	}
	
	// Required overrides
	global abstract void qualifyStartingRecords(List<sObject> newList, 
		List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
	global abstract void start();
	
	// Optional overrides
	global virtual void qualifyReEntryRecords(List<sObject> newList, 
		List<sObject> oldList, Map<ID, sObject> newMap, 
		Map<ID, sObject> oldMap)
	{
		
	}
	
	global virtual void reEntry()
	{
		
	}
	
	global virtual void finish(Boolean fromStart)
	{
		
	}
	
	// -------- Internal Classes --------
	// None
}