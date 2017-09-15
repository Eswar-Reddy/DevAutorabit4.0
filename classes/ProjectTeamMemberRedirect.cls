public with sharing class ProjectTeamMemberRedirect {
    private final Project_Team_Member__c ct;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public ProjectTeamMemberRedirect(ApexPages.StandardController stdController) {
        this.ct = (Project_Team_Member__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityProjectTeamMemberDetails?id='+ct.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+ct.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}