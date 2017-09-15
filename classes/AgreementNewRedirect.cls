public with sharing class AgreementNewRedirect
{
    public AgreementNewRedirect(ApexPages.StandardController stdController) 
    {}

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
            String oppId = ApexPages.currentPage().getParameters().get('oppid') != null ? ApexPages.currentPage().getParameters().get('oppid') : '';
            p = new PageReference('/apex/AgreementNewRedirectPortal?accid='+accId+'&oppid='+oppId);
            p.setRedirect(true);
        }
        else
        {
            String recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            p = new PageReference('/apex/AgreementNew?ent=echosign_dev1__SIGN_Agreement__c&nooverride=1&RecordType='+recTypeId);
            p.setRedirect(true);
        }
        return p;
    }
}