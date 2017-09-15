public class DocumentBeforeInsertHandler extends TriggerHandlerBase{
	// -------- Constants --------

    
	// -------- Variables --------
	Map<Document__c, Id> taskDocuments;
    
    // -------- Constructor --------
    public DocumentBeforeInsertHandler() {}

	//Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	Diagnostics.push('DocumentBeforeInsertHandler qualifyStartingRecords');

    	List<Document__c> newRecords = (List<Document__c>)newList;

    	taskDocuments = new Map<Document__c,Id>();

       	for(Document__c d : newRecords){
       		if(d.Project_Task__c != NULL) taskDocuments.put(d, d.Project_Task__c);
       	}
	}

	public override void start() {

		// If Document is related to a project task and not a project, populate the project lookup
        Map<Id, Project_Task__c> tasks = new Map<Id, Project_Task__c>([SELECT Id, Residential_Project__c FROM Project_Task__c WHERE Id IN: taskDocuments.values()]);
        for(Document__c d : taskDocuments.keyset()){
        	d.Residential_Project__c = tasks.get(d.Project_Task__c).Residential_Project__c;
        }
	}

	public override void finish(Boolean fromStart) {
        if(fromStart) {
        	
        }
        Diagnostics.pop();
    }
}