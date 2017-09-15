public with sharing class OpportunityListRedirect {

    public OpportunityListRedirect(ApexPages.StandardSetController controller) {

    }

    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public OpportunityListRedirect(ApexPages.StandardController stdController) {
        //nothing because we're in the list
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityOpportunities');
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/006?nooverride=1');
        }
        return p.setRedirect(true);
    }
}