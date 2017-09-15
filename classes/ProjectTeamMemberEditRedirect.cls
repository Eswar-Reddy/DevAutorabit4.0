public with sharing class ProjectTeamMemberEditRedirect {
    private final Project_Team_Member__c ptm;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public ProjectTeamMemberEditRedirect(ApexPages.StandardController stdController) {
        this.ptm = (Project_Team_Member__c)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityProjectTeamMemberEdit?id='+ptm.Id+'&retURL=%2F'+ptm.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+ptm.Id + '/e?nooverride=1&retURL=%2F'+ptm.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}