public with sharing class ResidentialProjectTaskRedirect 
{
	private final Project_Task__c myTask;

	public ResidentialProjectTaskRedirect(ApexPages.StandardController stdController) 
	{
		this.myTask = (Project_Task__c)stdController.getRecord();
	}

    public PageReference redirect()
    {
    	Id projId = ApexPages.currentPage().getParameters().get('Residential_Project__c');
    	String retUrlStr = '&retURL=/'+projId;

        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String urlStr = '/apex/SPCommunityResidentialProjectTaskDetails?id='+myTask.Id;
            urlStr = urlStr + retUrlStr;
            
            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        else
        {
        	String urlStr = '/'+myTask.Id + '?nooverride=1';
            urlStr = urlStr + retUrlStr;

            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        return p;
    }
}