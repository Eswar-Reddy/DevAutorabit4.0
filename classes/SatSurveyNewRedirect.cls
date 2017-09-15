public with sharing class SatSurveyNewRedirect {

    public SatSurveyNewRedirect(ApexPages.StandardController stdController)
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
            p = new PageReference('/apex/SatSurveyRedirectPortal?accid='+accId+'&retURL='+returnURL+'&nooverride=1');
            p.setRedirect(true);
        }
        else
        {
            Id recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            System.debug('**** In standard');
            p = new PageReference('/00T/e?RecordType='+recTypeId+'&nooverride=1&accid='+accId+'&retURL='+returnURL);
            p.setRedirect(true);
        }
        return p;
    }
}