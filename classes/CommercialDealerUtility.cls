public without sharing class CommercialDealerUtility {

 
 public static List<DealerResult> getDealersForDealerLocator(String street, String city, String state, String postalCode, String country, Integer ExtraRadius){
    
        System.debug('inside the getDealersForDealerLocator ==============street ====>'+street+'==city =='+city+'==state =='+state+'===postalCode=='+postalCode+'==country=='+country+'== ExtraRadius =='+ExtraRadius);
        
        list<DealerResult> dealerResults = new list<DealerResult>();
        DealerResult[] resultsFinal     = new DealerResult[]{};

        //System.debug(('@@@@@getDealers; Using Google: ');
        //Step 1 - Clean the address
        String cleanAddress = GeocodeAsyncHandler.cleanAddress( Street,  City,  State,  PostalCode,  Country);
        //System.debug(('@@@@@getDealers; Address Cleaned: '+cleanAddress); 
    
        //Step 2 - GeoCode the address
        GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCodeWithZipCodeFilter(cleanAddress, postalCode);
        
        System.debug('info =====================> '+info);
    
        if (info.lat != null) {
            dealerResults = getTopDealers(info.lat, info.lon, info, country, 1000);
        
        System.debug(' dealerResults =====================> '+dealerResults);
            
            for(DealerResult dr : dealerResults) 
            {
                if (dr.DealerLocatorOptOut == false) resultsFinal.add(dr);
            }            
        }

         
        return resultsFinal;
    }
    
     public static DealerResult[] getTopDealers(decimal lat, decimal lon, GeocodeAsyncHandler.GeoInfo info, string Country, integer dealerCount)
    {
        DealerGeneral__c c = DealerGeneral__c.getInstance();
        DealerResult[] results = new DealerResult[]{};
        DealerResult[] topDealers = new DealerResult[]{};
        list<CoverageArea__c> listCoverageAreaAfterAgreements = new list<CoverageArea__c>();
        list<CoverageArea__c> listFinalCoverageArea = new list<CoverageArea__c>();
        set<Id> setAccountIds = new set<id>();
        set<Id> uniqueIds = new set<id>();
        
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting CoverageArea__c');
        
        string  sQuery = 'select Account__c, Account__r.Name,Account__r.Account_Display_Name__c,Account__r.Partner_Logo__c, Account__r.Type, Account__r.Dealer_Score_Total__c, Account__r.Dealer_Locator_Phone__c, '+
                                    'Account__r.Phone, Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingCountry, Account__r.BillingPostalCode, '+
                                    'Account__r.Opportunity_Recipient__c, Account__r.website, Account__r.Oracle_Account_Number__c, Account__r.Description, '+
                                    'Account__r.Partner_Facts__c,Account__r.Reference_Sheet__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Radius__c, Account__r.Alliance_Program_Partner__c, Account__r.Dealer_Locator_Opt_Out__c, Account__r.Lead_Flow_Opt_Out__c  '+
                                    //'from CoverageArea__c where Account__r.Status__c = \'Active\' and Radius__c > 0 '+ //Update: #116798891
                                    'from CoverageArea__c WHERE Sector__c = \'Commercial\' AND Account__r.Status__c = \'Active\' and Radius__c > 0 ' +
                                    'and DISTANCE(Geolocation__c,GEOLOCATION(' + lat + ',' + lon + '), \'mi\')<300 ' +
                                    'and (Account__r.Type = \'Partner-Commercial\' OR Account__r.Type = \'Commercial\' OR Account__r.Type like \'%Partner-Combo%\')';
        
        ////System.debug((('@@@@@getTopDealers; SOQL:'+sQuery);
        
        //GET THE MAIN LIST SANS AGREEMENT CHECK
        list<CoverageArea__c> listCoverageAreas = database.query(sQuery);
        
        //BUILD A SET OF ID'S SO WE CAN CHECK FOR AGREEMENTS
        for (CoverageArea__c ca : listCoverageAreas)
            setAccountIds.add(ca.Account__c);
        
        //09.20.13 Since we now need to make sure an Agreement is in effect I need to do additional work. Would be nice IF I could Account__r.Agreements__r
        //CHECK TO SEE WHO HAS AN AGREEMENT
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting echosign_dev1__SIGN_Agreement__c');
        
        list<echosign_dev1__SIGN_Agreement__c> listAgreementMatches =[select Account__c from  echosign_dev1__SIGN_Agreement__c 
                                                                                                where Account__c IN :setAccountIds and echosign_dev1__Status__c = 'Signed' 
                                                                                                and Agreement_Type_2__c = 'Partner Agreement' and Name like '%Lead Handling Policy Agreement'];
                                                                                                
        map<id, echosign_dev1__SIGN_Agreement__c> mapAgreements = new map<id, echosign_dev1__SIGN_Agreement__c>();
        
        //Loading a Map to help reduce the number of iterations below
        for (echosign_dev1__SIGN_Agreement__c a : listAgreementMatches) 
            mapAgreements.put(a.Account__c, a);
                                                                                        
        //System.debug(('@@@@@getTopDealers; Check to see who has an agreement in :'+setAccountIds);                   
        //System.debug(('@@@@@getTopDealers; Found agreement matches :'+mapAgreements.size());     
       
        setAccountIds.clear();
                                                            
        //CYCLE THRU AGREEMENTS FOUND AND ONLY RETURN THOSE THAT MATCH FROM FIRST QUERY 
        for (CoverageArea__c ca : listCoverageAreas)    
        {     
            if (c.Enforce_Agreement_Check_Dealer_Search__c == true) 
            {                                                                                  
                if (mapAgreements.containskey(ca.Account__c)==true) {
                    listCoverageAreaAfterAgreements.add(ca);
                    setAccountIds.add(ca.Account__c);
                }
            }
            else
            {
                    listCoverageAreaAfterAgreements.add(ca);
                    setAccountIds.add(ca.Account__c);
            }
        }
        
        //CHECK TO SEE IF THE FINAL LIST OF DEALER HAS SOME SORT OF LICENSE IN THE STATE OF THE CUSTOMER.
        //NO NEED TO CHECK IS ITS VALID AT THIS TIME.
        //System.debug(('@@@@@getTopDealers; Check to see who has Registrations in: '+info);  
        
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting Business_Registration__c');
        
        list<Business_Registration__c> listRegs = new list<Business_Registration__c>();
        
        //Many times the State abbrev. in the United States will match a State abbrev. in another country (esp. Italy)
        //This justifies that we always include Country in the query. In addition, in production, all Bus. Reg. have a Country
        
        if (info.State != null && info.State != '' && Country == 'United States')
        {
            
         listRegs = [select Account__c from  Business_Registration__c where Account__c IN :setAccountIds and ( State__c = :info.State AND Country__c = :Country )];
         //System.debug(('@@@@@DealerUtility; getTopDealers; Business_Registration__c Query included State: ' + info.State + ' Country: ' + Country);
        }
        else if (Country != 'United States')
        { 
         listRegs = [select Account__c from  Business_Registration__c where Account__c IN :setAccountIds and Country__c = :Country ];
         //System.debug(('@@@@@DealerUtility; getTopDealers; Business_Registration__c Query included Country: ' + Country);
        }
        
        
        
        map<id, Business_Registration__c> mapRegistrations = new map<id, Business_Registration__c>();
        
        //System.debug(('@@@@@getTopDealers;  Found Registration matches: '+ listRegs.size());
        
        //Loading a Map to help reduce the number of iterations below
        for (Business_Registration__c br : listRegs)    
            mapRegistrations.put(br.Account__c, br);
        
        //CYCLE THRU LICENSES FOUND AND ONLY RETURN THOSE THAT HAD MATCHED  
        for (CoverageArea__c ca : listCoverageAreaAfterAgreements)                                                                                          
            if (mapRegistrations.containskey(ca.Account__c)==true) {
                //System.debug(('@@@@@getTopDealers;  Final entry: '+ ca.Account__c);
                listFinalCoverageArea.add(ca);
            }
        
        for (CoverageArea__c ca :  listFinalCoverageArea)
        {
            decimal distance = DealerUtility.getDistance(lat, lon, ca.Geolocation__Latitude__s, ca.Geolocation__Longitude__s, 'mi');
           
            
            if (ca.Radius__c >= distance)
            { 
            
                if (!uniqueIds.contains(ca.Account__c))
                {
                    DealerResult r = new DealerResult(
                                            ca.Account__c, 
                                            ca.Account__r.Name,
                                            
                                            ca.Account__r.Type, 
                                            ca.Geolocation__Latitude__s, 
                                            ca.Geolocation__Longitude__s, 
                                            distance,
                                            ca.Account__r.Dealer_Score_Total__c,
                                            ca.Account__r.Dealer_Locator_Phone__c, 
                                            ca.Account__r.Phone, 
                                            ca.Account__r.BillingStreet, 
                                            ca.Account__r.BillingCity, 
                                            ca.Account__r.BillingState, 
                                            ca.Account__r.BillingCountry, 
                                            ca.Account__r.BillingPostalCode, 
                                            ca.Account__r.Website, 
                                            ca.Account__r.Oracle_Account_Number__c, 
                                            ca.Account__r.Description, 
                                            ca.Account__r.Reference_Sheet__c == null ? ca.Account__r.Partner_Facts__c : ca.Account__r.Reference_Sheet__c, //ca.Account__r.Partner_Facts__c updated by  chakra CR:00665550 
                                            ca.Account__r.Alliance_Program_Partner__c,
                                            ca.Account__r.Opportunity_Recipient__c,
                                            ca.Account__r.Dealer_Locator_Opt_Out__c,
                                            ca.Account__r.Lead_Flow_Opt_Out__c 
                                         );
                                         
                    r.AccountDisplayName = ca.Account__r.Account_Display_Name__c;  
                    r.PartnerLogo  = ca.Account__r.Partner_Logo__c;

                    ////System.debug(('@@@@@getTopDealers NEW ROW:'+r);
                    results.add(r);
                    uniqueIds.add(ca.Account__c);
                }
            }
        }
        
        results.sort();
        
        if (dealerCount >= results.size())
        {
            //System.debug(('@@@@@getTopDealers .. Results (Dealer records) size: '+results.size());
            return results;
        } else {
            for (Integer i=0; i<dealerCount; i++) topDealers.add(results[i]);
            //System.debug(('@@@@@getTopDealers ... Results (Dealer records) size: '+topDealers.size());
            return topDealers;
        }
    }
    
}