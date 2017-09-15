public with sharing class Project_TaskAfterDeleteHandler extends TriggerHandlerBase{
	// -------- Constants --------
    Id ttId = ProjectTaskUtility.ttId; // Template Task Record Type on Project Task

	// -------- Variables --------
    Map<Project_Task__c, Decimal>           orderMap;
    public Map<Id, Project_Task__c>         tasksForUpdate; // I am using a map as protection against duplicate records

	// -------- Constructor --------
    public Project_TaskAfterDeleteHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Project_TaskAfterDeleteHandler qualifyStartingRecords');

        /* ReOrder */
        orderMap        = new Map<Project_Task__c, Decimal>();
        tasksForUpdate  = new Map<Id, Project_Task__c>();

        List<Project_Task__c> oldRecords = (List<Project_Task__c>)oldList;

        for(Project_Task__c pt : oldRecords){
            if(pt.RecordTypeId == ttId && pt.Critical_Path__c == TRUE && pt.Order__c != NULL) orderMap.put(pt, pt.Order__c);
        }

    }

    public override void start() {
		if (orderMap.size() > 0) tasksForUpdate.putall(ProjectTaskUtility.orderUpdateSync(orderMap, true, false));
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {
            // If critical path task was deleted, add all template task siblings to be update
            update tasksForUpdate.values();
        	
        }
        Diagnostics.pop();
    }
}