global class skedInspectionJobController extends skedSiteSurveyJobController {
    
    public skedInspectionJobController(ApexPages.StandardController stdCon) {
        super(stdCon);
    }
    
    /***********************************************************Override methods************************************************************/
    protected override void initializeServices() {
        this.gridBuilder = new skedInspectionGridBuilder();
    }
    
    protected override void updateRelatedProject(string resourceId) {
        Residential_Project__c residentialProject = [SELECT Id, Scheduled_AHJ_Inspection__c ,
                                                     (SELECT Id, Assigned_To__c
                                                      FROM Project_Tasks__r
                                                      WHERE Name = 'Complete Inspection')
                                                     FROM Residential_Project__c
                                                     WHERE Id = :this.rootRecordId];
        residentialProject.Scheduled_AHJ_Inspection__c = this.Wrapper.Job.sked__Start__c;
        update residentialProject;
        
        sked__Resource__c skedResource = [SELECT Id, sked__User__c FROM sked__Resource__c WHERE Id = :resourceId];
        for (Project_Task__c task : residentialProject.Project_Tasks__r) {
            task.Assigned_To__c = skedResource.sked__User__c;
        }
        update residentialProject.Project_Tasks__r;
    }
    
    protected override string getJobType() {
        return skedConstants.JOB_TYPE_INSPECTION;
    } 
    
    protected override void populateResidentialProjectData(Residential_Project__c residentialProject) {
        this.Wrapper.Duration = 60;
    } 
    
    protected override string getResourceCategory() {
        return skedConstants.RESOURCE_CATEGORY_INSPECTOR;
    }

}