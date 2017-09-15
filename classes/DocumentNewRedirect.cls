public with sharing class DocumentNewRedirect
{
	private final Document__c myDoc;

    public DocumentNewRedirect(ApexPages.StandardController stdController) 
    {
        this.myDoc = (Document__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            String acctStr = '&Account__c='+myDoc.Account__c;
            String oppStr = '&Opportunity__c='+myDoc.Opportunity__c;
            String rpStr = '&Residential_Project__c='+myDoc.Residential_Project__c;
            String urlStr = '/apex/SPCommunityDocumentNew?objecttype=Document__c';
            if(myDoc.Opportunity__c != null)
                urlStr = urlStr + oppStr + '&retURL=/'+myDoc.Opportunity__c;
            
            if(myDoc.Account__c != null)
                urlStr = urlStr + acctStr + '&retURL=/'+myDoc.Account__c;

            if(myDoc.Residential_Project__c != null)
                urlStr = urlStr + rpStr + '&retURL=/'+myDoc.Residential_Project__c;
            
            p = new PageReference(urlStr);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/a5F/e?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
    
}