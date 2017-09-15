public with sharing class FPOOrderNewRedirect 
{
	private final FPO_Order_Line__c myDoc;

    public FPOOrderNewRedirect(ApexPages.StandardController stdController) 
    {
        this.myDoc = (FPO_Order_Line__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String acctStr = '&Lease_Payment__c='+myDoc.Lease_Payment__c;
            String urlStr = '/apex/SPCommunityFPOOrderNew?objecttype=FPO_Order_Line__c';
            if(myDoc.Lease_Payment__c != null)
                urlStr = urlStr + acctStr + '&retURL=/'+myDoc.Lease_Payment__c;
            
            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        else
        {
        	Schema.DescribeSObjectResult r = FPO_Order_Line__c.sObjectType.getDescribe();
			String keyPrefix = r.getKeyPrefix();

            p = new PageReference('/'+keyPrefix+'/e?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}