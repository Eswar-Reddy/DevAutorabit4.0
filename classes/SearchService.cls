/**
 * Custom business logic to perform searches for records that match
 * requested locations.
 * 
 * @author Max Rudman
 * @since 8/16/2010
 */
public without sharing class SearchService {
    public static final SearchService INSTANCE = new SearchService();
    
    public static SearchService getInstance() {
        return INSTANCE;
    }
    
    // Case # 00154706
    // added additional parameter to handle "Partner Type" to return data for Account Type selected "Home", "Commercial", "Both"
    public List<SObject> findRecords(Set<String> locations, Map<String,String> filters , String PartnerType) {       
                                    
        // Done for case # 00061000                            
        /* List<Account> dealersAll = [SELECT Name, Type, Partner_Facts__c, Website, Phone, Dealer_Rank__c, Dealer_Tier__c, BillingStreet, 
                                    BillingCity, BillingState, BillingPostalCode 
                                 FROM Account
                                 WHERE RecordType.Name = 'Partner' AND Theater__c = 'North America' AND
                                    Status__c = 'Active' AND BillingPostalCode IN :locations AND
                                    Dealer_Rank__c >= 0]; */
        //Start Case#00224143:Dealer shouldn't displayed if Dealer Locator Optout field on Account is checked.
        String DealerLocatorOutOut=' AND Dealer_Locator_Opt_Out__c=false ';
        //End Case#00224143
        
        String locQuery = '';
        List<Account> dealersAll = new List<Account>();
        String accountQuery = '';
        for(String loc : locations){
            locQuery += 'BillingPostalCode LIKE \''+ loc + '%\' OR ';   
        } 
        if(locQuery != ''){
            locQuery = locQuery.substring(0,locQuery.length()-4);
            //Start 00122443
            locQuery = ' AND (' + locQuery + ') ';
            //End 00122443
        }
        
        //Case-00048121 
        //Dealer Locator search result should display the dealers within the State searched for. 
        String stateQuery = '';
        if(filters!=null && filters.size()>0 && filters.containsKey('State')){
            stateQuery = ' AND BillingState = \''+filters.get('State')+'\'';
        }
        
        // Case # 00154706
        // added conditions to fetch data on basis of the Account Type selected "Home", "Commercial", "Both"
        if(PartnerType == 'Home')
        {    
            accountQuery = 'SELECT ID, Name, Description, Oracle_Account_Number__c, Type, Partner_Facts__c, Website, Phone, Dealer_Locator_Phone__c, rating, New_Dealer_Rank__c, Dealer_Tier__c, BillingStreet,BillingCity, BillingState, BillingCountry, BillingPostalCode, Geolocation__Latitude__s, Geolocation__Longitude__s, Dealer_Score_Total__c, Alliance_Program_Partner__c,  Opportunity_Recipient__c, Dealer_Locator_Opt_Out__c, Lead_Flow_Opt_Out__c'+
                            ' FROM Account WHERE RecordType.Name = \'Partner\' AND Theater__c = \'North America\' AND Status__c = \'Active\' AND New_Dealer_Rank__c > 0 AND New_Dealer_Rank__c < 100 '+ DealerLocatorOutOut+locQuery + stateQuery ; 
        }
        else if(PartnerType == 'Commercial')
        {
            accountQuery = 'SELECT ID, Name, Description, Oracle_Account_Number__c, Type, Partner_Facts__c, Website, Phone, Dealer_Locator_Phone__c, rating, New_Dealer_Rank__c, Dealer_Tier__c, BillingStreet,BillingCity, BillingState, BillingCountry, BillingPostalCode, Geolocation__Latitude__s, Geolocation__Longitude__s, Dealer_Score_Total__c, Alliance_Program_Partner__c,  Opportunity_Recipient__c, Dealer_Locator_Opt_Out__c, Lead_Flow_Opt_Out__c'+
                            ' FROM Account WHERE RecordType.Name = \'Partner\' AND Theater__c = \'North America\' AND Status__c = \'Active\' AND New_Dealer_Rank__c >=50 '+ DealerLocatorOutOut+locQuery + stateQuery; 
        }
        else if(PartnerType == 'Both')
        {
            accountQuery = 'SELECT ID, Name, Description, Oracle_Account_Number__c, Type, Partner_Facts__c, Website, Phone, Dealer_Locator_Phone__c, rating, New_Dealer_Rank__c, Dealer_Tier__c, BillingStreet,BillingCity, BillingState, BillingCountry, BillingPostalCode, Geolocation__Latitude__s, Geolocation__Longitude__s, Dealer_Score_Total__c, Alliance_Program_Partner__c,  Opportunity_Recipient__c, Dealer_Locator_Opt_Out__c, Lead_Flow_Opt_Out__c'+
                            ' FROM Account WHERE RecordType.Name = \'Partner\' AND Theater__c = \'North America\' AND Status__c = \'Active\' AND New_Dealer_Rank__c >=50 AND New_Dealer_Rank__c < 100 '+ DealerLocatorOutOut + locQuery + stateQuery; 
        }
        else
        {
            accountQuery = 'SELECT ID, Name, Description, Oracle_Account_Number__c, Type, Partner_Facts__c, Website, Phone, Dealer_Locator_Phone__c, rating, New_Dealer_Rank__c, Dealer_Tier__c, BillingStreet,BillingCity, BillingState, BillingCountry, BillingPostalCode, Geolocation__Latitude__s, Geolocation__Longitude__s, Dealer_Score_Total__c, Alliance_Program_Partner__c,  Opportunity_Recipient__c, Dealer_Locator_Opt_Out__c, Lead_Flow_Opt_Out__c'+
                            ' FROM Account WHERE RecordType.Name = \'Partner\' AND Theater__c = \'North America\' AND Status__c = \'Active\' AND New_Dealer_Rank__c >=1 '+ DealerLocatorOutOut+ locQuery + stateQuery ; 
        }
    
         dealersAll = Database.Query(accountQuery); 
         return dealersAll;
    }
}