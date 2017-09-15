public with sharing class LearningRedirect
{
  private final Learning__c myLearning;

    public LearningRedirect(ApexPages.StandardController stdController) 
    {
        this.myLearning= (Learning__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunityLearningDetails?id='+myLearning.Id+'&retURL=/'+myLearning.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myLearning.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}