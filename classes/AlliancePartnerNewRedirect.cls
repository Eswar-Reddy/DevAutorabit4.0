public with sharing class AlliancePartnerNewRedirect 
{
	private final Alliance_Partner__c part;

    public AlliancePartnerNewRedirect(ApexPages.StandardController stdController) 
    {
        this.part = (Alliance_Partner__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String resStr = '&Residential_Project__c='+part.Residential_Project__c;
            String acctStr = '&Partner_Account__c='+part.Partner_Account__c;
            String comStr = '&Community__c='+part.Community__c;
            String urlStr = '/apex/SPCommunityAlliancePartnerNew?objecttype=Alliance_Partner__c';
            if(part.Partner_Account__c != null)
                urlStr = urlStr + acctStr;
            
            if(part.Residential_Project__c != null)
                urlStr = urlStr + resStr + '&retURL=/'+part.Residential_Project__c;

            if(part.Community__c != null)
                urlStr = urlStr + comStr;
            
            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/a7l/e?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
    
}