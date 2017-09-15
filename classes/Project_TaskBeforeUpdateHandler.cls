/*********************************************************

@class		Project_TaskBeforeUpdateHandler

@brief		Trigger handler class for project_task__c object

@author		Gabriel Baca (Redpoint)

@version	2016-6-8
*-------------------------------------------------------------------------------------------------------------
* Version | related Issue        | Date       | By               | Changes Description
*-------------------------------------------------------------------------------------------------------------
* 1.00    | Pivotal ID#120916385 | 06/08/2016 | Gabriel          | Trigger to display custom error message when
																 | missing required attachments
*-----------------------------------------------------------------------------------------------------------*/

public with sharing class Project_TaskBeforeUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------
	Id ptId = ProjectTaskUtility.ptId; //Project Task Record Type Id
	Id ttId = ProjectTaskUtility.ttId; //Template Task Record Type Id
	Id adId = ProjectTaskUtility.adId; //Ad Hoc Record Type Id

	// -------- Variables --------
	public Map<Id, Project_Task__c> statusChange; /* Map of project task ids [key] and status [value] */
	public List<Project_Task__c>    completedParent;
	public List<Id> 			    completedTasks;

	// -------- Constructor --------
	public Project_TaskBeforeUpdateHandler() {}

	// Begin processing
	// Select which records meet the right criteria to be processed
	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		Diagnostics.push('ProjectTaskBeforeUpdateHandler qualifyStartingRecords');

		List<Project_Task__c> newRecords 		= (List<Project_Task__c>)newList;
		Map<Id, Project_Task__c> oldRecordMap 	= (Map<Id, Project_Task__c>)oldMap;

		statusChange    = new Map<Id, Project_Task__c>();
		completedParent = new List<Project_Task__c>();
		completedTasks  = new List<Id>();

		String profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1].Name;
		Id ptId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();

		// Identify what has changed on each template task
		for (Project_Task__c newpt : newRecords) {
			Project_Task__c oldpt = oldRecordMap.get(newpt.Id);

			//Block changing Name on Project Task
			if (newpt.RecordTypeId == ptId && newpt.Name != oldpt.Name && profileName != 'System Administrator' && !Project_TaskAfterUpdateHandler.isNameChange){
				newpt.addError('Project Task Name cannot be updated');
			}

			if(newpt.Status_Type__c == 'Completed' && oldpt.Status_Type__c != 'Completed'){
				// Create list of these tasks to pass into dynamic project field validation
				completedTasks.add(newpt.Id);

				// Check if new project status is newly 'Completed' and Document Required is true
				if(newpt.Document_Required__c == TRUE){
					statusChange.put(newpt.Id, newpt);
				}

				// Check if task status is newly 'Compeleted', if it is validate it has no open sub tasks
				if(newpt.RecordTypeId == ptId || newpt.RecordTypeId == adId){
					completedParent.add(newpt);
				}
			}
			
			
			/* SLA Clock */
			if(newpt.RecordTypeId != ttId){
				if(newpt.Status_Type__c == 'Open' && oldpt.Status_Type__c == 'New'){
					newpt.Start_DateTime__c 	= System.now();
					newpt.Elapsed_DateTime__c 	= System.now();
				}
				if(newpt.Status_Type__c == 'Hold' && oldpt.Status_Type__c == 'Open'){
					newpt.Time_Differential__c = oldpt.SLA_Days_Aging__c;
				}
				if(newpt.Status_Type__c == 'Open' && oldpt.Status_Type__c == 'Hold'){
					newpt.Elapsed_DateTime__c = System.now();
				}
				if(newpt.Status_Type__c == 'Open' && oldpt.Status_Type__c == 'Completed'){
					newpt.Elapsed_DateTime__c = System.now();
					newpt.Time_Differential__c = oldpt.SLA_Days_Aging__c;
					newpt.Times_Repeated__c = newpt.Times_Repeated__c +1;
					system.debug('%% reopened - '+oldpt.SLA_Days_Aging__c);
				}
				if(newpt.Status_Type__c == 'Open' && oldpt.Status_Type__c == 'Cancelled'){
					newpt.Elapsed_DateTime__c = System.now();
				}
				if(newpt.Status_Type__c != 'Completed' && oldpt.Status_Type__c == 'Completed' ){
					newpt.End_DateTime__c = NULL;
				}
				if(newpt.Status_Type__c == 'Completed' && oldpt.Status_Type__c != 'Completed'){
					newpt.End_DateTime__c = System.now();
				}
				if(newpt.Status_Type__c == 'Cancelled' && oldpt.Status_Type__c != 'Cancelled'){
					newpt.Time_Differential__c = oldpt.SLA_Days_Aging__c;
					newpt.End_DateTime__c = System.now();
				}
			}
		}

		/* Dynamic Error Validation */
		// Check project field validation and throw error if needed
		Map<Id, String> errorMap = ProjectTaskUtility.runFieldValidation(completedTasks);

		for(Project_Task__c pt : newRecords){
			if(errorMap.containsKey(pt.Id)) pt.addError(errorMap.get(pt.Id));
		}
	}

	// Logic and manipulation of the qualifying records
	public override void start() {
		Map<Id, List<String>> ptMissingDocsMap = new Map<Id, List<String>>();
		Map<Id, List<Document__c>> docMap = new Map<Id, List<Document__c>>();

		// Generate list of all docs/attachments based on project task id
		for (Document__c d : [SELECT Id, Name, Document_Type__c, Project_Task__c, (SELECT Id, Name FROM Attachments ) FROM Document__c WHERE Project_Task__c = : statusChange.keyset()]) {
			if (docMap.containsKey(d.Project_Task__c)) {
				docMap.get(d.Project_Task__c).add(d);
			} else {
				docMap.put(d.Project_Task__c, new List<Document__c> {d});
			}
		}

		if (!statusChange.isEmpty() && !docMap.isEmpty()) {
			for (Project_Task__c pt : statusChange.values()) {
				// Loop through each document
				for (Document__c doc : docMap.get(pt.Id)) {
					// If the Attachments size is 0 that means the document is missing an attachment
					if (doc.Attachments.size() == 0) {
						if (ptMissingDocsMap.containsKey(doc.Project_Task__c)) {
							// Update value
							List<String> tempString = ptMissingDocsMap.get(doc.Project_Task__c);
							tempString.add(doc.Name);
							ptMissingDocsMap.put(doc.Project_Task__c, tempString);
						} else {
							// Insert new key/value to map
							List<String> tempString = new List<String>();
							tempString.add(doc.Name);
							ptMissingDocsMap.put(doc.Project_Task__c, tempString);
						}
					} else {
						// Do nothing, since this means the document has an attachment
					}
				}
			}
		}

		Project_Task__c actualRecord;
		// Loop over the project task id map with the List of missing document names
		for (Id ptId : ptMissingDocsMap.keySet()) {
			// We need the newMap trigger to display a message on the Project Task page
			actualRecord = (Project_Task__c)Trigger.newMap.get(ptId);
			actualRecord.addError('Missing attachment for document(s) "' + ptMissingDocsMap.get(ptId) + '"');
		}

		// Query open sub tasks for newly completed tasks and add error
		for(Project_Task__c p : [SELECT Id, (SELECT Id FROM Sub_Tasks__r WHERE Status_Type__c != 'Completed') FROM Project_Task__c WHERE Id IN: completedParent]){
			if(p.Sub_Tasks__r.size() > 0){
				Project_Task__c pRecord = (Project_Task__c)Trigger.newMap.get(p.Id);
				pRecord.addError('This Task cannot be completed until all Sub Tasks are completed');
			} 
		}
	}

	// Process data from start task, DML operations go here
	public override void finish(Boolean fromStart) {
		if (fromStart) {

		}
		Diagnostics.pop();
	}
}