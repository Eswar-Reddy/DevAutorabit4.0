public with sharing class ShippingSiteRedirect {
    private final Ship_to_Site__c ss;

    public ShippingSiteRedirect(ApexPages.StandardController stdController) {
        this.ss = [select Id, Dealer_Account__c from Ship_to_Site__c where Id =: stdController.getId()];
    }

    public PageReference redirect(){
        PageReference p;
        String acctString = '&retUrl=/'+ss.Dealer_Account__c;

        if(SPCommunityUtility.isPartnerUser()){
            
            String urlString = '/apex/SPCommunityShippingSiteDetails?id='+ss.Id;

            if(ss.Dealer_Account__c != null)
                urlString = urlString + acctString;

            p = new PageReference(urlString);
            p.setRedirect(true);
            
        }
        else{

            String urlString = '/'+ss.Id + '?nooverride=1';

            if(ss.Dealer_Account__c != null)
                urlString = urlString + acctString;

            p = new PageReference(urlString);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}