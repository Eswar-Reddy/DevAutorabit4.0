public with sharing class SunpowerDesignsRedirect
{
	private final SunPower_Design__c myDes;

    public SunpowerDesignsRedirect(ApexPages.StandardController stdController) 
    {
        this.myDes = (SunPower_Design__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser())
        {
            p = new PageReference('/apex/SPCommunitySunpowerDesignsDetails?id='+myDes.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+myDes.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p;
    }
}