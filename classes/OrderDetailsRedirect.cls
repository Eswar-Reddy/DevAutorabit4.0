public with sharing class OrderDetailsRedirect
{
	public OrderDetailsRedirect()
	{}

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/SPCommunityOrderDetails');
			p.setRedirect(true);
		}
		else
		{
			p = new PageReference('/apex/Order_Details');
			p.setRedirect(true);
		}
		return p.setRedirect(true);
	}
}