public with sharing class WarrantyRegistrationRedirect 
{
  public string redirectLink{get;set;}
  public WarrantyRegistrationRedirect() 
  {}

  public PageReference redirect()
  {
    String custId = ApexPages.currentPage().getParameters().get('CustomerId');

    String urlStr = '';
    if(custId != null)
      urlStr = '?CustomerId='+custId;

    PageReference p;
    if(SPCommunityUtility.isPartnerUser())
    {
      p = new PageReference('/apex/SPCommunityWarrantyRegistration'+urlStr);
      p.setRedirect(true);
      redirectLink = '/apex/SPCommunityWarrantyRegistration'+urlStr;
    }
    else
    {
      p = new PageReference('/apex/WarrantyRegistrationPanel'+urlStr);
      p.setRedirect(true);
      redirectLink = '/apex/WarrantyRegistrationPanel'+urlStr;
            
    }
    return null;
  }
}