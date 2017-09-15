public with sharing class FinancialPaymentRedirect {
    private final LeasePayment__c fp;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public FinancialPaymentRedirect(ApexPages.StandardController stdController) {
        this.fp = (LeasePayment__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityFinancialPaymentDetail?id='+fp.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+fp.Id + '?nooverride=1');
            p.setRedirect(true);
        }
    return p.setRedirect(true);
    }
}