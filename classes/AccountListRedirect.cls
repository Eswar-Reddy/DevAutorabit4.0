public with sharing class AccountListRedirect {
	public AccountListRedirect(ApexPages.StandardSetController controller) {

	}
	private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
	private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
	public AccountListRedirect(ApexPages.StandardController stdController) {
		//nothing because we're in the list
	}
	public PageReference redirect(){
		PageReference p;
		if(SPCommunityUtility.isPartnerUser()){
			//move to new stuff
			p = new PageReference('/apex/SPCommunityAccounts');
			//Partner Community Global permission set
		}
		else{
			p = new PageReference('/001?nooverride=1');
		}
		return p.setRedirect(true);
	}
}