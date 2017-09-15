Global Class DealerLocatorService{  


//===================================================================    
    webservice static List<ResultRow> findDealers(String street, String city, String state, String postalCode, String country, String accType){
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        
        list<DealerResult> dealerResults = new list<DealerResult>();
        
        dealerResults = DealerUtility.getDealersForDealerLocator(street,  city,  state,  postalCode,  country, 0);
        
        for (DealerResult dr : dealerResults) {
            ResultRow row = new ResultRow(dr);
            resultRows.add(row);
        }
        
        return resultRows;
    }
//===================================================================
 
//===================================================================
  webservice static void AssignDealer(Id OpportunityId) {
    DealerUtility.AutoAssign(OpportunityId);
  }

    /*
        Created By : SunPower (Niket)
        Summary    : Check the new assigned dealer is SPD or not if its SPD then do five 9 call 
    */

    webservice static void Five9Call(Id OpportunityId){
        
        Opportunity objOpp = [Select PartnerAccount.Name, PartnerAccountId,Not_Sent_To_Five9__c,Primary_Phone__c,Id,Campaign.Name,Opportunity_Number1__c from Opportunity where Id =: OpportunityId];
        List<SpectrumDebugUtility.debugLog> debuglogs = new List<SpectrumDebugUtility.debugLog>();
        
        // do Http Callout for SPD only
        if(objOpp.PartnerAccountId != null && String.valueOf(objOpp.PartnerAccountId).equalsIgnoreCase(system.label.SPDIds)){
            boolean calloutSuccess = Five9CallHandler.callfive9addtoList(objOpp);
            if(calloutSuccess == false)
                objOpp.Not_Sent_To_Five9__c = true;
            else if(calloutSuccess==true){
                objOpp.Not_Sent_To_Five9__c = false;
            }
            
            try{
                SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
                log.opportunityId = objOpp.Id;
                log.Service = 'Five9Call';
                log.Response = String.valueOf(calloutSuccess);
                System.debug(LoggingLevel.ERROR, 'Five 9 Call Done');
                debugLogs.add(log);
                
                SpectrumDebugUtility.generateDebugLog(debugLogs);
            }catch(Exception ex){
                system.debug(LoggingLevel.ERROR,'Debug logging failed'+ex.getMessage());
            }
        }
        
        database.update(objOpp);
    }

/*New Method For Reassigning Lead Dealer*/ 
//===================================================================
  webservice static void AssignNewLeadDealer(Id LeadId) {
      Set<Id> leadSet = new Set<Id>();
        leadSet.add(leadId);
     LeadDealerUtility.leadReassignment(leadSet);
  }
//===================================================================
    
    
//===================================================================   
    // Webservice to fetch the dealers existing in particular range of the location
    // Argument passed are
    //1. zip - PostalCode of the location
    //2. radius - range around the location of zip code provided
    //3. accType - type of partner "Home", "Commercial", "Both" (Case # 00154706)
    // Case # 00154706 - using a new custom field "New_Dealer_Rank__c" on Account to decide the type of Account.
    webservice static List<ResultRow> fetchDealers(String zip, Integer radius, String accType){
    
    String partnerType = accType;
    List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
      
    if (accType == 'Commercial')        
    {    
        list<DealerResult> dealerResults = new list<DealerResult>();
        
        dealerResults = CommercialDealerUtility.getDealersForDealerLocator(null,  null,  null,  zip,  'United States', radius);
       //case ID: 00716869 , Updating the commercial Dealers Sorting only on : Distance - Chakra
        DealerResult.SORT_FIELD = DealerResult.SortField.Distance;
        DealerResult.SORT_DIR = DealerResult.SortDirection.ASCENDING;
        dealerResults.sort();
        
        system.debug('@@@@@fetchDealers; Returned results: '+dealerResults.size());
        
        for (DealerResult dr : dealerResults) {
            ResultRow row = new ResultRow(dr);
            resultRows.add(row);
        }

        return resultRows;  
    }
    else
    {
        //List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        
        list<DealerResult> dealerResults = new list<DealerResult>();
        
        dealerResults = DealerUtility.getDealersForDealerLocator(null,  null,  null,  zip,  'United States', radius);
        
        system.debug('@@@@@fetchDealers; Returned results: '+dealerResults.size());
        
        for (DealerResult dr : dealerResults) {
            ResultRow row = new ResultRow(dr);
            resultRows.add(row);
        }
        
        return resultRows;  
    }
    
    }
//===================================================================

//===================================================================    
    //Start 00122443 - Provide functionality to fetch all dealers regradless of zip/radius
    webservice static List<ResultRow> fetchAllDealers(){
        List<ResultRow> allDealers = new List<ResultRow>();
        
        List<ResultRow> premierDealers = new List<ResultRow>();
        List<ResultRow> authorizedDealers = new List<ResultRow>();
        List<ResultRow> otherDealers = new List<ResultRow>();

        for (SObject rec : SearchService.getInstance().findRecords(new Set<String>(), null,null)) {
            Account dealer = (Account)rec; 
             
            Double distance = 0.0;
                
                DealerResult r = new DealerResult(
                    dealer.Id, dealer.Name,dealer.type, 
                    dealer.Geolocation__Latitude__s, dealer.Geolocation__Longitude__s,
                    distance, dealer.Dealer_Score_Total__c, dealer.Dealer_Locator_Phone__c, dealer.phone,dealer.BillingStreet,
                    dealer.BillingCity, dealer.BillingState, dealer.BillingCountry, dealer.BillingPostalCode,
                    dealer.website, dealer.Oracle_Account_Number__c, dealer.Description, dealer.Partner_Facts__c,
                    dealer.Alliance_Program_Partner__c, dealer.Opportunity_Recipient__c, dealer.Dealer_Locator_Opt_Out__c,
                    dealer.Lead_Flow_Opt_Out__c);
                
                                
                //ResultRow row = new ResultRow(rec , Decimal.valueOf(distance).setScale(1), partnerType );
                ResultRow row = new ResultRow(r);            
            
            //ResultRow row = new ResultRow(rec , null, null);
            //Following is done to show dealer in the order Elite, Premier and then authorized.
            if(dealer.New_Dealer_Rank__c == 1 || dealer.New_Dealer_Rank__c == 50)
            {
                allDealers.add(row);
            }
            else if(dealer.New_Dealer_Rank__c == 10 || dealer.New_Dealer_Rank__c == 60)
            {
                premierDealers.add(row);
            }
            else if(dealer.New_Dealer_Rank__c == 20 || dealer.New_Dealer_Rank__c == 70)
            {
                authorizedDealers.add(row);
            }
            else
            {
                otherDealers.add(row);
            }            
        }   
        allDealers.addAll(premierDealers);
        allDealers.addAll(authorizedDealers);
        allDealers.addAll(otherDealers);
        
        return allDealers;
    }
    //End 00122443
//===================================================================    
     
    //Dealer information 
    Global class ResultRow implements CollectionUtils.Comparable {   
        public SObject record {get; private set;}
        //public Account account {get{return (Account)record;}}
        public String PartnerType;
        
        webservice Decimal distance                 {get; set;}
        webservice String AccountID                 {get; set;} 
        webservice String AccountName           {get; set;}
         webservice String AccountDisplayName           {get; set;}
          webservice String PartnerLogo          {get; set;}
        webservice String AccountType           {get; set;} 
        webservice String AccountPhone          {get; set;} 
        webservice String AccountRating             {get; set;} 
        webservice String AccountAddress        {get; set;}  
        webservice String AccountWebSite        {get; set;}   
        webservice String AccountOracleNumber {get; set;} 
        webservice String AccountDescription    {get; set;}
        webservice String AccountPartnerFacts   {get; set;} 
        webservice Decimal Score                  {get; set;} 
        webservice Boolean AllianceProgramPartner {get; set;}
        webservice Boolean LeadFlowOptOut        {get; set;}                                              
        
        //public ResultRow(SObject record, Decimal distance, String partnersType) {
        public ResultRow(DealerResult record) {
            //this.record = record; 
            //this.PartnerType      =  partnersType; 
            this.AccountID      = record.AccountId;
            this.AccountName    = record.AccountName;
            this.AccountDisplayName    = record.AccountDisplayName;
            this.PartnerLogo    = record.PartnerLogo;
            this.AccountType    = record.type; 
            this.AllianceProgramPartner    = record.AllianceProgramPartner;
            this.LeadFlowOptOut            = record.LeadFlowOptOut;
               
            if(record.DealerLocatorPhone != null && record.DealerLocatorPhone != '')
                this.AccountPhone = record.DealerLocatorPhone; 
            else
                this.AccountPhone = record.phone;
            
            //this.AccountRating        = record.Rating;
            this.AccountAddress = record.Street + ', ' + record.City + ', ' + record.State + ', ' + record.Country + ', ' + record.PostalCode;     
            this.AccountWebSite= record.website;  
            this.AccountOracleNumber= record.OracleAccountNumber;   
            this.AccountDescription = record.Description;
            this.AccountPartnerFacts= record.PartnerFacts;        
            this.distance = (record.distance).setScale(1);
            this.Score = record.Score;
            this.AllianceProgramPartner    = record.AllianceProgramPartner;
            this.LeadFlowOptOut            = record.LeadFlowOptOut;
        }
        
        public Integer compareTo(Object value) {
            ResultRow other = (ResultRow)value;          
            //Then show dealers according to distance       
            if (distance == other.distance){
                return 0;
            }           
            return (distance > other.distance) ? 1 : -1;
            //End Case#00135004                                              
       }
    }
}