public with sharing class BusinessRegistrationRedirect 
{
	public final Business_Registration__c bus{get;set;}

	public BusinessRegistrationRedirect(ApexPages.StandardController stdController) 
	{
		bus = (Business_Registration__c)stdController.getRecord();
	}

	public PageReference redirect()
	{
		PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityBusinessRegistrationDetails?id='+bus.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+bus.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
	}
}