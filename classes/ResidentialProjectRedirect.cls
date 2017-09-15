public with sharing class ResidentialProjectRedirect 
{
	public final Residential_Project__c proj{get;set;}

	public ResidentialProjectRedirect(ApexPages.StandardController stdController) 
	{
		proj = (Residential_Project__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityResidentialProjectDetails?id='+proj.Id);
            p.setRedirect(true);
        }
        else
        {
            //p = new PageReference('/'+proj.Id + '?nooverride=1');
            p = new PageReference('/apex/ResidentailProjectNewDetail?id='+proj.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
	}
}