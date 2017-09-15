public without sharing class Project_TaskAfterInsertHandler extends TriggerHandlerBase {
    // -------- Constants --------
    Id ptId = ProjectTaskUtility.ptId; // Project Task Record Type on Project Task
    Id ttId = ProjectTaskUtility.ttId; // Template Task Record Type on Project Task
    Id adId = ProjectTaskUtility.adId; // Ad Hoc Record Type on Project Task
    Id stId = ProjectTaskUtility.stId; // Sub Task Record Type on Project Task

    // -------- Variables --------
    public Map<Id, Project_Task__c>         tasksForUpdate; // I am using a map as protection against duplicate records
    public List<Project_Task__c>            tasksForUpsert;
    public Set<Id>                          openSubParent;
    Set<Id>                                 projectAssignIds;
    Map<Project_Task__c, Decimal>           orderMap;

    // -------- Constructor --------
    public Project_TaskAfterInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ProjectTaskAfterInsertHandler qualifyStartingRecords');

        List<Project_Task__c> newRecords = (List<Project_Task__c>)newList;

        /* Sub Task */
        openSubParent   = new Set<Id>();
        /* Sharing */
        projectAssignIds = new Set<Id>();
        /* ReOrder */
        orderMap        = new Map<Project_Task__c, Decimal>();

        Map<Id, String> projectNameMap = new Map<Id, String>();
        for(Project_Task__c p : [SELECT Id, Residential_Project__r.Name FROM Project_Task__c WHERE Id IN: newRecords]){
            projectNameMap.put(p.Id, p.Residential_Project__r.Name);
        }
        
        for (Project_Task__c t : newRecords) {
            if(t.RecordTypeId == ttId && t.Order__c != NULL && t.Critical_Path__c == TRUE) orderMap.put(t, t.Order__c);

            /* Chatter Posts */
            if (t.Status__c == 'In Progress' || t.Status__c == 'Pending Approval' && t.RecordTypeId == ptId && t.Assigned_To__c != NULL) {
                String dateString = String.valueOf(t.Start_DateTime__c);
                String body = ' You have been assigned a new task: ' + t.Name + '. Your task began ' + dateString + '. You have ' + t.SLA_Days__c + ' days to complete this task. the task priority is ' + t.Project_Priority__c + '. Please log into Salesforce and begin work on your task.';
                ProjectTaskUtility.postChatter(t.Assigned_To__c, body, t.Id);
            }
            // Ad Hoc Notfications
            if (t.RecordTypeId == adId && t.Assigned_To__c != t.CreatedById && t.Assigned_To__c != NULL) {
                if (t.Due_Date__c != NULL && t.Start_DateTime__c != NULL ) {
                    String dueDate = String.valueOf(t.Due_Date__c);
                    String startDate = String.valueOf(t.Start_DateTime__c);
                    String body = ' You have a been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + t.Status__c + ' and the task priority is ' + t.Project_Priority__c + '. The task assignee has requested that you begin working on this task ' + startDate + ' and complete the task no later than ' + dueDate + '.';
                    ProjectTaskUtility.postChatter(t.Assigned_To__c, body, t.Id);
                }
                if (t.Due_Date__c != NULL && t.Start_DateTime__c == NULL ) {
                    String dueDate = String.valueOf(t.Due_Date__c);
                    String body = ' You have a been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + t.Status__c + ' and the task priority is ' + t.Project_Priority__c + '. The task assignee has requested that you complete the task no later than ' + dueDate + '.';
                    ProjectTaskUtility.postChatter(t.Assigned_To__c, body, t.Id);
                }
                if (t.Due_Date__c == NULL ) {
                    String body = ' You have a been assigned an ad hoc task by ' + UserInfo.getName() + '. The task status is ' + t.Status__c + ' and the task priority is ' + t.Project_Priority__c + '. The task creator did not specify a task start or due date.';
                    ProjectTaskUtility.postChatter(t.Assigned_To__c, body, t.Id);
                }
            }

            // Sub-task notifications
            if (t.RecordTypeId == stId && t.Assigned_To__c != t.CreatedById && t.Assigned_To__c != NULL) {

                String body = UserInfo.getName() + ' assigned sub-task "' + t.Name + '" to you for the project "' + projectNameMap.get(t.Id) + '".  Please review the sub-task and complete your requested actions.';
                System.debug('Sub Task Notification Body >>>> ' + body);
                ProjectTaskUtility.postChatter(t.Assigned_To__c, body, t.Id);

            }
            if (t.RecordTypeId == stId) {
                openSubParent.add(t.Parent_Task__c);
            }

            /* Sharing */
            if (t.Assigned_To__c != NULL && t.RecordTypeId != ttId ) {
                projectAssignIds.add(t.Residential_Project__c);
            }
        }
    }

    public override void start() {

        tasksForUpdate = new Map<Id, Project_Task__c>();
        tasksForUpsert = new List<Project_Task__c>();

        // If new task is critical path, add all template task siblings to be update
        if (orderMap.size() > 0) tasksForUpdate.putall(ProjectTaskUtility.orderUpdateSync(orderMap, false, true));

        /* Sub Task */
        // If a new sub task is added to a Completed task, that task is reopened
        for (Project_Task__c p : [SELECT Id, Status__c FROM Project_Task__c WHERE Id IN: openSubParent AND Status_Type__c = 'Completed']) {
            p.Status__c = 'In Progress';
            tasksForUpdate.put(p.Id, p);
        }

        tasksForUpsert.addAll(tasksForUpdate.values());

    }

    public override void finish(Boolean fromStart) {
        if (fromStart) {
            upsert tasksforUpsert;
            /* Sharing */
            ProjectSharingUtility.shareWithTeamMembers(projectAssignIds);
        }
        Diagnostics.pop();
    }
}