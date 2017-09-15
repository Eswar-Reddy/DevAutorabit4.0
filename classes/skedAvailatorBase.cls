global abstract class skedAvailatorBase {
    
    protected skedAvailatorParams params {get;set;}
    
    protected skedResourceAvailabilityBase resourceAvailability {
        get {
            if (resourceAvailability == NULL) {
                resourceAvailability = new skedResourceAvailability();
            }
            return resourceAvailability;
        }
        set;
    }
    
    protected Map<Id, skedResourceAvailabilityBase.resourceModel> mapResource {get;set;}
    
    protected List<skedModels.allocation> possibleAllocations {get;set;}
    
    /*********************************************************Constructor***************************************************/
    
    public skedAvailatorBase(skedAvailatorParams inputParams) {
        this.params = inputParams;
        initialize();
    }
    
    /*********************************************************Private methods***************************************************/

    private void initialize() {
        DateTime firstJobStart, lastJobFinish;
        List<skedModels.job> allJobs = new List<skedModels.job>();
        for (skedModels.job job : params.inputJobs) {
            allJobs.add(job);
            if (job.followups != NULL && !job.followups.isEmpty()) {
                allJobs.addAll(job.followups);
            }
        }
        for (skedModels.job job : allJobs) {
            if (firstJobStart == NULL || firstJobStart > job.start) {
                firstJobStart = job.start;
            }
            if (lastJobFinish == NULL || lastJobFinish < job.finish) {
                lastJobFinish = job.finish;
            }
        }
        
        this.mapResource = this.resourceAvailability.initializeResourceList(params.resourceIds, firstJobStart, lastJobFinish, params.timezoneSidId);
        
        this.possibleAllocations = getPossibleAllocations(mapResource.values(), params.inputJobs);
        
        validateAvailability(this.possibleAllocations, params.excludedJobIds);
    }
    
    private void validateAvailability(List<skedModels.allocation> inputAllocations, Set<Id> excludeJobIds) {
        Set<Id> possibleResourceIds = new Set<Id>();
        
        for (skedModels.allocation possibleAllocation : inputAllocations) {
            skedResourceAvailabilityBase.resourceModel resource = this.mapResource.get(possibleAllocation.resourceId);
            possibleAllocation.resource = resource;
            validateAllocation(possibleAllocation, resource, excludeJobIds);
            
            if (possibleAllocation.isAvailable && possibleAllocation.job.followups != NULL && !possibleAllocation.job.followups.isEmpty()) {
                for (skedModels.job followup : possibleAllocation.job.followups) {
                    string key = followup.start.format(skedUtils.TIMESLOT_KEY_FORMAT, params.timezoneSidId);
                    if (resource.availableSlots.containsKey(key)) {
                        boolean isAvailable = resource.availableSlots.get(key);
                        if (!isAvailable) {
                            possibleAllocation.isAvailable = false;
                            break;
                        } else {
                            continue;
                        }
                    }
                    
                    skedModels.allocation followupAllocation = possibleAllocation.clone();
                    followupAllocation.job = followup;
                    followupAllocation.jobId = followup.Id;
                    followupAllocation.resource = resource;
                    
                    validateAllocation(followupAllocation, resource, excludeJobIds);
                    if (!followupAllocation.isAvailable) {
                        possibleAllocation.isAvailable = false;
                        break;
                    }
                    resource.availableSlots.put(key, followupAllocation.isAvailable);
                }
            }
        }
    }
    
    private void validateAllocation(skedModels.allocation allocation, skedResourceAvailabilityBase.resourceModel resource, Set<Id> excludeJobIds) {
        skedResourceAvailabilityBase.eventModel previousEvent, nextEvent;
        for (skedResourceAvailabilityBase.eventModel event : resource.allEvents) {
            if (allocation.job.finish < event.start && nextEvent != NULL) {
                break;
            }
            
            if (this.params.allocationChecking == false && event.eventType == 'allocation') {
                continue;
            }
            
            if (event.relatedId != NULL && excludeJobIds != NULL && !excludeJobIds.isEmpty()) {
                if (excludeJobIds.contains(event.relatedId)) {
                    continue;
                }
            }
            if (event.start < allocation.job.finish && event.finish > allocation.job.start) {
                allocation.isAvailable = false;
                if (event.eventType == 'non-working') {
                    allocation.isQualified = false;
                }
                break;
            }
            if (previousEvent == NULL || previousEvent.finish < allocation.job.start) {
                previousEvent = event;
            }
            if (nextEvent == NULL || nextEvent.start > allocation.job.finish) {
                nextEvent = event;
            }
        }
        if (allocation.job.allDay) {
            if (resource.geoLocation != NULL) {
                allocation.startFromLocation = new skedModels.geometry(resource.geoLocation);
                allocation.distance = resource.geoLocation.getDistance(allocation.job.geoLocation, 'km');
                allocation.travelTimeFrom = getTravelTime(resource.geoLocation, allocation.job.geoLocation);
            }
        }
        else {
            if (allocation.job.geoLocation != NULL) {
                if (previousEvent != NULL && previousEvent.geoLocation != NULL) {
                    allocation.startFromLocation = new skedModels.geometry(previousEvent.geoLocation);
                    integer travelTimeFrom = getTravelTime(previousEvent.geoLocation, allocation.job.geoLocation);
                    allocation.travelTimeFrom = travelTimeFrom;
                    allocation.distance = previousEvent.geoLocation.getDistance(allocation.job.geoLocation, 'km');
                    if (previousEvent.finish.addMinutes(travelTimeFrom) > allocation.job.start) {
                        allocation.isAvailable = false;
                    }
                } else {
                    if (resource.geoLocation != NULL) {
                        allocation.startFromLocation = new skedModels.geometry(resource.geoLocation);
                        allocation.distance = resource.geoLocation.getDistance(allocation.job.geoLocation, 'km');
                        allocation.travelTimeFrom = getTravelTime(resource.geoLocation, allocation.job.geoLocation);
                    }
                }
                if (nextEvent != NULL && nextEvent.geoLocation != NULL) {
                    integer travelTimeTo = getTravelTime(allocation.job.geoLocation, nextEvent.geoLocation);
                    if (allocation.job.finish.addMinutes(travelTimeTo) > nextEvent.start) {
                        allocation.isAvailable = false;
                    }
                }
            }
        }
    }
    
    private List<skedModels.allocation> getPossibleAllocations(List<skedResourceAvailabilityBase.resourceModel> resources, List<skedModels.job> inputJobs) {
        List<skedModels.allocation> result = new List<skedModels.allocation>();
        
        for (skedModels.job job : inputJobs) {
            for (skedResourceAvailabilityBase.resourceModel resource : resources) {
                skedModels.allocation allocation = new skedModels.allocation();
                allocation.resource = resource;
                allocation.resourceId = resource.id;
                allocation.job = job;
                allocation.jobId = job.id;
                result.add(allocation);
            }
        }
        
        return result;
    }
    
    protected integer getTravelTime(Location location1, Location location2) {
        integer travelTime = -1;
        if (location1 == NULL || location2 == NULL) {
            return travelTime;
        }
        double dist = location1.getDistance(location2, 'km');
        travelTime = (dist * 2).intValue();
        travelTime = travelTime < 1 ? 1 : travelTime;
        return travelTime;
    }
    
}