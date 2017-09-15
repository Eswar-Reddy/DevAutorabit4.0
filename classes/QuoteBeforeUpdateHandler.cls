public without sharing class QuoteBeforeUpdateHandler extends TriggerHandlerBase {

    public QuoteBeforeUpdateHandler() {}

    private Map<ID, Quote> oldMap;
    private Map<ID, Quote> newMap;
    private List<Quote> newList;
    private List<Quote> oldList;
    private Map<Integer, Quote> qualifyOriginalLeaseNumberMap = new Map<Integer, Quote>();
    private Map<Id, Quote> qualifyFranceAccMap = new Map<Id, Quote>();
    private Set<Id> qIdSet = new Set<Id>();
    private Map<Id, Quote> QuoteNewMap;
    private List<Installation_Model__c> lIM = new List<Installation_Model__c>();
    private Map<Id,Quote> dealerFeeQuoteMap = new Map<Id,Quote>();
    private List<Quote> lstQ = new List<Quote>();
    private Set<String> saTVals = new Set<String>{'Product','Lessee','Production'};
    private List<Id> lstOppIds = new List<Id>();
    private List<Id> lstAcctIds = new List<Id>();
    private Map<Id, String> mapSEmail = new Map<Id, String>();
    private Map<Id, String> mapAccCountry = new Map<Id, String>();   //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    private list<Quote> updateSystemModelList = new List<Quote>();
    private List<Quote> updateAmendmentType = new List<Quote>();
    private List<Quote> lockedQuotes = new List<Quote>();


    public override void qualifyStartingRecords(List<sObject> newList, List< sObject > oldList, Map<ID, sObject > newMap, Map<ID, sObject > oldMap) {
        this.newMap = (Map<ID, Quote>)newMap;
        this.oldMap = (Map<ID, Quote>)oldMap;
        this.newList = (List<Quote>)newList;
        this.oldList = (List<Quote>)oldList;
		
		//Filtering for locked quotes
        for(Quote qt : this.newList){
            if(qt.Is_Locked__c == true && this.oldMap.get(qt.Id).Is_Locked__c != true){
                lockedQuotes.add(qt);
            }
        }

       //  filtering records to udpate AmendmentType and Update Lease doc
         for(Quote Q : this.newList){
                Quote oldRec = this.oldMap.get(Q.Id);
                if(Q.Amended_Lease__c != null && Q.Amended_Lease__c != oldRec.Amended_Lease__c){
                     updateAmendmentType.add(Q);
                     break;
                }
             }

         for (Integer i=0; i<this.newList.size(); i++) {
            Id recId = this.newList[i].Id;
            Quote newRec = this.newMap.get(recId);
            Quote oldRec = this.oldMap.get(recId);

            // Merging UpdateSystemModelField Trigger Code

            if(newRec.System_Model__c == null && newRec.Copy_SM_Before_Lock__c != null){
                 updateSystemModelList.add(newRec);
            }
            // End of Merging.
            // Merging beforeQuoteUpdate Trigger Code
            if(newRec.Is_Locked__c && newRec.Amendment_Type__c != null && saTVals.contains(newRec.Amendment_Type__c) && newRec.Amended_Lease__c != null)
              lstQ.add(newRec);
            if (newRec.Account_Billing_Country__c != null && newRec.Account_Billing_Country__c.equalsIgnoreCase('France')) {
                qualifyFranceAccMap.put(newRec.id, newRec);
            }
            if((newRec.QuoteType__c == 'Loan' || newRec.QuoteType__c == 'Lease' || newRec.QuoteType__c == 'Cash') && newRec.Is_Locked__c && newRec.Lease_Doc_Signed__c && (newRec.Lease_Doc_Signed__c != oldRec.Lease_Doc_Signed__c)){
                qIdSet.add(newRec.Id);
            }
        }

        if(!qIdSet.isEmpty())
                QuoteNewMap = new Map<Id, Quote>([select Id,QuoteType__c,Account_Billing_Country__c, Installation_Model__c,sector__c,Opportunity.Partner_Account_Id__r.NH_SSE_Type__c,Opportunity.Partner_Account_Id__r.Name,Opportunity.Partner_Account_Id__r.Channel__c  from Quote where Id in :newList]);

       for (Integer i=0; i<this.newList.size(); i++) {
            Id recId = this.newList[i].Id;
            Quote newRec = this.newMap.get(recId);
            Quote oldRec = this.oldMap.get(recId);
            if((newRec.QuoteType__c == 'Loan' || newRec.QuoteType__c == 'Lease' || newRec.QuoteType__c == 'Cash') && newRec.Is_Locked__c && newRec.Lease_Doc_Signed__c && (newRec.Lease_Doc_Signed__c != oldRec.Lease_Doc_Signed__c)){
                if(QuoteNewMap.size() > 0 && QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.NH_SSE_Type__c == Null ||(QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.NH_SSE_Type__c <> Null && (!QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.NH_SSE_Type__c.contains('TPS')))){

                    // New Homes Installation Model Assignment
                    if (QuoteNewMap.get(newRec.Id).Sector__c == 'New Homes'){
                        system.debug('inside NH');
                        //lIM  = [select Id,Name from Installation_Model__c where Type__c = 'Auto' AND Partner__c = 'New Homes' AND Financing_Option__c includes (:QuoteNewMap.get(newRec.Id).QuoteType__c)];
                        newRec.Installation_Model__c = InvoiceDocumentUtility.findInstallationModel(QuoteNewMap.get(newRec.Id).QuoteType__c, 'New Homes', QuoteNewMap.get(newRec.Id).Account_Billing_Country__c);

                    }
                    else if (QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__c != NULL){
                        // SPD Installation Model Assignment
                        if(QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.Channel__c == 'Direct' || QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.Name.contains('SPWR') || QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.Name.contains('SunPower') || QuoteNewMap.get(newRec.Id).Opportunity.Partner_Account_Id__r.Name.contains('SPD')){
                            newRec.Installation_Model__c = InvoiceDocumentUtility.findInstallationModel(QuoteNewMap.get(newRec.Id).QuoteType__c, 'SPD', QuoteNewMap.get(newRec.Id).Account_Billing_Country__c);
                        }
                        // Indirect Installation Model Assignment
                        else{
                            newRec.Installation_Model__c = InvoiceDocumentUtility.findInstallationModel(QuoteNewMap.get(newRec.Id).QuoteType__c, 'Indirect', QuoteNewMap.get(newRec.Id).Account_Billing_Country__c);
                        }
                    }

                }
             }

            if((newRec.QuoteType__c == 'Loan' || newRec.QuoteType__c == 'Lease' || newRec.QuoteType__c == 'Cash') && newRec.Is_Locked__c && newRec.Lease_Doc_Signed__c && ((newRec.Lease_Doc_Signed__c != oldRec.Lease_Doc_Signed__c) ||(newRec.Installation_Model__c!=null && oldRec.Installation_Model__c==null))){
                if(newRec.Installation_Model__c!=null && oldRec.Installation_Model__c==null){
                    Installation_Model__c iModel = [select Roles__c,Type__c from Installation_Model__c where Id=:newRec.Installation_Model__c];
                    if(iModel.Type__c!='Auto'){
                        List<OpportunityTeamMember> otmList = [select TeamMemberRole from OpportunityTeamMember where OpportunityId = :newRec.Opportunity_ID__c];
                        String missingRoles = PrepPOLineItems.findMissingRoles(otmList,iModel);
                        if(missingRoles!=null){
                            newRec.addError('The following Opportunity Team Members are not setup: '+missingRoles);
                            return;
                        }
                    }
                    dealerFeeQuoteMap.put(newRec.Id,newRec);
                }
                else{
                    dealerFeeQuoteMap.put(newRec.Id,newRec);
                }
            }
        }
       // Merge Ends
    }

    public override void start() {
		
		//To populate Lessee field on Quote
        if(!lockedQuotes.isEmpty()){
            QuoteTriggerUtility.populateLessee(lockedQuotes);
        }

        if(!qualifyFranceAccMap.isEmpty()){
            QuoteManagement.updateQuoteFromStringSizerTool(qualifyFranceAccMap, oldMap);
        }
        // Calling the function to update Invertervalues on Quote.
        QuoteTriggerUtility.UpdateQuoteInverterValues(newList);
        // Calling the function to update System Model  on Quote.
        QuoteTriggerUtility.UpdateQuoteSystemModelField(updateSystemModelList);
        if(!dealerFeeQuoteMap.isEmpty())
            System.debug('Updated Loan Quotes ----->'+ Dealerfee_cal_Utility_ModelBased.fIdentifiedRoleAndRelatedPartners(dealerFeeQuoteMap));
        // Merging CopyQuoteValuesUpdate Trigger code
        if(!lstQ.isEmpty()) {
           CloneQuote cq = new CloneQuote();
           cq.quoteUpdate(lstQ);
        }
        // End of Merging.

        // Calling the function QuoteforAgreement for both beforeInsert & beforeUpdate
              QuoteTriggerUtility.QuoteforAgreement(newList);

        if(updateAmendmentType.size() > 0){
              QuoteTriggerUtility.updateAmendmentType(updateAmendmentType);
          }
    }


    public override void finish(Boolean fromStart) {}

}