public class skedBookingNavigationController {
    
    public string rootRecordId {get;set;}
    public string entryMessage {get;set;}

    public skedBookingNavigationController(ApexPages.StandardController stdCon) {
        this.rootRecordId = ApexPages.currentPage().getParameters().get('id');
        this.entryMessage = '';
    }
    
    public PageReference Cmd_Navigation() {
        List<string> jobTypes = new List<string>();
        jobTypes.add(skedConstants.JOB_TYPE_SITE_SURVEY);
        jobTypes.add(skedConstants.JOB_TYPE_INSTALLATION);
        jobTypes.add(skedConstants.JOB_TYPE_INSPECTION);
        
        List<sked__Job__c> activeJobs = [SELECT Id, sked__Type__c
                                         FROM sked__Job__c
                                         WHERE Residential_Project__c = :this.rootRecordId
                                         AND sked__Type__c IN :jobTypes
                                         AND sked__Job_Status__c != :skedConstants.JOB_STATUS_CANCELLED
                                         AND sked__Job_Status__c != :skedConstants.JOB_STATUS_COMPLETE];
        if (activeJobs.isEmpty()) {
            this.entryMessage = 'There is no active job.';
            return null;
        }
        else {
            sked__Job__c currentJob = activeJobs.get(0);
            string bookingGridType = 'sked' + currentJob.sked__Type__c.replace(' ', '') + 'Job';
            string redirectUrl = '/apex/' + bookingGridType + '?id=' + this.rootRecordId + '&jobId=' + currentJob.Id;
            PageReference pageRef = new PageReference(redirectUrl);
            return pageRef;
        }
    }
    
}