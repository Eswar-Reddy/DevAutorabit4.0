public with sharing class TerminateContactRedirect 
{
	private final Contact myCt;

	public TerminateContactRedirect(ApexPages.StandardController stdController) 
    {
    	this.myCt = (Contact)stdController.getRecord();
    }

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			p = new PageReference('/apex/SPCommunityTerminateContact?id='+myCt.Id+'&retURL=/'+myCt.Id);
			p.setRedirect(true);
		}
		else
		{
			p = new PageReference('/apex/TerminateContact?id='+myCt.Id+'&retURL=/'+myCt.Id);
			p.setRedirect(true);
		}
		return p;
	}
}