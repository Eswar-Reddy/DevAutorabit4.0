public with sharing class ContactEditRedirect {
    private final Contact ct;

    public ContactEditRedirect(ApexPages.StandardController stdController) {
        this.ct = (Contact)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/CommunityContactEdit?id='+ct.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            Map<String, String> params = ApexPages.currentPage().getParameters();
            p = new PageReference('/'+ct.Id + '/e?nooverride=1&retURL=%2F'+ct.Id);
            if(params != null) {
                for(String s : params.keyset()) {
                    p.getParameters().put(s, params.get(s));
                }
            }
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}