public with sharing class DealerLocatorController {
    private Integer maxResults = 5;
    
    public String baseLocation {get; set;}
    public Integer radius {get; set;}
    public List<SelectOption> radiusValues {get; set;} 
    public List<ResultRow> resultRows {get; private set;}
    public Boolean searched {get; private set;}
    public Boolean empty { get{return (resultRows == null) || (resultRows.size() == 0);} }
    
    public String accType {get; set;}
    public List<SelectOption> accTypeValue {get; set;}
    
    // Done for Case # 00069491
    // Map is displayed first time only
    // Done for Case # 00073245 [Hiding the US map]
    //public Boolean displayMap {get; set;}
  
    public DealerLocatorController() {        
        populateRadiusOptions();
        populateaccTypeOptions();
        radius = 50;
        searched = false;
        // Done for Case # 00073245 [Hiding the US map]
        //displayMap = true;
        //Case#00062073        
        if(ApexPages.currentPage().getParameters().get('zip')!=null){
            baseLocation = ApexPages.currentPage().getParameters().get('zip');
        }
        if(ApexPages.currentPage().getParameters().get('radius')!=null){
            radius = Integer.valueOf(ApexPages.currentPage().getParameters().get('radius'));
        }
        
        if(ApexPages.currentPage().getParameters().get('type')!=null){
            accType = ApexPages.currentPage().getParameters().get('type');
        }
    }
    
    private void populateRadiusOptions(){
        radiusValues = new List<SelectOption>();
        radiusValues.add(new SelectOption('5','5'));
        radiusValues.add(new SelectOption('25','25'));
        radiusValues.add(new SelectOption('50','50'));
        radiusValues.add(new SelectOption('100','100'));
        radiusValues.add(new SelectOption('200','200'));
    }
    
    private void populateaccTypeOptions() {
        accTypeValue = new List<SelectOption>();
        accTypeValue.add(new SelectOption('none', '--None--'));
        accTypeValue.add(new SelectOption('home', 'Home'));
        accTypeValue.add(new SelectOption('commercial', 'Commercial'));
        accTypeValue.add(new SelectOption('both', 'Both'));
    }
    
    
    public PageReference onSearch() {
        // Done for Case # 00073245 [Hiding the US map]
        // Done for Case # 00069491
        /* if(ApexPages.currentPage().getParameters().get('displayString') == 'NO'){
          displayMap = false;
        }*/
        
        if (StringUtils.isBlank(baseLocation)) {
            // Done for case # 00065653 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter base zip code'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter your zip code'));
            return null;
        }
        resultRows = new List<ResultRow>();
        try {
            Map<String,String> filters = new Map<String,String>();            
            //Case-00048121
            Location__c baseLocationDetail = LocationService.getInstance().findLocationByName(baseLocation);
            if(baseLocationDetail != null && baseLocationDetail.state__c != null && baseLocationDetail.state__c != ''){
                filters.put('State',baseLocationDetail.state__c);
                //Case#00058646
                //All four Hawaii dealers should be displayed on searching for any Hawaii zip code
                //So set the default radius 200 miles so that all dealers are displayed
                if(baseLocationDetail.state__c == 'HI'){
                    radius = 200;
                }
            }                        
            Set<String> nearLocations = LocationService.getInstance().findLocationNamesWithinMileRadius(baseLocation, radius);
            List<ResultRow> allDealers = new List<ResultRow>();
            List<ResultRow> premierDealers = new List<ResultRow>();
            List<ResultRow> authorizedDealers = new List<ResultRow>();
            List<ResultRow> otherDealers = new List<ResultRow>();
            
            List<ResultRow> bucket25 = new List<ResultRow>();
            List<ResultRow> bucket50 = new List<ResultRow>();
            for (SObject rec : SearchService.getInstance().findRecords(nearLocations, filters, accType)) {
                Account dealer = (Account)rec;
                Double distance = LocationService.getInstance().computeDistance(baseLocation, dealer.BillingPostalCode);
                ResultRow row = new ResultRow(rec, Decimal.valueOf(distance).setScale(1),accType);
                resultRows.add(row);
                
                //Below section contains code to show dealer in the order Elite, Premier and then authorized.    
                if(dealer.New_Dealer_Rank__c == 1 || dealer.New_Dealer_Rank__c == 50)
                {
                    resultRows.add(row);
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
            
            // Below section sorts different Lists on basis of distance within a specific List i.e. will arrange all Elite partners by distance in Elite Partners List
            CollectionUtils.sort(resultRows);
            CollectionUtils.sort(premierDealers);
            CollectionUtils.sort(authorizedDealers);
            CollectionUtils.sort(otherDealers);
            
            // Adding all sorted lists into one List for display
            resultRows.addAll(premierDealers);
            resultRows.addAll(authorizedDealers);
            resultRows.addAll(otherDealers);
            
            if(accType =='Commercial'){
             CollectionUtils.sort(resultRows);
            }
            
            
            
            if (resultRows.size() > maxResults) {
                List<ResultRow> temp = new List<ResultRow>();
                for (Integer i=0;i<maxResults;i++) {
                    temp.add(resultRows.get(i));
                }
                resultRows = temp;
            }
            
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        searched = true;
         return null;
    }
    
    
    
    public class ResultRow implements CollectionUtils.Comparable {
        public SObject record {get; private set;}
        public Decimal distance {get; private set;}
        public String PartnerType{get; private set;}
        public Account account {get{return (Account)record;}}
        
        public ResultRow(SObject record, Decimal distance, String ptype ) {
            this.record = record;
            this.distance = distance;
            this.PartnerType = ptype;
        }
        
        public Integer compareTo(Object value) {
            ResultRow other = (ResultRow)value;
            Decimal result = account.New_Dealer_Rank__c  - other.account.New_Dealer_Rank__c ;
            
            //Case#00058646-Above should be skipped for Hawaii dealers(check with dealer rank and then with distance)
            //Case-00048120
            //If no Premier or Elite dealers exist within 50 miles, display nearest Authorized dealers 
           /**if(account.billingState!='HI'){
                if((account.New_Dealer_Rank__c  == 2 && distance<=50) && ((other.account.New_Dealer_Rank__c  == 0 || other.account.New_Dealer_Rank__c  == 1) && other.distance>50) && (PartnerType != 'Commercial' || PartnerType != 'Both')){
                    return 0;
                }
                else if((other.account.New_Dealer_Rank__c  == 2 && other.distance<=50) && ((account.New_Dealer_Rank__c  == 0 || account.New_Dealer_Rank__c  == 1) && distance>50) && (PartnerType != 'Commercial' || PartnerType != 'Both')){
                    return 1;
                }
            }**/
            
            if (result != 0) {
                return result.intValue();
            }
            if (distance == other.distance) {
                return 0;
            }
            
            return (distance > other.distance) ? 1 : -1;
        }
    }
}