public with sharing class FPOOrderRedirect 
{
	private final FPO_Order_Line__c fpo;

    public FPOOrderRedirect(ApexPages.StandardController stdController) {
        this.fpo = [select Id, Lease_Payment__c from FPO_Order_Line__c where Id =: stdController.getId()];
    }

    public PageReference redirect()
    {
        PageReference p;
        String acctString = '&retUrl=/'+fpo.Lease_Payment__c;

        if(SPCommunityUtility.isPartnerUser()){
            
            String urlString = '/apex/SPCommunityFPOOrderDetails?id='+fpo.Id;

            if(fpo.Lease_Payment__c != null)
                urlString = urlString + acctString;

            p = new PageReference(urlString);
            p.setRedirect(true);
            
        }
        else
        {

            String urlString = '/'+fpo.Id + '?nooverride=1';

            if(fpo.Lease_Payment__c != null)
                urlString = urlString + acctString;

            p = new PageReference(urlString);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}