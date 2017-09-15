public with sharing class ContactRedirect {
    private final Contact ct;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    public ContactRedirect(ApexPages.StandardController stdController) {
        this.ct = (Contact)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/CommunityContactPage?id='+ct.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            p = new PageReference('/apex/ContactNewDetail?id='+ct.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}