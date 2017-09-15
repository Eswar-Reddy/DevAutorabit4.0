public class InlineDealerLocatorController {
    
    public ApexPages.StandardController controller {get;set;}
    public Lead record {get;set;}
    public Campaign relatedCampaign {get;set;}
    public ApexPages.Message myMsg {get;set;}
    public final String noCampaignInfo = 'This lead does not have an associated Campaign. Displaying closest dealers, if any are available.';
    public final String preQualInfo = 'This Lead requires pre-qualification. You must warm transfer or set an appointment before converting. Leads can only be assigned to the dealer(s) shown below.';
    public final String noDealersInArea = 'No dealers were found for this location. Please verify address before proceeding.';
    public final String noCPartners = 'No Campaign Partners were found for this location. The results shown, if any, are the closest dealers to this lead.';
    public final String standardCampInfo = 'This campaign does not reqire pre-qualification. This lead can be assigned and converted to a dealer immediately.';
    public final String noPreQualDealers = 'Pre-Qualification campaigns may only be assigned to eligible partners. If no partners are shown, the lead is disqualified.';
    public final String noIsExclusiveDealers = 'This campaign is exclusive and can ONLY be assigned to campaign partners. If no dealers are shown, you can select one from the campaign or disqualify the lead.';
    public final String isExclusiveInfo = 'This campaign is exclusive and can ONLY be assigned to campaign partners and must be warm transferred or have an appointment set before converting.';
     public InlineDealerLocatorController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.record = [SELECT State, Street, City, Country, PostalCode FROM Lead WHERE Id =: controller.getId()];

        getCampaignData();
    }
    
    private void getCampaignData() {
             
        try {
            CampaignMember cm = [SELECT CampaignId FROM CampaignMember Where LeadId =: record.Id Order By LastModifiedDate Desc LIMIT 1];
            relatedCampaign = [SELECT Name, Short_Description__c,Requires_Lead_Pre_Qualification__c,isExclusive__c, AssignRandomPartner__c,
                                (SELECT Id, Name, Enabled__c, Partner_Type__c, Partner__c, Partner__r.Phone, Partner__r.Type, Partner__r.Name, Partner__r.Dealer_Tier__c FROM Campaign_Partners__r) 
                                FROM Campaign 
                                WHERE ID =: cm.CampaignId Order By CreatedDate Desc LIMIT 1];
        } catch(Exception e) {

        }         
    }
    
    public List<ListResult> getEligiblePartners() {
        
        //return if no postal code
        if(record.PostalCode == null) {
            myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noDealersInArea);
            ApexPages.addMessage(myMsg);
            return new List<ListResult>();
        }
        
        //fetch dealers for the postal code area
        List<DealerResult> resultRows = DealerUtility.getDealersForDealerLocator(record.street, record.city, record.state, record.postalCode, record.country, null); //DealerLocatorService.fetchDealers(record.PostalCode, 100, null);
        for(Integer i = 0; i < resultRows.size(); i++) {
            DealerResult r = resultRows[i];
            if(r.LeadFlowOptOut == true) 
                resultRows.remove(i);
        }
        //return if no dealers found
        if(resultRows.isEmpty()) {
            myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noDealersInArea);
            ApexPages.addMessage(myMsg);
            return new List<ListResult>();
        }
        else {
            //No campaign on lead
            if(relatedCampaign == null) {
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO, noCampaignInfo);
                ApexPages.addMessage(myMsg);
                List<DealerResult> temp = LeadDealerUtility.masterDealerPrioritization(resultRows);
                List<ListResult> results = buildResultsForPage(temp, null, 'Standard');
                results.sort();
                return results;
            }
            //prequalification campaign scenario
            //else if(relatedCampaign.Requires_Lead_Pre_Qualification__c) {
            
            //Warm Handoff  prequalification or is Exclusive is being checked  no Is SPD as of now
          /*  else if(relatedCampaign.Requires_Lead_Pre_Qualification__c ) {
                List<ListResult> results = new List<ListResult>();
                List<DealerResult> temp = findCampaignPartners(resultRows, relatedCampaign.Campaign_Partners__r);
                if(temp.isEmpty()) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noPreQualDealers);
                } else {
                    myMsg = new ApexPages.Message(ApexPages.Severity.INFO, preQualInfo);
                    results = buildResultsForPage(temp, relatedCampaign.Campaign_Partners__r, 'Appointment Setting');
                } 
                ApexPages.addMessage(myMsg);
                results.sort();
                return results;
            } */
            //IsExlucive Message Display related changes
             else if(relatedCampaign.isExclusive__c) {
                List<ListResult> results = new List<ListResult>();
                List<DealerResult> temp = findCampaignPartners(resultRows, relatedCampaign.Campaign_Partners__r);
                if(temp.isEmpty()) {
                    myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noIsExclusiveDealers);
                } else {
                    myMsg = new ApexPages.Message(ApexPages.Severity.INFO, isExclusiveInfo);
                    results = buildResultsForPage(temp, relatedCampaign.Campaign_Partners__r, 'Appointment Setting');
                } 
                ApexPages.addMessage(myMsg);
                results.sort();
                return results;
            }
            //Paid Campaign scenario
            else if(relatedCampaign.AssignRandomPartner__c) {
                
                List<DealerResult> campPartnerResults = findCampaignPartners(resultRows, relatedCampaign.Campaign_Partners__r);
                List<DealerResult> temp = new List<DealerResult>();
                List<ListResult> finalResults = new List<ListResult>();
                if(campPartnerResults.isEmpty()) {
                    //no campaign partners found, look for master dealers, else all dealers in area
                    myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noCPartners);
                    temp = LeadDealerUtility.masterDealerPrioritization(resultRows);
                } else {
                    myMsg = new ApexPages.Message(ApexPages.Severity.INFO, standardCampInfo);
                    //prioritize and remove highest assigned
                    temp = getDealersBasedOnLeadDistribution(campPartnerResults, relatedCampaign.Id);
                }
                finalResults = buildResultsForPage(temp, relatedCampaign.Campaign_Partners__r, 'Standard');
                ApexPages.addMessage(myMsg);
                finalResults.sort();
                return finalResults;
            } else {
                List<DealerResult> campPartnerResults = findCampaignPartners(resultRows, relatedCampaign.Campaign_Partners__r);
                List<DealerResult> temp = new List<DealerResult>();
                List<ListResult> finalResults = new List<ListResult>();
                if(campPartnerResults.isEmpty()) {
                    //no campaign partners found, look for master dealers, else all dealers in area
                    myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, noCPartners);
                    temp = LeadDealerUtility.masterDealerPrioritization(resultRows);
                    finalResults = buildResultsForPage(temp, null, 'Standard');
                } else {
                    myMsg = new ApexPages.Message(ApexPages.Severity.INFO, standardCampInfo);
                    finalResults = buildResultsForPage(campPartnerResults, relatedCampaign.Campaign_Partners__r, 'Standard');
                }
                ApexPages.addMessage(myMsg);
                finalResults.sort();
                return finalResults;
            }
        }
        return null;
    }
    
    
    private List<ListResult> buildResultsForPage(List<DealerResult> resultRows, List<Campaign_Partner__c> campaignPartners, String partnerHandleType) {
        
        List<ListResult> results = new List<ListResult>();
        if(resultRows == null || resultRows.isEmpty()) 
            return results;
        else {
            Map<Id, Campaign_Partner__c> cpMap = new Map<Id, Campaign_Partner__c>();
            if(campaignPartners != null) {
                for(Campaign_Partner__c cp : campaignPartners) {
                    cpMap.put(cp.Partner__c, cp);
                }
            }

            for(DealerResult row : resultRows) {
                
                //Split the type to determine tier for sorting
                List<String> splits = row.Type.split('-');
                String s = '';
                try { s = splits[0]; } catch(exception obex) { System.debug('Split Index failure'); }

                ListResult r = new ListResult();
                r.name = row.AccountName;
                r.partnerId = row.AccountId;
                r.AllianceProgramPartner = row.AllianceProgramPartner;
                if(!cpMap.isEmpty() && cpMap.containsKey(row.AccountId)) {
                    r.handleType = (cpMap.get(row.AccountId).Partner_Type__c == null ? partnerHandleType : cpMap.get(row.AccountId).Partner_Type__c);
                    r.isOverflowPartner = (cpMap.get(row.AccountId).Enabled__c == null ? false : cpMap.get(row.AccountId).Enabled__c);   
                } else {
                    r.handleType = partnerhandleType;
                    r.isOverflowPartner = true;
                }
                r.dealerPriority = s;
                r.partnerPhone = row.DealerLocatorPhone == null ? row.Phone : row.DealerLocatorPhone;
                r.rsmID = row.rsmID;
                r.rsmName = row.rsmName;
                results.add(r);
            }
        }
        return results;
    }
    
    private List<DealerResult> findCampaignPartners(List<DealerResult> resultRows, List<Campaign_Partner__c> campaignPartners) {
        
        List<DealerResult> results = new List<DealerResult>();
        if(resultRows == null || resultRows.isEmpty() || campaignPartners == null || campaignPartners.isEmpty())
            return results;
        else {
            for(Campaign_Partner__c cp : campaignPartners) {
                for(DealerResult row : resultRows) {
                    if(cp.Partner__c == row.AccountId) {
                        results.add(row);
                    }
                }
            }
        }
        return results;
    }
    
    public List<DealerResult> getDealersBasedOnLeadDistribution(List<DealerResult> resultRows, string CampaignId ) {
        
        if(resultRows.size() <= 5) return resultRows;
        
        List<DealerResult> results = new List<DealerResult>();
        for(DealerResult dr : resultRows) {
            if(dr.Type != null && dr.Type.containsIgnoreCase('Master')) {
                results.add(dr);
            }
        }
        
        if(results.size() < 3) return results;
        
        AggregateResult[] listAlreadyAssigned = [SELECT Dealer_Assigned__c, count(Id) FROM Lead_Dealer_Assignment_Audit__c 
                                                 WHERE Campaign__c =: campaignId AND Dealer_Assigned__c != null
                                                 GROUP BY Dealer_Assigned__c ORDER BY count(Id) DESC];
        
        if(listAlreadyAssigned == null || listAlreadyAssigned.isEmpty()) return resultRows;
        
        //===========================================================================
        //====  Indicates some have more than other so we remove the top one and return the rest
        //===========================================================================
        
        Integer mostAssigned = 0;
        for(AggregateResult leadAssignment3 : listAlreadyAssigned) 
            if (integer.valueOf(leadAssignment3.get('expr0')) > mostAssigned) 
                mostAssigned = integer.valueOf(leadAssignment3.get('expr0'));
        
        list<Id> listTOEXCLUDEDealerPool = new list<Id>();
        for (AggregateResult leadAssignment4 : listAlreadyAssigned) {
            if (integer.valueOf(leadAssignment4.get('expr0')) == mostAssigned) {
                listTOEXCLUDEDealerPool.add((ID)leadAssignment4.get('Dealer_Assigned__c'));
            }
        }
        
        //So we found the biggest - now populate the POOL and omitt any that have the biggest
        Boolean bFound = false;
        Map<Id, DealerResult> listDealerPool = new Map<Id, DealerResult>();
        for(DealerResult d : resultRows) { //Load the Pool based on the Dealer List Passed IN
            bFound = false;
            for(Id leadAssignment5 : listTOEXCLUDEDealerPool) {
                if (leadAssignment5 == d.AccountId && !d.AccountName.containsIgnoreCase(Label.Sunpower) && d.Type != null && !d.Type.containsIgnoreCase('Master')) { //never exclude Sunpower or masters
                    bFound = true;
                }
            }
            if(!bFound)
                listDealerPool.put(d.AccountId, d);
        }
        //remove highest assigned, return rest of list
        if(listDealerPool.isEmpty()){//was only one or all were assigned equally so just return
            return resultRows;
        }
        else {
            List<DealerResult> newResults = new List<DealerResult>();
            try {
                listDealerPool.remove(listTOEXCLUDEDealerPool[0]);
            } catch(Exception e) {
                System.debug('Index error: ' + e.getMessage());
            }
            
            return listDealerPool.values();
        }
        return null;
    }
    
    
     public class ListResult implements Comparable {
        
        public String name {get;set;}
        public String dealerPriority {get;set;}
        public String partnerPhone {get;set;}
        public Id partnerId {get;set;}
        public String handleType {get;set;}
        public boolean isOverflowPartner {get;set;}
        public boolean AllianceProgramPartner {get;set;}
        public String rsmId {get;set;}
         public String rsmName {get;set;} 
        
         public Integer compareTo(Object other) {
         
            return sortByTier(other);
        }
        
        private Integer sortByTier(Object other) {    
            ListResult obj = (ListResult)other;
            
            if(obj.DealerPriority == this.DealerPriority)
                return 0;
            if(obj.DealerPriority == 'Master')
                return 1;
            if(obj.DealerPriority == 'Elite' && this.DealerPriority != 'Master' )
                return 1;
            if(obj.DealerPriority == 'Elite' && this.DealerPriority == 'Master') 
                return -1;
            if(obj.DealerPriority == 'Elite' && (this.DealerPriority == 'Authorized' || this.DealerPriority == 'Premier')) 
                return 1;
            if(obj.DealerPriority == 'Premier' && (this.DealerPriority == 'Master' || this.DealerPriority == 'Elite'))
                return -1;
            if(obj.dealerPriority == 'Premier' && this.DealerPriority == 'Authorized')
               return 1;
            if(obj.DealerPriority == 'Authorized')
                return -1;
            return -1;
        }
    }

}