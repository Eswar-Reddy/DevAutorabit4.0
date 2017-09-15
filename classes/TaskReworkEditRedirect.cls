public with sharing class TaskReworkEditRedirect
{
    private final Task_Rework_Request__c myReworkRequest;

    public TaskReworkEditRedirect(ApexPages.StandardController stdController) 
    {
        this.myReworkRequest = (Task_Rework_Request__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityTaskReworkEdit?id='+myReworkRequest.Id+'&retURL=/'+myReworkRequest.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myReworkRequest.Id + '/e?nooverride=1&retURL=%2F'+myReworkRequest.Id);
            p.setRedirect(true);
        }
        return p;
    }
}