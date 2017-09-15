public with sharing class ContentListRedirect 
{
	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/ApplyCustomHeader?activeTab=Content&eURL=/sfc/#search');
		}
		else
		{
			p = new PageReference('/sfc/#search');
		}
		return p.setRedirect(true);
	}
}