public with sharing class Project_TaskBeforeInsertHandler extends TriggerHandlerBase {
	// -------- Constants --------
	

	// -------- Variables --------

	// -------- Constructor --------
	public Project_TaskBeforeInsertHandler() {}

	// Begin processing
	// Select which records meet the right criteria to be processed
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('Project_TaskBeforeInsertHandler qualifyStartingRecords');

		List<Project_Task__c> newRecords 		= (List<Project_Task__c>)newList;


		for (Project_Task__c newpt : newRecords) {
			// If task is created in progress populate the start datetime and elapsed datetime for the SLA clock
			if(newpt.Status_Type__c == 'Open'){
				newpt.Start_DateTime__c = system.now();
				newpt.Elapsed_DateTime__c = system.now();
			}
		}
	}

	// Logic and manipulation of the qualifying records
	public override void start() {
		
	}

	// Process data from start task, DML operations go here
	public override void finish(Boolean fromStart) {
		if (fromStart) {

		}
		Diagnostics.pop();
	}
}