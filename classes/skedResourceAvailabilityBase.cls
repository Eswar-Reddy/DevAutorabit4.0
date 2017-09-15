global abstract class skedResourceAvailabilityBase {

    public Map<Id, resourceModel> initializeResourceList(Set<Id> resourceIds, DateTime startTime, DateTime endTime, string timezoneSidId) {
        Map<Id, sked__Resource__c> mapSkedResource = getResourceWithAvailabilities(resourceIds, startTime, endTime);
        DateTime firstDateStart = skedUtils.GetStartOfDate(startTime, timezoneSidId);
        DateTime lastDateEnd = skedUtils.GetEndOfDate(endTime, timezoneSidId);
        
        Map<Id, resourceModel> mapResource = new Map<Id, resourceModel>();
        for (sked__Resource__c skedResource : mapSkedResource.values()) {
            resourceModel resource = new resourceModel(skedResource);
            resource.mapDateslot = new Map<string, dateslotModel>();
            
            DateTime tempDt = firstDateStart;
            while (tempDt < lastDateEnd) {
                dateslotModel dateslot = new dateslotModel();
                dateslot.stringValue = tempDt.format(skedUtils.DATE_FORMAT, timezoneSidId);
                dateslot.dateValue = (Date)Json.deserialize(tempDt.format(skedUtils.DATE_ISO_FORMAT, timezoneSidId), Date.class);
                dateslot.weekday = tempDt.format('EEE', timezoneSidId).toUpperCase();
                dateslot.start = tempDt;
                dateslot.finish = skedUtils.addDays(dateslot.start, 1, timezoneSidId);
                dateslot.addEvent(dateslot.start, dateslot.finish, 'non-working', false);
                
                resource.mapDateslot.put(dateslot.stringValue, dateslot);
                tempDt = skedUtils.addDays(tempDt, 1, timezoneSidId);
            }
            mapResource.put(resource.Id, resource);
        }
        
        loadWorkingTime(mapResource, resourceIds, timezoneSidId);
        
        for (sked__Resource__c skedResource : mapSkedResource.values()) {
            resourceModel resource = mapResource.get(skedResource.Id);
            loadResourceEvents(skedResource, resource, timezoneSidId);
        }
        return mapResource;
    }
    
    /**********************************************************Private methods********************************************************************/
    
    //Need to have ability to determine the working time's timezone
    
    global virtual void loadWorkingTime(Map<Id, resourceModel> mapResource, Set<Id> resourceIds, string timezoneSidId) {
        DateTime currentTime = system.now();
        
        List<sked__Availability_Template_Resource__c> templateResourceList = [SELECT sked__Resource__c, sked__Availability_Template__c
                                                                              FROM sked__Availability_Template_Resource__c
                                                                              WHERE sked__Resource__c IN :resourceIds];
        
        Map<Id, Id> map_ResourceId_TemplateId = new Map<Id, Id>();
        for (sked__Availability_Template_Resource__c atr : templateResourceList) {
            map_ResourceId_TemplateId.put(atr.sked__Resource__c, atr.sked__Availability_Template__c);
        }
        
        map<Id, sked__Availability_Template__c> mapTemplate 
            = new map<Id, sked__Availability_Template__c>([SELECT Id, 
                                                           (SELECT Id, sked__Finish_Time__c, sked__Is_Available__c, sked__Start_Time__c, sked__Weekday__c 
                                                            FROM sked__Availability_Template_Entries__r) 
                                                           FROM sked__Availability_Template__c 
                                                           WHERE Id IN :map_ResourceId_TemplateId.values()]);
        
        Map<string, Set<Date>> mapHolidays = skedUtils.getHolidays();
        
        for (ResourceModel resource : mapResource.values()) {
            Set<Date> allHolidays = new Set<Date>();
            if (mapHolidays.containsKey(skedConstants.HOLIDAY_GLOBAL)) {
                Set<Date> globalHolidays = mapHolidays.get(skedConstants.HOLIDAY_GLOBAL);
                allHolidays.addAll(globalHolidays);
            }
            if (mapHolidays.containsKey(resource.RegionId)) {
                Set<Date> regionHolidays = mapHolidays.get(resource.RegionId);
                allHolidays.addAll(regionHolidays);
            }
            
            Id templateId = map_ResourceId_TemplateId.get(resource.Id);
            if (templateId == NULL) {
                continue;
            }
            sked__Availability_Template__c avaiTemplate = mapTemplate.get(templateId);
            
            Map<string, sked__Availability_Template_Entry__c> mapEntry = new Map<string, sked__Availability_Template_Entry__c>();
            for (sked__Availability_Template_Entry__c entry : avaiTemplate.sked__Availability_Template_Entries__r) {
                mapEntry.put(entry.sked__Weekday__c, entry);
            }
            for (dateslotModel dateslot : resource.mapDateslot.values()) {
                if (!mapEntry.containsKey(dateslot.weekday)) {
                    continue;
                }
                sked__Availability_Template_Entry__c entry = mapEntry.get(dateslot.Weekday);
                integer startWorkingInMinutes = integer.valueOf(integer.valueOf(entry.sked__Start_Time__c) / 100) * 60 + Math.mod(integer.valueOf(entry.sked__Start_Time__c), 100);
                integer endWorkingInMinutes = integer.valueOf(integer.valueOf(entry.sked__Finish_Time__c) / 100) * 60 + Math.mod(integer.valueOf(entry.sked__Finish_Time__c), 100);
                
                DateTime startWorkingTime = skedUtils.addMinutes(dateslot.start, startWorkingInMinutes, timezoneSidId);
                DateTime endWorkingTime = skedUtils.addMinutes(dateslot.start, endWorkingInMinutes, timezoneSidId);
                
                if (!allHolidays.contains(dateslot.dateValue)) {
                    if (currentTime < endWorkingTime) {
                        dateslot.AddEvent(startWorkingTime, endWorkingTime, null, true);
                        if (startWorkingTime < currentTime) {
                            dateslot.AddEvent(startWorkingTime, currentTime, 'uneditable', false);
                        }
                    }
                }
            }
        }
    }
    
    private void loadResourceEvents(sked__Resource__c skedResource, resourceModel resource, string timezoneSidId) {
        for (sked__Availability__c availableBlock : skedResource.sked__Availabilities1__r) {
            if (availableBlock.sked__Is_Available__c != TRUE) {
                continue;
            }
            DateTime availableStart = availableBlock.sked__Start__c;
            DateTime availableEnd = availableBlock.sked__Finish__c;
            
            dateslotModel firstDateSlot = resource.mapDateslot.values().get(0);
            if (availableStart < firstDateSlot.start) {
                availableStart = firstDateSlot.start;
            }
            dateslotModel lastDateSlot = resource.mapDateslot.values().get(resource.mapDateslot.values().size() - 1);
            if (availableEnd > lastDateSlot.finish) {
                availableEnd = lastDateSlot.finish;
            }
            
            string availableDateString = availableStart.format(skedUtils.DATE_FORMAT, timezoneSidId);
            dateslotModel dateslot = resource.mapDateslot.get(availableDateString);
            dateslot.AddEvent(availableStart, availableEnd, null, true);
        }
        
        for (sked__Availability__c availableBlock : skedResource.sked__Availabilities1__r) {
            if (availableBlock.sked__Is_Available__c != FALSE) {
                continue;
            }
            DateTime availableStart = availableBlock.sked__Start__c;
            DateTime availableEnd = availableBlock.sked__Finish__c;
            
            for (dateslotModel dateslot : resource.mapDateslot.values()) {
                if (dateslot.finish <= availableStart || dateslot.start >= availableEnd) {
                    continue;
                }
                else {
                    DateTime tempStart = availableStart < dateslot.start ? dateslot.start : availableStart; 
                    DateTime tempEnd = availableEnd > dateslot.finish ? dateslot.finish : availableEnd;
                    eventModel unavailableEvent = dateslot.AddEvent(tempStart, tempEnd, 'unavailable', false);
                    unavailableEvent.eventDetails = availableBlock.Name;
                }
            }
        }
        
        for (sked__Job_Allocation__c allocation : skedResource.sked__Job_Allocations__r) {
            string allocationDateString = allocation.sked__Job__r.sked__Start__c.format(skedUtils.DATE_FORMAT, timezoneSidId);
            if (resource.mapDateslot.containsKey(allocationDateString)) {
                dateslotModel dateslot = resource.mapDateslot.get(allocationDateString);
                DateTime jobStart = allocation.sked__Job__r.sked__Start__c;
                DateTime jobEnd = allocation.sked__Job__r.sked__Finish__c;
                Location jobLocation = allocation.sked__Job__r.sked__GeoLocation__c;
                eventModel allocationEvent = dateslot.AddEvent(jobStart, jobEnd, 'allocation', false, allocation.sked__Job__c);
                allocationEvent.geoLocation = allocation.sked__Job__r.sked__GeoLocation__c;
                allocationEvent.eventDetails = allocation.sked__Job__r.Name;
            }
        }
        
        for (sked__Activity__c activity : skedResource.sked__Activities__r) {
            string activityDateString = activity.sked__Start__c.format(skedUtils.DATE_FORMAT, timezoneSidId);
            if (resource.mapDateslot.containsKey(activityDateString)) {
                dateslotModel dateslot = resource.mapDateslot.get(activityDateString);
                eventModel activityEvent = dateslot.AddEvent(activity.sked__Start__c, activity.sked__End__c, 'activity', false, activity.Id);
                activityEvent.geoLocation = activity.sked__GeoLocation__c;
                activityEvent.eventDetails = activity.Name;
            }
        }
        
        resource.allEvents = new List<eventModel>();
        for (dateslotModel dateslot : resource.mapDateslot.values()) {
            dateslot.events.sort();
            resource.allEvents.addAll(dateslot.events);
        }
        resource.allEvents.sort();
    }
    
    /**********************************************************Protected methods********************************************************************/
    
    protected virtual Map<Id, sked__Resource__c> getResourceWithAvailabilities(Set<Id> resourceIds, DateTime startTime, DateTime endTime) {
        return new Map<Id, sked__Resource__c>([SELECT Id, Name, sked__User__r.SmallPhotoUrl, sked__User__c, sked__Category__c, sked__Primary_Region__c,
                                               sked__GeoLocation__c, sked__GeoLocation__Latitude__s, sked__GeoLocation__Longitude__s, sked__Home_Address__c,
                                               
                                               (SELECT Id, sked__Tag__c, sked__Resource__c, sked__Expiry_Date__c
                                                FROM sked__ResourceTags__r
                                                WHERE (sked__Expiry_Date__c = NULL OR sked__Expiry_Date__c >= :startTime)),
                                               
                                               (SELECT sked__Job__c, sked__Job__r.Name, sked__Job__r.sked__Type__c, sked__Job__r.sked__Start__c, 
                                                sked__Job__r.sked__Finish__c, sked__Job__r.sked__Timezone__c, sked__Job__r.sked__GeoLocation__c
                                                FROM sked__Job_Allocations__r
                                                WHERE sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DELETED 
                                                AND sked__Job__r.sked__Job_Status__c != :skedConstants.JOB_STATUS_CANCELLED
                                                AND sked__Job__r.sked__Start__c >= :startTime AND sked__Job__r.sked__Start__c < :endTime
                                                ORDER BY sked__Job__r.sked__Start__c ASC),
                                               
                                               (SELECT Id, Name, sked__Start__c, sked__Finish__c, sked__Is_Available__c, sked__Status__c
                                                FROM sked__Availabilities1__r
                                                WHERE sked__Start__c < :endTime AND sked__Finish__c > :startTime
                                                AND sked__Status__c = 'Approved'
                                                ORDER BY sked__Start__c ASC),
                                               
                                               (SELECT Id, Name, sked__Start__c, sked__End__c, sked__Address__c, sked__GeoLocation__c
                                                FROM sked__Activities__r
                                                WHERE sked__Start__c < :endTime AND sked__End__c > :startTime
                                                ORDER BY sked__Start__c ASC)
                                               
                                               FROM sked__Resource__c
                                               WHERE Id IN :resourceIds]);
    }
    
    global abstract void loadAdditionalEvents(Map<Id, resourceModel> mapResource, Set<Id> resourceIds);
    
    /**********************************************************Nested classes********************************************************************/
    
    global class resourceModel extends skedModels.resource {
        public transient Map<string, dateslotModel> mapDateslot {get;set;}
        public transient List<eventModel> allEvents {get;set;}
        public transient Map<string, boolean> availableSlots {get;set;} 
        
        public resourceModel() {}
        
        public resourceModel(sked__Resource__c skedResource) {
            super(skedResource);
            this.mapDateslot = new Map<string, dateslotModel>();
            this.availableSlots = new Map<string, boolean>();
        }
    }
    
    global class dateslotModel {
        public string stringValue {get;set;}
        public Date dateValue {get;set;}
        public DateTime start {get;set;}
        public DateTime finish {get;set;}
        public string weekday {get;set;}
        public List<eventModel> events {get;set;}
        
        public dateslotModel() {
            this.events = new List<eventModel>();
        }
        
        public eventModel addEvent(DateTime startTime, DateTime endTime, string eventType, boolean isAvailable) {
            return addEvent(startTime, endTime, eventType, isAvailable, null);
        }
            
        public eventModel addEvent(DateTime startTime, DateTime endTime, string eventType, boolean isAvailable, string relatedId) {
            if (isAvailable == true) {
                addAvailableBlock(startTime, endTime);
            }
            else {
                eventModel newEvent = new eventModel();
                newEvent.start = startTime;
                newEvent.finish = endTime;
                newEvent.eventType = eventType;
                newEvent.relatedId = relatedId;
                this.events.add(newEvent);
                return newEvent;
            }
            return null;
        }
        
        private void addAvailableBlock(DateTime startTime, DateTime endTime) {
            List<eventModel> newEvents = new List<eventModel>();
            Set<DateTime> removedEvents = new Set<DateTime>();
            
            for (eventModel eventItem : this.events) {
                if (eventItem.start < startTime && startTime < eventItem.finish) {
                    if (endTime < eventItem.finish) {
                        eventModel newEvent = new eventModel();
                        newEvent.start = endTime;
                        newEvent.finish = eventItem.finish;
                        newEvent.eventType = eventItem.eventType;
                        newEvents.add(newEvent);
                    }
                    eventItem.finish = startTime;
                }
                else if (startTime <= eventItem.start) {
                    if (endTime >= eventItem.finish) {
                        removedEvents.add(eventItem.start);
                    }
                    else if (eventItem.start < endTime && endTime < eventItem.finish) {
                        eventItem.start = endTime;
                    }
                }
            }
            
            for (integer i = this.events.size() - 1; i >= 0; i--) {
                eventModel eventItem = this.events.get(i);
                if (removedEvents.contains(eventItem.start)) {
                    this.events.remove(i);
                }
            }
            
            this.events.addAll(newEvents);
        }
    }
    
    global class eventModel implements Comparable {
        public DateTime start {get;set;}
        public DateTime finish {get;set;}
        public string eventType {get;set;}
        public Id relatedId {get;set;}
        public Location geoLocation {get;set;}
        public string eventDetails {get;set;}
        
        public Integer compareTo(Object compareTo) {
            eventModel compareToRecord = (eventModel)compareTo;
            Integer returnValue = 0;
            
            if (start > compareToRecord.start) {
                returnValue = 1;
            } else if (start < compareToRecord.start) {
                returnValue = -1;
            } else {
                if (finish > compareToRecord.finish) {
                    returnValue = -1;
                } else if (finish < compareToRecord.finish) {
                    returnValue = 1;
                }
            }
            return returnValue;   
        }
    }
    
}