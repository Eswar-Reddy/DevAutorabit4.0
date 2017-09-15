public with sharing class DocumentRedirect
{
	private final Document__c myDoc;

    public DocumentRedirect(ApexPages.StandardController stdController) 
    {
        this.myDoc = (Document__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityDocumentDetails?id='+myDoc.Id+'&retURL=/'+myDoc.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myDoc.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
    
}