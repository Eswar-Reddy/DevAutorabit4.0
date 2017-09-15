/************************************************************************************************
Created By: Sita Reeves Redpoint
Created On: 4/27/16

* CreateTemplate - When a residential project is saved this method will try to find a Project Template
  with the same name as the Template Type. If a match is found it will create Project Team Member
  records and Project Task records that match the template.

************************************************************************************************/
public without sharing class ResidentialProjectUtility {
    public static Id spdId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('SPD').getRecordTypeId();
    public static Id tpsId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
    public static Id nhId  = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('New Home').getRecordTypeId();
    public static Id indirectId  = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Indirect').getRecordTypeId();
    public static Id ptpId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Project Template').getRecordTypeId();
    public static Id iprId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP Regions').getRecordTypeId();
    public static Id iptId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP Template').getRecordTypeId();
    public static Id ipuId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP User Assignment').getRecordTypeId();
    public static Id nhuId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('NH User Assignment').getRecordTypeId();

    public static Boolean runValidation = TRUE; // Used to bypass custom project field validation ex. when cancellation agreement is created update status without validation

    public static void createTemplate(Map<Id, Id> templateMap, Map<Id, Map<String, Id>> userAssignment) {

        // Constants //
        Id ptId  = ProjectTaskUtility.ptId; // Project Task 'Project Task' RecordTypeId


        // Variables //
        List<Project_Team_Member__c>    templateMembers     = new List<Project_Team_Member__c>();
        List<Document__c>               templateDocuments   = new List<Document__c>();
        Map<Id, Project_Task__c>        templateTasks       = new Map<Id, Project_Task__c>();
        Map<Id, Map<String, Id>>        ipUserAssignment    = new Map<Id, Map<String, Id>>();


        // Query for template: Team Members, Tasks, Documents
        Map<Id, Residential_Project__c> templates = new Map<Id, Residential_Project__c>([SELECT Id,
                Name,
                (SELECT Role__c, Project_Dashboard_User__c, User__c FROM Project_Team_Members__r),
                (SELECT Name, Task_Type__c, Task_Type_Name__c, Description__c, Milestone__c, Role_Assignment__c, Order__c, Critical_Path__c, SLA_Days__c, Document_Required__c FROM Project_Tasks__r),
                (SELECT Name, Document_Type__c, Project_Task__c FROM Documents__r where Invoice_Document_data__c = Null)
                FROM Residential_Project__c
                WHERE Id IN: templateMap.values()]);

        // Query new projects existing documents to cross reference the template
        Map<Id, Residential_Project__c> newProjectsMap = new Map<Id, Residential_Project__c>([SELECT Id, Name, Opportunity__r.OwnerId, RecordType.Name, Community__c, Installation_Model__c, Installation_Partner__c, (SELECT Id, Name, Opportunity__c, Document_Type__c FROM Documents__r WHERE Document_Type__c != NULL) FROM Residential_Project__c WHERE Id IN: templateMap.keyset()]);


        for (Id rpId : templateMap.keyset()) {
            Map<String, Id> assignmentMap = new Map<String, Id>();
            // Find Related Template
            Residential_Project__c template = templates.get(templateMap.get(rpId));
            Residential_Project__c project = newProjectsMap.get(rpId);

            // Create Project Team Member records
            if(template.Project_Team_Members__r.size() > 0) {
                for(Project_Team_Member__c ptm : template.Project_Team_Members__r) {
                    Project_Team_Member__c m    = new Project_Team_Member__c();
                    m.Role__c                   = ptm.Role__c;
                    m.Residential_Project__c    = rpId;
                    m.User__c                   = ptm.User__c;
                    m.Project_Dashboard_User__c = ptm.Project_Dashboard_User__c;
                    templateMembers.add(m);
                    if(m.Role__c == 'Energy Consultant' && project.Opportunity__c != NULL) {
                        m.User__c = project.Opportunity__r.OwnerId;
                    }

                    // SPD - Loop through the IP User Assignment records to see if there is a match
                    if(project.RecordType.Name == 'SPD'){
                        if(userAssignment != null && !userAssignment.isEmpty() && project.Installation_Partner__c != NULL) {
                            for(String role : userAssignment.get(project.Installation_Partner__c).keyset()) {
                                if(role == ptm.Role__c) {
                                    m.User__c = userAssignment.get(project.Installation_Partner__c).get(role);
                                }
                            }
                        }
                    }

                    // New Home - Loop through the NH User Assignment records to see if there is a match
                    if(project.RecordType.Name == 'New Home'){
                        if(userAssignment.size() > 0 && project.Community__c != NULL) {
                            for(String role : userAssignment.get(project.Community__c).keyset()) {
                                if(role == ptm.Role__c) {
                                    m.User__c = userAssignment.get(project.Community__c).get(role);
                                }
                            }
                        }
                    }

                    if(ptm.User__c != NULL) {
                        assignmentMap.put(ptm.Role__c, ptm.User__c);
                    }
                }
            }

            // Create Project Task records
            if (template.Project_Tasks__r.size() > 0) {
                for (Project_Task__c pt : template.Project_Tasks__r) {
                    Project_Task__c t           = new Project_Task__c();
                    t.RecordTypeId              = ptId;
                    t.Task_Type__c              = 'Task';
                    t.Residential_Project__c    = rpId;
                    t.Name                      = pt.Name;
                    t.Task_Type_Name__c         = pt.Task_Type_Name__c;
                    t.Order__c                  = pt.Order__c;
                    t.Description__c            = pt.Description__c;
                    t.Document_Required__c      = pt.Document_Required__c;
                    t.SLA_Days__c               = pt.SLA_Days__c;
                    t.Role_Assignment__c        = pt.Role_Assignment__c;
                    t.Critical_Path__c          = pt.Critical_Path__c;
                    t.Milestone__c              = pt.Milestone__c;
                    t.Template_Task__c          = pt.Id;
                    t.Assigned_To__c            = assignmentMap.containsKey(pt.Role_Assignment__c) ? assignmentMap.get(pt.Role_Assignment__c) : project.Opportunity__c != NULL ? project.Opportunity__r.OwnerId : UserInfo.getUserId();
                    t.Status__c                 = (pt.Order__c == 1) ? 'In Progress' : 'Not Started';
                    t.Start_DateTime__c         = (pt.Order__c == 1) ? System.Now() : NULL;
                    t.Elapsed_DateTime__c       = (pt.Order__c == 1) ? System.Now() : NULL;
                    // Put Template Task Id as key so that we can lookup Task Document relationship
                    templateTasks.put(pt.Id, t);
                }
            }
        }


        insert templateTasks.values();
        insert templateMembers;


        for (Id rpId : templateMap.keyset()) {
            // Find Related Template
            Residential_Project__c template = templates.get(templateMap.get(rpId));

            // Create Documents records
            if (template.Documents__r.size() > 0) {
                for (Document__c dt : template.Documents__r) {
                    // Some documents get automatically related to the project from the opportunity
                    // cross reference the existing documents against the template to remove duplicates
                    // if template document is related to a task, relate existing document to the task
                    Boolean documentFound = false;
                    for (Document__c ed : newProjectsMap.get(rpId).Documents__r) {
                        if (dt.Document_Type__c == ed.Document_Type__c) {
                            documentFound = true;
                            if (dt.Project_Task__c != NULL) {
                                ed.Project_Task__c = templateTasks.get(dt.Project_Task__c).Id;
                                templateDocuments.add(ed);
                            }
                        }
                    }
                    // If no existing document of that type is found, create document placeholder
                    if (!documentFound) {
                        if (dt.Project_Task__c != NULL) {
                            Document__c d               = new Document__c();
                            d.Residential_Project__c    = rpId;
                            d.Project_Task__c           = templateTasks.get(dt.Project_Task__c).Id;
                            d.Name                      = dt.Name;
                            d.Document_Type__c          = dt.Document_Type__c;
                            templateDocuments.add(d);
                        } else {
                            Document__c d               = new Document__c();
                            d.Residential_Project__c    = rpId;
                            d.Name                      = dt.Name;
                            d.Document_Type__c          = dt.Document_Type__c;
                            templateDocuments.add(d);
                        }
                    }
                }
            }
        }
        upsert templateDocuments;
    }
    // Map = Project Id, Quote Id
    public static void attachRoofDetails(Map<Id, Id> quoteMap) {
        List<Roof_Details__c> roofsToUpdate = new List<Roof_Details__c>();
        List<Roof_Details__c> roofs = [SELECT Id, Residential_Project__c, Roof_Design__r.Quote__c FROM Roof_Details__c WHERE Roof_Design__r.Quote__c != null AND Roof_Design__r.Quote__c IN: quoteMap.values()];
        Set<Id> rpIdSet = new Set<Id>();
        for (Id rpId : quoteMap.keyset()) {
            for (Roof_Details__c roof : roofs) {
                if (roof.Roof_Design__r.Quote__c == quoteMap.get(rpId)) {
                    roof.Residential_Project__c = rpId;
                    roofsToUpdate.add(roof);
                    rpIdSet.add(rpId);
                }
            }
        }
        for(Id rId : rpIdSet){
            quoteMap.remove(rId);
        }
        update roofsToUpdate;
    }

    // If the Alliance Partners change on a SPD project, get all IP User Assignment records and update the project team member assignment
    public static void updateTeamRoles(List<Alliance_Partner__c> partners) {
        Map<Id, Project_Team_Member__c> ptmUpdateMap = new Map<Id, Project_Team_Member__c>();
        Map<String, Map<String, Id>> projectTeamMap = new Map<String, Map<String, Id>>();
        Set<Id> rpSet   = new Set<Id>();
        Set<Id> accSet  = new Set<Id>();

        // Create set of project and partners
        for(Alliance_Partner__c ap : partners){
            rpSet.add(ap.Residential_Project__c);
            accSet.add(ap.Partner_Account__c);
        }

        // Query projects with sub queriy for project team members
        Map<Id, Residential_Project__c> projects = new Map<Id, Residential_Project__c>([SELECT Id, (SELECT Id, Role__c, User__c FROM Project_Team_Members__r) FROM Residential_Project__c WHERE Id IN: rpSet]);

        // Query all PIS where the partner account is referenced
        List<Project_Installation_Setting__c> settings = [SELECT User__c, Role__c, Installation_Partner__c, Partner_Role__c FROM Project_Installation_Setting__c WHERE RecordTypeId = : ipuId AND Installation_Partner__c IN: accSet];

        // create a map of partner + role as key and User with Role as value map
        for(Project_Installation_Setting__c pis : settings){
            String apKey = String.valueOf(pis.Installation_Partner__c) + pis.Partner_Role__c;
            if(projectTeamMap.containsKey(apKey)){
                projectTeamMap.get(apKey).put(pis.Role__c, pis.User__c);
            }else{
                projectTeamMap.put(apKey, new Map<String, Id>{pis.Role__c => pis.User__c});
            }
        }

        // Run through projects and update project team members based on the partner + role key
        for(Alliance_Partner__c ap : partners){
            Residential_Project__c rp = projects.get(ap.Residential_Project__c);
            String apKey = String.valueOf(ap.Partner_Account__c) + ap.Role__c;
            Map<String, Id> userMap = projectTeamMap.get(apKey);
            if(rp.Project_Team_Members__r != null) {
                for(Project_Team_Member__c ptm : rp.Project_Team_Members__r){
                    if(userMap != null) {
                        for(String role : userMap.keyset()){
                            if(role == ptm.Role__c && userMap.containsKey(role) && userMap.get(role) != ptm.User__c){
                                ptm.User__c = userMap.get(role);
                                ptmUpdateMap.put(ptm.Id, ptm);
                            }
                        }
                    }
                }
            }
        }
        update ptmUpdateMap.values();
    }

    public static void notifyECofHOInstallChange(List<Id> projects){
        List<Residential_Project__c> projs = [SELECT Id, Name, Homeowner_Scheduled_Installation_Date__c, (SELECT User__c FROM Project_Team_Members__r WHERE Role__c = 'Energy Consultant' LIMIT 1) FROM Residential_Project__c WHERE Id IN: projects];
        for(Residential_Project__c r : projs){
            if(r.Project_Team_Members__r.size() >0){
                String body = ' System installation for '+ r.Name +' has been scheduled for '+ string.valueof(r.Homeowner_Scheduled_Installation_Date__c);
                ProjectTaskUtility.postChatter(r.Project_Team_Members__r[0].User__c, body, r.Id);
            }
        }
    }

    // Query Current Rate Code and Proposed Rate Code from Electric Rate Usage Input related to Account.
    public static void getSolarRateSchedule(List<Residential_Project__c> projects){
        Map<Id, Electric_Rate_Usage_Input__c> accRateMap = new Map<Id, Electric_Rate_Usage_Input__c>();
        
        for(Residential_Project__c p : projects){
            accRateMap.put(p.Account__c, NULL);
        }

        // Accounts should have only 1 ERUI record
        for(Electric_Rate_Usage_Input__c er : [SELECT Id, Current_Rate_Code__c, Proposed_Rate_Code__c, Account__c FROM Electric_Rate_Usage_Input__c WHERE Account__c IN: accRateMap.keyset()]){
            accRateMap.put(er.Account__c, er);
        }

        for(Residential_Project__c p : projects){
            if(accRateMap.containsKey(p.Account__c) && accRateMap.get(p.Account__c) != NULL){
                p.Proposed_Rate_Plan__c = accRateMap.get(p.Account__c).Proposed_Rate_Code__c;
                p.Current_Rate_Plan__c = accRateMap.get(p.Account__c).Current_Rate_Code__c;
            }
        }
    }

    public static void findTemplate(Map<Residential_Project__c, Id> projectMap) {
        Map<Id, Id> templateMap = new Map<Id, Id>();
        // Query for IP Templates
        for (Project_Installation_Setting__c ps : [SELECT Id, Installation_Partner__c, Project_Template__c FROM Project_Installation_Setting__c WHERE Installation_Partner__c IN: projectMap.values() AND RecordTypeId = : iptId]) {
            templateMap.put(ps.Installation_Partner__c, ps.Project_Template__c);
        }
        // Assign Project Template to Residential Project based on IP
        for (Residential_Project__c p : projectMap.keyset()) {
            if (templateMap.containsKey(p.Installation_Partner__c)) p.Project_Template__c = templateMap.get(p.Installation_Partner__c);
        }
    }

    /* User Assignment Settings */

    // SPD IP User Assignment
    public static Map<Id, Map<String, Id>> spdUserAssignment(Set<Id>  ipSet){
        Map<Id, Map<String, Id>>        ipUserAssignment    = new Map<Id, Map<String, Id>>();
        for (Project_Installation_Setting__c pis : [SELECT User__c, Role__c, Installation_Partner__c FROM Project_Installation_Setting__c WHERE RecordTypeId = : ipuId AND Installation_Partner__c IN: ipSet]) {
            if (ipUserAssignment.containsKey(pis.Installation_Partner__c)) {
                ipUserAssignment.get(pis.Installation_Partner__c).put(pis.Role__c, pis.User__c);
            } else {
                ipUserAssignment.put(pis.Installation_Partner__c, new Map<String, Id> {pis.Role__c => pis.User__c});
            }
        }
        return ipUserAssignment;
    }

    // NH Community User Assignment
    public static Map<Id, Map<String, Id>> nhUserAssignment(Set<Id> comSet){
        Map<Id, Map<String, Id>>        ipUserAssignment    = new Map<Id, Map<String, Id>>();
        for (Project_Installation_Setting__c pis : [SELECT User__c, Role__c, Community__c FROM Project_Installation_Setting__c WHERE RecordTypeId = : nhuId AND Community__c IN: comSet]) {
            if (ipUserAssignment.containsKey(pis.Community__c)) {
                ipUserAssignment.get(pis.Community__c).put(pis.Role__c, pis.User__c);
            } else {
                ipUserAssignment.put(pis.Community__c, new Map<String, Id> {pis.Role__c => pis.User__c});
            }
        }
        return ipUserAssignment;
    }
}