public with sharing class QuoteSummaryRedirect
{
  private final Quote_Summary__c myQuoteSummary;

    public QuoteSummaryRedirect(ApexPages.StandardController stdController) 
    {
        this.myQuoteSummary = (Quote_Summary__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityQuoteSummaryDetails?id='+myQuoteSummary.Id+'&retURL=/'+myQuoteSummary.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myQuoteSummary.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}