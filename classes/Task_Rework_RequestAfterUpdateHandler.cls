public class Task_Rework_RequestAfterUpdateHandler extends TriggerHandlerBase{

	// -------- Variables --------
	Map<Id, Project_Task__c> tasksToUpdate;
	// -------- Constructor --------
    public Task_Rework_RequestAfterUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	Diagnostics.push('Task_Rework_RequestAfterUpdateHandler qualifyStartingRecords');

    	List<Task_Rework_Request__c> newRecords = (List<Task_Rework_Request__c>)newList;
    	Map<Id, Task_Rework_Request__c> oldMapRecords 	= (Map<Id, Task_Rework_Request__c>)oldMap;

    	tasksToUpdate = new Map<Id, Project_Task__c>();

    	
    	for(Task_Rework_Request__c rr : newRecords){
    		Task_Rework_Request__c oldRR = oldMapRecords.get(rr.Id);
    		if(rr.Status__c == 'Cancelled' && oldRR.Status__c == 'Open'){
    			// Initiating Task status updates to 'In Progress' 
	    		Project_Task__c it = new Project_Task__c();
	    		it.Id = rr.Initiating_Task__c;
	    		it.Status__c = 'In Progress';
                it.Apex_Updated__c = System.currentTimeMillis();
	    		tasksToUpdate.put(it.Id, it);

	    		// Rework Task status updates to 'Completed'
	    		Project_Task__c rt = new Project_Task__c();
	    		rt.Id = rr.Rework_Task__c;
	    		rt.Status__c = 'Completed';
                it.Apex_Updated__c = System.currentTimeMillis();
	    		tasksToUpdate.put(rt.Id, rt);

    		}
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