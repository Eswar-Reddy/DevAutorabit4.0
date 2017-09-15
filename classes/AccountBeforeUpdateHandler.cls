/*

Child of HandlerBase for handling account trigger actions

Class:              AccountBeforeUpdateHandler
Date:               12/18/2014
Version:            1
Last Updated:       12/18/2014



////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class AccountBeforeUpdateHandler extends TriggerHandlerBase {
    
    // -------- Constants --------
    //private List<RecordType> accRecordTypeList  = GW_RecTypes.getRecordTypeforSelectedObject('Account');
    private Id partnerAccountRecordId = AccountHandlerUtilities.PartnerRecTypeId; 
    private Id residentialAccountRecordId = AccountHandlerUtilities.ResidentialRecTypeId;
    // -------- Constructor --------
    public AccountBeforeUpdateHandler(){}
    
    // -------- Variables --------
    
    // -------- Properties --------

    // Qualified records
    private Map<Id, Account> qualifiedAccounts;
    private Map<Id, Account> qualifiedOwnerChangeCustomerAccounts; // this is written for Multi-State project by Ganesh CHedella to properly associate BR's of new partner to Customer Account
    private Set<Id> newPartnerIds; // this is for Mutli-State project by Ganesh Chedella
    private Set<Id> setFieldsSet;
    private Set<Id> activatedPartnerAccounts;
    private Set<Id> ooaAccts;
    private Set<Id> sicChanged;
    private Map<Id, Account> dealerScoreAccounts;
    private Set<Account> accsWithFieldUpdates;
	private Set<Id> accountBillTos;

    //---------Collections for queries----
    private Set<String> countries;
    private Set<ID> rsmOwnerQuery;
    private Set<Id> setOwnerIds;
    private Set<String> accSIC;

    //Collections for 
    private Set<Id> rsmOwnerUsers;
    private Map<String,String> countryTheaterMap;
    private Map<String , List<Account>> theaterAccCSATCodeOneMap;
    private Map<String , List<Account>> theaterAccCSATCodeTwoMap;
    public Map<ID, Account> oldMap;

    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, 
        List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        //List <AggregateResult> fieldNameCategories = new List <AggregateResult>([SELECT Field_Name__c, Filter_Field__c, MAX(Score_Value__c) maxScore FROM Dealer_Scoring__c GROUP BY Field_Name__c, Filter_Field__c]);

        qualifiedAccounts = new Map<Id, Account>();
        qualifiedOwnerChangeCustomerAccounts = new Map<Id,Account>(); // written for Multi-state by Ganesh Chedella
        Map<ID, Account> newAccountMap = (Map<ID, Account>)newMap;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)oldMap;
        List<Account> newAccountList = (List<Account>)newList;
        List<Account> oldAccountList = (List<Account>)oldList;
        oldMap = oldAccountMap;
        setFieldsSet = new Set<Id>();
        countries = new Set<String> ();
        rsmOwnerQuery = new Set<ID>();
        activatedPartnerAccounts = new Set<Id>();
        ooaAccts = new Set<Id>();
        setOwnerIds = new Set<Id>();
        accSIC = new Set<String>();
        dealerScoreAccounts = new Map<Id, Account>();
        sicChanged = new Set<Id>();
        accsWithFieldUpdates = new Set<Account>();
		accountBillTos = new Set<Id>();

    //Used instead of aggregate query of custom setting
    Map<String, Dealer_Scoring__c> dsMap = new Map<String, Dealer_Scoring__c>();
    for(Dealer_Scoring__c d: Dealer_Scoring__c.getall().values()){
        if(!dsMap.containsKey(d.Field_Name__c)){
            dsMap.put(d.Field_Name__c, d);
        }else if(d.Score_Value__c > dsMap.get(d.Field_Name__c).Score_Value__c){
            dsMap.put(d.Field_Name__c, d);
        }
    }

        // load up bill to sites for accounts
        for(Bill_To_Site__c bt : [SELECT Dealer_Account__c FROM Bill_To_Site__c WHERE Dealer_Account__c IN :newMap.keySet()]) {
          accountBillTos.add(bt.Dealer_Account__c);
        }
		
        //System.debug('*****NEWACCOUNTSBU: '+newAccountList.size() + ' records in trigger');
            // Looping through Trigger records
            for(Account acct: newAccountList){
                System.debug('OWNERID*****: '+acct.OwnerId);
                System.debug('xAcctOwner: '+acct.x_Account_Owner__c);
                acct.X_Account_Owner__c = acct.OwnerId;
                //System.debug('*****NEWACCOUNTSBU: '+acct.Name);
                //from Account trigger ln. 51-65
                if(!ReferralManagementCallout.inBatchContext) {
                    if(acct.BillingStreet != oldAccountMap.get(acct.Id).BillingStreet || acct.BillingState != oldAccountMap.get(acct.Id).BillingState ||
                       acct.BillingCity != oldAccountMap.get(acct.Id).BillingCity || acct.BillingCountry != oldAccountMap.get(acct.Id).BillingCountry ||
                       acct.BillingPostalCode != oldAccountMap.get(acct.Id).BillingPostalCode){
                           GeocodeAsyncHandler.setToTrue();
                           acct.IsAddressUpdated__c = true;
                           acct.Geolocation__Latitude__s = null;
                           acct.Geolocation__Longitude__s = null;
                       }
                }
                
                // check to make sure child accounts don't have bill to sites for new homes builders
                if(acct.RecordTypeId == partnerAccountRecordId && String.isNotBlank(acct.ParentId) && acct.Type == 'Builder' && String.isBlank(oldAccountMap.get(acct.Id).ParentId) && accountBillTos.contains(acct.Id)) {
                  acct.addError('Child accounts cannot have bill to sites, please remove the existing bill to site(s) before associating this account to a parent account.');
                }
				
            //accounts without regional sales manager get it set as owner if owner has rsm role (queries User)
            //beforeAccountUpdate trigger: AccountManagement.setRSMName
            //Skip:
            if(!util.isSkipTrigger()) {
                if(partnerAccountRecordId != null){
                    if(acct.RSM__c == null)
                        rsmOwnerQuery.add(acct.ownerID);  
                }
                
                //newly activated accounts set CSAT_Cycle_Code to the lower accumulation of 1 or 2 (queries account)
                //beforeAccountUpdate trigger: AccountManagement.setCSATCycleCode
                //Skip if(util.isSkipTrigger())
                if(acct.Status__c == 'Active' && oldAccountMap.get(acct.Id).Status__c != 'Active' && acct.RecordTypeId == partnerAccountRecordId){
                    activatedPartnerAccounts.add(acct.Id);
                    //System.debug('PARTNERACCOUNTACTIVATED');
                }
                
                //set account theater to proper value for country (queries Country_Reference__c)
                //beforeAccountUpdate trigger: AccountManagement.setAccountFields
                //Skip: if(util.isSkipTrigger())
                if(acct.BillingCountry != null && acct.BillingCountry != oldAccountMap.get(acct.Id).BillingCountry){            
                    countries.add(acct.BillingCountry);
                }
                
                //online order access accounts with a task with no completed date, set date to today (queries tasks)
                //beforeAccountUpdate trigger: AccountManagement.setOnlineOrderAccessDates
                //Skip: if(util.isSkipTrigger())
                if(acct.Online_Order_Access__c){
                    ooaAccts.add(acct.Id);
                }
                
                //add accounts that trigger a field update to collection of qualified accounts
                //For skips: if(util.isSkipTrigger())
                if(acct.BillingCountry != null || acct.Theater__c!=oldAccountMap.get(acct.Id).Theater__c || (acct.Type != null && acct.Type!=oldAccountMap.get(acct.Id).Type)
                   || (acct.Territory__c != null && acct.Territory__c != oldAccountMap.get(acct.Id).Territory__c) || acct.RSM__c == null || (activatedPartnerAccounts != null && activatedPartnerAccounts.size() > 0)
                   || acct.AccountNumber == null || acct.AccountNumber == '' || acct.ACBParanet_ID__c == null || acct.ACBParanet_ID__c == ''
                   || acct.Integration_ID__c == null || acct.Integration_ID__c == '') { 
                       qualifiedAccounts.put(acct.Id, acct);
                       setFieldsSet.add(acct.Id);
                   }
                
                //from AccountOwnerUpdate trigger
                //AccountOwnerUpdate.ownerUpdate
                //Skip: if(util.isInContextOfLeadConversion()) if(util.isSkipTrigger())
                //if(!Util.isInContextOfLeadConversion()){
  //move to start()?
                    //account owner changes and is related to a contact, set partner account to owner's related account(queries User)
                    if(acct.OwnerId != oldAccountMap.get(acct.Id).OwnerId){
                        setOwnerIds.add(acct.OwnerId);
                        qualifiedAccounts.put(acct.Id, acct);
                    }
                    //acc's sic changes, set fields to corresponding fields in SIC object (queries SIC__c)
                    if(acct.Sic != oldAccountMap.get(acct.Id).Sic){
                        accSIC.add(acct.Sic);
                        sicChanged.add(acct.Id);
                        qualifiedAccounts.put(acct.Id, acct);
                    }
                //}
            }
            //from Account trigger 
            //MDM User Skip begin
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null)){
                if(acct.Type != null && (acct.Type.contains('Partner-Residential') || acct.Type.contains('Partner-Combo')) 
                   && (acct.Theater__c == 'North America' || acct.Theater__c == 'Europe' || acct.Theater__c == 'Central America and the Caribbean')){
                       //from Account trigger ln. 21-26
                       if(acct.RSM_Discretionary_Adj__c != null && (acct.RSM_Discretionary_Adj__c >  Integer.valueOf(Label.RSMDiscretionaryAdjustmentUpperLimit)|| acct.RSM_Discretionary_Adj__c < Integer.valueOf(Label.RSMDiscretionaryAdjustmentLowerLimit))){
                           acct.addError(Label.RSMDiscretionaryAdjustmentErrroMessage);
                       }
                      
                       //from Account trigger ln. 67-94
                       if(acct.RSM_Discretionary_Adj__c != oldAccountMap.get(acct.Id).get('RSM_Discretionary_Adj__c') || acct.OwnerId != oldAccountMap.get(acct.Id).get('OwnerId')){
                           dealerScoreAccounts.put(acct.Id, acct);
                       }else{
                           //for(AggregateResult fc : fieldNameCategories){
                           //    String fieldName = string.valueOf(fc.get('Field_Name__c'));
                           //    String filterField = string.valueOf(fc.get('Filter_Field__c'));
                           //    String newValue = string.valueOf(newAccountMap.get(acct.Id).get(fieldName));
                           //    String oldValue = string.valueOf(oldAccountMap.get(acct.Id).get(fieldName));
                           //    String newFilterValue;
                           //    String oldFilterValue;
                           //    if(!string.isBlank(filterField)){
                           //        newFilterValue = string.valueOf(newAccountMap.get(acct.Id).get(filterField));
                           //        oldFilterValue = string.valueOf(oldAccountMap.get(acct.Id).get(filterField));
                           //    }
                           //    if((newValue != oldValue || newFilterValue != oldFilterValue) && !dealerScoreAccounts.containsKey(acct.Id)){
                           //        dealerScoreAccounts.put(acct.Id, acct);
                           //    }
                           //}

                          //Changed to get rid of aggregate query of custom setting 
                          for(Dealer_Scoring__c ds: dsMap.values()){
                             String fieldName = string.valueOf(ds.get('Field_Name__c'));
                             String filterField = string.valueOf(ds.get('Filter_Field__c'));
                             String newValue = string.valueOf(newAccountMap.get(acct.Id).get(fieldName));
                             String oldValue = string.valueOf(oldAccountMap.get(acct.Id).get(fieldName));
                             String newFilterValue;
                             String oldFilterValue;
                             if(!string.isBlank(filterField)){
                                 newFilterValue = string.valueOf(newAccountMap.get(acct.Id).get(filterField));
                                 oldFilterValue = string.valueOf(oldAccountMap.get(acct.Id).get(filterField));
                             }
                             if((newValue != oldValue || newFilterValue != oldFilterValue) && !dealerScoreAccounts.containsKey(acct.Id)){
                                 dealerScoreAccounts.put(acct.Id, acct);
                             }
                          }
                       }
                   }//end MDM User Skip
            }
            /*
            //potential workflow moves
            if(acct.RecordTypeId == residentialAccountRecordId && (acct.Oracle_Sales_Channel__c != oldAccountMap.get(acct.Id).Oracle_Sales_Channel__c && acct.Oracle_Sales_Channel__c != 'RVAR LEASE')
                  || (acct.Oracle_Payment_Terms__c != oldAccountMap.get(acct.Id).Oracle_Payment_Terms__c && acct.Oracle_Payment_Terms__c != '45 NET')
                  || (acct.Oracle_Order_Type__c != oldAccountMap.get(acct.Id).Oracle_Order_Type__c && acct.Oracle_Order_Type__c != 'SPEB RVAR Lease 2')
                  || (acct.Oracle_Operating_Unit__c != oldAccountMap.get(acct.Id).Oracle_Operating_Unit__c && acct.Oracle_Operating_Unit__c != 'SPEB OU')
                  || (acct.Oracle_Account_Type__c != oldAccountMap.get(acct.Id).Oracle_Account_Type__c && acct.Oracle_Account_Type__c != 'R')
                  || (acct.Oracle_Customer_Classification__c != oldAccountMap.get(acct.Id).Oracle_Customer_Classification__c && acct.Oracle_Customer_Classification__c != 'LEASE_CUSTOMER')) {
                      setFieldsSet.add(acct.Id);
            }
            if(acct.RecordTypeId == partnerAccountRecordId && acct.Status__c == 'Terminated' && oldAccountMap.get(acct.Id).Status__c != 'Terminated') {
                setFieldsSet.add(acct.Id);
            }
            if(acct.Send_PDF_Notification__c == true && oldAccountMap.get(acct.Id).Send_PDF_Notification__c == false) {
                setFieldsSet.add(acct.Id);
            }
            if(acct.Theater__c == 'NA' && acct.Theater__c != oldAccountMap.get(acct.Id).Theater__c) {
                setFieldsSet.add(acct.Id);
            } */

            // adding the Customer Accounts whose Owner is changed to qualified Map for Multi-state project by Ganesh Chedella
            if(acct.RecordTypeId == residentialAccountRecordId && acct.OwnerId != oldAccountMap.get(acct.Id).OwnerId){
               qualifiedOwnerChangeCustomerAccounts.put(acct.Id,acct);
            }
        }
    }
    

    
    // Start processing
    public override void start() {



      /*  List<Account> eligibleAccounts = new List<Account>();
        List<Id> eligibleAccountIds = new List<Id>();
        if(qualifiedOwnerChangeCustomerAccounts.size() > 0){
            for(Id i : qualifiedAccounts.keySet()){
                Account a = qualifiedAccounts.get(i);
                //if(a.OwnerId != oldMap.get(a.Id).OwnerId){
                  if(a.RecordTypeId == residentialAccountRecordId){
                      eligibleAccounts.add(a);
                      eligibleAccountIds.add(a.Partner_Account__c);
                  }
               // }
            }
        }
        system.debug('eligibleAccountIds is '+eligibleAccountIds);
        if(eligibleAccountIds.size() > 0)
          setNewBusinessRegistration(eligibleAccounts,eligibleAccountIds); */
        /* done adding by Ganesh Chedella for Multi-State Lease*/ 

        countryTheaterMap = new Map<String,String> ();
        if(countries.size()>0){   
            for(Country_Reference__c countryRef : [select Country__c, Theater__c from Country_Reference__c where Country__c in : countries]){                    
                countryTheaterMap.put(countryRef.Country__c, countryRef.Theater__c);        
            }              
        }

  //      rsmOwnerUsers = new Set<Id>();
  //      if(ownerIDs != null && ownerIDs.size() > 0){
  //        for(User u:[select Id, UserRole.Name, Username from User where Id in :ownerIDs and UserRole.Name LIKE '%Regional Sales Manager%']){
  //            rsmOwnerUsers.add(u.id);
  //        }
  //      }

  //      Map<Id, User> mUser = new Map<Id, User>();
        //if(lstOwnerId != null && lstOwnerId.size() > 0){
        //  mUser = new Map<Id, User>([SELECT Id, ContactId, Contact.Email, ProfileId, AccountId FROM User WHERE Id IN: lstOwnerId]);  //combine with other user
        //}

        rsmOwnerUsers = new Set<Id>();
        Map<Id, User> ownerMap = new Map<Id, User>();
        if((rsmOwnerQuery != null && rsmOwnerQuery.size() > 0) || (setOwnerIds != null && setOwnerIds.size() > 0)){  //qualifiers need work here.
            
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
        if(activatedPartnerAccounts != null && activatedPartnerAccounts.size() > 0){
            for(Account acc : [select id,Theater__c,Status__c , CSAT_Cycle_Code__c from Account 
                                where RecordTypeId = :partnerAccountRecordId  AND Status__c = 'Active' 
                                AND Theater__c IN ('North America','Europe','Australia')]){
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
      //System.debug('CSAT1: '+theaterAccCSATCodeOneMap);
      //System.debug('CSAT2: '+theaterAccCSATCodeTwoMap);
        }

        Map<Id, Date> accountCompletionDate = new Map<Id, Date>();
        if(ooaAccts != null && ooaAccts.size() > 0){
            for(Task t: [select Id, WhatId, Subject, Completed_Date__c from Task where WhatId = :ooaAccts
                                                        and (Subject = 'Provide Partner Portal access, enable Online Ordering & Provide SmartStore Access' or Subject ='Provide Partner Portal access & enable Online Ordering')
                                                        and RecordType.Name ='On-boarding task']){
                if(t.Completed_Date__c!=null)
                    accountCompletionDate.put(t.WhatId, t.Completed_Date__c.date());
            }
        }

        Map<String, SIC__c> sicMap = new Map<String, SIC__c>();
        if(accSIC != null && accSIC.size() > 0){
            for(SIC__c s:[select Id,SIC_Code__c,First_Level__c,Second_Level__c,Third_Level__c,SPWR_Industry_Type__c from SIC__c where SIC_Code__c IN : accSIC]){
                sicMap.put(s.SIC_Code__c, s);
            }
        }

        if (!dealerScoreAccounts.isEmpty()){
            DealerGeneral__c dg = DealerGeneral__c.getInstance();
            if (dg.Enable_ALR_Dealer_Scoring__c == true){
                CalculateDealerScore cds = new CalculateDealerScore();
                cds.accountList = dealerScoreAccounts.values();
                cds.accountTriggerRequest = true;
                cds.calculateScoresInsert();
            }
        }

        if(qualifiedAccounts.keyset().size() > 0){
            //System.debug('*****QUALACCOUNTSBU: '+qualifiedAccounts.keyset().size());
            for(Account a:qualifiedAccounts.values()){
                //System.debug('*****QUALACCOUNTSBU: '+a.Name);
                if(setFieldsSet.contains(a.Id)){
                    setAccountFields(a);
                }
                if(ooaAccts.contains(a.Id)){
                    a.Online_Order_Access_Date__c = accountCompletionDate.get(a.Id);
                }
                if(ownerMap.containsKey(a.OwnerId) && ownerMap.get(a.OwnerId).ContactId != null){
                    a.Partner_Account__c = ownerMap.get(a.OwnerId).AccountId;
                }
                if(sicChanged.contains(a.Id)){
                    SIC__c si = sicMap.get(a.Sic);
                    if(si!= null){
                      a.First_Level_SIC_Name__c = si.First_Level__c; 
                      a.Second_Level_SIC_Name__c = si.Second_Level__c;
                      a.Third_Level_SIC_Name__c = si.Third_Level__c;     
                      a.SPWR_Industry_Type__c = si.SPWR_Industry_Type__c;
                    }
                }else if(a.Sic == null){
                    if(sicChanged.contains(a.Id)){
                        a.First_Level_SIC_Name__c = null;
                        a.Second_Level_SIC_Name__c = null;
                        a.Third_Level_SIC_Name__c = null;
                        a.SPWR_Industry_Type__c = null;
                    }
                }
            }
        }
        // this code should be there after Partner Account is assigned to Customer ACcount when Owner changed for customer Account
        // Method to update the BR for Customer Account when new Partner is assigned to Customer Account
        // looping through all the qualified customer Accounts whose Owner changed and adding them to set
        if(qualifiedOwnerChangeCustomerAccounts.size() > 0){
          newPartnerIds = new Set<Id>();
            Set<String> custBillingStates = new Set<String>();
            for(Account acc: qualifiedOwnerChangeCustomerAccounts.values()){
             // if(qualifiedAccounts.containsKey(acc.Id) && qualifiedAccounts.get(acc.Id).Partner_Account__c != null)
             //   newPartnerIds.add(qualifiedAccounts.get(acc.Id).Partner_Account__c);
              newPartnerIds.add(acc.Partner_Account__c);
              custBillingStates.add(acc.BillingState);
            } 
            system.debug('newPartnerIds are '+newPartnerIds);
            List<Account> partnerAccountList = [select id,(select id,State__c,License_City__c from Business_Registrations__r) from Account where ID IN :newPartnerIds];
            Map<Id,List<Business_Registration__c>> partnerAccountIdBusinessRegMap = new Map<Id,List<Business_Registration__c>>();
            for(Account a : partnerAccountList){
              partnerAccountIdBusinessRegMap.put(a.Id,a.Business_Registrations__r);
            }
            Boolean cityExists = false;
            Boolean nullCityExists = false;
            for(Account acc: qualifiedOwnerChangeCustomerAccounts.values()){
                acc.Business_Registration__c = null;
                cityExists = false;
                nullCityExists = false;
                if(acc.Partner_Account__c != null && partnerAccountIdBusinessRegMap.containsKey(acc.Partner_Account__c)){
                   for(Business_Registration__c br : partnerAccountIdBusinessRegMap.get(acc.Partner_Account__c)){
                       if(acc.BillingState == br.State__c){
                                if(br.License_CIty__c != null){
                                    cityExists = true; 
                                    if(acc.BillingCity == br.License_CIty__c){
                                       acc.Business_Registration__c = br.Id;
                                       break; 
                                    }
                                }
                                else if(br.License_CIty__c == null){
                                    nullCityExists = true;
                                }
                       }
                   }
                   if(acc.Business_Registration__c == null && nullCityExists){
                       for(Business_Registration__c br : partnerAccountIdBusinessRegMap.get(acc.Partner_Account__c)){
                           if(br.License_CIty__c == null && acc.BillingState == br.State__c){
                               acc.Business_Registration__c = br.Id;
                               break;
                           }
                       }
                   } 
                }
            }

        }

        
    }

    // 
    public override void finish(Boolean fromStart){

        if (fromStart) {

        }
    }
    
    // -------- Internal Classes --------

    /* this method is for Multi-State project by Ganesh Chedella */
  /*  public void setNewBusinessRegistration(List<Account> accountList,List<Id> accIds){
        Map<Id,List<Business_Registration__c>> accBRMap = getBusinessRegistrationMap(accountList,accIds);
        system.debug('qualifiedAccounts is '+qualifiedAccounts);
        if(qualifiedAccounts != null){
            for(Account acc : qualifiedAccounts.values()){
                if(accBRMap != null && accBRMap.get(acc.Id) != null && accBRMap.get(acc.Id).size() > 0){
                    Business_Registration__c br = accBRMap.get(acc.Id).get(0);
                    acc.Business_Registration__c = br.Id;
                }
            } 
        }
         
    }  */

   /* public Map<Id,List<Business_Registration__c>> getBusinessRegistrationMap(List<Account> accList,List<Id> accIds){
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
    
    //also used by beforeinsert.  Could move to AccountHandlerUtilities
    public void setAccountFields(Account acct){                   
        
        AccountHandlerUtilities.setAccountFields(acct);
        
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

        //beforeAccountUpdate trigger: AccountManagement.setRSMName
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        //if(util.isSkipTrigger())
        if(rsmOwnerUsers != null && rsmOwnerUsers.size() > 0 && acct.RSM__c == null && rsmOwnerUsers.contains(acct.ownerID)){
            acct.RSM__c = acct.OwnerID;
        }

        //beforeAccountUpdate trigger: AccountManagement.setCSATCycleCode
        //Skips: if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
        //if(util.isSkipTrigger())
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

     /*     if(currentUser.Profile.Name.contains('Partner')){  //this for before insert only
            if (objcommercialAccountRecordType != null && acct.RecordTypeId == objcommercialAccountRecordType.Id) {
                acct.Status__c= 'Active';
                acct.CurrencyIsoCode = 'USD' ;
                acct.Theater__c = currentUser.Contact.Account.Theater__c;
                acct.Territory__c = currentUser.Contact.Account.Territory__c;
            }
            // set theater value if account recordtype is of residential type.
            else if (objresidentialAccountRecordType != null && acct.RecordTypeId == objresidentialAccountRecordType.Id) {
               acct.Theater__c = currentUser.Contact.Account.Theater__c;
            }
        }

        if(acct.lat__c!=null && acct.log__c!=null && acct.Geo__latitude__s == null ){ //another before insert only.  Should be removed?
            acct.Geo__latitude__s = acct.Lat__c;
            acct.Geo__longitude__s = acct.log__c;
        } */
        
        //workflows 
        /*
        if(acct.RecordTypeId == partnerAccountRecordId && acct.Status__c == 'Terminated') {
            acct.Terminated_Date__c = Date.today();
        }
        if(acct.Send_PDF_Notification__c) {
            acct.Subscription_Date__c = System.now();
        }
        if(acct.Theater__c == 'NA') {
            acct.Theater__c = 'North America';
        }
        if(acct.RecordTypeId == residentialAccountRecordId) { 
            if(acct.Oracle_Sales_Channel__c != 'RVAR LEASE') {
                acct.Oracle_Sales_Channel__c = 'RVAR LEASE';
            }
            if(acct.Oracle_Payment_Terms__c != '45 NET') {
                acct.Oracle_Payment_Terms__c = '45 NET';
            }
            if(acct.Oracle_Order_Type__c != 'SPEB RVAR Lease 2') {
                acct.Oracle_Order_Type__c = 'SPEB RVAR Lease 2';
            }
            if(acct.Oracle_Operating_Unit__c != 'SPEB OU') {
                acct.Oracle_Operating_Unit__c = 'SPEB OU';
            }
            if(acct.Oracle_Account_Type__c != 'R') {
                acct.Oracle_Account_Type__c = 'R';
            }
            if(acct.Oracle_Customer_Classification__c != 'LEASE_CUSTOMER') {
                acct.Oracle_Customer_Classification__c = 'LEASE_CUSTOMER';
            } 
        }*/
    }
}