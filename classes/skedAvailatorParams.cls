global class skedAvailatorParams {
    
    public string timezoneSidId {get;set;}
    public boolean respectResourceTimezone {get;set;}
    public Set<Id> regionIds {get;set;}
    public Set<Id> resourceIds {get;set;}
    public Set<Id> excludedJobIds {get;set;}
    public List<skedModels.job> inputJobs {get;set;}
    
    //temporarily code changes for installation booking grid, ignore allocation when building installation grid
    public boolean allocationChecking {get;set;}
    
    public skedAvailatorParams() {
        this.timezoneSidId = UserInfo.getTimeZone().getID();
        this.respectResourceTimezone = false;
        this.regionIds = new Set<Id>();
        this.resourceIds = new Set<Id>();
        this.excludedJobIds = new Set<Id>();
        this.inputJobs = new List<skedModels.job>();
        
        this.allocationChecking = true;
    }
    
}