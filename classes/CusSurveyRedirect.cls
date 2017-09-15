public with sharing class CusSurveyRedirect {
    private final Customer_Survey_Result__c survey;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public CusSurveyRedirect(ApexPages.StandardController stdController) {
        this.survey = (Customer_Survey_Result__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityCusSurveyDetails?id='+survey.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+survey.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}