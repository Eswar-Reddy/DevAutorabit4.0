public with sharing class CoverageAreaRedirect 
{
	public final CoverageArea__c area{get;set;}

	public CoverageAreaRedirect(ApexPages.StandardController stdController) 
	{
		area = (CoverageArea__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityCoverageAreaDetails?id='+area.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+area.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
	}
}