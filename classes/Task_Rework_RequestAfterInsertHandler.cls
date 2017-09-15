public class Task_Rework_RequestAfterInsertHandler extends TriggerHandlerBase{

	// -------- Variables --------
	Map<Id, Project_Task__c> tasksToUpdate;
	// -------- Constructor --------
    public Task_Rework_RequestAfterInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	Diagnostics.push('Task_Rework_RequestAfterInsertHandler qualifyStartingRecords');

    	List<Task_Rework_Request__c> newRecords = (List<Task_Rework_Request__c>)newList;
    	tasksToUpdate = new Map<Id, Project_Task__c>();

    	
    	for(Task_Rework_Request__c rr : newRecords){
    		// Initiating Task status updates to 'Pending Rework'
    		Project_Task__c it = new Project_Task__c();
    		it.Id = rr.Initiating_Task__c;
    		it.Status__c = 'Pending Rework';
    		tasksToUpdate.put(it.Id, it);

    		// Rework Task status updates to 'Needs Rework'
    		Project_Task__c rt = new Project_Task__c();
    		rt.Id = rr.Rework_Task__c;
    		rt.Status__c = 'Needs Rework';
    		tasksToUpdate.put(rt.Id, rt);
    	}


	}

	public override void start() {

	}

	public override void finish(Boolean fromStart) {
        if(fromStart) {
        	update tasksToUpdate.values();
        }
        Diagnostics.pop();
    }
}