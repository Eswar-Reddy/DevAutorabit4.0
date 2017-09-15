public with sharing class ResidentialProjectEditRedirect 
{
	public final Residential_Project__c proj{get;set;}

	public ResidentialProjectEditRedirect(ApexPages.StandardController stdController) 
	{
		proj = (Residential_Project__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityResidentialProjectEdit?id='+proj.Id+'&retURL=/'+proj.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+proj.Id + '/e?nooverride=1&retURL=/'+proj.Id);
            p.setRedirect(true);
        }
        return p;
	}
}