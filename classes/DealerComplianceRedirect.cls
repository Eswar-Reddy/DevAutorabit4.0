public with sharing class DealerComplianceRedirect
{
	private final Dealer_Compliance_Requirement__c dcr;
	private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
	private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];

	public DealerComplianceRedirect(ApexPages.StandardController stdController)
	{
		this.dcr = (Dealer_Compliance_Requirement__c)stdController.getRecord();
	}

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            p = new PageReference('/apex/CommunityDealerCompliancePage?id='+dcr.Id);
            p.setRedirect(true);
        }
        else
        {
            p = new PageReference('/'+dcr.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}