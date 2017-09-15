public with sharing class AccountRedirect {
    private final Account acct;
    public AccountRedirect(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }
    public PageReference redirect(){
        PageReference p;
        if(SPCommunityUtility.isPartnerUser()){
            String commercialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType).get('Commercial');
            if (acct.RecordTypeId == commercialRecordTypeId && SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) {
                p = Page.SPCommunityCustomer;
                p.setAnchor('/account/commercial/'+acct.Id+'/view');
            } else {
                p = new PageReference('/apex/SPCommunityAccountDetails?id='+acct.Id);
            }
            p.setRedirect(true);
        }
        else{
           p = new PageReference('/apex/AccountNewDetail?id='+acct.Id);
            p.setRedirect(true);
        }
        return p.setRedirect(true);
    }
}