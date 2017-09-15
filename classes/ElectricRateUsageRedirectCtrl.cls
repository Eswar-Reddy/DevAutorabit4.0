public with sharing class ElectricRateUsageRedirectCtrl {
    private final Account acct;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public ElectricRateUsageRedirectCtrl(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }
    public PageReference redirectUrl(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            p = new PageReference('/apex/applycustomheader?eURL=%2Fapex%2FGenabilityUsage%3Fid%3D'+acct.Id);
            p.setRedirect(true);
        }
        else{
            p = new PageReference('/apex/GenabilityUsage?id='+acct.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
    
}