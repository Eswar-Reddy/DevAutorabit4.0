public with sharing class QuoteLineItemEditRedirect {
    private final QuoteLineItem quoteline;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public QuoteLineItemEditRedirect(ApexPages.StandardController stdController) {
        this.quoteline = (QuoteLineItem)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityQuoteLineItemEdit?id='+quoteline.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+quoteline.Id + '/e?nooverride=1&retURL=%2F'+quoteline.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}