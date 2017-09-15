public with sharing class ProjectDashboardRedirect 
{
	public ProjectDashboardRedirect()
	{}

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/SPCommunityProjectDashboard');
			p.setRedirect(true);
		}
		else
		{
			p = new PageReference('/apex/ProjectDashboard');
			p.setRedirect(true);
		}
		return p.setRedirect(true);
	}
}