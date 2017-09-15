public with sharing class AgreementEditRedirect
{
	private final echosign_dev1__SIGN_Agreement__c myAgr;

    public AgreementEditRedirect(ApexPages.StandardController stdController) 
    {
        this.myAgr = (echosign_dev1__SIGN_Agreement__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/CommunityAgreementEdit?id='+myAgr.Id);
            p.setRedirect(true);
			
        }
        else
        {
            p = new PageReference('/'+myAgr.Id + '/e?nooverride=1&retURL=%2F'+myAgr.Id);
            p.setRedirect(true);
        }
        return p;
    }
}