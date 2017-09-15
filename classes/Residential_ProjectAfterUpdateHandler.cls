/*
    Created By: Sita Reeves - Residential Installation Project Mgmt
    Created On: March 2016

    Functions
    -----------------------------
    Project Status Changes
    Project Priority Changes
    Project Hold Data
    Template Creation
    Alliance Partner Creation
    IP User Assignment
    Roof Details
    Installation Model update on Quote

*/
public class Residential_ProjectAfterUpdateHandler extends TriggerHandlerBase{
    // -------- Constants --------
    Id ptId = ProjectTaskUtility.ptId; //Project Task Record Type Id
    Id adId = ProjectTaskUtility.adId; //Ad Hoc Record Type Id
    Id spdId = ResidentialProjectUtility.spdId; // RecordTypeId of 'SPD' for Residential Project
    Id tpsId = ResidentialProjectUtility.tpsId; // RecordTypeId of 'TPS' for Residential Project
    Id nhId = ResidentialProjectUtility.nhId; // RecordTypeId of 'New Home' for Residential Project

    // -------- Variables --------
    Map<Id, Id>                     quoteChangeMap;
    Map<Id, Id>                     quoteMapforFPO;
    List<Roof_Details__c>           roofsToDelete;
    Map<Id, String>                 priorityChange;
    List<Project_Task__c>           tasksPriorityUpdate;
    List<Residential_Project__c>    holdProjects;
    List<Residential_Project__c>    activeProjects;
    List<Residential_Project__c>    cancelledProjects;
    List<Residential_Project__c>    uncancelledProjects;
    List<Project_Task__c>           holdTasks;
    List<Project_Task__c>           uncancelTasks;
    List<Project_Hold_Data__c>      phdToUpsert;
    Map<Id, Project_Task__c>        tasksToUpdate; // Use map to prevent duplicates
    Map<Id, Id>                     modelAssignment;
    Map<Id, Id>                     qModelAssignment;
    List<Quote>                     quoteModels;
    List<Id>                        hoInstallChange;
    Map<Id, Id>                     newIMMap;
    Map<Id, Id>                     oldIMMap;
    List<Id>                        modelProjects;
    List<Id>                        oppTeamComplete;
    List<Quote>                     qToUpdate;
    Static Boolean                  cancelChatter = true;
    Set<Id>                         projectsICD;
    Map<Id,Id>                      changedInstallationModel;

    // Project Template Creation Variables
    Map<Id, Id>           projectSPD;
    Map<Id, Id>           projectTPS;
    Map<Id, Id>           projectNH;
    Set<Id>               comSet;

    // -------- Constructor --------
    public Residential_ProjectAfterUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ResidentialProjectAfterUpdateHandler qualifyStartingRecords');

        List<Residential_Project__c>    newRecords      = (List<Residential_Project__c>)newList;
        Map<Id, Residential_Project__c> oldMapRecords   = (Map<Id, Residential_Project__c>)oldMap;

        quoteChangeMap    = new Map<Id, Id>();
        quoteMapforFPO    = new Map<Id, Id>();
        priorityChange    = new Map<Id, String>();
        holdProjects      = new List<Residential_Project__c>();
        activeProjects    = new List<Residential_Project__c>();
        cancelledProjects = new List<Residential_Project__c>();
        uncancelledProjects = new List<Residential_Project__c>();
        hoInstallChange   = new List<Id>();
        tasksToUpdate     = new Map<Id, Project_Task__c>();
        comSet            = new Set<Id>();
        modelAssignment   = new Map<Id, Id>();
        qModelAssignment  = new Map<Id, Id>();
        projectSPD      = new Map<Id, Id>();
        projectTPS      = new Map<Id, Id>();
        projectNH       = new Map<Id, Id>();
        newIMMap        = new Map<Id, Id>();
        oldIMMap        = new Map<Id, Id>();
        modelProjects   = new List<Id>();
        oppTeamComplete = new List<Id>();
        qToUpdate       = new List<Quote>();
        projectsICD     = new Set<Id>();
        changedInstallationModel = new Map<Id,Id>();

