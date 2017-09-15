public with sharing class AccountNewRedirectController
{
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};

    public AccountNewRedirectController(ApexPages.StandardController stdController) 
    {
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            System.debug('**** In partner');
            //move to new stuff
            p = new PageReference('/apex/AccountNewRedirectPortal');
            p.setRedirect(true);
        }
        else
        {
            String recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            System.debug('**** In standard');
            p = new PageReference('/apex/AccountNew?ent=Account&nooverride=1&RecordType='+recTypeId);
            p.setRedirect(true);
        }
        return p;
    }
}