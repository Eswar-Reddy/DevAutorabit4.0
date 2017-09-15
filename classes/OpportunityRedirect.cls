public with sharing class OpportunityRedirect {
    private final Opportunity opp;
    public OpportunityRedirect(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            String commercialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType).get('Commercial');
            A2_App_Settings__c setting = A2_App_Settings__c.getInstance('Opp Routing Commercial');
            Boolean routeToOldOppView = setting == null ? false : setting.Route_to_Old_Opp_View__c;
            if (opp.RecordTypeId == commercialRecordTypeId && SPCommunityUtility.isNewUIUser(UserInfo.getUserId()) && routeToOldOppView != true) {
                p = Page.SPCommunityCustomer;
                p.setAnchor('/account/commercial/'+opp.AccountId+'/opportunity/'+opp.Id+'/basic-info');
            } else {
                p = new PageReference('/apex/SPCommunityOpportunityDetails?id='+opp.Id);
            }
            p.setRedirect(true);
        }
        else{
            p = new PageReference('/apex/OpportunityNewDetail?id='+opp.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}