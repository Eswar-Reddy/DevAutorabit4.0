global class skedGridBuilderParams {
    
    public string timezoneSidId {get;set;}
    public string startDateIso {get;set;}
    public string endDateIso {get;set;}
    public boolean skipHolidays {get;set;}
    public boolean skipSaturdays {get;set;}
    public boolean skipSundays {get;set;}
    
    public string regionId {get;set;}
    public Set<Id> resourceIds {get;set;}
    public Set<Id> excludedJobIds {get;set;}
    public decimal jobLocationLat {get;set;}
    public decimal jobLocationLong {get;set;}
    public integer duration {get;set;}
    public DateTime bufferTime {get;set;} 
    
    public boolean allocationChecking {get;set;}
    
    public skedGridBuilderParams() {
        this.bufferTime = DateTime.now();
        this.skipHolidays = true;
        this.skipSaturdays = true;
        this.skipSundays = true;
        
        this.allocationChecking = true;
    }

}