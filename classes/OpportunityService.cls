/*************************************************
Purpose :: Opportunity Management related Webservices
Author  :: Appiro(Prakash Gyamlani)

**************************************************/
global class OpportunityService {
	/*
		Function approve the Opportunity if it is non-approved
	*/
	webService static boolean approveOpportunity(String oppID) {
		Opportunity opp = [select id,isApproved__c from Opportunity where id = :oppID LIMIT 1];
		if(!opp.isApproved__c){
			opp.isApproved__c = !opp.isApproved__c;
			update opp;
		}
		return true;
	}
}