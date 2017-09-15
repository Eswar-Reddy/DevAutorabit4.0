public with sharing class ContactNewRedirect {
	private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};

    public ContactNewRedirect(ApexPages.StandardController stdController) 
    {
    }

    public PageReference redirect()
    {
        //System.debug(ApexPages.currentPage().getParameters().get('accid'));

        PageReference p;
        String accId = ApexPages.currentPage().getParameters().get('accid') != null ? ApexPages.currentPage().getParameters().get('accid') : '';
        String returnURL = ApexPages.currentPage().getParameters().get('retURL') != null ? ApexPages.currentPage().getParameters().get('retURL') : '';
        if(SPCommunityUtility.isPartnerUser()){
            System.debug('**** In partner');
            //move to new stuff
            p = new PageReference('/apex/ContactNewRedirectPortal?accid='+accId+'&retURL='+returnURL);
            p.getParameters().putAll(ApexPages.currentPage().getParameters());
            p.setRedirect(true);
        }
        else
        {
            Id recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            System.debug('**** In standard');
            p = new PageReference('/003/e?RecordType='+recTypeId+'&nooverride=1&accid='+accId+'&retURL='+returnURL);
            p.setRedirect(true);
        }
        return p;
    }
}