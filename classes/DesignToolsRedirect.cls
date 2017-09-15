public with sharing class DesignToolsRedirect
{
	public DesignToolsRedirect()
	{}

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/SPCommunityDesignTools');
			p.setRedirect(true);
		}
		else
		{
			p = new PageReference('/apex/Design_Tools');
			p.setRedirect(true);
		}
		return p.setRedirect(true);
	}
}