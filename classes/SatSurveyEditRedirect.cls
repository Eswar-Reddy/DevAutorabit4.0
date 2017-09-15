public with sharing class SatSurveyEditRedirect {
    private final X1Y_Satisfaction_Survey_Result__c survey;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public SatSurveyEditRedirect(ApexPages.StandardController stdController) {
        this.survey = (X1Y_Satisfaction_Survey_Result__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunitySatSurveyEdit?id='+survey.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+survey.Id + '/e?nooverride=1&retURL=%2F'+survey.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}