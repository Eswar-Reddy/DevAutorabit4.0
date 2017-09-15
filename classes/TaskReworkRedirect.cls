public with sharing class TaskReworkRedirect
{
  private final Task_Rework_Request__c myReworkRequest;

    public TaskReworkRedirect(ApexPages.StandardController stdController) 
    {
        this.myReworkRequest = (Task_Rework_Request__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityTaskReworkDetail?id='+myReworkRequest.Id+'&retURL=/'+myReworkRequest.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myReworkRequest.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}