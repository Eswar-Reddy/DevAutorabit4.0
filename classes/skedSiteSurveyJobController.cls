global virtual class skedSiteSurveyJobController extends skedBookingControllerBase {
    
    public skedSiteSurveyJobController(ApexPages.StandardController stdCon) {
        super(stdCon);
    }
    
    /***********************************************************Override methods************************************************************/
    protected override void saveJob(List<sked__Job__c> newJobs) {
        sked__Region__c region = [SELECT Id, sked__Timezone__c FROM sked__Region__c WHERE Id = :this.Wrapper.Job.sked__Region__c];
        DateTime jobStart = (DateTime)Json.deserialize(this.Wrapper.selectedDateTime, DateTime.class);
        DateTime jobFinish = jobStart.addMinutes(this.Wrapper.Duration);
        Location jobLocation = Location.newInstance(this.Wrapper.Job.sked__GeoLocation__Latitude__s, this.Wrapper.Job.sked__GeoLocation__Longitude__s);
        
        this.Wrapper.Job.sked__Start__c = jobStart;
        this.Wrapper.Job.sked__Finish__c = jobFinish;
        this.Wrapper.Job.sked__Duration__c = this.Wrapper.Duration;
        
        List<skedModels.job> jobs = new List<skedModels.job>();
        skedModels.job job = new skedModels.job();
        job.start = jobStart;
        job.finish = jobFinish;
        job.geoLocation = jobLocation;
        jobs.add(job);
        
        Map<Id, sked__Resource__c> mapResource = skedGridBuilderBase.getMapResource(region.Id, getResourceCategory());
        skedAvailatorParams params = new skedAvailatorParams();
        params.resourceIds = mapResource.keySet();
        params.inputJobs = jobs;
        params.timezoneSidId = region.sked__Timezone__c;
        params.resourceIds = mapResource.keySet();
        params.excludedJobIds = this.excludedJobIds;
        skedAvailator validator = new skedAvailator(params);
        List<skedModels.allocation> availableAllocations = validator.getAvailableAllocations();
        skedModels.allocation nearestResource = findNearestResource(availableAllocations, jobLocation);
        
        updateRelatedProject(nearestResource.resourceId);
        
        newJobs.add(this.Wrapper.Job);
        insert this.Wrapper.Job;
        
        sked__Job_Allocation__c jobAlloc = new sked__Job_Allocation__c(
            sked__Job__c = this.Wrapper.Job.Id,
            sked__Resource__c = nearestResource.resourceId,
            sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_PENDING_DISPATCH
        );
        insert jobAlloc;
    }
    
    protected virtual void updateRelatedProject(string resourceId) {
        Residential_Project__c residentialProject = [SELECT Id, Scheduled_Site_Survey_Date__c,
                                                     (SELECT Id, Assigned_To__c
                                                      FROM Project_Tasks__r
                                                      WHERE Name = 'Perform Site Survey')
                                                     FROM Residential_Project__c
                                                     WHERE Id = :this.rootRecordId];
        residentialProject.Scheduled_Site_Survey_Date__c = this.Wrapper.Job.sked__Start__c;
        update residentialProject;
        
        sked__Resource__c skedResource = [SELECT Id, sked__User__c FROM sked__Resource__c WHERE Id = :resourceId];
        for (Project_Task__c task : residentialProject.Project_Tasks__r) {
            task.Assigned_To__c = skedResource.sked__User__c;
        }
        update residentialProject.Project_Tasks__r;
    }
    
    protected virtual override void initializeServices() {
        this.gridBuilder = new skedSiteSurveyGridBuilder();
    }
    
    protected virtual string getResourceCategory() {
        return skedConstants.RESOURCE_CATEGORY_SITE_SURVEYOR;
    }
    
    protected virtual override string getJobType() {
        return skedConstants.JOB_TYPE_SITE_SURVEY;
    } 
    
    protected virtual override void populateResidentialProjectData(Residential_Project__c residentialProject) {
        this.Wrapper.Duration = 120;
    } 
    
    protected override void loadBookingGrid(string selectedDateIsoString) {
        Date selectedDate = (Date)Json.deserialize(selectedDateIsoString, Date.class);
        Date startDate = selectedDate.toStartOfWeek();
        Date endDate = startDate.addDays(7);
        
        Map<Id, sked__Resource__c> mapResource = skedGridBuilderBase.getMapResource(this.Wrapper.Job.sked__Region__c, getResourceCategory());
        skedGridBuilderParams params = new skedGridBuilderParams();
        params.startDateIso = Json.serialize(startDate);
        params.endDateIso = Json.serialize(endDate);
        params.regionId = this.Wrapper.Job.sked__Region__c;
        params.duration = this.Wrapper.Duration;
        params.jobLocationLat = this.Wrapper.Job.sked__GeoLocation__Latitude__s; 
        params.jobLocationLong = this.Wrapper.Job.sked__GeoLocation__Longitude__s;
        params.resourceIds = mapResource.keySet();
        params.excludedJobIds = this.excludedJobIds;
        
        this.gridBuilder.initialize(params);
        this.bookingGrid = gridBuilder.build();
    }
}