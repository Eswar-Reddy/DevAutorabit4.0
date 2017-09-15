public with sharing class AlliancePartnerRedirect 
{
	public final Alliance_Partner__c proj{get;set;}

	public AlliancePartnerRedirect(ApexPages.StandardController stdController) 
	{
		proj = (Alliance_Partner__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityAlliancePartnerDetails?id='+proj.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+proj.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
	}
}