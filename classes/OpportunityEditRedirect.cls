public with sharing class OpportunityEditRedirect {
    private final Opportunity opp;

    public OpportunityEditRedirect(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/SPCommunityOpportunityEdit?id='+opp.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else{
            Map<String, String> params = ApexPages.currentPage().getParameters();
            p = new PageReference('/'+opp.Id + '/e?nooverride=1&retURL=%2F'+opp.Id);
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