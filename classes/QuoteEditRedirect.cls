public with sharing class QuoteEditRedirect {
    private final Quote quote;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public QuoteEditRedirect(ApexPages.StandardController stdController) {
        this.quote = (Quote)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityQuoteEdit?id='+quote.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+quote.Id + '/e?nooverride=1&retURL=%2F'+quote.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}