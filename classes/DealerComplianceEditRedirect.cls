public with sharing class DealerComplianceEditRedirect 
{
	private final Dealer_Compliance_Requirement__c dcr;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];

    public DealerComplianceEditRedirect(ApexPages.StandardController stdController) 
    {
        this.dcr = (Dealer_Compliance_Requirement__c)stdController.getRecord();
    }

    public PageReference redirect()
    {
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            //move to new stuff
            p = new PageReference('/apex/CommunityDealerComplianceComplete?id='+dcr.Id);
            p.setRedirect(true);
            //Partner Community Global permission set
        }
        else
        {
            p = new PageReference('/'+dcr.Id + '/e?nooverride=1&retURL=%2F'+dcr.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}