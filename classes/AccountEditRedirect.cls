public with sharing class AccountEditRedirect {
    private final Account acct;

    public AccountEditRedirect(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityAccountEdit?id='+acct.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            Map<String, String> params = ApexPages.currentPage().getParameters();
            p = new PageReference('/'+acct.Id + '/e?nooverride=1&retURL=%2F'+acct.Id);
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