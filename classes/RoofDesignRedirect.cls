public with sharing class RoofDesignRedirect
{
  private final Roof_Design__c myRD;

  public RoofDesignRedirect(ApexPages.StandardController stdController) 
    {
      this.myRD = (Roof_Design__c)stdController.getRecord();
    }

  public PageReference redirect()
  {
    PageReference p;
    if(SPCommunityUtility.isPartnerUser())
    {
      String retUrl = ApexPages.currentPage().getParameters().get('retURL');
      p = new PageReference('/apex/SPCommunityRoofDesignDetails?id='+myRD.Id+'&retURL=/'+myRD.Id);

      p.setRedirect(true);
    }
    else
    {
      p = new PageReference('/'+myRD.Id + '?nooverride=1&retURL=/'+myRD.Id);

      p.setRedirect(true);
    }
    return p.setRedirect(true);
  }
}