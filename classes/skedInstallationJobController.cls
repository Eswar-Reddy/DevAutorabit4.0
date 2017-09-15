global class skedInstallationJobController extends skedBookingControllerBase {
    
    public skedInstallationJobController(ApexPages.StandardController stdCon) {
        super(stdCon);
    }
    
    /***********************************************************Override methods************************************************************/
    protected override boolean validate() {
    	boolean result = false;
        List<Project_Team_Member__c> teamMembers = [SELECT Id, User__c, Role__c, Residential_Project__c 
                                                    FROM Project_Team_Member__c 
                                                    WHERE Residential_Project__c = :this.rootRecordId 
                                                    AND User__c = :UserInfo.getUserId()];
        for (Project_Team_Member__c ptm : teamMembers){
            if (ptm.Role__c == 'Project Coordinator' || ptm.Role__c == 'Regional Operations Manager' || ptm.Role__c == 'Scheduler') {
                result = true;
                break;
            }
        }
        if (result == false) {
            this.entryMessage = 'Installation Jobs can only be scheduled by the Project Coordinator, the Regional Operations Manager, or the Scheduler.';
        }
        return result;
    }
    
    protected override void saveJob(List<sked__Job__c> newJobs) {
        sked__Region__c region = [SELECT Id, sked__Timezone__c FROM sked__Region__c WHERE Id = :this.Wrapper.Job.sked__Region__c];
        string timezoneSidId = region.sked__Timezone__c;
        DateTime selectedDateTime = (DateTime)Json.deserialize(this.Wrapper.selectedDateTime, DateTime.class);
        Location jobLocation = Location.newInstance(this.Wrapper.Job.sked__GeoLocation__Latitude__s, this.Wrapper.Job.sked__GeoLocation__Longitude__s);
        
        sked_Booking_Setting__c bookingSetting = sked_Booking_Setting__c.getOrgDefaults();
        integer startTimeInt = integer.valueOf(bookingSetting.Start_Working_Time__c);
        integer endTimeInt = integer.valueOf(bookingSetting.End_Working_Time__c);
        integer startTimeInMinutes = skedUtils.ConvertTimeNumberToMinutes(startTimeInt);
        integer endTimeInMinutes = skedUtils.ConvertTimeNumberToMinutes(endTimeInt);
        integer jobDuration = endTimeInMinutes - startTimeInMinutes;
        
        this.Wrapper.Job.sked__Start__c = selectedDateTime;
        this.Wrapper.Job.sked__Finish__c = skedUtils.addMinutes(selectedDateTime, jobDuration, timezoneSidId);
        this.Wrapper.Job.sked__Duration__c = jobDuration;
        
        skedModels.job job = new skedModels.job();
        job.allDay = true;
        job.start = this.Wrapper.Job.sked__Start__c;
        job.finish = this.Wrapper.Job.sked__Finish__c;
        job.geoLocation = jobLocation;
        skedInstallationGridBuilder.getFollowups(job, this.Wrapper.Duration, this.gridBuilder.holidays, skipHolidays, skipSaturdays, skipSundays, timezoneSidId);
        
        List<skedModels.job> jobs = new List<skedModels.job>();
        jobs.add(job);
        
        Map<Id, sked__Resource__c> mapResource = skedGridBuilderBase.getMapResource(region.Id, skedConstants.RESOURCE_CATEGORY_INSTALLATION_TECHNICIAN);
        skedAvailatorParams params = new skedAvailatorParams();
        params.resourceIds = mapResource.keySet();
        params.inputJobs = jobs;
        params.timezoneSidId = timezoneSidId;
        params.excludedJobIds = this.excludedJobIds;
        params.allocationChecking = false;
        skedAvailator validator = new skedAvailator(params);
        List<skedModels.allocation> availableAllocations = validator.getAvailableAllocations();
        skedModels.allocation nearestResource = findNearestResource(availableAllocations, jobLocation);
        
        Residential_Project__c residentialProject = [SELECT Id, Homeowner_Scheduled_Installation_Date__c ,
                                                     (SELECT Id, Assigned_To__c
                                                      FROM Project_Tasks__r
                                                      WHERE Name = 'System Installation Start' OR Name = 'System Installation Complete')
                                                     FROM Residential_Project__c
                                                     WHERE Id = :this.rootRecordId];
        residentialProject.Homeowner_Scheduled_Installation_Date__c = this.Wrapper.Job.sked__Start__c.date();
        update residentialProject;
        
        sked__Resource__c skedResource = [SELECT Id, sked__User__c FROM sked__Resource__c WHERE Id = :nearestResource.resourceId];
        for (Project_Task__c task : residentialProject.Project_Tasks__r) {
            task.Assigned_To__c = skedResource.sked__User__c;
        }
        update residentialProject.Project_Tasks__r;
        
        string summary = 'Repeats daily. Starting on ' + this.Wrapper.Job.sked__Start__c.format('MMMM dd, yyyy', timezoneSidId);
        summary += ', ending after ' + this.Wrapper.Duration + ' occurrences.';
        
        sked__Recurring_Schedule__c recurringSchedule = new sked__Recurring_Schedule__c(
            sked__Summary__c = summary,
            sked__Ack_All_Jobs__c = true
        );
        insert recurringSchedule;
        
        this.Wrapper.Job.sked__Recurring_Schedule__c = recurringSchedule.Id;
        
        newJobs.add(this.Wrapper.Job);
        for (skedModels.job followup : job.followups) {
            sked__Job__c skedFollowup = this.Wrapper.Job.clone();
            skedFollowup.sked__Start__c = followup.start;
            skedFollowup.sked__Finish__c = followup.finish;
            newJobs.add(skedFollowup);
        }
        insert newJobs;
        
        List<sked__Job_Allocation__c> newJobAllocs = new List<sked__Job_Allocation__c>();
        for (sked__Job__c skedJob : newJobs) {
            sked__Job_Allocation__c jobAlloc = new sked__Job_Allocation__c(
                sked__Job__c = skedJob.Id,
                sked__Resource__c = nearestResource.resourceId,
                sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_PENDING_DISPATCH
            );
            newJobAllocs.add(jobAlloc);
        }
        insert newJobAllocs;
    }
    
    protected override void initializeServices() {
        this.gridBuilder = new skedInstallationGridBuilder();
    }
    
    protected override string getJobType() {
        return skedConstants.JOB_TYPE_INSTALLATION;
    } 
    
    protected override void populateResidentialProjectData(Residential_Project__c residentialProject) {
        this.Wrapper.Duration = 1;
    } 
    
    protected override void loadBookingGrid(string selectedDateIso) {
        Date selectedDate = (Date)Json.deserialize(selectedDateIso, Date.class);
        Date startOfMonth = selectedDate.toStartOfMonth();
        Date endOfMonth = startOfMonth.addMonths(1).addDays(-1);
        
        Map<Id, sked__Resource__c> mapResource = skedGridBuilderBase.getMapResource(this.Wrapper.Job.sked__Region__c, skedConstants.RESOURCE_CATEGORY_INSTALLATION_TECHNICIAN);
        skedGridBuilderParams params = new skedGridBuilderParams();
        params.startDateIso = Json.serialize(startOfMonth);
        params.endDateIso = Json.serialize(endOfMonth);
        params.skipHolidays = this.skipHolidays;
        params.skipSaturdays = this.skipSaturdays;
        params.skipSundays = this.skipSundays;
        params.regionId = this.Wrapper.Job.sked__Region__c;
        params.duration = this.Wrapper.Duration;
        params.jobLocationLat = this.Wrapper.Job.sked__GeoLocation__Latitude__s; 
        params.jobLocationLong = this.Wrapper.Job.sked__GeoLocation__Longitude__s;
        params.resourceIds = mapResource.keySet();
        params.excludedJobIds = this.excludedJobIds;
        
        params.allocationChecking = false;
        
        this.gridBuilder.initialize(params);
        this.bookingGrid = gridBuilder.build();
    }
    
    protected override List<SelectOption> getDurationOptions() {
        List<SelectOption> durationOptions = new List<SelectOption>();
        for (integer i = 1; i <= 4; i++) {
            durationOptions.add(new SelectOption(string.valueOf(i), string.valueOf(i)));
        }
        return durationOptions;
    }
}