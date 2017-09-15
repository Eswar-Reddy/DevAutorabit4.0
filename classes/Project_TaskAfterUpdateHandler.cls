public without sharing class Project_TaskAfterUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------
	Id ptId = ProjectTaskUtility.ptId;
	Id ttId = ProjectTaskUtility.ttId;
	Id adId = ProjectTaskUtility.adId;

	// -------- Variables --------
	public Map<Id, Project_Task__c> 		tasksForUpdate; // I am using a map as protection against duplicate records
	public Map<Id, Decimal> 				queryMap;
	public Map<Id, String>  				nameChange;
	public Map<Id, String>  				milestoneChange;
	public Map<Id, Decimal> 				slaChange;
	public Map<Id, String>  				roleChange;
	public Map<Id, String>  				descChange;
	public Map<Project_Task__c, Decimal> 	orderUpdateMap;
	public Map<Project_Task__c, Decimal> 	orderNewMap;
	public List<Project_Task__c>		 	orderCritChange;
	public List<Id>		 					jcoTasks;
	public Set<Id> 							projectAssignIds;
	public Set<Id> 							reworkTasks;
	public Set<Id> 							flowProgress;
	public List<Task_Rework_Request__c> 	trRequests;
	static public boolean 					isNameChange = false;

    // -------- Constructor --------
    public Project_TaskAfterUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ProjectTaskAfterUpdateHandler qualifyStartingRecords');

        List<Project_Task__c> newRecords 		= (List<Project_Task__c>)newList;
        Map<Id, Project_Task__c> oldRecordMap 	= (Map<Id, Project_Task__c>)oldMap;

        /* Template Task Update */
        nameChange 		= new Map<Id, String>();
		milestoneChange = new Map<Id, String>();
		slaChange 		= new Map<Id, Decimal>();
		roleChange 		= new Map<Id, String>();
		descChange 		= new Map<Id, String>();
		orderUpdateMap  = new Map<Project_Task__c, Decimal>();
		orderNewMap  	= new Map<Project_Task__c, Decimal>();
		tasksForUpdate 	= new Map<Id, Project_Task__c>();
		projectAssignIds = new Set<Id>();
		reworkTasks 	= new Set<Id>();
		trRequests 		= new List<Task_Rework_Request__c>();
		orderCritChange = new List<Project_Task__c>();
		jcoTasks 		= new List<Id>();

		// Identify what has changed on each template task
		for(Project_Task__c pt : newRecords){
			Boolean crit = FALSE;
			Project_Task__c oldpt = oldRecordMap.get(pt.Id);
			if(pt.RecordTypeId == ttId){
				if(pt.Name != oldpt.Name)								nameChange.put(pt.Id, pt.Name);
				if(pt.Milestone__c != oldpt.Milestone__c)				milestoneChange.put(pt.Id, pt.Milestone__c);
				if(pt.SLA_Days__c != oldpt.SLA_Days__c)					slaChange.put(pt.Id, pt.SLA_Days__c);
				if(pt.Order__c != oldpt.Order__c && pt.Critical_Path__c == TRUE) orderUpdateMap.put(pt, oldpt.Order__c);
				if(pt.Description__c != oldpt.Description__c)			  descChange.put(pt.Id, pt.Description__c);						
				if(pt.Role_Assignment__c != oldpt.Role_Assignment__c) 	  roleChange.put(pt.Id, pt.Role_Assignment__c);
				if(pt.Critical_Path__c != oldpt.Critical_Path__c){
					// If task has just become a critical path, push it through the ordering method as an insert
					if(pt.Critical_Path__c == TRUE){
						orderNewMap.put(pt, NULL);
					}else{
						// If task has just become NOT a critical path, push it through the ordering method as a delete.
						orderCritChange.add(pt);
					}
				}
			}

			/* Sharing */
			if(pt.Assigned_To__c != oldpt.Assigned_To__c && pt.RecordTypeId != ttId){
				projectAssignIds.add(pt.Residential_Project__c);
			}
		}

		/* Chatter Posts */
		ProjectTaskUtility.checkForNotifications(newRecords, oldRecordMap);

		if(orderNewMap.size() > 0) 		tasksForUpdate.putAll(ProjectTaskUtility.orderUpdateSync(orderNewMap, false, true));

		if(orderCritChange.size() > 0) 	tasksForUpdate.putAll(ProjectTaskUtility.orderCritChange(orderCritChange));

		queryMap = new Map<Id, Decimal>();
		flowProgress = new Set<Id>();
		for(Project_Task__c pt : newRecords){
			Project_Task__c oldPT = oldRecordMap.get(pt.Id);

			/* JCO task completion - Photos PDF */
			if(pt.Name == 'System Installation Complete' && pt.Status_Type__c == 'Completed' && oldPT.Status_Type__c != 'Completed'){
				jcoTasks.add(pt.Id);
			}

			/* Rework Task Completion */
			if(pt.Status_Type__c == 'Completed' && oldpt.Status__c == 'Needs Rework'){
				reworkTasks.add(pt.Id);
			}

			/* Successor Tasks */
			//if(pt.Template_RecordType__c == 'Project Template'){
				if(pt.Order__c != NULL && pt.Critical_Path__c == TRUE && pt.Status_Type__c == 'Completed' && oldPT.Status_Type__c != 'Completed' && oldPT.Status__c != 'Needs Rework'){
					queryMap.put(pt.Residential_Project__c, pt.Order__c +1);
				}
			//}
		}
    }

    public override void start() {

    	
    	List<Project_Task__c> 			roleUpdateList = new List<Project_Task__c>();

    	/* Template Task Update */
    	// Get list of all clone tasks that will need to be changed
		List<Project_Task__c> clonetasks = [SELECT 	Id, 
													Order__c, 
													Description__c,
													Role_Assignment__c, 
													Name, 
													Milestone__c, 
													Critical_Path__c, 
													Template_Task__c, 
													Status__c,
													Status_Type__c,
													Document_Required__c,
													Residential_Project__r.Account__r.Name,
													Residential_Project__r.Name 
													FROM Project_Task__c 
													WHERE (Residential_Project__r.Status__c = 'Active' OR Residential_Project__r.Status__c = 'Hold')
													AND (Template_Task__c IN: roleChange.keyset() 
													OR Template_Task__c IN: descChange.keyset()
													OR Template_Task__c IN: nameChange.keyset()
													OR Template_Task__c IN: milestoneChange.keyset()
													OR Template_Task__c IN: slaChange.keyset())];

		for(Project_Task__c t : cloneTasks){
			if(nameChange.containsKey(t.Template_Task__c)){
				t.Name = nameChange.get(t.Template_Task__c);
				isNameChange = true;
			}
			if(milestoneChange.containsKey(t.Template_Task__c)){
				t.Milestone__c = milestoneChange.get(t.Template_Task__c);
			}
			if(descChange.containsKey(t.Template_Task__c)){
				t.Description__c = descChange.get(t.Template_Task__c);
			}
			if(t.Status_Type__c == 'New'){
				if(slaChange.containsKey(t.Template_Task__c)){
					t.SLA_Days__c = slaChange.get(t.Template_Task__c);
				}
				if(roleChange.containsKey(t.Template_Task__c)){
					t.Role_Assignment__c = roleChange.get(t.Template_Task__c);
					roleUpdateList.add(t);
				}
			}
		}
		tasksForUpdate.putAll(clonetasks);
		tasksForUpdate.putAll(ProjectTaskUtility.roleAssignmentSync(roleUpdateList));

		// Ordering Methods //
		if(orderUpdateMap.size() > 0) 	tasksForUpdate.putAll(ProjectTaskUtility.orderUpdateSync(orderUpdateMap, false, false));

		/*JCO Tasks**/
		if(jcoTasks.size() >0) ProjectTaskUtility.generateJCOPDF(jcoTasks);
		
		/* Rework Task Completion */
		trRequests = [SELECT Id, Status__c, Initiating_Task__c, CreatedById FROM Task_Rework_Request__c WHERE Status__c = 'Open' AND Rework_Task__c IN: reworkTasks];
		for(Task_Rework_Request__c t : trRequests){
			t.Status__c = 'Completed';
			t.End_DateTime__c = system.now();

			// Update initiating task back to in progress and chatter rework creator
			Project_Task__c pt = new Project_Task__c();
			pt.Id = t.Initiating_Task__c;
			pt.Status__c = 'In Progress';
			pt.Apex_Updated__c = System.currentTimeMillis();
			tasksForUpdate.put(pt.Id, pt);

			String body = ' Your task rework request has been completed and your task has been placed back in progress.';
			ProjectTaskUtility.postChatter(t.CreatedById, body, pt.Id);
		}

		/* Successor Tasks */
		// OLD - will get replaced with process flow
		if(queryMap.size() >0){
			List<Project_Task__c> nextPT = [SELECT Id, Name, Assigned_To__c, Apex_Updated__c, RecordTypeId, Status__c, Status_Type__c, Order__c, SLA_Days__c, Start_DateTime__c, Project_Priority__c, Residential_Project__c FROM Project_Task__c WHERE Residential_Project__c IN: queryMap.keyset() AND Status_Type__c = 'New' ORDER BY Order__c ASC];
			
			for(Project_Task__c pt : nextPT){
				if(pt.Order__c == queryMap.get(pt.Residential_Project__c) && pt.RecordTypeId == ptId ){
					pt.Status__c = 'In Progress';
					pt.Apex_Updated__c = System.currentTimeMillis();
					
					/* Chatter Posts */
		            String startDate = String.valueOf(System.Now());
					String body = 'You have been assigned a new task: '+pt.Name+'. Your task began '+startDate+'. You have '+pt.SLA_Days__c+' days to complete this task. The task priority is '+pt.Project_Priority__c+'. Please log into Salesforce and begin work on your task.';
					ProjectTaskUtility.postChatter(pt.Assigned_To__c, body, pt.Id);

					tasksForUpdate.put(pt.Id, pt);
				} 
			}
		}
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {
        	if(trRequests.size() > 0 ) update trRequests;
        	update tasksForUpdate.values();
        	/* Sharing */
        	ProjectSharingUtility.shareWithTeamMembers(projectAssignIds);

        }
        Diagnostics.pop();
    }
}