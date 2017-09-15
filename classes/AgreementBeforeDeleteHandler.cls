public class AgreementBeforeDeleteHandler extends TriggerHandlerBase{
	// -------- Constants --------
	Id hicContractRecTypeId = AgreementUtility.hicContractRecTypeId; // recordtype ID for HIC contract of Agreement
	Id lendingAgreementRecTypeId = AgreementUtility.lendingAgreementRecTypeId; // recordtype Id for Lending Agreement

	// -------- Constructor --------
	public AgreementBeforeDeleteHandler() {}

	// -------- Variables --------

	 // -------- Properties --------
	// Qualified records for actions
	private Map<Id, echosign_dev1__SIGN_Agreement__c> qualifiedAgreements;
	private Set<Id> hicAgreementQuoteIds;
	private Set<Id> lendingAgreementQuoteIds;
	private Set<Id> opportunityIdsToBeUpdated;
	private List<Quote> quotesToBeUpdated;
	private List<Opportunity> opportunitiesToBeUpdated;
	private Id profileId;

	public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {

		Map<ID, echosign_dev1__SIGN_Agreement__c> oldAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)oldMap;

		qualifiedAgreements = new Map<Id, echosign_dev1__SIGN_Agreement__c>();
		hicAgreementQuoteIds = new Set<Id>();
		lendingAgreementQuoteIds = new Set<Id>();
		opportunityIdsToBeUpdated = new Set<Id>();
		quotesToBeUpdated = new List<Quote>();
		opportunitiesToBeUpdated = new List<Opportunity>();

		profileId = UserInfo.getProfileId();
		User loggedinUser = [select Id, ByPassValidation__c from User where Id = :UserInfo.getUserId()];
		Profile p = [select Id, Name from Profile where Id = :profileId];

		for(Id i : oldAgreementMap.keySet()){
			echosign_dev1__SIGN_Agreement__c agg = oldAgreementMap.get(i);

			// adding HIC agreements to qualified agreements so that corresponding Quotes can be updated properly as part of Loan project by Ganesh Chedella
			if(agg.RecordTypeId == hicContractRecTypeId){
				   qualifiedAgreements.put(agg.Id,agg);
			}
			else if(agg.RecordTypeId == lendingAgreementRecTypeId){
				if(loggedinUser.ByPassValidation__c && p.Name == 'System Administrator'){
					qualifiedAgreements.put(agg.Id,agg);
				}
				else{
					if(agg.echosign_dev1__Status__c != 'Signed') {
						if(Label.Lending_Agreement_Deletable_Profiles != null && Label.Lending_Agreement_Deletable_Profiles.contains(p.Name)) {
							qualifiedAgreements.put(agg.Id,agg);
						}
						else{
							agg.addError('You are not authorized to delete this record');
						}
					}
					else if(agg.echosign_dev1__Status__c == 'Signed'){
						agg.addError('Contract cannot be deleted if it is signed by MOSAIC or customer');
					}
				}
			}
		}
	}

	public override void start() {
		  if(!qualifiedAgreements.isEmpty()){
			  for(Id i : qualifiedAgreements.keySet()){
				  // adding quote Ids from HIC Agreemnts to update them
				  echosign_dev1__SIGN_Agreement__c agg = qualifiedAgreements.get(i);
				  if(agg.RecordTypeId == hicContractRecTypeId)
					 hicAgreementQuoteIds.add(qualifiedAgreements.get(i).Quote__c);
				  else if(agg.RecordTypeId == lendingAgreementRecTypeId){
					 lendingAgreementQuoteIds.add(qualifiedAgreements.get(i).Quote__c);
				  }
			  }
		  }

		  // calling a method to update the quotes of all hic recordtype agreements
		  if(!hicAgreementQuoteIds.isEmpty()){
			  updateQuotesOfHICAgreements();
		  }

		  // calling a method to update the quotes of all lending agreement recordtype agreements
		  if(lendingAgreementQuoteIds.isEmpty()){
			   updateQuotesofLendingAgreements();
		  }

		 try{
			if(quotesToBeUpdated != null && !quotesToBeUpdated.isEmpty()){
				List<Database.SaveResult> quoteUpdateSaveResults = Database.update(quotesToBeUpdated,false);
				SpectrumDebugUtility.createExceptionLogs(quoteUpdateSaveResults,'updating Quote when either Lending Agreement or HIC Contract is being deleted',Quote.sObjectType);
			}
		 }
		 catch(Exception e){
			 Exception_log__c exceptionLog = new Exception_log__c();
			 exceptionLog.Error_Message__c = e.getMessage();
			 exceptionLog.Stack_Trace__c = e.getStackTraceString();
			 insert exceptionLog;
		 }
		 if(!opportunitiesToBeUpdated.isEmpty()){
			List<Database.SaveResult> opportunityUpdateSaveResults = Database.update(opportunitiesToBeUpdated,false);
		 }
	}

	public override void finish(Boolean fromStart) {
		  if(fromStart){}
	}

	private void updateQuotesOfHICAgreements(){
		for(Quote q : [select id,Loan_Contract_Status__c from Quote where ID IN :hicAgreementQuoteIds]){
			q.Loan_Contract_Status__c = 'Lending Agreement Created';
			quotesToBeUpdated.add(q);
		}
	}

	private void updateQuotesofLendingAgreements(){
		for(Quote q : [select id,Loan_Contract_Status__c,OpportunityId from Quote where ID IN :lendingAgreementQuoteIds]){
			q.Loan_Contract_Status__c = null;
			quotesToBeUpdated.add(q);
			opportunityIdsToBeUpdated.add(q.OpportunityId);
		}
		if(!opportunityIdsToBeUpdated.isEmpty()){
			for(Opportunity opp : [select id,Contract_Status__c from Opportunity where ID IN :opportunityIdsToBeUpdated]){
				opp.Contract_Status__c = null;
				opportunitiesToBeUpdated.add(opp);
			}
		}
	}
}