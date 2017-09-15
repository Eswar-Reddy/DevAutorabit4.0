public with sharing class AlliancePartnerEditRedirect 
{
	public final Alliance_Partner__c proj{get;set;}

	public AlliancePartnerEditRedirect(ApexPages.StandardController stdController) 
	{
		proj = (Alliance_Partner__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityAlliancePartnerEdit?id='+proj.Id+'&retURL=/'+proj.Id);
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