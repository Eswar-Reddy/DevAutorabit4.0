global abstract class skedGridBuilderBase {
    
    public Set<Date> holidays {get;set;}
    
    protected skedGridBuilderParams params {get;set;}
    protected sked_Booking_Setting__c bookingSetting;
    protected Date startDate {get;set;}
    protected Date endDate {get;set;}
    protected integer startWorkingTimeInMinute;
    protected integer endWorkingTimeInMinute;
    
    /***********************************************************Constructor************************************************************/
    public skedGridBuilderBase() {
        this.holidays = new Set<Date>();
    }
    
    public void initialize(skedGridBuilderParams params) {
        if (string.isBlank(params.timezoneSidId)) {
            sked__Region__c region = [SELECT Id, sked__Timezone__c FROM sked__Region__c WHERE Id = :params.regionId];
            params.timezoneSidId = region.sked__Timezone__c;
        }
        if (params.resourceIds == NULL) {
            Map<Id, sked__Resource__c> mapResource = new Map<Id, sked__Resource__c>([SELECT Id
                                                                                     FROM sked__Resource__c
                                                                                     WHERE sked__Primary_Region__c = :params.regionId
                                                                                     AND sked__Is_Active__c = TRUE]);
            params.resourceIds = mapResource.keyset();
        }
        this.params = params;
        
        bookingSetting = sked_Booking_Setting__c.getOrgDefaults();
        integer startTimeInt = integer.valueOf(bookingSetting.Start_Working_Time__c);
        integer endTimeInt = integer.valueOf(bookingSetting.End_Working_Time__c);
        startWorkingTimeInMinute = skedUtils.ConvertTimeNumberToMinutes(startTimeInt);
        endWorkingTimeInMinute = skedUtils.ConvertTimeNumberToMinutes(endTimeInt);
        
        startDate = (Date)Json.deserialize(params.startDateIso, Date.class);
        endDate = (Date)Json.deserialize(params.endDateIso, Date.class);
    }
    
    public bookingGridModel build() {
        bookingGridModel bookingGrid = initializeGrid();
        
        List<skedModels.job> possibleJobs = getPossbileJobs(bookingGrid);
        if (possibleJobs != NULL && !possibleJobs.isEmpty()) {
            skedAvailatorParams availatorParams = new skedAvailatorParams();
            availatorParams.resourceIds = params.resourceIds;
            availatorParams.inputJobs = possibleJobs;
            availatorParams.timezoneSidId = params.timezoneSidId;
            availatorParams.excludedJobIds = params.excludedJobIds;
            availatorParams.allocationChecking = params.allocationChecking;
            skedAvailator validator = new skedAvailator(availatorParams);
            
            List<skedModels.allocation> qualifiedAllocations = validator.getQualifiedAllocations();
            for (skedModels.allocation qualifiedAllocation : qualifiedAllocations) {
                string slotKey = Json.serialize(qualifiedAllocation.job.start);
                slotModel slot = bookingGrid.mapslot.get(slotKey);
                slot.noOfQualifiedRes++;
                if (qualifiedAllocation.isAvailable) {
                    slot.noOfAvailRes++;
                }
            }
            for (slotModel slot : bookingGrid.mapslot.values()) {
                slot.isAvailable = slot.noOfAvailRes > 0;
            }
        }
        
        return bookingGrid;
    }
    
    /***********************************************************Static methods************************************************************/
    public static Map<Id, sked__Resource__c> getMapResource(string regionId, string resourceCategory) {
        Map<Id, sked__Resource__c> mapResource = new Map<Id, sked__Resource__c>([SELECT Id
                                                                                 FROM sked__Resource__c
                                                                                 WHERE sked__Primary_Region__c = :regionId
                                                                                 AND sked__Category__c = :resourceCategory
                                                                                 AND sked__Is_Active__c = TRUE
                                                                                 AND sked__GeoLocation__Latitude__s != NULL
                                                                                 AND sked__GeoLocation__Longitude__s != NULL]);
        return mapResource;
    }
    
    /***********************************************************Protected methods************************************************************/
    protected virtual bookingGridModel initializeGrid() {
        throw new skedSkedException('Please implement skedGridBuilderBase.initializeGrid method.');
    }
    
    protected List<skedModels.job> getPossbileJobs(bookingGridModel bookingGrid) {
        List<skedModels.job> jobs = new List<skedModels.job>();
        
        for (groupSlotModel groupItem : bookingGrid.groups) {
            for (slotModel slot : groupItem.slots) {
                skedModels.job job = preparePossibleJob(slot);
                if (job != NULL) {
                    if (job.start < this.params.bufferTime) {
                        continue;
                    }
                    jobs.add(job);
                }
            }
        }
        
        return jobs;
    }
    
    protected virtual skedModels.job preparePossibleJob(slotModel slot) {
        throw new skedSkedException('Please implement skedGridBuilderBase.preparePossibleJob method.');
    }
    
    /***********************************************************Nested Classes************************************************************/
    global class bookingGridModel {
        public List<groupSlotModel> groups {get;set;}
        
        public transient Map<string, slotModel> mapSlot {get;set;}
        
        public bookingGridModel() {
            this.groups = new List<groupSlotModel>();
            this.mapSlot = new Map<string, slotModel>();
        }
    }
    
    global class groupSlotModel {
        public string label {get;set;}
        public List<slotModel> slots {get;set;}
        
        public groupSlotModel() {
            this.slots = new List<slotModel>();
        }
    }
    
    global class slotModel implements Comparable {
        public string label {get;set;}
        public string slotKey {get;set;}
        public integer duration {get;set;}
        public boolean isAvailable {get;set;}
        public Set<Id> availableResourceIds {get;set;}
        public List<skedModels.allocation> possibleAllocations {get;set;}
        public integer noOfAvailRes {get;set;}
        public integer noOfQualifiedRes {get;set;}
        public boolean outOfRange {get;set;}
        public boolean isHoliday {get;set;}
        
        public transient DateTime startTimeValue {get;set;}
        public transient DateTime endTimeValue {get;set;}
        
        public slotModel() {
            this.isAvailable = false;
            this.possibleAllocations = new List<skedModels.allocation>();
            this.availableResourceIds = new Set<Id>();
            this.noOfAvailRes = 0;
            this.noOfQualifiedRes = 0;
            this.outOfRange = false;
            this.isHoliday = false;
        }
        
        public Integer compareTo(Object compareTo) {
            slotModel compareToRecord = (slotModel)compareTo;
            Integer returnValue = 0;
            
            if (startTimeValue > compareToRecord.startTimeValue) {
                returnValue = 1;
            } else if (startTimeValue < compareToRecord.startTimeValue) {
                returnValue = -1;
            }
            return returnValue;   
        }
    }

}