public with sharing class ResidentialProjectTaskEditRedirect 
{
	private final Project_Task__c myTask;

    public ResidentialProjectTaskEditRedirect(ApexPages.StandardController stdController) 
    {
        this.myTask = (Project_Task__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityResidentialProjectTaskEdit?id='+myTask.Id+'&retURL=/'+myTask.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myTask.Id + '/e?nooverride=1&retURL=/'+myTask.Id);
            p.setRedirect(true);
        }
        return p;
    }
}