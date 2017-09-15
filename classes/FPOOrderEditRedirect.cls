public with sharing class FPOOrderEditRedirect 
{
	private final FPO_Order_Line__c fpo;

    public FPOOrderEditRedirect(ApexPages.StandardController stdController) 
    {
        this.fpo = (FPO_Order_Line__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityFPOOrderEdit?id='+fpo.Id+'&retURL=/'+fpo.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+fpo.Id + '/e?nooverride=1&retURL=%2F'+fpo.Id);
            p.setRedirect(true);
        }
        return p;
    }
}