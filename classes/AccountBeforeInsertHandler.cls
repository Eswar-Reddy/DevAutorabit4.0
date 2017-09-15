/*

Child of HandlerBase for handling account trigger actions

Class:              AccountBeforeInsertHandler
Date:               12/18/2014
Version:            1
Last Updated:       12/18/2014


Refactor BY: Michael 
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class AccountBeforeInsertHandler extends TriggerHandlerBase {
    
    // -------- Constants --------
  //  public static Id homeOwnerRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Home_Owner');
    // None
    
    // -------- Constructor --------
    public AccountBeforeInsertHandler(){}
    
    // -------- Variables --------
    // None
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Integer, Account> qualifiedAccounts;
    private Set<Integer> setFieldsSet;
    private List<Account> dealerScoreAccounts;
    private Set<Integer> activatedPartnerAccounts;
    private Set<Integer> fillShipAddressSet;

    //---------Collections for queries----
    private Set<String> countries;
    private Set<ID> rsmOwnerQuery;
    private Map<String,Account> mapNameAccount;
    private Set<Id> setOwnerIds;
    private Set<String> accSICSet;

    //Dupe check maps
    private Map<String, Integer> dupCheckByName;
    
    private Id objcommercialAccountRecordType = AccountHandlerUtilities.CommercialRecTypeId;
    private Id objresidentialAccountRecordType = AccountHandlerUtilities.ResidentialRecTypeId;
    private Id partnerAccountRecordId = AccountHandlerUtilities.PartnerRecTypeId;
    private User currentUser = [Select Id, Profile.Name, Contact.Account.Theater__c, Contact.Account.Territory__c from User where Id = :UserInfo.getUserId()];// and Profile.Name like 'Partner%' Limit 1];
    private Set<Id> rsmOwnerUsers;
    private Map<String,String> countryTheaterMap;
    private Map<String , List<Account>> theaterAccCSATCodeOneMap;
    private Map<String , List<Account>> theaterAccCSATCodeTwoMap;
    private set<Integer> setAccsToUpdateCounty;
    private set<String> setZipcode;
    private List<Vertex_Address_Validation__c>  countyList;
      
    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        Map<ID, Account> newAccountMap = (Map<ID, Account>)newMap;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)oldMap;
        List<Account> newAccountList = (List<Account>)newList;
        List<Account> oldAccountList = (List<Account>)oldList;

        qualifiedAccounts = new Map<Integer, Account>();
        setFieldsSet = new Set<Integer>();
        dealerScoreAccounts = new List<Account>();
        countries = new Set<String> ();
        rsmOwnerQuery = new Set<ID>();
        mapNameAccount = new Map<String,Account>();
        setOwnerIds = new Set<Id>(); 
        activatedPartnerAccounts = new Set<Integer>();
        accSICSet = new Set<String>();
        fillShipAddressSet = new Set<Integer>();
        //dupe map
        dupCheckByName = new Map<String, Integer>();
        setAccsToUpdateCounty =new  set<Integer>();
        setZipcode = new set<String>();

        for(Integer i=0;i<newAccountList.size();i++){
            Account acct = newAccountList[i];
            
            if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
                if(acct.Geolocation__Latitude__s == null || acct.Geolocation__Longitude__s == null) {
                    acct.IsAddressUpdated__c = true;
                    if(!ReferralManagementCallout.inBatchContext) {
                        GeocodeAsyncHandler.setToTrue();
                    }
                }
                //acct.Geolocation__Latitude__s = null;
                //acct.Geolocation__Longitude__s = null;
            }
            if((acct.Oracle_Shipping_County__c == null || acct.Oracle_County__c == null) 
                        ||(acct.BillingPostalCode != null && acct.BillingCity != null)) 
                 {
                            
                    setAccsToUpdateCounty.add(i);
                    setZipcode.add(acct.BillingPostalCode);
                    qualifiedAccounts.put(i,acct);
                }

            //validation on US to match picklists on ship tos and bill tos
            if(acct.BillingCountry == 'US' || acct.BillingCountry == 'United States of America' || acct.BillingCountry == 'USA') {
                acct.BillingCountry = 'United States';
            }
            if(acct.ShippingCountry == 'US' || acct.ShippingCountry == 'United States of America' || acct.ShippingCountry == 'USA') {
                acct.ShippingCountry = 'United States';
            }
            //qualifier to copy billing address to shipping address if shipping address is empty
            if(acct.ShippingStreet == null || acct.ShippingCity == null || acct.ShippingState == null 
               || acct.ShippingCountry == null || acct.ShippingPostalCode == null) {
                fillShipAddressSet.add(i);
                qualifiedAccounts.put(i,acct);
            }
            //accounts without regional sales manager get it set as owner if owner has rsm role
            //beforeAccountInsert trigger: AccountManagement.setRSMName
            //Skips: DataMigration Users 
            if(!Util.isSkipTrigger('DatamigrationAccountSkip', null)) {
                if(partnerAccountRecordId != null){
                    if(acct.RSM__c == null)
                        rsmOwnerQuery.add(acct.ownerID);  
                }
                //newly activated accounts set CSAT_Cycle_Code to the lower accumulation of 1 or 2 for theater(queries account)
                //beforeAccountInsert trigger: AccountManagement.setCSATCycleCode
                if(acct.Status__c == 'Active' && acct.RecordTypeId == partnerAccountRecordId){
                    activatedPartnerAccounts.add(i);
                }
                //set account theater to proper value for country (queries Country_Reference__c)
                //from beforeAccountInsert trigger, AccountManagement.beforeAccountInsert, setAccountFields()
                if(acct.BillingCountry != null){            
                    countries.add(acct.BillingCountry);
                }
                if(acct.BillingCountry != null || acct.Theater__c=='North America' || acct.Theater__c=='Central America and the Caribbean' || acct.Theater__c=='Australia' 
                   || acct.Theater__c=='Europe' || acct.Territory__c != null || acct.RSM__c == null || acct.Status__c == 'Active' || acct.RecordTypeId == objcommercialAccountRecordType 
                   || acct.RecordTypeId == objresidentialAccountRecordType || acct.Geo__latitude__s == null || (activatedPartnerAccounts != null && activatedPartnerAccounts.size() > 0)){ //data migration user check?
                       qualifiedAccounts.put(i, acct);
                       setFieldsSet.add(i);
                   }
            }
            //from AccountOwnerUpdate trigger
            //AccountOwnerUpdate.ownerUpdate
            //Skip: if(util.isInContextOfLeadConversion()), if(util.isSkipTrigger())
            //if(!Util.isInContextOfLeadConversion() && !Util.isSkipTrigger()){
            acct.X_Account_Owner__c = acct.OwnerId;
                //account owner is related to a contact, set partner account to owner's related account(queries User)
                setOwnerIds.add(acct.OwnerId);
                //set fields to corresponding fields in SIC object (queries SIC__c)(moved from after insert)
                //from afterAccountInsert trigger
                //AccountManagement.afterAccountInsert, setAccountNumber()
                if(acct.Sic != null){
                    accSICSet.add(acct.Sic);
                }
                qualifiedAccounts.put(i, acct);
            //}

            //check for duplicate accounts based on name (queries account)
            //checkAccountDuplicate trigger
            //Skips: Data Migration users and Informatica Cloud, PowerPartners, Partners
            if(!Util.isSkipTrigger() && !Util.isSkipTrigger('AccountDuplicate',null)) {
                if(UserInfo.getuserType() != 'PowerPartner' || UserInfo.getuserType() != 'Partner') {
                    if(!acct.Override_Duplicate_Check__c) { 
                       /* if(mapNameAccount.containsKey(acct.Name)){
                            acct.addError('A duplicate Account has been found in the system');
                        }*/
                        
                        mapNameAccount.put(acct.Name,acct);
                        qualifiedAccounts.put(i, acct);
                        dupCheckByName.put(acct.Name, i);
                    }
                }
            }
            
            
            //From Account Trigger ln. 21-50
            //MDM User ByPass
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null)){
            if(acct.Type != null && (acct.Type.contains('Partner-Residential') || acct.Type.contains('Partner-Combo')) 
                    && (acct.Theater__c == 'North America' || acct.Theater__c == 'Europe' || acct.Theater__c == 'Central America and the Caribbean')){
                        //from Account trigger, ln. 23-26
                        if(acct.RSM_Discretionary_Adj__c != null && (acct.RSM_Discretionary_Adj__c > Integer.valueOf(Label.RSMDiscretionaryAdjustmentUpperLimit)|| acct.RSM_Discretionary_Adj__c < Integer.valueOf(Label.RSMDiscretionaryAdjustmentLowerLimit))){
                            acct.addError(Label.RSMDiscretionaryAdjustmentErrroMessage);
                        }
                        //from Account trigger, ln. 36-50
                        if (DealerUtility.IsBatchRunning == false) { 
                            //The Batch_ConvertLead sets this flag because it handles the GeoCoding.
                            if (!Test.isRunningTest()) GeocodeAsyncHandler.setToTrue();
                        }
                        
                        dealerScoreAccounts.add(acct);  
                    }//end MDM User ByPass
            }
        }
    }
    
    // Start processing
    public override void start() {

        countryTheaterMap = new Map<String,String> ();
        if(countries.size()>0){   
            for(Country_Reference__c countryRef : [select Country__c, Theater__c from Country_Reference__c where Country__c in : countries]){                    
                countryTheaterMap.put(countryRef.Country__c, countryRef.Theater__c);        
            }              
        }
        if(!setZipcode.isEmpty())
        countyList = [SELECT id,geo_county__c,Geo_City__c,geo_postal_code__c FROM Vertex_Address_Validation__c WHERE geo_postal_code__c IN : setZipcode ];  
        
        rsmOwnerUsers = new Set<Id>();
        Map<Id, User> ownerMap = new Map<Id, User>();
        if((rsmOwnerQuery != null && rsmOwnerQuery.size() > 0) || (setOwnerIds != null && setOwnerIds.size() > 0)){
            for(User u:[select Id, UserRole.Name, Username, ContactId, Contact.Email, ProfileId, AccountId from User where Id in :setOwnerIds OR Id in :rsmOwnerQuery]){
                if(setOwnerIds.contains(u.Id)){
                    ownerMap.put(u.Id, u);
                }
                if(rsmOwnerQuery.contains(u.Id) && String.valueOf(UserRole.Name).contains('Regional Sales Manager')){
                    rsmOwnerUsers.add(u.id);
                }
            }
        }

        theaterAccCSATCodeOneMap = new Map<String, List<Account>>();
        theaterAccCSATCodeTwoMap = new Map<String, List<Account>>();
        Map<String, Account> accountMatch = new Map<String, Account>();
        if((dupCheckByName != null && dupCheckByName.keyset().size() > 0) || (activatedPartnerAccounts != null && activatedPartnerAccounts.size() > 0)){

            for(Account acc : [select id,Theater__c,Status__c , CSAT_Cycle_Code__c, Name, RecordTypeId from Account 
                                where Name in :mapNameAccount.KeySet() OR (RecordTypeId = :partnerAccountRecordId  AND Status__c = 'Active' 
                                AND Theater__c IN ('North America','Europe','Australia'))]){
                if(mapNameAccount.KeySet().contains(acc.Name)){
                    accountMatch.put(acc.Name,acc);
                }
                if(acc.RecordTypeId == partnerAccountRecordId  && acc.Status__c == 'Active' && (acc.Theater__c == 'North America' || acc.Theater__c == 'Europe' || acc.Theater__c == 'Australia')){
                    if(acc.CSAT_Cycle_Code__c == '1') {
                        if(theaterAccCSATCodeOneMap.containsKey(acc.Theater__c)) {
                            theaterAccCSATCodeOneMap.get(acc.Theater__c).add(acc);                            
                        }else {
                            theaterAccCSATCodeOneMap.put(acc.Theater__c,new List<Account>{acc});
                        }  
                    }else if(acc.CSAT_Cycle_Code__c == '2') {
                        if(theaterAccCSATCodeTwoMap.containsKey(acc.Theater__c)) {
                            theaterAccCSATCodeTwoMap.get(acc.Theater__c).add(acc);                                
                        }else {
                            theaterAccCSATCodeTwoMap.put(acc.Theater__c,new List<Account>{acc});
                        }  
                    }   
                }
            }
        }

        Map<String, SIC__c> sicMap = new Map<String, SIC__c>();
        if(accSICSet != null && accSICSet.size() > 0){
            for(SIC__c s:[select Id,SIC_Code__c,First_Level__c,Second_Level__c,Third_Level__c,SPWR_Industry_Type__c from SIC__c where SIC_Code__c IN : accSICSet]){
                sicMap.put(s.SIC_Code__c, s);
            }
        }

        if (!dealerScoreAccounts.isEmpty()){
            DealerGeneral__c dg = DealerGeneral__c.getInstance();
            if (dg.Enable_ALR_Dealer_Scoring__c == true){
                CalculateDealerScore cds = new CalculateDealerScore();
                cds.accountList = dealerScoreAccounts;
                cds.accountTriggerRequest = true;
                cds.calculateScoresInsert();
            }
        }
        
        if(qualifiedAccounts.size() > 0){
            //System.debug('******QUALACCOUNTSBI: '+qualifiedAccounts.size() + ' qualified records');
            for(Integer i : qualifiedAccounts.keySet()){
                Account a = qualifiedAccounts.get(i); 
                //System.debug('******QUALACCOUNTSBI: '+a.Name);
                if(fillShipAddressSet.contains(i)) {
                    fillShippingAddress(a);
                }
                if(setAccsToUpdateCounty.contains(i)){
                    updateCountyFromVertex(a);
                }
                if(a.Sic != null){
                    SIC__c si = sicMap.get(a.Sic);
                    a.First_Level_SIC_Name__c = si.First_Level__c; 
                    a.Second_Level_SIC_Name__c = si.Second_Level__c;
                    a.Third_Level_SIC_Name__c = si.Third_Level__c;     
                    a.SPWR_Industry_Type__c = si.SPWR_Industry_Type__c;
                }

                if(setFieldsSet.contains(i)){
                    setAccountFields(a);
                }
                
                if(accountMatch.containsKey(a.Name)
                   && UserInfo.getuserType() != 'PowerPartner'
                   && UserInfo.getuserType() != 'Partner'){
                    a.addError('A duplicate Account has been found in the system');
                }
                  

                //These errors from checkAccountDuplicate trigger
                //Skip:
                    //if(UserInfo.getUserId()=='005Q0000000JOxo' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4' || UserInfo.getUserId()== '00580000005HbJOAA0')
                    //if(UserInfo.getuserType() == 'PowerPartner' || UserInfo.getuserType() == 'Partner')
                /* Done for the case # 00054338 on 28Jan2011 */
                //If((acc.Business_Unit__c == 'UPP Americas' || acc.Business_Unit__c == 'NA Commercial' || acc.Business_Unit__c == 'UPP Intl') && (acc.Lead_Approval__c == 'False' || acc.Lead_Approval__c == null)){
                if((a.Business_Unit__c == 'UPP Americas' || a.Business_Unit__c == 'NA Commercial') && (a.Lead_Approval__c == 'False' || a.Lead_Approval__c == null)){
                    a.addError('Approval is required from your Sales Manager before conversion '); 
                }
                if((a.Business_Unit__c == 'UPP Americas' || a.Business_Unit__c == 'NA Commercial' || a.Business_Unit__c == 'UPP Intl') && (a.HD_Lead_Status__c != 'Qualified')){ 
                    a.addError('Lead must be set to qualified to convert'); 
                }
                // Done for case # 00066557
                // If((acc.Business_Unit__c == 'IBD' || acc.Business_Unit__c == 'Components') && (acc.HD_Lead_Status__c != 'Qualified')){ 

                if(ownerMap.containsKey(a.OwnerId) && ownerMap.get(a.OwnerId).ContactId != null){
                    System.debug('a.OwnerId: ' + a.ownerId);
                    System.debug('ownerMap.get(a.OwnerID).ContactId: ' + ownerMap.get(a.OwnerId).ContactId);
                    a.Partner_Account__c = ownerMap.get(a.OwnerId).AccountId;
                }

                //attempt to move lead conversion dml from lead trigger
                //Lead convertedLead = Util.isInContextOfLeadConversion2();
                //if(convertedLead!=null){
                //  setFieldsForLeadConversion(a, convertedLead);
                //}
            }
        }

        // this code should be there after Partner Account is assigned to Customer Account 
        // Method to update the BR for Customer Account when a new Customer Account is created
        
        List<Id> newPartnerIds = new List<Id>();
        if(qualifiedAccounts.size() > 0){
            for(Integer i : qualifiedAccounts.keySet()){
                Account a = qualifiedAccounts.get(i);
                if(a.RecordTypeId == objresidentialAccountRecordType){
                    newPartnerIds.add(a.Partner_Account__c);
                }
            }

            if(newPartnerIds.size() > 0){
                List<Account> partnersList = [select id,(select id,Account__c,State__c,License_City__c from Business_Registrations__r) from Account where ID IN:newPartnerIds];
                Map<Id,List<Business_Registration__c>> partnerIdBusinessRegMap = new Map<Id,List<Business_Registration__c>>();
                for(Account a : partnersList){
                    partnerIdBusinessRegMap.put(a.Id,a.Business_Registrations__r);
                }
                Boolean cityExists = false;
                Boolean nullCityExists = false;
                for(Account cAcct : qualifiedAccounts.values()){
                    cityExists = false;
                    nullCityExists = false;
                    if(cAcct.Partner_Account__c != null && partnerIdBusinessRegMap.containsKey(cAcct.Partner_Account__c)){
                        for(Business_Registration__c br : partnerIdBusinessRegMap.get(cAcct.Partner_Account__c)){
                            if(cAcct.BillingState == br.State__c){
                                if(br.License_CIty__c != null){
                                    cityExists = true; 
                                    if(cAcct.BillingCity == br.License_CIty__c){
                                       cAcct.Business_Registration__c = br.Id;
                                       break; 
                                    }
                                }
                                else if(br.License_CIty__c == null){
                                    nullCityExists = true;
                                }
                            }
                            
                        }
                        if(cAcct.Business_Registration__c == null  && nullCityExists){
                            for(Business_Registration__c br : partnerIdBusinessRegMap.get(cAcct.Partner_Account__c)){
                                if(br.License_City__c == null && cAcct.BillingState == br.State__c){
                                    cAcct.Business_Registration__c = br.Id;
                                    break;
                                }
                          }
                        }
                    }
                }
            }
        }
        
        /* done adding by Ganesh Chedella for Multi-State Lease*/
        
    
    }

    
    // -------- Internal Classes --------
    //copy billing address to shipping address if no shipping address was provided
    private void fillShippingAddress(Account acct) {
        acct.ShippingStreet = acct.BillingStreet;
        acct.ShippingCity = acct.BillingCity;
        acct.ShippingState = acct.BillingState;
        acct.ShippingPostalCode = acct.BillingPostalCode;
        acct.ShippingCountry = acct.BillingCountry;
    }

    /* this is for Multi-State Lease */
   /* public void setQuoteCreationAllowed(List<Account> accountList,List<Id> accIds){
        Map<Id,List<Business_Registration__c>> accBRMap = getBusinessRegistrationMap(accountList,accIds);
        system.debug('qualifiedAccounts is '+qualifiedAccounts);
        if(qualifiedAccounts != null){
            for(Account acc : qualifiedAccounts.values()){
                if(accBRMap != null && accBRMap.get(acc.Id) != null && accBRMap.get(acc.Id).size() > 0){
                    Business_Registration__c br = accBRMap.get(acc.Id).get(0);
                 //   acc.Quote_Creation_Allowed__c = br.License_Number__c;
                    acc.Business_Registration__c = br.Id;
                }
            } 
        }
         
    }

    public Map<Id,List<Business_Registration__c>> getBusinessRegistrationMap(List<Account> accList,List<Id> accIds){
        List<Business_Registration__c> businessRegList = [select id,Account__c,License_Number__c,Expires_On__c,State__c from Business_Registration__c where Account__c IN :accIds];
        system.debug('businessRegList is '+businessRegList);
        Map<Id,List<Business_Registration__c>> accountBusRegMap = new Map<Id,List<Business_Registration__c>>();
        for(Account acc : accList){
            system.debug('acc.Partner_Account__c is '+acc.Partner_Account__c);
            List<Business_Registration__c> brList = new List<Business_Registration__c>();
            for(Business_Registration__c br : businessRegList){
                if(acc.Partner_Account__c == br.Account__c && acc.BillingState == br.State__c){
                    brList.add(br);
                    accountBusRegMap.put(acc.Id,brList);
                    break;
                }
            }
        }
        system.debug('accountBusRegMap is '+accountBusRegMap);
        return accountBusRegMap;
    }  */
    /* done adding by Ganesh Chedella for Multi-state Lease */
    
    //also used by beforeupdate.  Could move to AccountHandlerUtilities
    //All skip if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
    //EXCEPT: InsertGeo trigger part.  Can that be removed?
    public void setAccountFields(Account acct){                   

        //beforeAccountInsert trigger: AccountManagement.setAccountFields
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        /* Theater */
        if(acct.BillingCountry != null && countryTheaterMap.containsKey(acct.BillingCountry))
            acct.Theater__c = countryTheaterMap.get(acct.BillingCountry); 
        
        //Following is done corresponding to the case 00012745 
        // 'Equal' condition changed to 'contains' to set country domain under case 00094125   
        if(acct.Type !=null && (acct.Theater__c=='Central America and the Caribbean' || acct.Theater__c=='North America')){
            if(acct.Type.contains('Commercial')){
                acct.country_domain__c = 'cvar-us';
            }
            if(acct.Type.contains('Residential')){
                acct.country_domain__c = 'rvar-us';
            }
            if(acct.Type.contains('Combo')){
                acct.country_domain__c = 'combo-us';
            }
        }
        
        //Following is done corresponding to the case 00047329 -closed by customer 
        //GPP Changes :   Country Domain will be updated based on Type : Uncommented on 01-Jul-2014
        if(acct.Theater__c=='Australia' && acct.Type !=null){
            if(acct.Type.contains('Commercial')){
                acct.country_domain__c = 'cvar-au';
            }
            if(acct.Type.contains('Residential')){
                acct.country_domain__c = 'rvar-au';
            }
            if(acct.Type.contains('Combo')){
                acct.country_domain__c = 'combo-au';
            }
        }
        
        //Following is done corresponding to the case 00013120   
        //Set the country domain according to the territory and Account type If theater is Europe              
        if(acct.Theater__c=='Europe' && acct.Territory__c!=null && acct.Territory__c!='' && acct.Type!=null && acct.Type!=''){
            string countryDomain = '';
            boolean isPrefix = false;
            boolean isSuffix = false;
            //Get the prefix of country domain according to the selected Account Type
            if(acct.Type.contains('Commercial')){
                countryDomain = 'cvar-';
                isPrefix = true;
            }
            if(acct.Type.contains('Residential')){
                countryDomain = 'rvar-';
                isPrefix = true;
            }
            if(acct.Type.contains('Combo')){
                countryDomain = 'combo-';
                isPrefix = true;
            }

            //Get the suffix of country domain according to the Territory of Europe theater
            if(acct.Territory__c.indexOf('France')>=0){
                countryDomain += 'fr';
                isSuffix = true;
            }
            else if(acct.Territory__c.indexOf('Germany')>=0){
                countryDomain += 'de';
                isSuffix = true;
            }
            else if(acct.Territory__c.indexOf('Italy')>=0){
                countryDomain += 'it';
                isSuffix = true;
            }
            else if(acct.Territory__c.indexOf('Spain')>=0){
                countryDomain += 'es';
                isSuffix = true;
            }
            //Following is done corresponding to the case 00050644
            else if(acct.Territory__c.indexOf('Belgium')>=0){
                countryDomain += 'be';
                isSuffix = true;
            }
            //Start for Case#00073912
            else if(acct.Territory__c.indexOf('United Kingdom')>=0){
                countryDomain += 'uk';
                isSuffix = true;
            }
            //End for Case#00073912
            //If proper country domain string is prepared
            if(isSuffix == true && isPrefix == true){
                acct.country_domain__c = countryDomain;
            }
        }

        //beforeAccountInsert trigger: AccountManagement.setRSMName
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        if(rsmOwnerUsers != null && rsmOwnerUsers.size() > 0 && acct.RSM__c == null && rsmOwnerUsers.contains(acct.ownerID)){
            acct.RSM__c = acct.OwnerID;
        }

        //beforeAccountInsert trigger: AccountManagement.setCSATCycleCode
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        //Need to have opps with csat data already inserted for this to work.
        if(activatedPartnerAccounts != null && activatedPartnerAccounts.size() > 0){
            if(theaterAccCSATCodeOneMap.get(acct.Theater__c)!=null && theaterAccCSATCodeTwoMap.get(acct.Theater__c)!=null){
                if(theaterAccCSATCodeOneMap.get(acct.Theater__c).size() > theaterAccCSATCodeTwoMap.get(acct.Theater__c).size()){
                    acct.CSAT_Cycle_Code__c = '2';
                    theaterAccCSATCodeTwoMap.get(acct.Theater__c).add(acct);
                }else {
                    acct.CSAT_Cycle_Code__c = '1';
                    theaterAccCSATCodeOneMap.get(acct.Theater__c).add(acct);
                }  
            }
        }
        //from AccountManagement.beforeAccountInsert, setCommercialAccountFields()
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        if(currentUser.Profile.Name.contains('Partner')){  //this for before insert only
            if (objcommercialAccountRecordType != null && acct.RecordTypeId == objcommercialAccountRecordType) {
                acct.Status__c= 'Active';
                acct.CurrencyIsoCode = 'USD' ;
                acct.Theater__c = currentUser.Contact.Account.Theater__c;
                acct.Territory__c = currentUser.Contact.Account.Territory__c;
            }
            // set theater value if account recordtype is of residential type.
            else if (objresidentialAccountRecordType != null && acct.RecordTypeId == objresidentialAccountRecordType) {
               acct.Theater__c = currentUser.Contact.Account.Theater__c;
            }
        }

        //InsertGeo trigger  TODO: remove?
        if(acct.lat__c!=null && acct.log__c!=null && acct.Geo__latitude__s == null ){ //another before insert only.  Should be removed?
            acct.Geo__latitude__s = acct.Lat__c;
            acct.Geo__longitude__s = acct.log__c;
            acct.Geolocation__Latitude__s = acct.Lat__c;
            acct.Geolocation__Longitude__s = acct.Log__c;
            
        }
        /*
        //workflows
        if(acct.RecordTypeId == objResidentialAccountRecordType) {
            acct.Oracle_Sales_Channel__c = 'RVAR LEASE';
            acct.Oracle_Payment_Terms__c = '45 NET'; //This Picklist only has 1 Value? Is this field update necessary?
            acct.Oracle_Order_Type__c = 'SPEB RVAR Lease 2'; //Ditto here too
            acct.Oracle_Operating_Unit__c = 'SPEB OU'; 
            acct.Oracle_Account_Type__c = 'R'; 
            acct.Oracle_Customer_Classification__c = 'Lease_Customer'; //Ditto again here
        }
        if(acct.RecordTypeId == partnerAccountRecordId) {
            if(acct.Status__c == 'Terminated') {
                acct.Terminated_Date__c = Date.today();
            }
            acct.Executives_view_all_Opportunities__c = true;
        }
        if(acct.Send_PDF_Notification__c == true && acct.Subscription_Date__c == null)  {
                acct.Subscription_Date__c = System.now();
        }
        if(acct.Theater__c == 'NA') {
            acct.Theater__c = 'North America';
        } */
    }

    public void setFieldsForLeadConversion(Account a, Lead l){
        
        //add account and lead ids to custom object in accountafterupdate (Same with contact and opp)

        //System.debug('ACCIDINCONV'+l.ConvertedAccountId);
        if(l.Description!=null && l.Description!=''){
            a.Description = l.Description;                     
        }       
        if(l.Referral_Program_Status__c!=null){
            a.Referral_Program_Status__c = l.Referral_Program_Status__c;               
        }       
        if(lead.Transmission_Capacity__c!=null){
            a.Transmission_Capacity__c = l.Transmission_Capacity__c;
        } 
        a.Contact_Language__c = l.Contact_Language__c;
        //account types need to be set here?
        if(l.RecordTypeId == Schema.SObjectType.Lead.RecordTypeInfosByName.get('New Homes').RecordTypeId){
            if (l.Business_Unit__c == 'UPP Intl'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard') != null)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard').RecordTypeId;
            }else if((l.Business_Unit__c == 'RLC' && l.RLC_Type__c=='New Homes') || l.Business_Unit__c == 'UPP Intl'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer').RecordTypeId;          
            }else if(l.Business_Unit__c == 'NA Commercial' || l.Business_Unit__c == 'UPP Americas'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard').RecordTypeId;
            }
        }
        if(l.RecordTypeID == Schema.SObjectType.Lead.RecordTypeInfosByName.get('Systems').RecordTypeId){
            if (l.Business_Unit__c == 'UPP Americas' || l.Business_Unit__c == 'UPP Intl'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard') != null)
                    a.RecordTypeId =  Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard').RecordTypeId;
            }else if(l.Business_Unit__c == 'RLC' && l.RLC_Type__c=='Light Commercial'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Commercial Customer') != null)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Commercial Customer').RecordTypeId;
            }else if(l.Business_Unit__c == 'NA Commercial' || l.Business_Unit__c == 'UPP Intl'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard').RecordTypeId;
            }
        }
        if(l.RecordTypeID == Schema.SObjectType.Lead.RecordTypeInfosByName.get('Residential').RecordTypeId){
            if (l.Business_Unit__c == 'UPP Intl' || l.Business_Unit__c == 'NA Commercial'  || l.Business_Unit__c == 'UPP Americas'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Standard').RecordTypeId;
            }else if(l.Business_Unit__c == 'RLC' && l.RLC_Type__c=='Residential'){
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer').RecordTypeId;    
            }else{
                if(Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer') != null && !a.IsPersonAccount)
                    a.RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer').RecordTypeId;  
            } 
            //if(opportunityRecordTypes.get('Home Owner') != null){  //if opportunity converted,( set record type to home owner and setDefaultStageName) if lead is residential 
            //    opp.RecordTypeID = opportunityRecordTypes.get('Home Owner');
            //    opp.Type = leadRecordTypes.get(lead.recordTypeID);       
            //    setDefaultStageName('Home Owner',opp); 
            //    setAccountFacilityValue(lead, acct);
            //}
            //if(contactRecordTypes.get('Customer')!=null && ! acct.IsPersonAccount)
            //    con.RecordTypeId = contactRecordTypes.get('Customer');   //make converted contact customer record type if lead is residential
            //acctRecords.add(acct);
            //conRecords.add(con);  
            //if(opp.Id != null) 
            //    oppRecords.add(opp);
            //else
            //    continue; 
            if(!(l.Facility_Address__c == null && l.Facility_Address_2__c == null && l.Facility_City__c == null && l.Facility_Zip__c == null && l.Facility_State__c == null)){
                a.Facility_Address__c = l.Facility_Address__c; 
                a.Facility_Address_2__c = l.Facility_Address_2__c; 
                a.Facility_City__c = l.Facility_City__c; 
                a.Facility_Zip__c = l.Facility_Zip__c; 
                a.Facility_State__c =l.Facility_State__c; 
            }
        }    
    }
    private void updateCountyFromVertex(Account objAccount){
        //countyList = [SELECT id, geo_county__c,geo_postal_code__c,geo_county__c FROM Vertex_Address_Validation__c WHERE geo_postal_code__c IN : setZipcode ];
        System.debug(LoggingLevel.ERROR,'-------objAccount'+objAccount.Oracle_County__c);
        System.debug(LoggingLevel.ERROR,'-------countyList'+objAccount.Oracle_Shipping_County__c);
        for(Vertex_Address_Validation__c objVertexAddress : countyList){
            if(objVertexAddress.geo_postal_code__c == objAccount.BillingPostalCode 
               &&(objVertexAddress.Geo_City__c == null || objVertexAddress.Geo_City__c == objAccount.BillingCity)){
                objAccount.Oracle_County__c = objVertexAddress.geo_county__c;
                objAccount.Oracle_Shipping_County__c = objVertexAddress.geo_county__c;
                   System.debug(LoggingLevel.ERROR,'-------Oracle_Shipping_County__c'+objAccount.Oracle_County__c);
            }
            
        }
    }

}