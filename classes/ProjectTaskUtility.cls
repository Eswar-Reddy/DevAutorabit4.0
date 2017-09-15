/************************************************************************************************
Created By: Sita Reeves - Redpoint - Residential Installation Project
Created On: 5/25/16

 - I am setting the record type variables here as reference for all other classes. If Record Type
   Name changes, updating it here should update it everywhere.

************************************************************************************************/

public without sharing class ProjectTaskUtility {

	public static Id ttId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Task Template').getRecordTypeId();
	public static Id ptId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Project Task').getRecordTypeId();
	public static Id adId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Ad Hoc').getRecordTypeId();
	public static Id stId = Schema.SObjectType.Project_Task__c.getRecordTypeInfosByName().get('Sub Task').getRecordTypeId();

	public static Id ptpId = ResidentialProjectUtility.ptpId;

	public static Boolean fromDelete = false;

	/* Used only when an existing task is changed from critical to non critical */
	public static List<Project_Task__c> orderCritChange(List<Project_Task__c> tasks) {
		Set<Id> 						projectSet = new Set<Id>();
		Map<Id, List<Project_Task__c>> 	siblingMap = new Map<Id, List<Project_Task__c>>();
		List<Project_Task__c> 			newOrderTasks = new List<Project_Task__c>();

		for (Project_Task__c pt : tasks) {
			projectSet.add(pt.Residential_Project__c);
		}

		for (Project_Task__c sis : [SELECT Id, Order__c, Residential_Project__c FROM Project_Task__c WHERE Critical_Path__c = TRUE AND Residential_Project__c IN: projectSet AND Id NOT IN: tasks]) {
			if (siblingMap.containsKey(sis.Residential_Project__c)) {
				siblingMap.get(sis.Residential_Project__c).add(sis);
			} else {
				siblingMap.put(sis.Residential_Project__c, new List<Project_Task__c> {sis});
			}
		}

		for (Project_Task__c t : tasks) {
			if (siblingMap.get(t.Residential_Project__c) != NULL) {
				for (Project_Task__c sis : siblingMap.get(t.Residential_Project__c)) {
					if (sis.Order__c > t.Order__c) {
						sis.Order__c = sis.Order__c - 1;
						newOrderTasks.add(sis);
					}
				}
			}
		}

		return newOrderTasks;
	}

	/* Order Sync
		- Only tasks where Critical_Path__c = TRUE should be included.
		  Critical Path Tasks are linear but there can be multiple non
		  critical tasks of the same order.
	    - All Record Types should be included.
	*/
	public static List<Project_Task__c> orderUpdateSync(Map<Project_Task__c, Decimal> tMap, Boolean forDelete, Boolean forInsert) {
		Set<Id> 						projectSet = new Set<Id>();
		Map<Id, List<Project_Task__c>> 	siblingMap = new Map<Id, List<Project_Task__c>>();
		List<Project_Task__c> 			newOrderTasks = new List<Project_Task__c>();

		for (Project_Task__c t : tMap.keyset()) {
			if (t.Critical_Path__c && t.Order__c != NULL) projectSet.add(t.Residential_Project__c);
		}
		if (projectSet.size() > 0) {
			for (Project_Task__c sis : [SELECT Id, Order__c, Residential_Project__c FROM Project_Task__c WHERE Critical_Path__c = TRUE AND Residential_Project__c IN: projectSet AND Id NOT IN: tMap.keyset()]) {
				if (siblingMap.containsKey(sis.Residential_Project__c)) {
					siblingMap.get(sis.Residential_Project__c).add(sis);
				} else {
					siblingMap.put(sis.Residential_Project__c, new List<Project_Task__c> {sis});
				}
			}

			/* For Update */
			if (forDelete == FALSE && forInsert == FALSE) {
				for (Project_Task__c t : tMap.keyset()) {
					if (siblingMap.get(t.Residential_Project__c) != NULL) {
						// Determine if order went up or down. Decimal in map represents previous order.
						Boolean ascending = FALSE;
						if (t.Order__c > tMap.get(t)) ascending = TRUE;
						for (Project_Task__c sis : siblingMap.get(t.Residential_Project__c)) {
							if (ascending) {
								if (sis.Order__c <= t.Order__c && sis.Order__c > tMap.get(t)) {
									sis.Order__c = sis.Order__c - 1;
									newOrderTasks.add(sis);
								}
							} else {
								if (sis.Order__c >= t.Order__c && sis.Order__c < tMap.get(t)) {
									sis.Order__c = sis.Order__c + 1;
									newOrderTasks.add(sis);
								}
							}
						}
					}
				}
			}

			/* For Delete */
			if (forDelete) {
				for (Project_Task__c t : tMap.keyset()) {
					if (siblingMap.get(t.Residential_Project__c) != NULL) {
						for (Project_Task__c sis : siblingMap.get(t.Residential_Project__c)) {
							if (sis.Order__c > t.Order__c) {
								sis.Order__c = sis.Order__c - 1;
								newOrderTasks.add(sis);
							}
						}
					}
				}
			}

			/* For Insert */
			if (forInsert) {
				for (Project_Task__c t : tMap.keyset()) {
					if (siblingMap.get(t.Residential_Project__c) != NULL) {
						for (Project_Task__c sis : siblingMap.get(t.Residential_Project__c)) {
							if (sis.Order__c >= t.Order__c) {
								sis.Order__c = sis.Order__c + 1;
								newOrderTasks.add(sis);
							}
						}
					}
				}
			}
		}
		return newOrderTasks;
	}

	/* Role Assignment Sync
		- When a role assingment is updated, update the assigned to user
		  if one exists in the team members list
	*/
	public static List<Project_Task__c> roleAssignmentSync(List<Project_Task__c> tasks) {
		Set<Id> projectSet = new Set<Id>();
		Map<Id, List<Project_Team_Member__c>> memberMap = new Map<Id, List<Project_Team_Member__c>>();

		for (Project_Task__c t : tasks) {
			projectSet.add(t.Residential_Project__c);
		}

		for (Project_Team_Member__c team : [SELECT Id, User__c, Role__c, Residential_Project__c FROM Project_Team_Member__c WHERE Residential_Project__c IN: projectSet]) {
			if (memberMap.containsKey(team.Residential_Project__c)) {
				memberMap.get(team.Residential_Project__c).add(team);
			} else {
				memberMap.put(team.Residential_Project__c, new List<Project_Team_Member__c> {team});
			}
		}

		for (Project_Task__c t : tasks) {
			if (memberMap.containsKey(t.Residential_Project__c)) {
				for (Project_Team_Member__c m : memberMap.get(t.Residential_Project__c)) {
					if (t.Role_Assignment__c == m.Role__c) t.Assigned_To__c = m.User__c;
				}
			}
		}
		return tasks;
	}

	public static void checkForNotifications(List<Project_Task__c> tasks, Map<Id, Project_Task__c> oldTasks) {

		checkForSubTaskNotifications(tasks, oldTasks);

		for (Project_Task__c pt : tasks) {
			Project_Task__c oldpt = oldtasks.get(pt.Id);
			// Non template or ad hoc tasks notifications
			if (pt.RecordTypeId == ptId || pt.RecordTypeId == adId && pt.Assigned_To__c != NULL) {
				if ((pt.Status_Type__c == 'In Progress' || pt.Status__c == 'Pending Approval') && oldpt.Status__c == 'Not Started') {
					String startDate = String.valueOf(pt.Start_DateTime__c);
					String body = ' You have been assigned a new task: ' + pt.Name + '. Your task began ' + startDate + '. You have ' + pt.SLA_Days__c + ' days to complete this task. The task priority is ' + pt.Project_Priority__c + '. Please log into Salesforce and begin work on your task.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Status__c == 'Hold' && (oldpt.Status_Type__c == 'Open')) {
					String body = ' This task has been put on Hold';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (oldpt.Status__c == 'Hold' && (pt.Status_Type__c == 'Open')) {
					String body = ' This task has gone from Hold to In Progress';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Status_Type__c == 'Open' && pt.Status__c != 'Needs Rework' && oldpt.Status_Type__c == 'Completed') {
					String body = ' This task has been reopened';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Status__c == 'Needs Rework' && oldpt.Status_Type__c == 'Completed') {
					String body = ' You have been requested to rework this task. View task rework request for more details.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Status_Type__c == 'Open' && oldpt.Status__c == 'Pending Rework') {
					String body = ' Your task rework request has been completed and your task has been placed back in progress.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
			}
			// Ad Hoc Notifications
			if (pt.RecordTypeId == adId && pt.Assigned_To__c != pt.CreatedById && pt.Assigned_To__c != oldpt.Assigned_To__c && pt.Assigned_To__c != NULL) {
				if (pt.Due_Date__c != NULL && pt.Start_DateTime__c != NULL ) {
					String dueDate = String.valueOf(pt.Due_Date__c);
					String startDate = String.valueOf(pt.Start_DateTime__c);
					String body = ' You have been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + pt.Status__c + ' and the task priority is ' + pt.Project_Priority__c + '. The task assignee has requested that you begin working on this task ' + startDate + ' and complete the task no later than ' + dueDate + '.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Due_Date__c != NULL && pt.Start_DateTime__c == NULL ) {
					String dueDate = String.valueOf(pt.Due_Date__c);
					String body = ' You have been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + pt.Status__c + ' and the task priority is ' + pt.Project_Priority__c + '. The task assignee has requested that you complete the task no later than ' + dueDate + '.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
				if (pt.Due_Date__c == NULL ) {
					String body = ' You have been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + pt.Status__c + ' and the task priority is ' + pt.Project_Priority__c + '. The task creator did not specify a task start or due date.';
					postChatter(pt.Assigned_To__c, body, pt.Id);
				}
			}
			if(pt.RecordTypeId == adId && UserInfo.getUserId() != pt.CreatedById){
				if(pt.Status_Type__c == 'Completed' && oldPt.Status_Type__c != 'Completed'){
					String body = ' '+UserInfo.getName()+' completed ad hoc task '+ pt.Name +' you assigned on '+pt.Start_DateTime__c+'. Please log into Salesforce and review the completed work.';
					postChatter(pt.CreatedById, body, pt.Id);
				}
			}
		}
	}

	public static void checkForSubTaskNotifications(List<Project_Task__c> tasks, Map<Id, Project_Task__c> oldTasks) {
		String currentUser = UserInfo.getName();

        Map<Id, String> projectNameMap = new Map<Id, String>();
        for(Project_Task__c p : [SELECT Id, Residential_Project__r.Name FROM Project_Task__c WHERE Id IN: tasks]){
            projectNameMap.put(p.Id, p.Residential_Project__r.Name);
        }

		for (Project_Task__c pt : tasks) {
			Project_Task__c oldpt = oldtasks.get(pt.Id);

			// If parent_task__c is not null then this task is considered a sub task
			if (pt.Parent_Task__c != null) {

				// Sub-Task Notifications
				if (pt.RecordTypeId == stId) {

					// Send notification to new assigned user
					if (pt.Assigned_To__c != oldpt.Assigned_To__c && pt.Assigned_To__c != NULL) {

						String body = currentUser + ' assigned sub-task "' + pt.Name + '" to you for the project "' + projectNameMap.get(pt.Id) + '".  Please review the sub-task and complete your requested actions.';
						System.debug('Sub Task Notification Body >>>> ' + body);
						postChatter(pt.Assigned_To__c, body, pt.Id);

					}

					// Send notification to user who created task letting them know someone else reassigned the sub-task
					if (pt.Assigned_To__c != oldpt.Assigned_To__c && pt.LastModifiedById != oldpt.CreatedById) {

						String body = currentUser + ' reassigned sub-task "' + pt.Name + '" you originated for the project "' + projectNameMap.get(pt.Id) + '".';
						System.debug('Sub Task Notification Body >>>> ' + body);
						postChatter(oldpt.CreatedById, body, pt.Id);

					}

					// Send notification when sub-task has been completed
					if (pt.Status__c != oldpt.Status__c && pt.Status__c == 'Completed') {

						String body = currentUser + ' completed sub-task "' + pt.Name + '" you originated for the project "' + projectNameMap.get(pt.Id) + '".  Please review the sub-task and proceed with your parent task responsibilities.';
						System.debug('Sub Task Notification Body >>>> ' + body);
						postChatter(oldpt.CreatedById, body, pt.Id);

					}

					// Send notification when sub-task has been approved
					if (pt.Status__c != oldpt.Status__c && pt.Status__c == 'Approved') {

						String body = currentUser + ' approved sub-task "' + pt.Name + '" you originated for the project "' + projectNameMap.get(pt.Id) + '".  Please review the sub-task and proceed with your parent task responsibilities.';
						System.debug('Sub Task Notification Body >>>> ' + body);
						postChatter(oldpt.CreatedById, body, pt.Id);

					}
				}
			}
		}
	}

	public static void postChatter(Id mentionId, String body, Id parentId) {

		try {
			ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

			mentionSegmentInput.id = mentionId;
			messageBodyInput.messageSegments.add(mentionSegmentInput);

			textSegmentInput.text = body;
			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = parentId;
			feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;

			if(!Test.isRunningTest()) ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
		} catch (Exception e) {
			system.debug('Chatter post was unable to be created ' + e.getMessage());
		}
	}

	public static Map<Id, String> runFieldValidation(List<Id> tasks){

		Map<Id, String> retMap = new Map<Id, String>();
		List<Project_Task__c> ptTasks = new List<Project_Task__c>();
		Map<String, String> labelToAPIName = new Map<String, String>();
		String projectsId = '';

		// Create string of project Id's for dynamic query
		for(Project_Task__c pt : [SELECT Id, Name, Residential_Project__c, Template_Task__c, Template_Task__r.Required_Project_Fields__c FROM Project_Task__c WHERE Id IN: tasks AND Template_Task__c != NULL AND Template_Task__r.Required_Project_Fields__c != NULL]){
			projectsId += '\''+pt.Residential_Project__c+'\',';
			ptTasks.add(pt);
		}
		if(ptTasks.size() > 0){
			// Remove last , from projects string
			projectsId = projectsId.left(projectsId.length()-1);

			// Create map of project fields <label, api name>
			Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Residential_Project__c.fields.getMap();
			for(Schema.SObjectField field : fieldMap.values() ){
				labelToAPIName.put(field.getDescribe().getLabel(), field.getDescribe().getName());
			}

			// Create dynamic query of all fields on the project record
			String query = 'SELECT  ';
			for(String s : fieldMap.keyset()){
			    query+= s+',';
			}
			query = query.left(query.length()-1);
			query += ' FROM Residential_Project__c WHERE Id IN ('+projectsId+')';

			List<Residential_Project__c> rps = database.query(query);

			// Create map of all populated fields on the projects
			Map<Id, Map<String, Object>> projectFieldPop = new Map<Id, Map<String, Object>>();
			for(Residential_Project__c rp : rps){
				Map<String, Object> popMap = rp.getPopulatedFieldsAsMap();
				projectFieldPop.put(rp.Id, new Map<String, Object>(popMap));
			}

			// Loop through project task and validate that all 'required fields' are populated. If they are not create dynamic error message to pass back
			for(Project_Task__c p : ptTasks){
				List<String> invalidFields = new List<String>();
				List<String> valFields = p.Template_Task__r.Required_Project_Fields__c.split(';');
				system.debug('Required Project Fields: '+valFields);
				for(String val : valFields){
					String apiName = labelToAPIName.get(val);
					system.debug('API name of field to check: '+apiName);
					Map<String, Object> popFields = projectFieldPop.get(p.Residential_Project__c);
					system.debug('Fields that are populated on this project: '+popFields);
					if(!popFields.containsKey(apiName)){
						invalidFields.add(val);
					}
				}
				system.debug('Fields that were not populated: '+invalidFields);
				if(invalidFields.size() > 0){
					String errormsg = 'The following fields are required to complete this task: ';
					for(String s : invalidFields){
						errormsg += s +', ';
					}
					errormsg = errormsg.left(errormsg.length()-2);
					system.debug('Error message for task Name = '+p.Name + ', Id = '+p.Id+': '+ errorMsg);
					retMap.put(p.Id, errormsg);
				}

			}
		}

		// Return all tasks with error message
		return retMap;
	}

	// Expect a list of newly completed tasks whose name = 'System Installation Complete'
	@future (callout=true)
	public static void generateJCOPDF(List<Id> tasks){
		List<Attachment> atts = new List<Attachment>();
		if(!tasks.isEmpty()) {
			Map<Id, Attachment> attMap = new Map<Id, Attachment>();
			for(Form__c form : [SELECT Id, Project_Task__c, Project_Task__r.Residential_Project__c FROM Form__c WHERE Project_Task__c IN: tasks AND RecordType.Name = 'Job Checkout Form']){
				Id rId = form.Id;
				pageReference ref = Page.GeneratePDF;
				ref.getParameters().put('rid',rId);
				Blob bpdf;
				if(test.isRunningTest())  bpdf = Blob.valueOf('Test ABC');
				if(!test.isRunningTest()) bpdf = ref.getcontentasPDF();
				Attachment att = new Attachment();
				att.Body = bpdf;
				att.Name = 'Photos.pdf';
				att.contentType = '.pdf';
				att.ParentId = form.Id;
				attMap.put(form.Project_Task__r.Residential_Project__c, att);
			}
			if(!attMap.isEmpty()) {
				// START ******* THIS FOR LOOP CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents
				for(Invoice_Documents__c inv : [SELECT Id, Residential_Project__c FROM Invoice_Documents__c WHERE Documents_in_File__c = 'Photos' AND Invoice_Type__c = 'Install' AND Lease_Payment__r.Residential_Project__c IN :attMap.keyset()]){
					Attachment a = new Attachment();
					a.Body = attMap.get(inv.Residential_Project__c).Body;
					a.Name = attMap.get(inv.Residential_Project__c).Name;
					a.ContentType = attMap.get(inv.Residential_Project__c).ContentType;
					a.ParentId = inv.Id;
					atts.add(a);
				}
				// END ******* THIS FOR LOOP CAN BE REMOVED AFTER THE CUT OVER TO Invoice Compliance Documents

				for(Invoice_Compliance_Document__c icd : [SELECT Id, Residential_Project__c FROM Invoice_Compliance_Document__c WHERE Documents_in_File__c = 'Photos' AND Invoice_Type__c = 'Install' AND Residential_Project__c IN :attMap.keyset()]){
					Attachment a = attMap.get(icd.Residential_Project__c);
					a.ParentId = icd.Id;
					atts.add(a);
				}
				insert atts;
			}
		}
	}
}