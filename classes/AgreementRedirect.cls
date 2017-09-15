public with sharing class AgreementRedirect
{
	private final echosign_dev1__SIGN_Agreement__c myAgr;

    public AgreementRedirect(ApexPages.StandardController stdController) 
    {
        this.myAgr = (echosign_dev1__SIGN_Agreement__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            //p = new PageReference('/apex/SPCommunityAgreementDetails?id='+myAgr.Id);
            p = new PageReference('/apex/CommunityAgreementPage?id='+myAgr.Id);
            p.setRedirect(true);
			
        }
        else
        {
            p = new PageReference('/'+myAgr.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}