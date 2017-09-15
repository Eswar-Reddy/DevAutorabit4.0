public class skedJobHandler {
    
    public static void beforeInsert(List<sked__Job__c> newJobs) {
        updateJobDescription(newJobs);
    }
    
    public static void afterInsert(List<sked__Job__c> newJobs) {
        insertRelatedForms(newJobs);
    }
    
    public static void afterUpdate(List<sked__Job__c> newJobs, Map<Id, sked__Job__c> oldJobs) {
        onJobStatusChanges(newJobs, oldJobs);
    }
    
    private static void insertRelatedForms(List<sked__Job__c> newJobs) {
        string jobHazardAnalysisFormName = 'Job Hazard Analysis';
        string jobCheckoutFormName = 'Job Checkout Form';
        string siteSurveyFormName = 'Site Survey Form';
        
        List<Form_Template__c> formTemplates = [SELECT Id, Type__c,
                                                (SELECT Id, Order__c, Scope_of_Work__c, Potential_Safety_Risks_Issues__c, Mitigation_of_Potential_Risks__c
                                                 FROM Form_Template_Details__r
                                                 ORDER BY Order__c ASC)
                                                FROM Form_Template__c];
        Map<string, Form_Template__c> mapFormTemplate = new Map<string, Form_Template__c>();
        for (Form_Template__c formTemplate : formTemplates) {
            mapFormTemplate.put(formTemplate.Type__c, formTemplate);
        }
        
        List<Form__c> newForms = new List<Form__c>();
        List<Form__c> jobHazardAnalysisForms = new List<Form__c>();
        for (sked__Job__c job : newJobs) {
            if (job.sked__Type__c == skedConstants.JOB_TYPE_INSTALLATION) {
                Form__c jobHazardAnalysisForm = new Form__c(
                    Job__c = job.Id,
                    RecordTypeId = Schema.SObjectType.Form__c.getRecordTypeInfosByName().get(jobHazardAnalysisFormName).getRecordTypeId(),
                    Form_Record_Type__c = jobHazardAnalysisFormName
                );
                newForms.add(jobHazardAnalysisForm);
                jobHazardAnalysisForms.add(jobHazardAnalysisForm);
                Form__c jobCheckoutForm = new Form__c(
                    Job__c = job.Id,
                    RecordTypeId = Schema.SObjectType.Form__c.getRecordTypeInfosByName().get(jobCheckoutFormName).getRecordTypeId(),
                    Form_Record_Type__c = jobCheckoutFormName
                );
                newForms.add(jobCheckoutForm);
            }
            else if (job.sked__Type__c == skedConstants.JOB_TYPE_SITE_SURVEY) {
                Form__c siteSurveyForm = new Form__c(
                    Job__c = job.Id,
                    RecordTypeId = Schema.SObjectType.Form__c.getRecordTypeInfosByName().get(siteSurveyFormName).getRecordTypeId(),
                    Form_Record_Type__c = siteSurveyFormName
                );
                newForms.add(siteSurveyForm);
            }
        }
        if (!newForms.isEmpty()) {
            insert newForms;
        }
        if (!jobHazardAnalysisForms.isEmpty()) {
            if (mapFormTemplate.containsKey(jobHazardAnalysisFormName)) {
                Form_Template__c jobHazardAnalysisTemplate = mapFormTemplate.get(jobHazardAnalysisFormName);
                List<Job_Hazard_Analysis__c> analysisList = new List<Job_Hazard_Analysis__c>();
                for (Form__c form : jobHazardAnalysisForms) {
                    for (Form_Template_Detail__c detail : jobHazardAnalysisTemplate.Form_Template_Details__r) {
                        Job_Hazard_Analysis__c analysis = new Job_Hazard_Analysis__c(
                            Form__c = form.Id,
                            Order__c = detail.Order__c,
                            Scope_of_Work__c = detail.Scope_of_Work__c,
                            Potential_Safety_Risks_Issues__c = detail.Potential_Safety_Risks_Issues__c,
                            Mitigation_of_Potential_Risks__c = detail.Mitigation_of_Potential_Risks__c
                        );
                        analysisList.add(analysis);
                    }
                }
                if (!analysisList.isEmpty()) {
                    insert analysisList;
                }
            }
        }
    }
    
    private static void onJobStatusChanges(List<sked__Job__c> newJobs, Map<Id, sked__Job__c> oldJobs) {
        if (skedTriggerHandler.triggerSource == 'rescheduling_flow') {
            return;
        }
        List<sked__Job__c> processedJobs = new List<sked__Job__c>();
        Set<Id> completedJobIds = new Set<Id>();
        Set<Id> residentialProjectIds = new Set<Id>();
        Set<Id> recurringScheduleIds = new Set<Id>();
        
        for (sked__Job__c newJob : newJobs) {
            sked__Job__c oldData = oldJobs.get(newJob.Id);
            if (newJob.sked__Job_Status__c != oldData.sked__Job_Status__c) {
                processedJobs.add(newJob);
                residentialProjectIds.add(newJob.Residential_Project__c);
                
                if (newJob.sked__Job_Status__c == skedConstants.JOB_STATUS_COMPLETE || newJob.sked__Job_Status__c == skedConstants.JOB_STATUS_CANCELLED) {
                    completedJobIds.add(newJob.Id);
                    if (newJob.sked__Recurring_Schedule__c != NULL) {
                        recurringScheduleIds.add(newJob.sked__Recurring_Schedule__c);
                    }
                }
            }
        }
        if (processedJobs.isEmpty()) {
            return;
        }
        
        List<sked__Job__c> incompleteJobs = [SELECT Id, sked__Recurring_Schedule__c
                                             FROM sked__Job__c
                                             WHERE Id NOT IN :completedJobIds
                                             AND sked__Recurring_Schedule__c IN :recurringScheduleIds
                                             AND sked__Job_Status__c != :skedConstants.JOB_STATUS_COMPLETE
                                             AND sked__Job_Status__c != :skedConstants.JOB_STATUS_CANCELLED];
        Set<Id> incompleteScheduleIds = new Set<Id>();
        for (sked__Job__c incompleteJob : incompleteJobs) {
            incompleteScheduleIds.add(incompleteJob.sked__Recurring_Schedule__c);
        }
        
        List<Project_Task_Mapping__mdt> allMappings = [SELECT Label, Job_Type__c, Job_Statuses__c
                                                       FROM Project_Task_Mapping__mdt];
        Map<string, string> mapProjectTaskName = new Map<string, string>();
        for (Project_Task_Mapping__mdt mapping : allMappings) {
            List<string> jobStatuses = mapping.Job_Statuses__c.split(',');
            for (string jobStatus : jobStatuses) {
                mapProjectTaskName.put(mapping.Job_Type__c + ':' + jobStatus, mapping.Label);
            }
        }
        
        List<Project_Task__c> relatedProjectTasks = [SELECT Id, Residential_Project__c, Name, Status__c
                                                     FROM Project_Task__c
                                                     WHERE Residential_Project__c IN :residentialProjectIds
                                                     AND Name IN :mapProjectTaskName.values()
                                                     AND Status__c != :skedConstants.PROJECT_TASK_STATUS_COMPLETED];
        Map<string, Project_Task__c> mapProjectTask = new Map<string, Project_Task__c>();
        for (Project_Task__c projectTask : relatedProjectTasks) {
            mapProjectTask.put(projectTask.Residential_Project__c + ':' + projectTask.Name, projectTask);
        }
        
        Map<Id, Project_Task__c> mapProjectTasksToUpdate = new Map<Id, Project_Task__c>();
        for (sked__Job__c job : processedJobs) {
            string mapProjectTaskNameKey = job.sked__Type__c + ':' + job.sked__Job_Status__c;
            if (!mapProjectTaskName.containsKey(mapProjectTaskNameKey)) {
                continue;
            }
            string projectTaskName = mapProjectTaskName.get(mapProjectTaskNameKey);
            
            string mapProjectTaskKey = job.Residential_Project__c + ':' + projectTaskName;
            if (!mapProjectTask.containsKey(mapProjectTaskKey)) {
                continue;
            }
            if (job.sked__Job_Status__c == skedConstants.JOB_STATUS_COMPLETE || job.sked__Job_Status__c == skedConstants.JOB_STATUS_CANCELLED) {
                if (job.sked__Recurring_Schedule__c != NULL && incompleteScheduleIds.contains(job.sked__Recurring_Schedule__c)) {
                    continue;
                }
            }
            Project_Task__c relatedProjectTask = mapProjectTask.get(mapProjectTaskKey);
            relatedProjectTask.Status__c = skedConstants.PROJECT_TASK_STATUS_COMPLETED;
            relatedProjectTask.Document_Required__c = true;
            mapProjectTasksToUpdate.put(relatedProjectTask.Id, relatedProjectTask);
        }
        
        if (!mapProjectTasksToUpdate.isEmpty()) {
            update mapProjectTasksToUpdate.values();
        }
        
        if (!completedJobIds.isEmpty()) {
            List<sked__Job_Allocation__c> relatedAllocations = [SELECT Id
                                                                FROM sked__Job_Allocation__c
                                                                WHERE sked__Job__c IN :completedJobIds
                                                                AND sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_COMPLETE
                                                                AND sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DELETED
                                                                AND sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DECLINED];
            if (!relatedAllocations.isEmpty()) {
                for (sked__Job_Allocation__c jobAlloc : relatedAllocations) {
                    jobAlloc.sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_COMPLETE;
                }
                update relatedAllocations;
            }
        }
    }

    private static void updateJobDescription(List<sked__Job__c> newJobs) {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> regionIds = new Set<Id>();
        for (sked__Job__c job : newJobs) {
            if (job.sked__Account__c != NULL) {
                accountIds.add(job.sked__Account__c);
            }
            regionIds.add(job.sked__Region__c);
        }
        Map<Id, sked__Region__c> mapRegion = new Map<Id, sked__Region__c>([SELECT Id, Name
                                                                           FROM sked__Region__c
                                                                           WHERE Id IN :regionIds]);
        Map<Id, Account> mapAccount = new Map<Id, Account>([SELECT Id, Name
                                                            FROM Account
                                                            WHERE Id IN :accountIds]);
        for (sked__Job__c job : newJobs) {
            job.sked__Description__c = '';
            if (mapAccount.containsKey(job.sked__Account__c)) {
                Account acc = mapAccount.get(job.sked__Account__c);
                job.sked__Description__c += 'Account: ' + acc.Name;
                job.sked__Description__c += '\n';
            }
            job.sked__Description__c += 'Job Type: ' + job.sked__Type__c;
            job.sked__Description__c += '\n';
            
            sked__Region__c region = mapRegion.get(job.sked__Region__c);
            job.sked__Description__c += 'Region :' + region.Name;
            job.sked__Description__c += '\n';
        }
        
    }
}