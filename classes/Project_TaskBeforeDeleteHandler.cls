public with sharing class Project_TaskBeforeDeleteHandler extends TriggerHandlerBase{
	// -------- Constants --------
	Id ptId = ProjectTaskUtility.ptId; // Project Task Record Type on Project Task
	Id ttId = ProjectTaskUtility.ttId; // Template Task Record Type on Project Task

	// -------- Variables --------



	// -------- Constructor --------
    public Project_TaskBeforeDeleteHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Project_TaskBeforeDeleteHandler qualifyStartingRecords');

        List<Project_Task__c> oldRecords = (List<Project_Task__c>)oldList;


        for(Project_Task__c pt : oldRecords){
            if(pt.Critical_Path__c == TRUE && pt.RecordTypeId != ttId && pt.Template_Task__c != NULL) pt.addError('Critical path tasks can only be deleted at the template level');
        }
    }

    public override void start() {
		
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {

        }
        Diagnostics.pop();
    }
}