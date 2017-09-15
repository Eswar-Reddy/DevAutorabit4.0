public with sharing class PVFUSurveyRedirect {
    private final Post_Visit_Follow_Up_Survey__c survey;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public PVFUSurveyRedirect(ApexPages.StandardController stdController) {
        this.survey = (Post_Visit_Follow_Up_Survey__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityPVFUSurveyDetails?id='+survey.Id);
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