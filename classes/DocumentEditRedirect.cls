public with sharing class DocumentEditRedirect
{
    private final Document__c myDoc;

    public DocumentEditRedirect(ApexPages.StandardController stdController) 
    {
        this.myDoc = (Document__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityDocumentEdit?id='+myDoc.Id+'&retURL=/'+myDoc.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myDoc.Id + '/e?nooverride=1&retURL=%2F'+myDoc.Id);
            p.setRedirect(true);
        }
        return p;
    }
    
}