public with sharing class TaskCloseRedirect {
    private final Task ta;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public TaskCloseRedirect(ApexPages.StandardController stdController) {
        this.ta = (Task)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityTaskEdit?id='+ta.Id+'&close=1');
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/'+ta.Id + '/e?close=1&nooverride=1&retURL=%2F'+ta.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}