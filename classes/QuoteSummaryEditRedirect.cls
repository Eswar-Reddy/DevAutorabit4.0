public with sharing class QuoteSummaryEditRedirect {
    private final Quote_Summary__c quote;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public QuoteSummaryEditRedirect(ApexPages.StandardController stdController) {
        this.quote = (Quote_Summary__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityQuoteSummaryEdit?id='+quote.Id);
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