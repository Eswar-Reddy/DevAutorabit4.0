/*********************************************************

@class      ProjectDashboardController

@about      Class to communicate with Project Dashboard page

@author     Sita Reeves (Redpoint)
            Gabriel Baca (Redpoint)

@created    2016-5-13

********************************************************/

global without sharing class ProjectDashboardController {
    public  Id                      chatterId           { get; set; }
    public  Id                      taskId              { get; set; }
    public  Id                      projectId           { get; set; }
    public  Boolean                 showChatter         { get; set; }
    public  Boolean                 showFiles           { get; set; }
    public  List<File>              files               { get; set; }
    public  List<File>              submittedFiles      { get; set; }
    public  List<File>              unSubmittedFiles    { get; set; }
    public  List<File>              submittedTaskFiles  { get; set; }
    public  List<File>              unSubmittedTaskFiles { get; set; }
    public  List<ProjectObject>     myProjectsList      { get; set; }
    public  List<TaskObject>        myTasksList         { get; set; }
    public  SelectListObject        selectListOptions   { get; set; }
    public  ChatterDocObject        chatterDocObject    { get; set; }
    public  enum                    objectType          { TASK, PROJECT }
    public  String                  selectedUser        { get; set; }
    public  String                  userSearchTerm      { get; set; }
    public  String                  userIdParameter     { get; set; }
    public  String                  userNameParameter   { get; set; }
    public  String                  selectedPartnerAccount { get; set; }
    public  String                  partnerSearchTerm      { get; set; }
    public  String                  partnerIdParameter     { get; set; }
    public  String                  partnerAccountParameter   { get; set; }

    // Record Type Ids
    public Id ttId  = ProjectTaskUtility.ttId; // Template Task
    public Id ptpId = ResidentialProjectUtility.ptpId; // Project Template

    public ProjectDashboardController() {
        // Load my tasks and my projects
        userIdParameter = System.currentPagereference().getParameters().get('userId');
        partnerIdParameter = System.currentPagereference().getParameters().get('partnerId');
        if (String.isNotBlank(userIdParameter)) {
            // Set user name parameter for display on page, so that user is aware of filter
            User[] user = [SELECT Name FROM User WHERE Id = :userIdParameter];

            userNameParameter = userIdParameter;
            if (user.size() > 0){
                userNameParameter = user[0].Name;
            }
            searchForUserById();
        } else {
            loadMyTasks('', true);
        }

        if (String.isNotBlank(partnerIdParameter)) {
            // Set partner account parameter for display on page
            Opportunity[] opp = [SELECT Partner_Account_text__c FROM Opportunity WHERE Partner_Account_text__c = : partnerIdParameter LIMIT 1];

            partnerAccountParameter = partnerIdParameter;
            if (opp.size() > 0){
                partnerAccountParameter = opp[0].Partner_Account_text__c;
            }
            loadMyProjectsByPartnerAccount();
        } else {
            loadMyProjects('');
        }

        // Initially set chatter and files section to hidden(false)
        showChatter = false;
        showFiles = false;

        selectListOptions = new SelectListObject();
    }

    // Javascript remote action called when searching for user
    @RemoteAction
    global static List<Opportunity> searchForPartnerAccount(String partnerSearchTerm) {
        List<Opportunity> partnerAccounts = new List<Opportunity>();
        Map<String, Opportunity> tempPartnerAcctMap = new Map<String, Opportunity>();
        if (String.isNotBlank(partnerSearchTerm)) {
            // Escape string to minimize SOQL injections
            String escapedPartnerAccount = String.escapeSingleQuotes(partnerSearchTerm);
            List<Opportunity> dbQuery = new List<Opportunity>();
            dbQuery = Database.query('SELECT Id, Partner_Account_text__c FROM Opportunity WHERE Partner_Account_text__c LIKE \'%' + escapedPartnerAccount + '%\' LIMIT 10');

            // Put the db query into a map
            for (Opportunity opp : dbQuery) {
                Opportunity tempOpp = new Opportunity();
                tempOpp = opp;

                if (!tempPartnerAcctMap.containsKey(opp.Partner_Account_text__c)) {
                    tempPartnerAcctMap.put(opp.Partner_Account_text__c, opp);
                }
            }

            // Add only unique map elements to list
            partnerAccounts.addAll(tempPartnerAcctMap.values());

            return partnerAccounts;
        } else {
            return partnerAccounts;
        }
    }

    // Javascript remote action called when searching for user
    @RemoteAction
    global static List<User> searchForUser(String userSearchTerm) {
        List<User> users = new List<User>();
        if (String.isNotBlank(userSearchTerm)) {
            // Escape string to minimize SOQL injections
            String escapedUserName = String.escapeSingleQuotes(userSearchTerm);
            users = Database.query('SELECT Id, Name FROM User WHERE Name LIKE \'%' + escapedUserName + '%\' LIMIT 10');
            return users;
        } else {
            return users;
        }
    }

    public PageReference loadMyProjectsByPartnerAccount() {
        String soqlWhereClause = ' AND Opportunity__r.Partner_Account_text__c=\'' + String.escapeSingleQuotes(partnerAccountParameter) + '\'';

        loadMyProjects(soqlWhereClause);

        return null;
    }

    public PageReference searchForUserById() {
        String soqlWhereClause = ' AND Assigned_to__c=\'' + String.escapeSingleQuotes(userIdParameter) + '\'';

        loadMyTasks(soqlWhereClause, false);

        return null;
    }

    public void loadMyTasks(String optionalWhereClause, Boolean onlyMyTasks) {
        myTasksList = new List<TaskObject>();
        List<Project_Task__c> tempMyTasks = new List<Project_Task__c>();
        List<Project_Task__c> tempTaskTypes = new List<Project_Task__c>();
        Map<Id, TaskObject> tempMyTasksMap = new Map<Id, TaskObject>();

        String myTasksDefaultSelectSOQL = 'SELECT Id, Name, Task_Type_Name__c, Status__c, Milestone__c, Start_DateTime__c, Residential_Project__r.Community__c, Residential_Project__r.Name, SLA_Days__c, SLA_Days_Aging__c, SLA_Flag__c, Residential_Project__r.Status__c, Overdue__c, Critical_Path__c, Project_Priority__c, Parent_Task__c, Parent_Task__r.Project_Priority__c, Parent_Task__r.Milestone__c, Task_Type__c FROM Project_Task__c';

        String myTasksDefaultWhereSOQL = ' WHERE (Status_Type__c = \'Open\' OR Status_Type__c = \'Hold\') AND (Residential_Project__r.Status__c = \'Active\' OR Residential_Project__r.Status__c = \'Hold\') AND (RecordTypeId != : ttId)';

        String myTasksIAmOwnerSOQL = ' AND I_am_Owner__c = true';

        String myTasksTypeWhereSOQL = ' WHERE (Task_Type__c = \'Ad Hoc\' OR Task_Type__c = \'Approval\' OR Task_Type__c = \'Escalation\') AND (Status_Type__c = \'New\' OR Status_Type__c = \'Open\' OR Status_Type__c = \'Hold\')';

        // Default my tasks query
        String tempMyTasksSOQL = myTasksDefaultSelectSOQL + myTasksDefaultWhereSOQL;
        // Find only projects with a certain task type.  Pivotal #126449147
        String tempTaskTypesSOQL = myTasksDefaultSelectSOQL + myTasksTypeWhereSOQL;

        // If onlyMyTasks is true then add the myTasksIAmOwnerSOQl to the query
        if (onlyMyTasks) {
            tempMyTasksSOQL += myTasksIAmOwnerSOQL;
            tempTaskTypesSOQL += myTasksIAmOwnerSOQL;
        }

        // Add optional where clause to queries
        if (String.isNotBlank(optionalWhereClause)) {
            tempMyTasksSOQL += optionalWhereClause;
            tempTaskTypesSOQL += optionalWhereClause;
        }

        // Default my tasks query
        tempMyTasks = Database.query(tempMyTasksSOQL);
        // Find only projects with a certain task type.  Pivotal #126449147
        tempTaskTypes = Database.query(tempTaskTypesSOQL);

        // Add tasks to my tasks list if there are any
        if (tempMyTasks != null && tempMyTasks.size() > 0) {
            for (Project_Task__c ptc : tempMyTasks) {
                system.debug('%%%2='+ptc);
                TaskObject tempTaskObject = new TaskObject(ptc);

                tempMyTasksMap.put(tempTaskObject.ptId, tempTaskObject);
            }
        }

        // Add tempTaskTypes list to tempMyTasksMap.  Pivotal #126449147
        if (tempTaskTypes != null && tempTaskTypes.size() > 0) {
            for (Project_Task__c ptcTaskType : tempTaskTypes) {
                TaskObject tempTaskObject = new TaskObject(ptcTaskType);

                if (!tempMyTasksMap.containsKey(tempTaskObject.ptId)) {
                    tempMyTasksMap.put(tempTaskObject.ptId, tempTaskObject);
                }
            }
        }

        // Get the values from the map and store back in the myTasksList
        myTasksList = tempMyTasksMap.values();
    }

    public void loadMyProjects(String optionalWhereClause) {
        myProjectsList = new List<ProjectObject>();
        List<Residential_Project__c> tempProjectsList = new List<Residential_Project__c>();

        String myProjectsDefaultSOQL = 'SELECT Id, Name, Status__c, Project_Days_Aging__c, Priority__c, Project_Number__c, Installation_Partner__c, Installation_Partner__r.Name, CreatedDate, Customer_City__c, Customer_State__c, Opportunity__r.Account_Name_text__c, Community__c, Community__r.Name, (SELECT Id, User__c FROM Project_Team_Members__r), (SELECT Id, Status__c, Active_Critical__c, Critical_Path__c, Name, Milestone__c, Task_Type_Name__c, Start_DateTime__c, SLA_Flag__c, SLA_Days_Aging__c, SLA_Days__c, Overdue__c, Assigned_to__c, Assigned_to__r.FirstName, Assigned_to__r.LastName, Status_Type__c FROM Project_Tasks__r ORDER BY Active_Critical__c DESC, Order__c ASC ), (SELECT Partner_Account__r.Name FROM Alliance_Partners__r) FROM Residential_Project__c';

        String myProjectsDefaultWhereSOQL = ' WHERE Id IN (SELECT Residential_Project__c FROM Project_Team_Member__c WHERE User__c =\'' + UserInfo.getUserId() + '\' AND Project_Dashboard_User__c = TRUE) AND (Status__c = \'Active\' OR Status__c = \'Hold\') AND RecordTypeId != \'' + ptpId +  '\'';

        // Default my tasks query
        String tempMyProjectsSOQL = myProjectsDefaultSOQL + myProjectsDefaultWhereSOQL;

        if (String.isNotBlank(optionalWhereClause)) {
            tempMyProjectsSOQL += optionalWhereClause;
        }

        tempProjectsList = Database.query(tempMyProjectsSOQL);

        if (tempProjectsList != null && tempProjectsList.size() > 0) {
            for (Residential_Project__c r : tempProjectsList) {
                myProjectsList.add(new ProjectObject(r));
            }
        }
    }

    public  pageReference displayChatter() {
        showChatter = true;
        showFiles = false;

        return null;
    }

    public pageReference displayProjectFiles() {
        chatterDocObject = new ChatterDocObject(objectType.PROJECT, projectId);

        showChatter = true;
        showFiles = true;
        return null;
    }

    public pageReference displayTaskFiles() {
        chatterDocObject = new ChatterDocObject(objectType.TASK, taskId);

        showChatter = true;
        showFiles = true;
        return null;
    }

    public pageReference approveTask() {
        Project_Task__c pt = new Project_Task__c();
        pt.Id = taskId;
        pt.Status__c = 'Approved';
        update pt;
        return null;
    }

    public class ChatterDocObject {
        public Id           taskProjectId           { get; set; }
        public Boolean      isTask                  { get; set; }
        public Boolean      isProject               { get; set; }
        public String       name                    { get; set; }
        public List<File>   taskFiles               { get; set; }
        public List<File>   projectFiles            { get; set; }
        public List<File>   projectSubmittedFiles   { get; set; }
        public List<File>   projectUnsubmittedFiles { get; set; }
        public List<File>   taskSubmittedFiles      { get; set; }
        public List<File>   taskUnsubmittedFiles    { get; set; }


        public ChatterDocObject(objectType type, Id objectId) {
            isTask = false;
            isProject = false;
            // taskProjectId is used for displaying the chatter feed for the project or task
            taskProjectId = objectId;

            if (type == objectType.TASK) {
                // Set is task to true
                isTask = true;

                // Get task name and set it
                name = [SELECT Name FROM Project_Task__c WHERE Id = : objectId].Name;

                // Get related task documents
                GetTaskDocuments(objectId);
            } else if (type == objectType.PROJECT) {
                // Set is project to true
                isProject = true;

                // Get project name and set it
                name = [SELECT Name FROM Residential_Project__c WHERE Id = : objectId].Name;

                // Get related project documents
                GetProjectDocuments(objectId);
            }
        }

        public void GetTaskDocuments(Id taskId) {
            taskFiles = new List<File>();
            taskSubmittedFiles = new List<File>();
            taskUnsubmittedFiles = new List<File>();

            // Load files uploaded through chatter
            List<ContentDocumentLink> cDocLinks = new List<ContentDocumentLink>();
            cDocLinks = [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = : taskId];
            for (ContentDocumentLink c : cDocLinks) {
                ProjectDashboardController.File f = new ProjectDashboardController.File(c.ContentDocument.Title, c.ContentDocumentId);
                taskFiles.add(f);
            }

            // Load files attached to Documents object of project task
            List<Document__c> docs = new List<Document__c>();
            docs = [SELECT Id, Name, Document_Type__c, (SELECT Id, Name FROM Attachments ) FROM Document__c WHERE Project_Task__c = : taskId];
            for (Document__c doc : docs) {
                if (doc.Attachments.size() > 0) {
                    ProjectDashboardController.File f = new ProjectDashboardController.File(doc.Name, doc.Id);
                    taskFiles.add(f);
                }
            }

            // Add any documents that have/have not been attached
            List<Document__c> docsSubmitted = new List<Document__c>();
            docsSubmitted = [SELECT Id, Name, Document_Type__c, (SELECT Id, Name FROM Attachments ) FROM Document__c WHERE Project_Task__c = : taskId];
            for (Document__c doc : docsSubmitted) {
                if (doc.Attachments.size() == 0) {
                    ProjectDashboardController.File f = new ProjectDashboardController.File(doc.Name, doc.Id);
                    taskUnsubmittedFiles.add(f);
                } else {
                    ProjectDashboardController.File f = new ProjectDashboardController.File(doc.Name, doc.Id);
                    taskSubmittedFiles.add(f);
                }
            }
        }

        public void GetProjectDocuments(Id projectId) {
            projectFiles = new List<File>();
            projectSubmittedFiles = new List<File>();
            projectUnsubmittedFiles = new List<File>();

            List<ContentDocumentLink> cDocLinks = new List<ContentDocumentLink>();
            cDocLinks = [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = : projectId];
            for (ContentDocumentLink c : cDocLinks) {
                ProjectDashboardController.File f = new ProjectDashboardController.File(c.ContentDocument.Title, c.ContentDocumentId);
                projectFiles.add(f);
            }

            List<ContentDocumentLink> cDocLinksProj = new List<ContentDocumentLink>();
            cDocLinksProj = [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM Project_Task__c WHERE Residential_Project__c = : projectId)];
            for (ContentDocumentLink c : cDocLinksProj) {
                ProjectDashboardController.File f = new ProjectDashboardController.File(c.ContentDocument.Title, c.ContentDocumentId);
                projectFiles.add(f);
            }

            List<Attachment> attachmentsList = new List<Attachment>();
            attachmentsList = [SELECT Id, Name FROM Attachment WHERE ParentId IN (SELECT Id FROM Document__c WHERE Residential_Project__c = : projectId)];
            for (Attachment a : attachmentsList) {
                ProjectDashboardController.File f = new ProjectDashboardController.File(a.Name, a.Id);
                projectFiles.add(f);
            }

            // Add any documents that have not been attached
            List<Document__c> docs = new List<Document__c>();
            docs = [SELECT Id, Name, Document_Type__c, (SELECT Id, Name FROM Attachments ) FROM Document__c WHERE Residential_Project__c = : projectId];
            for (Document__c doc : docs) {
                if (doc.Attachments.size() == 0) {
                    ProjectDashboardController.File f = new ProjectDashboardController.File(doc.Name, doc.Id);
                    projectUnsubmittedFiles.add(f);
                } else {
                    ProjectDashboardController.File f = new ProjectDashboardController.File(doc.Name, doc.Id);
                    projectSubmittedFiles.add(f);
                }
            }
        }
    }

    public class TaskObject {
        //public Project_Task__c  ptc                 { get; set; }
        public Boolean          isOverdue           { get; set; }
        public Boolean          showApproveBtn      { get; set; }
        public String           taskName            { get; set; }
        public String           priority            { get; set; }
        public Decimal          slaAging            { get; set; }
        public Decimal          sla                 { get; set; }
        public String           slaStatusOverdue    { get; set; }
        public String           projName            { get; set; }
        public Id               projId              { get; set; }
        public Id               ptId                { get; set; }
        public String           ptstatus            { get; set; }
        public String           community           { get; set; }

        public TaskObject(Project_Task__c projectTask) {
            system.debug('%%%% pt = '+projectTask);
            this.ptId       = projectTask.Id;
            this.isOverdue  = projectTask.Overdue__c;
            this.projName   = projectTask.Residential_Project__r.Name;
            this.projId     = projectTask.Residential_Project__c;
            this.ptstatus   = projectTask.Status__c;
            this.community  = projectTask.Residential_Project__r.Community__C;

            if (projectTask.Status__c == 'Pending Approval') {
                this.showApproveBtn = true;
            }
            if (projectTask.Parent_Task__c == NULL) {
                this.sla = projectTask.SLA_Days__c;
                this.slaAging = projectTask.SLA_Days_Aging__c;
                this.priority = projectTask.Project_Priority__c;
            } else {
                this.sla = NULL;
                this.slaAging = NULL;
                this.priority = projectTask.Parent_Task__r.Project_Priority__c;
            }

            // Used for filtering sla status. Pivotal ##125198371
            slaStatusOverdue = '';
            if (this.isOverdue && this.sla != NULL) {
                slaStatusOverdue = 'Overdue';
            } else if (!this.isOverdue && this.sla != NULL) {
                slaStatusOverdue = 'OnTime';
            }

            // If Task_Type_Name__c is null set taskName to Name otherwise set it to Task_Type_Name__c
            taskName = (projectTask.Task_Type_Name__c == null) ? projectTask.Name : projectTask.Task_Type_Name__c;
        }
    }

    public class ProjectObject {
        //public Residential_Project__c   rp                  { get; set; }
        public Boolean                  healthy             { get; set; }
        public List<String>             users               { get; set; }
        public Integer                  currentTaskIndex    { get; set; }
        public String                   currentTaskName     { get; set; }
        public String                   location            { get; set; }
        public String                   slaStatusOverdue    { get; set; }
        public Id                       rpId                { get; set; }
        public String                   rpName              { get; set; }
        public String                   rpNumber            { get; set; }
        public String                   rpCity              { get; set; }
        public String                   rpStatus            { get; set; }
        public Decimal                  rpDaysAging         { get; set; }
        public String                   rpPriority          { get; set; }
        public String                   ptMilestone         { get; set; }
        public String                   ptOwner             { get; set; }
        public Decimal                  ptSLA               { get; set; }
        public Decimal                  ptSLAAging          { get; set; }
        public Boolean                  hasTask             { get; set; }
        public Date                     rpStartDate         { get; set; }
        public String                   rpInstallation      { get; set; }   
        public Id                       ptId                { get; set; } 
        public String                   ptStatus            { get; set; } 
        public String                   community           { get; set; }

        public ProjectObject(Residential_Project__c theRP) {
            //this.rp         = theRP;
            Decimal sla     = 0;
            Decimal aging   = 0;
            currentTaskIndex = 0;
            currentTaskName = '';
            rpId            = theRP.Id;
            rpName          = theRP.Name;
            rpNumber        = theRP.Project_Number__c;
            rpCity          = theRP.Customer_City__c;
            rpStatus        = theRP.Status__c;
            rpDaysAging     = theRP.Project_Days_Aging__c;
            rpPriority      = theRP.Priority__c;
            rpInstallation  = theRP.Installation_Partner__r.Name;
            community       = theRP.Community__c;
            hasTask         = FALSE;


            Boolean currentTaskSelected = false;

            if (theRP.Project_Tasks__r.size() > 0) {
                // Set the customer location
                SetCustomerLocation(theRP.Customer_City__c, theRP.Customer_State__c);

                for (Integer i = 0; i < theRP.Project_Tasks__r.size(); i++) {

                    hasTask = TRUE;

                    // Find the current task.  This assumes that the related project tasks is brought in already ordered
                    if (currentTaskSelected == false && theRP.Project_Tasks__r[i].Critical_Path__c == true && (theRP.Project_Tasks__r[i].Status_Type__c == 'Open' || theRP.Project_Tasks__r[i].Status_Type__c == 'Hold')) {
                        // Set current task index for disply on the dashboard page
                        currentTaskIndex = i;
                        currentTaskSelected = true;
                        currentTaskName = (theRP.Project_Tasks__r[i].Task_Type_Name__c == null) ? theRP.Project_Tasks__r[i].Name : theRP.Project_Tasks__r[i].Task_Type_Name__c;
                        ptMilestone = theRP.Project_Tasks__R[i].Milestone__c;
                        ptOwner = theRP.Project_Tasks__R[i].Assigned_to__r.FirstName +' '+theRP.Project_Tasks__R[i].Assigned_to__r.LastName;
                        ptSLA = theRP.Project_Tasks__R[i].SLA_Days__c;
                        ptSLAAging = theRP.Project_Tasks__R[i].SLA_Days_Aging__c;
                        ptId = theRP.Project_Tasks__r[i].Id;
                        ptStatus = theRP.Project_Tasks__r[i].Status__c;

                    }

                    // Calculate overall SLA health of all critical path tasks
                    if (theRP.Project_Tasks__r[i].Critical_Path__c == true && theRP.Project_Tasks__r[i].SLA_Days_Aging__c != NULL && theRP.Project_Tasks__r[i].SLA_Days__c != NULL) {
                        sla += theRP.Project_Tasks__r[i].SLA_Days__c;
                        aging += theRP.Project_Tasks__r[i].SLA_Days_Aging__c;
                    }
                }
                

                this.healthy = (sla >= aging) ? true : false;

                // Used for filtering sla status. Pivotal ##125198371
                slaStatusOverdue = '';
                if (this.healthy && theRP.Project_Tasks__r[currentTaskIndex].SLA_Days__c != NULL) {
                    slaStatusOverdue = 'OnTime';
                } else if (!this.healthy && theRP.Project_Tasks__r[currentTaskIndex].SLA_Days__c != NULL) {
                    slaStatusOverdue = 'Overdue';
                }
            }

            // Build list of users associated to project
            users = new List<String>();
            Set<Id> uSet = new Set<Id>();
            for (Project_Team_Member__c ptm : theRP.Project_Team_Members__r) {
                if (ptm.User__c != null) {
                    uSet.add(ptm.User__c);
                }
            }

            if (theRP.Alliance_Partners__r.size() > 0){
                rpInstallation = '';
                for (Alliance_Partner__c ap : theRP.Alliance_Partners__r){
                    if (ap.Partner_Account__r.Name != null) rpInstallation += ap.Partner_Account__r.Name + '|';
                }
                if (rpInstallation == '') rpInstallation = null;
                else rpInstallation = rpInstallation.left(rpInstallation.length() - 1);
            }

            // The below is commented out because it caused a SOQl to many queries error
            // The users list was used on the projectdashboardpage to filter team members but
            // currently is not needed 7/15/16
            //for (Id u : uSet) {
            //    String uName = [SELECT Id, Name FROM User WHERE Id = : u].Name;
            //    users.add(uName);
            //}
        }

        public void SetCustomerLocation(String city, String state) {
            String tempLocation = 'Customer location not set';

            if (String.isBlank(city) && !String.isBlank(state)) {
                tempLocation = state;
            } else if (!String.isBlank(city) && String.isBlank(state)) {
                tempLocation = city;
            } else if (!String.isBlank(city) && !String.isBlank(state)) {
                tempLocation = city + ', ' + state;
            }

            location = tempLocation;
        }
    }

    public class File {
        public String   fileName    {get; set;}
        public Id       fileId      {get; set;}

        public File(String fName, Id fId) {
            fileName = fName;
            fileId = fId;
        }
    }

    public class SelectListObject {
        public List<SelectOption>   milestones      { get; set; }
        public List<SelectOption>   taskStatus      { get; set; }
        public List<SelectOption>   projectStatus   { get; set; }
        public List<SelectOption>   installPartner  { get; set; }
        public List<SelectOption>   teamMember      { get; set; }
        public List<SelectOption>   priority        { get; set; }
        public List<SelectOption>   slaStatus       { get; set; }
        public List<SelectOption>   taskPriority    { get; set; }
        public List<SelectOption>   communities     { get; set; }
        public List<SelectOption>   taskcommunities     { get; set; }
        
        public SelectListObject() {
            // Initialize all unique select lists
            setMilestoneSelectList();
            setTaskStatusSelectList();
            setProjectStatusSelectList();
            setInstallPartnerSelectList();
            //setTeamMemberSelectList();
            setPrioritySelectList();
            setSLAStatusSelectList();
            setTaskPrioritySelectList();
            setCommunitySelectList();
            setTaskCommunitySelectList();
        }

        public void setCommunitySelectList(){
            communities = new List<SelectOption>();
            Map<Id, String> commMap = new Map<Id, String>();
            for(Residential_Project__c rp : [SELECT Id, Community__c, Community__r.Name FROM Residential_Project__c WHERE Id IN (SELECT Residential_Project__c FROM Project_Team_Member__c WHERE User__c =: UserInfo.getUserId() AND Project_Dashboard_User__c = TRUE)]){
                if(rp.Community__c != NULL) commMap.put(rp.Community__c, rp.Community__r.Name);
            }
            communities.add(new SelectOption('',''));
            for(Id comm : commMap.keyset()){
                communities.add(new SelectOption(comm, commMap.get(comm)));
            }
        }

        public void setTaskCommunitySelectList(){
            taskcommunities = new List<SelectOption>();
            Map<Id, String> commMap = new Map<Id, String>();
            for(Project_Task__c pt : [SELECT Id, Residential_Project__r.Community__c, Residential_Project__r.Community__r.Name FROM Project_Task__c WHERE Assigned_To__c =: UserInfo.getUserId()]){
                if(pt.Residential_Project__r.Community__c != NULL) commMap.put(pt.Residential_Project__r.Community__c, pt.Residential_Project__r.Community__r.Name);
            }
            taskcommunities.add(new SelectOption('',''));
            for(Id comm : commMap.keyset()){
                taskcommunities.add(new SelectOption(comm, commMap.get(comm)));
            }
        }

        public void setMilestoneSelectList() {
            milestones = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Project_Task__c.Milestone__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            milestones.add(new SelectOption('', ''));
            for (Schema.PicklistEntry f : ple) {
                milestones.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        public void setTaskStatusSelectList() {
            taskStatus = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Project_Task__c.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            taskStatus.add(new SelectOption('', ''));
            for (Schema.PicklistEntry f : ple) {
                taskStatus.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        public void setProjectStatusSelectList() {
            projectStatus = new List<SelectOption>();

            projectStatus.add(new SelectOption('', ''));
            projectStatus.add(new SelectOption('Active', 'Active'));
            projectStatus.add(new SelectOption('Hold', 'Hold'));
        }

        public void setInstallPartnerSelectList() {
            installPartner = new List<SelectOption>();

            Set<String> prtnrSet = new Set<String>();
            for(Residential_Project__c rp : [SELECT Installation_Partner__r.Name, (SELECT Partner_Account__r.Name FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id IN (SELECT Residential_Project__c FROM Project_Team_Member__c WHERE User__c =: UserInfo.getUserId() AND Project_Dashboard_User__c = TRUE) AND (Status__c = 'Active' OR Status__c = 'Hold')]){
                if(rp.Installation_Partner__r.Name != NULL) prtnrSet.add(rp.Installation_Partner__r.Name);
                for (Alliance_Partner__c ap : rp.Alliance_Partners__r){
                    if (ap.Partner_Account__r.Name != null) prtnrSet.add(ap.Partner_Account__r.Name);
                }
            }
            installPartner.add(new SelectOption('',''));
            if (prtnrSet.size() > 0){
                List<String> prtnrList = new List<String>(prtnrSet);
                prtnrList.sort();
                for (String s : prtnrList) {
                    installPartner.add(new SelectOption(s,s));
                }
            }
        }

        //public void setTeamMemberSelectList() {
        //  teamMember = new List<SelectOption>();

        //  // Find all team members from residential projects and task owners and add to teamMember select list
        //  List<Project_Team_Member__c> ptmc = new List<Project_Team_Member__c>();
        //  ptmc = [SELECT Id, Role__c, User__c FROM Project_Team_Member__c];

        //  Set<Id> uSet = new Set<Id>();
        //  for (Project_Team_Member__c ptm : ptmc) {
        //      if (ptm.User__c != null) {
        //          uSet.add(ptm.User__c);
        //      }
        //  }

        //  teamMember.add(new SelectOption('', ''));
        //  for (Id u : uSet) {
        //      String uName = [SELECT Id, Name FROM User WHERE Id = : u].Name;
        //      teamMember.add(new SelectOption(uName, uName));
        //  }
        //  teamMember = sortSelectOptions(teamMember);
        //}

        public void setPrioritySelectList() {
            priority = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Residential_Project__c.Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            priority.add(new SelectOption('', ''));
            for (Schema.PicklistEntry f : ple) {
                priority.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        public void setTaskPrioritySelectList() {
            taskPriority = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = Project_Task__c.Project_Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            taskPriority.add(new SelectOption('', ''));
            for (Schema.PicklistEntry f : ple) {
                taskPriority.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        public void setSLAStatusSelectList() {
            slaStatus = new List<SelectOption>();

            slaStatus.add(new SelectOption('', ''));
            slaStatus.add(new SelectOption('OnTime', 'On-Time'));
            slaStatus.add(new SelectOption('Overdue', 'Overdue'));
        }

        public List<SelectOption> sortSelectOptions(List<SelectOption> sortingList) {
            if(sortingList.size() >0){
                for (Integer i = 0; i < sortingList.size(); i++) {
                    for (Integer j = i; j > 0; j--) {
                        if (sortingList[j - 1].getLabel() > sortingList[j].getLabel()) {
                            SelectOption temp = sortingList[j];
                            sortingList[j] = sortingList[j - 1];
                            sortingList[j - 1] = temp;
                        }
                    }
                }
            }
            return sortingList;
        }
    }
}