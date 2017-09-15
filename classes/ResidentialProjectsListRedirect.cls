public with sharing class ResidentialProjectsListRedirect 
{
	public ResidentialProjectsListRedirect(ApexPages.StandardController controller) 
	{}

	public ResidentialProjectsListRedirect(ApexPages.StandardSetController controller) 
	{}

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/SPCommunityResProjects');
		}
		else
		{
			p = new PageReference('/a6l/o?nooverride=1');
		}
		return p.setRedirect(true);
	}
}