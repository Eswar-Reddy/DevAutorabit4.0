public with sharing class AgreementNew
{
	private final echosign_dev1__SIGN_Agreement__c myAgr;

    public AgreementNew(ApexPages.StandardController stdController) 
    {
        this.myAgr = (echosign_dev1__SIGN_Agreement__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
            String oppId = ApexPages.currentPage().getParameters().get('oppid') != null ? ApexPages.currentPage().getParameters().get('oppid') : '';
            p = new PageReference('/apex/SPCommunityAgreementNew?objecttype=echosign_dev1__SIGN_Agreement__c&Account__c='+accId+'&Opportunity__c='+oppId);
            p.setRedirect(true);
        }
        else
        {
            String recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            p = new PageReference('/a07/e?nooverride=1&RecordType='+recTypeId);
            p.setRedirect(true);
        }
        return p;
    }
}