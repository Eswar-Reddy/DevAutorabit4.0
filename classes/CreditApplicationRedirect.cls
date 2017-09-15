public with sharing class CreditApplicationRedirect{
  private final Credit_Application__c creditapplication;
  private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
  private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
  public CreditApplicationRedirect(ApexPages.StandardController stdController) {
    this.creditapplication = (Credit_Application__c)stdController.getRecord();
  }
  public PageReference redirect(){
    PageReference p;
if(SPCommunityUtility.isPartnerUser()){
      //move to new stuff
      p = new PageReference('/apex/SPCommunityCreditApplicationDetail?id='+creditapplication.Id);
      p.setRedirect(true);
      //Partner Community Global permission set
    }
    else{
      p = new PageReference('/'+creditapplication.Id + '?nooverride=1');
      p.setRedirect(true);
    }
    return p.setRedirect(true);
  }
}