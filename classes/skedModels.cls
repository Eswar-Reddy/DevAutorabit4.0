global class skedModels {
    
    global class job {
        public string id {get;set;}
        public string startTime {get;set;}
        public string jobDate {get;set;}
        public integer duration {get;set;}
        public boolean allDay {get;set;}
        public Set<string> tagIds {get;set;}
        public List<allocation> allocations {get;set;}
        public List<job> followups {get;set;}
        
        public transient location geoLocation {get;set;}
        public transient DateTime start {get;set;}
        public transient DateTime finish {get;set;}
        
        public job() {
            this.allDay = false;
        }
    }
    
    global virtual class resource {
        public string id {get;set;}
        public string name {get;set;}
        public string category {get;set;}
        public string photoUrl {get;set;}
        public string regionId {get;set;}
        public string userId {get;set;}
        public integer noOfAvailJobs {get;set;}
        public integer travelTimeFromHome {get;set;}
        
        public transient Location geoLocation {get;set;}
        public transient List<resourceTag> tags {get;set;}
        
        public resource() {
            this.tags = new List<resourceTag>();
            this.noOfAvailJobs = 0;
        }
        
        public resource(sked__Resource__c skedResource) {
            this.id = skedResource.Id;
            this.name = skedResource.Name;
            this.regionId = skedResource.sked__Primary_Region__c;
            this.userId = skedResource.sked__User__c;
            this.photoUrl = skedResource.sked__User__r.SmallPhotoUrl;
            this.category = skedResource.sked__Category__c;
            this.geoLocation = skedResource.sked__GeoLocation__c;
            
            if (skedResource.sked__ResourceTags__r != NULL && !skedResource.sked__ResourceTags__r.isEmpty()) {
                this.tags = new List<resourceTag>(); 
                for (sked__Resource_Tag__c skedResourceTag : skedResource.sked__ResourceTags__r) {
                    resourceTag tag = new resourceTag();
                    tag.resourceId = skedResourceTag.sked__Resource__c;
                    tag.tagId = skedResourceTag.sked__Tag__c;
                    tag.expiryDate = skedResourceTag.sked__Expiry_Date__c;
                }
            }
        }
    }
    
    global class resourceTag {
        public string resourceId {get;set;}
        public string tagId {get;set;}
        public transient DateTime expiryDate {get;set;}
    }
    
    global virtual class allocation implements Comparable {
        public string id {get;set;}
        public string jobId {get;set;}
        public string resourceId {get;set;}
        public decimal distance {get;set;}
        public integer travelTimeFrom {get;set;}
        public geometry startFromLocation {get;set;}
        public boolean isAvailable {get;set;}
        public boolean isQualified {get;set;}
        
        public transient resource resource {get;set;}
        public transient job job {get;set;}
        
        public allocation() {
            this.isAvailable = true;
            this.isQualified = true;
        }
        
        public Integer compareTo(Object compareTo) {
            allocation compareToRecord = (allocation)compareTo;
            Integer returnValue = 0;
            
            if (travelTimeFrom > compareToRecord.travelTimeFrom) {
                returnValue = 1;
            } else if (travelTimeFrom < compareToRecord.travelTimeFrom) {
                returnValue = -1;
            }
            return returnValue;   
        }
    }
    
    global class geometry implements Comparable {
        public string relatedId {get;set;}
        public decimal latitude {get;set;}
        public decimal longitude {get;set;}
        public decimal distance {get;set;}
        public transient Location geoLoc {get;set;}
        
        public geometry(Location location) {
            setup(location);
        }
        
        private void setup(Location location) {
            if (location != NULL) {
                this.latitude = location.getLatitude();
                this.longitude = location.getLongitude();
                this.geoLoc = location;
            }
        }
        
        public Integer compareTo(Object compareTo) {
            geometry compareToRecord = (geometry)compareTo;
            Integer returnValue = 0;
            
            if (distance > compareToRecord.distance) {
                returnValue = 1;
            } else if (distance < compareToRecord.distance) {
                returnValue = -1;
            }
            return returnValue;   
        }
    }
    
}