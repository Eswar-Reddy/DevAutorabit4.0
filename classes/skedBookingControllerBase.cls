global abstract class skedBookingControllerBase {
    
    protected skedGridBuilderBase gridBuilder;
    protected Set<Id> excludedJobIds;
    
    public skedGridBuilderBase.bookingGridModel bookingGrid {get;set;}
    public JobWrapper Wrapper {get;set;}
    
    public string rootRecordId {get;set;}
    public List<SelectOption> regionOptions {get;set;}
    public List<SelectOption> durationOptions {get;set;}
    public string selectedDate {get;set;}
    
    public boolean skipHolidays {get;set;}
    public boolean skipSaturdays {get;set;}
    public boolean skipSundays {get;set;}
    
    public boolean showBookingGrid {get;set;}
    public string entryMessage {get;set;}
    public string errorMessage {get;set;}

    public skedBookingControllerBase(ApexPages.StandardController stdCon) {
        this.rootRecordId = ApexPages.currentPage().getParameters().get('id');
        this.regionOptions = getRegionOptions();
        this.durationOptions = getDurationOptions();
        this.showBookingGrid = true;
        this.entryMessage = '';
        this.errorMessage = '';
        this.selectedDate = Json.serialize(system.today());
        
        this.skipHolidays = true;
        this.skipSaturdays = true;
        this.skipSundays = true;
        
        if (!validate()) {
            this.showBookingGrid = string.isBlank(this.entryMessage);
            return;
        }
        
        string jobId = ApexPages.currentPage().getParameters().get('jobId');
        if (!string.isBlank(jobId)) {
            sked__Job__c rescheduleJob = [SELECT Id, sked__Recurring_Schedule__c
                                          FROM sked__Job__c
                                          WHERE Id = :jobId];
            if (rescheduleJob.sked__Recurring_Schedule__c != NULL) {
                Map<Id, sked__Job__c> mapRescheduleJob = new Map<Id, sked__Job__c>([SELECT Id FROM sked__Job__c 
                                                                                    WHERE sked__Recurring_Schedule__c = :rescheduleJob.sked__Recurring_Schedule__c]);
                excludedJobIds = mapRescheduleJob.keySet();
            } 
            else {
                excludedJobIds = new Set<Id>();
                excludedJobIds.add(jobId);
            }
        }
        
        initialize(this.rootRecordId);
        this.showBookingGrid = string.isBlank(this.entryMessage);
        
        initializeServices();
        if (this.showBookingGrid) {
            loadBookingGrid(this.selectedDate);
        }
    }
    
    /***********************************************************Action Function************************************************************/
    public void Cmd_LoadBookingGrid() {
        this.selectedDate = ApexPages.currentPage().getParameters().get('selectedDate');
        loadBookingGrid(this.selectedDate);
    }
    
    public void Cmd_SaveJob() {
        //SavePoint sp = Database.setSavepoint();
        this.errorMessage = '';
        try {
            List<sked__Job__c> newJobs = new List<sked__Job__c>();
            saveJob(newJobs);
            cancelOldJobs();
            
            Set<Id> jobIds = new Set<Id>();
            for (sked__Job__c newJob : newJobs) {
                jobIds.add(newJob.Id);
            }
            skedSkeduloApiManager.dispatchJobs_future(jobIds);
        }
        catch (Exception ex) {
            this.errorMessage = ex.getMessage();
            system.debug('#ex#' + this.errorMessage);
            system.debug('#ex#' + ex.getStackTraceString());
            //Database.rollback(sp);
            this.Wrapper.SelectedDateTime = '';
        }
    }
    
    /***********************************************************Protected methods************************************************************/
    protected virtual boolean validate() {
        return true;
    }
    
    protected virtual void initializeServices() {}
    
    protected virtual string getJobType() {
        throw new skedSkedException('Please implement skedBookingControllerBase.getJobType method.');
    }
    
    protected virtual void populateResidentialProjectData(Residential_Project__c residentialProject) {} 
    
    protected skedModels.allocation findNearestResource(List<skedModels.allocation> allocations, Location targetLocation) {
        sked_Google_Api_Settings__c googleSetting = sked_Google_Api_Settings__c.getOrgDefaults();
        integer maxOrigins = 10;
        if (googleSetting.Max_Origins_Destinations__c != NULL) {
            maxOrigins = integer.valueOf(googleSetting.Max_Origins_Destinations__c);
        }
        
        List<skedModels.allocation> topNearestResources = new List<skedModels.allocation>();
        allocations.sort();
        if (allocations.size() <= maxOrigins) {
            topNearestResources.addAll(allocations);
        }
        else {
            for (integer i = 0; i < maxOrigins; i++) {
                skedModels.allocation allocation = allocations.get(i);
                topNearestResources.add(allocation);
            }
        }
        
        List<skedModels.geometry> inputGeometry = new List<skedModels.geometry>();
        for (skedModels.allocation allocation : topNearestResources) {
            if (allocation.startFromLocation == null) {
                continue;
            }
            skedModels.geometry geometry = allocation.startFromLocation;
            geometry.relatedId = allocation.resourceId;
            inputGeometry.add(geometry);
        }
        
        skedModels.geometry nearestLocation = findNearestLocation(inputGeometry, targetLocation);
        skedModels.allocation result;
        for (skedModels.allocation allocation : topNearestResources) {
            if (allocation.resourceId == nearestLocation.relatedId) {
                result = allocation;
                break;
            }
        }
        return result;
    }
    
    protected skedModels.geometry findNearestLocation(List<skedModels.geometry> inputGeometry, Location targetLocation) {
        if (inputGeometry == NULL || inputGeometry.isEmpty() || targetLocation == NULL) {
            return NULL;
        }
        sked_Google_Api_Settings__c googleSetting = sked_Google_Api_Settings__c.getOrgDefaults();
        integer maxOrigins = 10;
        if (googleSetting.Max_Origins_Destinations__c != NULL) {
            maxOrigins = integer.valueOf(googleSetting.Max_Origins_Destinations__c);
        }
        
        List<skedModels.geometry> topGeometry = new List<skedModels.geometry>();
        if (inputGeometry.size() <= maxOrigins) {
            topGeometry.addAll(inputGeometry);
        }
        else {
            for (skedModels.geometry geometry : inputGeometry) {
                geometry.distance = geometry.geoLoc.getDistance(targetLocation, 'km');
            }
            inputGeometry.sort();
            for (integer i = 0; i < maxOrigins; i++) {
                skedModels.geometry geometry = inputGeometry.get(i);
                topGeometry.add(geometry);
            }
        }
        
        skedModels.geometry result;
        
        List<string> origins = new List<string>();
        Map<integer, skedModels.geometry> mapGeometry = new Map<integer, skedModels.geometry>();
        for (integer i = 0; i < topGeometry.size(); i++) {
            skedModels.geometry geometry = topGeometry.get(i);
            string origin = geometry.latitude + ',' + geometry.longitude;
            origins.add(origin);
            mapGeometry.put(i, geometry);
        }
        
        string destination = targetLocation.getLatitude() + ',' + targetLocation.getLongitude();
        skedGoogleData.distanceMatrixResult matrixResult = skedGoogleMapServiceApi.calculateMultiDistances(origins, destination);
        if (matrixResult.hasError == false) {
            integer minDistance;
            for (integer i = 0; i < matrixResult.rows.size(); i++) {
                skedGoogleData.Row row = matrixResult.rows.get(i);
                skedGoogleData.Element element = row.elements.get(0);
                integer distance = element.distance.value;
                if (minDistance == NULL || minDistance > distance) {
                    minDistance = distance;
                    result = mapGeometry.get(i);
                }
            }
        }
        else {
            throw new skedSkedException('Google Distance Matrix API Error: ' + matrixResult.errorMessage);
        }
        
        return result;
    }
    
    protected virtual void loadBookingGrid(string selectedDateIso) {
        
    }
    
    protected virtual void saveJob(List<sked__Job__c> newJobs) {
        
    }
    
    protected virtual List<SelectOption> getDurationOptions() {
        sked_Booking_Setting__c bookingSetting = sked_Booking_Setting__c.getOrgDefaults();
        
        List<string> predefinedDurationOptions = bookingSetting.Predefined_Duration_Options__c.split(';');
        List<integer> durationList = new List<integer>();
        for (string predefinedValue : predefinedDurationOptions) {
            integer duration = integer.valueOf(predefinedValue);
            durationList.add(duration);
        }
        durationList.sort();
        
        List<SelectOption> durationOptions = new List<SelectOption>();
        for (integer duration : durationList) {
            durationOptions.add(new SelectOption(string.valueOf(duration), duration + ' minutes'));
        }
        return durationOptions;
    }
    
    /***********************************************************Private methods************************************************************/
    private void initialize(Id residentialPrjoectId) {
        //populate info from residential project
        Residential_Project__c residentialProject = [SELECT Id, Account__c, RecordTypeId, RecordType.Name, Installation_Partner__r.Name, Module_Quantity__c,
                                                     Customer_City__c, Customer_Country__c, Customer_State__c, Customer_Street__c, Customer_Zip__c,
                                                     Primary_Contact__c, Secondary_Contact__c
                                                     FROM Residential_Project__c
                                                     WHERE Id = :residentialPrjoectId];
        string address = '';
        if (!string.isBlank(residentialProject.Customer_Street__c)) {
            address += residentialProject.Customer_Street__c;
        }
        if (!string.isBlank(residentialProject.Customer_City__c)) {
            address += ', ' + residentialProject.Customer_City__c;
        }
        if (!string.isBlank(residentialProject.Customer_State__c)) {
            address += ', ' + residentialProject.Customer_State__c;
        }
        if (!string.isBlank(residentialProject.Customer_Zip__c)) {
            address += ' ' + residentialProject.Customer_Zip__c;
        }
        if (!string.isBlank(residentialProject.Customer_Country__c)) {
            address += ', ' + residentialProject.Customer_Country__c;
        }
        
        this.Wrapper = new JobWrapper();
        this.Wrapper.Job = new sked__Job__c(
            sked__Address__c = address,
            sked__Account__c = residentialProject.Account__c,
            sked__Contact__c = residentialProject.Primary_Contact__c,
            Residential_Project__c = residentialProject.Id,
            sked__Type__c = getJobType(),
            sked__Job_Status__c = skedConstants.JOB_STATUS_PENDING_DISPATCH
        );
        
        skedGoogleData.geocodeResult geocodeResult = skedGoogleMapServiceApi.getGeocode(address);
        system.debug('#geocodeResult#' + geocodeResult);
        if (geocodeResult.hasError == false) {
            skedGoogleData.geocodeResultItem geoData = geocodeResult.results.get(0);
            this.Wrapper.Job.sked__GeoLocation__Latitude__s = geoData.geometry.location.lat;
            this.Wrapper.Job.sked__GeoLocation__Longitude__s = geoData.geometry.location.lng;
        }
        else {
            this.entryMessage = 'Google Geocode API Error: ' + geocodeResult.errorMessage;
        }
        
        string regionName;
        if (residentialProject.RecordType.Name == skedConstants.RESIDENTIAL_TYPE_SPD) {
            if (residentialProject.Installation_Partner__r != NULL) {
                regionName = residentialProject.Installation_Partner__r.Name;
            }
            else {
                this.entryMessage = 'Please enter Installation Partner prior to booking.';
                return;
            }
        }
        else if (residentialProject.RecordType.Name == skedConstants.RESIDENTIAL_TYPE_TPS || residentialProject.RecordType.Name == skedConstants.RESIDENTIAL_TYPE_NEW_HOMES) {
            List<Alliance_Partner__c> alliancePartnerQuery = [SELECT Partner_Account_Text__c 
                                                              FROM Alliance_Partner__c
                                                              WHERE Residential_Project__c = :residentialProject.Id
                                                              AND (Role__c = 'IP' OR Role__c = 'Installation Partner')];
            if (!alliancePartnerQuery.isEmpty()) {
                Alliance_Partner__c alliance = alliancePartnerQuery.get(0);
                if (!string.isBlank(alliance.Partner_Account_Text__c)) {
                    regionName = alliance.Partner_Account_Text__c;
                }
                else {
                    this.entryMessage = 'Please select Parent Account for Alliance Partner prior to booking.';
                    return;
                }
            }
            else {
                this.entryMessage = 'Please create Alliance Partner prior to booking.';
                return;
            }
        }
        List<sked__Region__c> regionQuery = [SELECT Id FROM sked__Region__c WHERE Name = :regionName];
        if (!regionQuery.isEmpty()) {
            this.Wrapper.Job.sked__Region__c = regionQuery.get(0).Id;
        }
        else {
            this.entryMessage = 'Region ' + regionName + ' does not exist.';
            return;
        }
        
        //populate project task
        string jobDispatchedStatus = '%' + skedConstants.JOB_STATUS_DISPATCHED + '%';
        List<Project_Task_Mapping__mdt> mappings = [SELECT Label, Job_Statuses__c
                                                    FROM Project_Task_Mapping__mdt
                                                    WHERE Job_Type__c = :this.Wrapper.Job.sked__Type__c];
        Project_Task_Mapping__mdt dispatchedMapping, completeMapping;
        for (Project_Task_Mapping__mdt mapping : mappings) {
            if (mapping.Job_Statuses__c.contains(skedConstants.JOB_STATUS_DISPATCHED)) {
                dispatchedMapping = mapping;
            }
            if (mapping.Job_Statuses__c.contains(skedConstants.JOB_STATUS_COMPLETE)) {
                completeMapping = mapping;
            }
        }
        
        List<Project_Task__c> projectTaskQuery = [SELECT Id, Name, Status__c
                                                  FROM Project_Task__c
                                                  WHERE Residential_Project__c = :residentialProject.Id];
        if (!projectTaskQuery.isEmpty()) {
            Project_Task__c dispatchedProjectTask, completeProjectTask;
            for (Project_Task__c taskQueryItem : projectTaskQuery) {
                if (taskQueryItem.Name == dispatchedMapping.Label) {
                    dispatchedProjectTask = taskQueryItem;
                }
                if (taskQueryItem.Name == completeMapping.Label) {
                    completeProjectTask = taskQueryItem;
                }
            }
            if (completeProjectTask != NULL) {
                this.Wrapper.Job.Project_Task__c = completeProjectTask.Id;
            }
            if (dispatchedProjectTask != NULL && dispatchedProjectTask.Status__c != skedConstants.PROJECT_TASK_STATUS_INPROGRESS) {
                if (excludedJobIds == NULL || excludedJobIds.isEmpty()) {
                    boolean projectTaskValid = false;
                    if (this.Wrapper.Job.sked__Type__c == skedConstants.JOB_TYPE_SITE_SURVEY) {
                        for (Project_Task__c taskQueryItem : projectTaskQuery) {
                            if (taskQueryItem.Name == 'Perform Site Survey' && taskQueryItem.Status__c == skedConstants.PROJECT_TASK_STATUS_NEEDS_REWORK) {
                                projectTaskValid = true;
                                break;
                            }
                        }
                    }
                    if (!projectTaskValid) {
                        this.entryMessage = 'Project Task [' + dispatchedProjectTask.Name + '] needs to be in progress prior to booking.';
                        return;
                    }
                }
            }
        }
        
        populateResidentialProjectData(residentialProject);
    }
    
    private void cancelOldJobs() {
        if (this.excludedJobIds != NULL && !this.excludedJobIds.isEmpty()) {
            List<sked__Job__c> oldJobs = [SELECT Id,
                                          (SELECT Id
                                           FROM sked__Job_Allocations__r
                                           WHERE sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DELETED)
                                          FROM sked__Job__c WHERE Id IN :this.excludedJobIds];
            List<sked__Job_Allocation__c> jobAllocsToUpdate = new List<sked__Job_Allocation__c>();
            for (sked__Job__c oldJob : oldJobs) {
                oldJob.sked__Job_Status__c = skedConstants.JOB_STATUS_CANCELLED;
                for (sked__Job_Allocation__c jobAlloc : oldJob.sked__Job_Allocations__r) {
                    jobAlloc.sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_DELETED;
                    jobAllocsToUpdate.add(jobAlloc);
                }
            }
            skedTriggerHandler.triggerSource = 'rescheduling_flow';
            update oldJobs;
            if (!jobAllocsToUpdate.isEmpty()) {
                update jobAllocsToUpdate;
            }
        }
    }
    
    private List<SelectOption> getRegionOptions() {
        List<sked__Region__c> regions = [SELECT Id, Name FROM sked__Region__c];
        List<SelectOption> regionOptions = new List<SelectOption>();
        for (sked__Region__c region : regions) {
            regionOptions.add(new SelectOption(region.Id, region.Name));
        }
        return regionOptions;
    }
    
    /***********************************************************Nested Classes************************************************************/
    public class JobWrapper {
        public sked__Job__c Job {get;set;}
        public string SelectedDateTime {get;set;}
        public integer Duration {get;set;}
    }
    
}