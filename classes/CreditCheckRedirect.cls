public with sharing class CreditCheckRedirect
{
	private final Credit_Check_Request__c myCCR;

	public CreditCheckRedirect(ApexPages.StandardController stdController) 
    {
    	this.myCCR = (Credit_Check_Request__c)stdController.getRecord();
    }

	public PageReference redirect()
	{
		PageReference p;
		if(SPCommunityUtility.isPartnerUser())
		{
			String retUrl = ApexPages.currentPage().getParameters().get('retURL');
			p = new PageReference('/apex/SPCommunityCreditCheckDetails?id='+myCCR.Id+'&retURL=/'+myCCR.Id);

			p.setRedirect(true);
		}
		else
		{
			p = new PageReference('/'+myCCR.Id + '?nooverride=1&retURL=/'+myCCR.Id);

			p.setRedirect(true);
		}
		return p.setRedirect(true);
	}
}