        for(Residential_Project__c rp : newRecords){
            Residential_Project__c oldRP = oldMapRecords.get(rp.Id);

            /* Project on Hold */
            if((rp.Status__c == 'Hold' && oldRP.Status__c != 'Hold') || (rp.Status__c == 'Pending Cancellation' && oldRP.Status__c != 'Pending Cancellation')) holdProjects.add(rp);

            /* Project Active from Hold */
            if(rp.Status__c == 'Active' && (oldRP.Status__c == 'Hold' || oldRP.Status__c == 'Pending Cancellation')) activeProjects.add(rp);

            /* Project Cancelled */
            if(rp.Status__c == 'Cancelled' && oldRP.Status__c != 'Cancelled') cancelledProjects.add(rp);

            /* Uncancelled Projects */
            if(rp.Status__c == 'Active' && oldRP.Status__c == 'Cancelled') uncancelledProjects.add(rp);

            /* Quote Change */
            if(rp.Quote__c != oldRP.Quote__c) {
                quoteChangeMap.put(rp.Id, rp.Quote__c);
                quoteMapforFPO.put(rp.Quote__c, rp.Id);
                if(rp.Installation_Model__c != NULL && rp.RecordTypeId == tpsId) qModelAssignment.put(rp.Quote__c, rp.Installation_Model__c);
            }

            /* Priority Change */
            if(rp.Priority__c != oldRP.Priority__c) priorityChange.put(rp.Id, rp.Priority__c);

            /* Installation Model Assignment */
            if(rp.RecordTypeId == tpsId){
                if(rp.Installation_Model__c != NULL && rp.Installation_Model__c != oldRP.Installation_Model__c) {
                    if(oldRP.Installation_Model__c == NULL) {
                        modelAssignment.put(rp.Id, rp.Installation_Model__c);
                        modelProjects.add(rp.Id);
                    }
                    if(oldRP.Installation_Model__c != NULL) {
                        oldIMMap.put(rp.Id, oldRP.Installation_Model__c);
                        newIMMap.put(rp.Id, rp.Installation_Model__c);
                    }
                    if(rp.Quote__c != NULL) qModelAssignment.put(rp.Quote__c, rp.Installation_Model__c);
                }
            }

            // filtering the records for changed Installation Model and ignoring if previous value is Null 
            if(oldRP.Installation_Model__c!=Null && rp.Installation_Model__c != NULL && rp.Installation_Model__c != oldRP.Installation_Model__c){
                changedInstallationModel.put(rp.Id,rp.Installation_Model__c);
            }

            /* Homeowner Scheduled Installation Date */
            if(rp.Homeowner_Scheduled_Installation_Date__c != NULL && oldRP.Homeowner_Scheduled_Installation_Date__c != rp.Homeowner_Scheduled_Installation_Date__c) hoInstallChange.add(rp.Id);

            /* Template Creation */
            if(rp.Project_Template__c != NULL && oldRP.Project_Template__c == NULL){
                if(rp.RecordTypeId == spdId){
                    projectSPD.put(rp.Id, rp.Project_Template__c);
                }
                if(rp.RecordTypeId == tpsId){
                    projectTPS.put(rp.Id, rp.Project_Template__c);
                }
                if(rp.RecordTypeId == nhId){
                    projectNH.put(rp.Id, rp.Project_Template__c);
                    if(rp.Community__c != NULL) comSet.add(rp.Community__c);
                }
            }

            /* Opp Team Complete */
            if(rp.OppTeamComplete__c == TRUE && oldRP.OppTeamComplete__c == FALSE && rp.Installation_Model__c != NULL && rp.RecordTypeId == tpsId) {
                // Update Quote with Installation Model now that Opp Team is Complete
                Quote q = new Quote();
                q.Id = rp.Quote__c;
                q.Installation_Model__c = rp.Installation_Model__c;
                qToUpdate.add(q);
            }

            // get projects that need invoice compliance docs
            if(String.isNotBlank(rp.Installation_Model__c) && String.isBlank(oldRP.Installation_Model__c) && String.isNotBlank(rp.Quote__c) || String.isNotBlank(rp.Installation_Model__c) && String.isNotBlank(rp.Quote__c) && String.isBlank(oldRP.Quote__c)) {
                projectsICD.add(rp.Id);
            }
            System.debug('projectsICD: ' + projectsICD);
        }
    }

    public override void start() {
        holdTasks = new List<Project_Task__c>();
        uncancelTasks = new List<Project_Task__c>();
        phdToUpsert = new List<Project_Hold_Data__c>();
        quoteModels = new List<Quote>();

        /* Uncancelled Projects */
        if(uncancelledProjects.size() > 0){
            uncancelTasks = [SELECT Id, Status__c, Status_Type__c, Order__c, SLA_Days_Aging__c, Residential_Project__c, Residential_Project__r.Status__c, Residential_Project__r.Last_Completed_Step__c, (SELECT Id, End_DateTime__c FROM Task_Rework_Requests1__r WHERE Status__c = 'Open'),(SELECT Id, End_DateTime__c FROM Task_Rework_Requests__r WHERE Status__c = 'Open') FROM Project_Task__c WHERE Residential_Project__c IN: uncancelledProjects AND Status__c = 'Cancelled'];
            for(Project_Task__c pt : uncancelTasks){
                Decimal lastStep = pt.Residential_Project__r.Last_Completed_Step__c != NULL ? pt.Residential_Project__r.Last_Completed_Step__c +1 : 1 ;
                pt.Status__c = pt.Task_Rework_Requests1__r.size() > 0 ? 'Needs Rework' : pt.Task_Rework_Requests__r.size() > 0  ? 'Pending Rework' : pt.Order__c == lastStep ? 'In Progress' : 'Not Started';
                pt.Apex_Updated__c = System.currentTimeMillis();

                tasksToUpdate.put(pt.Id, pt);
            }
        }

        /* Project on Hold */
        if(holdProjects.size() > 0 || activeProjects.size() > 0 || cancelledProjects.size() > 0 ){
            holdTasks = [SELECT Id, Status__c, Status_Type__c, RecordTypeId, Task_Type__c, Residential_Project__r.Status__c, Residential_Project__r.Last_Completed_Step__c, (SELECT Id, End_DateTime__c FROM Task_Rework_Requests1__r WHERE Status__c = 'Open') FROM Project_Task__c WHERE (Residential_Project__c IN: holdProjects OR Residential_Project__c IN: activeProjects OR Residential_Project__c IN: cancelledProjects) AND RecordType.Name != 'Ad Hoc' ];
            for(Project_Task__c pt : holdTasks){
                if((pt.Residential_Project__r.Status__c == 'Hold' || pt.Residential_Project__r.Status__c == 'Pending Cancellation') && pt.Status_Type__c == 'Open'){
                    pt.Status__c = pt.Residential_Project__r.Status__c;
                    tasksToUpdate.put(pt.Id, pt);
                }
                if(pt.Residential_Project__r.Status__c == 'Active' && pt.Status_Type__c == 'Hold' && pt.Status__c != 'Pending Rework'){
                    if(pt.Task_Rework_Requests1__r.size() > 0 ){
                        pt.Status__c = pt.Status__c = 'Needs Rework';
                    }else{
                        pt.Status__c = 'In Progress';
                    }
                    tasksToUpdate.put(pt.Id, pt);
                }
                // Only cancel tasks that haven't been completed
                if(pt.Residential_Project__r.Status__c == 'Cancelled' && pt.Status__c != 'Completed'){
                    pt.Status__c = 'Cancelled';
                    tasksToUpdate.put(pt.Id, pt);
                }
            }

            for(Residential_Project__c rp : holdProjects){
                Project_Hold_Data__c phd = new Project_Hold_Data__c();
                phd.Residential_Project__c = rp.Id;
                phd.Hold_Justification__c = rp.Hold_Justification__c;
                phd.User__c = UserInfo.getUserId();
                phd.Start_DateTime__c = system.now();
                phd.Start_Status__c = rp.Status__c;
                phdToUpsert.add(phd);
            }

            for(Project_Hold_Data__c phd : [SELECT Id, End_DateTime__c, Residential_Project__r.Status__c FROM Project_Hold_Data__c WHERE (Residential_Project__c IN: activeProjects OR Residential_Project__c IN: cancelledProjects) AND End_DateTime__c = NULL]){
                phd.End_DateTime__c = system.now();
                phd.End_Status__c = phd.Residential_Project__r.Status__c;
                phdToUpsert.add(phd);
            }
        }

        /* Quote Change */
        // Remove connection between existing roof details and project. Attach roof details from updated Quote Id
        if(quoteChangeMap.size() > 0){
            roofsToDelete = [SELECT Id FROM Roof_Details__c WHERE Residential_Project__c IN: quoteChangeMap.keyset()];
            ResidentialProjectUtility.attachRoofDetails(quoteChangeMap);
        }

        if(quoteMapforFPO.size() > 0) LeasePaymentService.updateFPOtoRP(quoteMapforFPO);

        /* Priority Change */
        // Update priority for all non 'Ad Hoc' tasks
        if(priorityChange.size() > 0){
            tasksPriorityUpdate = [SELECT Id, Project_Priority__c, Residential_Project__c FROM Project_Task__c WHERE Residential_Project__c IN: priorityChange.keyset() AND RecordType.Name != 'Ad Hoc'];
            for(Project_Task__c pt : tasksPriorityUpdate) {
                pt.Project_Priority__c = priorityChange.get(pt.Residential_Project__c);
                tasksToUpdate.put(pt.Id, pt);
            }
        }

        /* Alliance Partner Creation */
        // If Installation Model was newly assigned, create Alliance Partner records
        if(modelAssignment.size() > 0) ResidentialProjectTPSUtility.createAlliancePartners(modelAssignment);

        // If Installation Model was changed, run delta on Alliance Partner records
        if( newIMMap.size() > 0) ResidentialProjectTPSUtility.changeAlliancePartners(newIMMap, oldIMMap);
        // If Installation Model was changed, run delta on Invoice Compliance Documents.
        if(changedInstallationModel.size() > 0) InvoiceComplianceDocumentUtility.InvoiceComplianceDocDelta(changedInstallationModel);

        /* Installation Model on Quote */
        // If the installation model is newly assigned or the quote is changed, update the installation model on the quote
        if(qModelAssignment.size() > 0){
            for(Id qId : qModelAssignment.keyset()){
                Quote q = new Quote();
                q.Id = qId;
                q.Installation_Model__c = qModelAssignment.get(qId);
                quoteModels.add(q);
            }
        }

        /* Homeowner Scheduled Installation Date Change */
        if(hoInstallChange.size() > 0) ResidentialProjectUtility.notifyECofHOInstallChange(hoInstallChange);

        //Add Chatter notifications on Cancelled Projects
        if (cancelledProjects.size() > 0 && cancelChatter){
            cancelChatter = false;
            String cancelMsg;
            List <Project_Team_Member__c> projTeamMember = [SELECT User__c, Residential_Project__c, Residential_Project__r.Name, Residential_Project__r.Cancellation_Justification__c FROM Project_Team_Member__c WHERE Role__c IN ('Project Manager', 'Project Coordinator', 'Regional Operations Manager') AND User__c <> NULL AND Residential_Project__c IN :cancelledProjects];

            for (Project_Team_Member__c ptm : projTeamMember){
                cancelMsg = ' Project ' + ptm.Residential_Project__r.Name + ' has been cancelled due to ' + ptm.Residential_Project__r.Cancellation_Justification__c + '. Please review the project to determine any required actions that must be completed to close out the project.';
                ProjectTaskUtility.postChatter(ptm.User__c, cancelMsg, ptm.Residential_Project__c);
            }
        }

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {
            if(roofsToDelete != NULL && roofsToDelete.size() > 0) delete roofsToDelete;
            update tasksToUpdate.values();
            upsert phdToUpsert;

            /* Quote Installation Model Update */
            try{
                if(quoteModels.size() > 0)  update quoteModels;
                if(qToUpdate.size() > 0)    update qToUpdate;
            }catch(Exception e){
                // Catch errors because there could be legitimate validation rules that fails at this time.
                system.debug('%%% Installation Model update on the Quote failed. Error=' + e.getMessage());
            }

            /* TEMPLATE CREATION */
            if(projectSPD.size() > 0){
                // Create Template records
                ResidentialProjectUtility.createTemplate(projectSPD, null);
            }

            if(projectNH.size() > 0){
                // Find User Assignment records
                Map<Id, Map<String,Id>> nhUserAssignment = new Map<Id, Map<String,Id>>();
                if(comSet.size() > 0) nhUserAssignment = ResidentialProjectUtility.nhUserAssignment(comSet);
                // Create Template records
                ResidentialProjectUtility.createTemplate(projectNH, nhUserAssignment);
            }

            // Create Template records
            if(projectTPS.size() > 0) ResidentialProjectUtility.createTemplate(projectTPS, NULL);

            // Run IM Aliance Partner User Assignment
            if(modelProjects.size() > 0) AlliancePartnerUtility.IMUserAssignment(modelProjects);

            // create invoice compliance docs
            if(!projectsICD.isEmpty()) {
                InvoiceComplianceDocumentUtility.createInvoiceComplianceDocuments(projectsICD);
            }
        }
        Diagnostics.pop();
    }
}