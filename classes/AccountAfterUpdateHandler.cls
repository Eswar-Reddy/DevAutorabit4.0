/*

Child of HandlerBase for handling account trigger actions

Class:              AccountAfterUpdateHandler
Date:               12/18/2014
Version:            1
Last Updated:       12/18/2014


Refactor by: Crystal

CHANGE HISTORY:

version: KCM_06212016
author: Kane Chelster Macaspac
last modified date/time: 06/21/2016 2:23 PM MNL
description:
1. user reported that changing the billing address of an account record whose Type contains "Partner" results in the following error: 

Error:Apex trigger AccountTrigger caused an unexpected exception, contact your administrator: AccountTrigger: execution of AfterUpdate 
caused by: System.DmlException: Upsert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are 
missing: [Account]: [Account]: () 

2. the error above is caused by the missing assignment statements in the code for the newly created coverage area record's Account__c 
   field.
3. use the version name KCM_06212016 to jump to parts of the code specific to this change.
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class AccountAfterUpdateHandler extends TriggerHandlerBase {
    
    // -------- Constants --------
    private static ID AccountResidentialRecTypeId = AccountHandlerUtilities.ResidentialRecTypeId;
    private static ID AccountCommercialRecTypeId = AccountHandlerUtilities.CommercialRecTypeId; //Ralph - Case 00722361 
    private static ID AccountPartnerRecTypeId = AccountHandlerUtilities.PartnerRecTypeId;
    private static Id OnBoardingTaskRecTypeId = AccountHandlerUtilities.OnBoardingTaskRecTypeId;
    public static Id auManagerId;
    // -------- Constructor --------
    public AccountAfterUpdateHandler(){}
    
    // -------- Variables --------
    Set<Id> customerAccountIds = new Set<Id>(); //  building these account Ids for which we need to call Sales Tax API call
    Set<Id> terminatedAccIds = new Set<Id>();
    List<Certification__c> lstCertifications = new List<Certification__c>();
    /**Collections for task creation on Status Change**/
    Map<Id, Account> accsForTaskCreation = new Map<Id, Account>();
    Static List<Task> newTasksForAccs = new List<Task>();
    /**Collections for User and Contact Country Domain Updates**/
    Set<Account> accsForUserUpdate = new Set<Account>();
    Set<Id> accsForContactUpdate = new Set<Id>();
    List<User> userData = new List<User>();
    List<User> usersToUpdate = new List<User>();
    List<Contact> contactData = new List<Contact>();
    List<Contact> contactsToUpdate = new List<Contact>();
    /*Collections for Partner Account Sharing*/
    Set<Id> accsToFindPortalUsers = new Set<Id>();
    List<User> usersForSharingUpdate = new List<User>();
    List<AccountShare> accShares = new List<AccountShare>();
    List<AccountShare> sharesToDelete = new List<AccountShare>();
    /*Collections for Opportunity Update on Account Owner change*/
    Set<Account> accsForOppUpdate = new Set<Account>();
    List<Opportunity> newOwnerOpps;
    /*Collections for Accounts with Address/Phone changes*/
    List<Account> accsWithAddressChanges = new List<Account>();
    List<Contact> updateContactAddress = new List<Contact>();
    /*Collections for GeoCode, OriginationDocs, Business Registration, and ShipAndBill Tos */
    List<Account> accsToGeoCode;
    static List<Account> accsForOriginationDocs;
    List<Account> accsForBusinessRegs = new List<Account>();
    Map<Id, Account> accsForShipAndBillTo = new Map<Id, Account>();
    static Map<Id, Account> oldMapforOriginationDocs;
    /*Collections for new or updated Geocoded Accounts and CoverageAreas*/
    Map<Id, Account> geoUpdatedAccs = new Map<Id, Account>();
    Map<Id, List<CoverageArea__c>> areasMap;
    List<CoverageArea__c> areasToUpdate = new List<CoverageArea__c>();
    Map<Id, Account> accsForDeleteCoverageArea = new Map<Id, Account>();
    Map<Id, Account> accsForAddCoverageArea = new Map<Id, Account>();
    private boolean OktoShipOptOut = false;//Ok To Ship
    //Co branding
        Set<string> tempList = new Set<string>();
        List<Account> tempAccList = new List<Account>();
        set<Id> Accid = new set<Id>();
        set<Id> LeaseAccid = new set<Id>();
        
    //CRYSTAL - TESTING
    Map<Id, Account> accIdsForOppOwnerUpdate = new Map<Id, Account>();
    
    // -------- Properties --------
    // Qualified records
    private Map<Id, Account> qualifiedAccounts;
    private map<Id,Account> accToUpdatePSREmail = new map<Id,Account>();
    // -------- Methods --------
    
    // Qualify records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList,
                                                Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        qualifiedAccounts = new Map<Id, Account>();
        Map<ID, Account> newAccountMap = (Map<ID, Account>)newMap;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)oldMap;
        List<Account> newAccountList = (List<Account>)newList;
        List<Account> oldAccountList = (List<Account>)oldList;
        accsForOriginationDocs = new List<Account>();
        oldMapforOriginationDocs = new Map<Id, Account>();
        accsToGeoCode = new List<Account>();
        
        
                                                    
        for(Account acc : newAccountList) {
            
            //add to geoencode
            //from Account Trigger
            //MDM User Skip
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null) && !ReferralManagementCallout.inBatchContext){
                if(acc.Geolocation__Latitude__s == null || acc.Geolocation__Longitude__s == null || acc.IsAddressUpdated__c == true
                   ) {
                        accsToGeoCode.add(acc);
                }
            }
            if(acc.RecordTypeId == AccountResidentialRecTypeId && acc.Number_of_Credit_Check_Sent__c == 0 && (acc.BillingStreet != oldAccountMap.get(acc.Id).BillingStreet || acc.BillingState != oldAccountMap.get(acc.Id).BillingState ||
                       acc.BillingCity != oldAccountMap.get(acc.Id).BillingCity || acc.BillingCountry != oldAccountMap.get(acc.Id).BillingCountry ||
                       acc.BillingPostalCode != oldAccountMap.get(acc.Id).BillingPostalCode)){
                    customerAccountIds.add(acc.Id);
            }
            
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null) && acc.theater__c != 'North America'){
                accsForOriginationDocs.add(acc);
                
            }
            //from afterAccountUpdate trigger, AccountManagement.afterAccountUpdate, processTerminatedAccount()
            //No Skips
            if(acc.Status__c == 'Terminated' && oldAccountMap.get(acc.Id).Status__c != 'Terminated') {
                qualifiedAccounts.put(acc.Id, acc);
                terminatedAccIds.add(acc.Id);
            }
            
            //from afterAccountUpdate trigger, AccountManagement.afterAccountUpdate, createTaskOnAccountStatusChange()
            //No Skips
            if(acc.RecordTypeId == AccountPartnerRecTypeId){
                if(acc.Status__c != null && oldAccountMap.get(acc.Id).Status__c != null &&
                   acc.Status__c == 'Active' && oldAccountMap.get(acc.Id).Status__c == 'Contract Pending'){
                       qualifiedAccounts.put(acc.Id, acc);
                       accsForTaskCreation.put(acc.ID, acc);
                }
                
                //Ok To Ship
                if( Label.Ok_To_Ship_Switch=='ON' && oldAccountMap.get(acc.Id).Partner_Opt_Out_Ok_To_Ship__c ==false && acc.Partner_Opt_Out_Ok_To_Ship__c == true){
                    OktoShipOptOut = true;
                }
                   
            }
            //from afterAccountUpdate trigger, AccountManagement.updateUserCountryDomain ln. 258-280
            //And afterAccountUpdate trigger, AccountManagement.updateContactCountryDomain ln. 285-297
            //No Skips
            if(acc.Country_Domain__c != oldAccountMap.get(acc.Id).Country_Domain__c) {
                qualifiedAccounts.put(acc.Id, acc);
                accsForContactUpdate.add(acc.Id);
                if(acc.IsPartner) {
                    accsForUserUpdate.add(acc);
                } 
            }
            // Gathering the residential customer accounts
            if(acc.RecordTypeId == AccountResidentialRecTypeId){
                qualifiedAccounts.put(acc.Id, acc);
            }
            //From afterAccountUpdate trigger, AccountManagement.SharePartnerAccount ln.473-578
            //No Skips
            if(acc.OwnerId != oldAccountMap.get(acc.Id).OwnerId && acc.IsPartner) {
                accsToFindPortalUsers.add(acc.Id);
            }
            //From UpdateOppOnAcctOwnerChange Trigger
            //No Skips
            //CRYSTAL - TESTING
            if(acc.OwnerId != oldAccountMap.get(acc.Id).OwnerId 
               && (acc.RecordTypeId == AccountResidentialRecTypeId || acc.RecordTypeId == AccountCommercialRecTypeId) ) { //RRA - Removed acc.Type == 'Home Owner' from the conditional statement
                System.debug('NEW OWNER: ' + acc.OwnerId);
                System.debug('OLD OWNER: ' + oldAccountMap.get(acc.Id).OwnerId);
                accIdsForOppOwnerUpdate.put(acc.Id, acc);//CRYSTAL - TESTING
                qualifiedAccounts.put(acc.Id, acc);
            }
            //from UpdatePrimaryContactDetails trigger
            if(!Util.isSkipTrigger()) {
                if(acc.RecordTypeId == AccountResidentialRecTypeId && (acc.BillingCity != oldAccountMap.get(acc.Id).BillingCity
                                                                   || acc.BillingPostalCode != oldAccountMap.get(acc.Id).BillingPostalCode
                                                                   || acc.BillingState != oldAccountMap.get(acc.Id).BillingState
                                                                   || acc.BillingStreet != oldAccountMap.get(acc.Id).BillingStreet
                                                                   || acc.Phone != oldAccountMap.get(acc.Id).Phone)) {
                                                                       accsWithAddressChanges.add(acc);
                                                                       qualifiedAccounts.put(acc.Id, acc);
                                                                   }
            }

            //from Account trigger ln. 166-170
                //Begin MDM User skip
                System.debug('---------OLD MAP'+ oldAccountMap.get(acc.Id).Type);
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null)){
                //JAJA - updated from PRE
                if(acc.Type != null 
                &&(oldAccountMap.get(acc.Id).Type == null 
                || (!oldAccountMap.get(acc.Id).Type.contains('Partner-Residential') 
                && !oldAccountMap.get(acc.Id).Type.contains('Partner-Combo')) 
                ) 
                && acc.Type != oldAccountMap.get(acc.Id).Type && acc.RecordTypeId == AccountPartnerRecTypeId 
                &&(acc.Type.contains('Partner-Residential') || acc.Type.contains('Partner-Combo')) && 
                (acc.Theater__c =='North America' || acc.Theater__c == 'Europe' || acc.Theater__c == 'Central America and the Caribbean')) { 
                accsForBusinessRegs.add(acc); 
                }
                //JAJA - updated from PRE 
                //from Account trigger ln 215-256
                //To update coverage areas if Geolocation has changed                   
                   //Chakra - Added condition to only create coverage for partner accounts  Case: 00665550 
                if(acc.RecordTypeId == AccountPartnerRecTypeId && acc.Type <> null && acc.Type.contains('Partner') && (acc.Geolocation__Latitude__s != oldAccountMap.get(acc.Id).Geolocation__Latitude__s 
                   || acc.Geolocation__Longitude__s != oldAccountMap.get(acc.Id).Geolocation__Longitude__s)) {
                       geoUpdatedAccs.put(acc.Id, acc);
                       qualifiedAccounts.put(acc.Id, acc);
                   }
            }//end of MDM User Skip
             if(acc.Lead_Flow_opt_out__c != oldAccountMap.get(acc.Id).Lead_Flow_opt_out__c){
                 /*if(acc.Lead_Flow_opt_out__c)
                    accsForDeleteCoverageArea.put(acc.id,acc);
                 else
                    accsForAddCoverageArea.put(acc.id,acc);*/
                 accsForAddCoverageArea.put(acc.id,acc);
            }
            
            //case #00641878  Co Branding Starts            
            if(acc.RecordtypeId == AccountResidentialRecTypeId && acc.DSE_IsCustomer__c == true && acc.Theater__c == 'North America' 
                &&  String.isNotBlank(acc.DSE_CustomerType__c) && String.isBlank(acc.CO_BRAND_Partner__c)) {
                    if(acc.DSE_CustomerType__c == 'Cash' ){
                        Accid.add(acc.Id);
                        qualifiedAccounts.put(acc.Id, acc);
                    }
                    if(acc.DSE_CustomerType__c == 'Lease' ){
                        LeaseAccid.add(acc.Id);
                        qualifiedAccounts.put(acc.Id, acc); 
                    }
            }

           // checking for PSR update
           if( acc.RecordtypeId == AccountPartnerRecTypeId && acc.Primary_PSR__c <> oldAccountMap.get(acc.Id).Primary_PSR__c){
                accToUpdatePSREmail.put(acc.Id,acc);
             } 
        
            
            
            
        }
        
        //runs only if Partner sharing is needed
        //determine if accs in accsToFindPortalUsers have at least 1 portal user
        
        if(!accsToFindPortalUsers.isEmpty() || !accsForContactUpdate.isEmpty()) {
            List<Contact> conts = new List<Contact>([SELECT Id, Partner_Portal_User__c, Partner_Portal_User__r.Id,
                                             Partner_Portal_User__r.Contact.Account.IsPartner, Partner_Portal_User__r.UserType,
                                             Partner_Portal_User__r.Contact.Account.ID, Partner_Portal_User__r.Contact.Account.Name,
                                             AccountId, Name, isPersonAccount
                                      FROM Contact 
                                      WHERE (contact.AccountID in : accsToFindPortalUsers AND partner_portal_user__c != null)
                                      OR (AccountId IN: accsForContactUpdate AND isPersonAccount = false)]);
            for(Contact cont : conts) {
                if(accsToFindPortalUsers.contains(cont.AccountId)) {
                    usersForSharingUpdate.Add(cont.Partner_Portal_User__r);
                } 
                if(accsForContactUpdate.contains(cont.AccountId)) {
                    contactData.add(cont);
                }
            }  
        }
        
        //Split into new methods from AccountCreateShipBillTos trigger
        //AccountServices.createShipBillTos
        if(!Util.isSkipTrigger())
            AccountServices2.createShipBillTos(newAccountMap, oldAccountMap);                                          
        //AccountServices.createOriginationDocumentsForAccounts(newAccountList);
        //MDM User Skip next 2 lines
        if(!Util.isSkipTrigger('MDMUserAccountBypass',null)){
            //accsForOriginationDocs.addAll(newAccountList);
            oldMapforOriginationDocs.putAll(oldAccountMap);
        }

       if(!util.isCoverageAreaReverseGeocode && !accsForAddCoverageArea.isEmpty()) { 
           list<CoverageArea__c> listCoverageArea = new list<CoverageArea__c>();
           for(CoverageArea__c objCoverageArea : [select id,is_Active__c,Account__c from CoverageArea__c where Account__c in: accsForAddCoverageArea.keySet()]){
               if(objCoverageArea.is_Active__c == accsForAddCoverageArea.get(objCoverageArea.Account__c).Lead_Flow_opt_out__c){
                   objCoverageArea.is_Active__c = !accsForAddCoverageArea.get(objCoverageArea.Account__c).Lead_Flow_opt_out__c;
                   listCoverageArea.add(objCoverageArea);
               }
               if(!listCoverageArea.isEmpty()){
                   try{
                       update listCoverageArea;
                   }Catch(Exception ex)
                   {
                       
                   }   
               }
           }
       }
      // Calling Method to update PSR Email on all related LP records
      if(!accToUpdatePSREmail.isEmpty())
         accountHandlerUtilities.updatePrimaryPSREmail(accToUpdatePSREmail);
    }
    
    // Start processing
    public override void start() {  
         areasMap = new Map<Id, List<CoverageArea__c>>();
        
        
        /*GATHER QUERY DATA*/
        //Gather Certifications from terminated accounts
        if(terminatedAccIds != null && !terminatedAccIds.isEmpty()) {
            lstCertifications = [SELECT Id, Name FROM Certification__c WHERE Account__c IN: terminatedAccIds];
        }
        //Get AU Task Manager information
        if(!accsForTaskCreation.isEmpty()) {
                auManagerId = AccountHandlerUtilities.getAUManagerId();
        }
        //Get User and Contact Data for Country Domain Update
        //Get Owner and Opportunity data for owner updates
        if(!accsForUserUpdate.isEmpty()) {
            List<User> getUserData = new List<User>([SELECT u.Name, u.Id, u.Country_Domain__c,u.Contact.AccountID
                                                     FROM User u
                                                     WHERE (u.UserType = 'PowerPartner'
                                                            AND u.Contact.AccountId IN: accsForUserUpdate)]);
            for(User u : getUserData) {
                userData.add(u);
            }
        }

        //Get Coverage Area for updated new/updated geocodes
        if(!geoUpdatedAccs.isEmpty()) {
            for(CoverageArea__c ca : [SELECT Id, Account__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Name //...
                                      FROM CoverageArea__c
                                      //WHERE Name = 'Billing Address' AND Account__c IN: geoUpdatedAccs.keySet()]) {
                                      WHERE (Name = 'Billing Address' OR Name = 'Billing Address - Commercial') AND Account__c IN: geoUpdatedAccs.keySet()]) {
                                          if(areasMap.containsKey(ca.Account__c)) {
                                              areasMap.get(ca.Account__c).add(ca);
                                          }
                                          else {
                                              areasMap.put(ca.Account__c, new List<CoverageArea__c>());
                                              areasMap.get(ca.Account__c).add(ca);
                                          }
            }
        }
        //Billing Address (residential)
        //Billing Address - Commerical
        
        //Create Business Registrations
        if(!accsForBusinessRegs.isEmpty()) {
            AccountHandlerUtilities.createBusinessRegistration(accsForBusinessRegs);
        }
              
        /*BEGIN PROCESSING QUALIFIED ACCOUNTS*/
        if(!qualifiedAccounts.isEmpty()){
            for(Account acc : qualifiedAccounts.values()) {
                if(accsForTaskCreation.containsKey(acc.Id)) {
                    createTaskForAccount(acc);
                }
                if(accsForUserUpdate.contains(acc)) {
                    for(User usr : userData){
                        if(usr.Contact.AccountId == acc.Id){
                            usr.Country_Domain__c = acc.Country_Domain__c;
                            usersToupdate.add(usr);
                        }
                    }
                }
                if(accsForContactUpdate.contains(acc.Id)) {
                    for(Contact con : contactData) {
                        if(con.AccountId == acc.Id) {
                            con.Country_Domain__c = acc.Country_Domain__c;
                            contactsToUpdate.add(con);
                        }
                    }
                }
                if(geoUpdatedAccs.containsKey(acc.Id)) {
                    newCoverageAreas(acc);
                }
            }//End for loop
        }//end outer loop
        
        //Do account sharing at end of processing
        if(!usersForSharingUpdate.isEmpty()) {
            sharePartnerAccounts(); 
        }
        //Update Primary Contact addresses
        if(!accsWithAddressChanges.isEmpty()) {
            primaryContactsToUpdate(accsWithAddressChanges); 
        }
        
        // Call Sales Tax rate API
        if(!customerAccountIds.isEmpty()){
            callSalesTaxRate(customerAccountIds);
        }
        
        // Co Branding
        //Cash only
        if(Accid.size() > 0){
            Id standardAccRecordType = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Standard');
            List<Co_Branding_Patner__c> CB = Co_Branding_Patner__c.getall().values();
            //R.Alega - 04.APR.2016 - Exclude other Theaters from Co-branding functionality. Only applicable to North America - Case 00685255 -> moved to qualifier
            //---- START (Case 00685255) ----//
            for(Opportunity  opp : [Select Id, AccountId, StageName, Account.BillingState, Account.DSE_CustomerType__c, Account.DSE_IsCustomer__c, 
                                            Account.Partner_Account__r.Name, Account.Partner_Account__r.RecordTypeId 
                                    FROM Opportunity WHERE AccountId IN: Accid
                                    AND Account.Partner_Account__r.RecordTypeId !=: standardAccRecordType //case 00810661: exclude standard record type
                                    AND Account.BillingState != null
                                    AND Account.DSE_CustomerType__c != null]) {
                for(Co_Branding_Patner__c  cp : CB ) {                       
                    if( cp.State__c.contains(opp.Account.BillingState) && cp.DEAL_TYPE__c.contains(opp.Account.DSE_CustomerType__c) 
                        && (cp.SELLING_ENTITY__c == 'ALL' || opp.Account.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) 
                        && cp.OPPORTUNITY_STAGE__c.contains(opp.StageName)) {                     
                           tempList.add( opp.AccountId +','+cp.CO_BRAND_Partner__c);
                    }   else 
                            return;
                }                    
            }
            //---- END (Case 00685255) ----//                
        }
        
        //Lease only    
        if(LeaseAccid.size() > 0){

            List<Co_Branding_Patner__c> CB = Co_Branding_Patner__c.getall().values();
          
            for(LeasePayment__c  Lpo : [SELECT Id, Funding_Tranche__c, Opportunity__c, Opportunity__r.StageName, Account__c, Account__r.BillingState, 
                                               Account__r.DSE_CustomerType__c, Account__r.DSE_IsCustomer__c ,Account__r.Partner_Account__r.Name 
                                        FROM LeasePayment__c WHERE Account__c IN: LeaseAccid
                                        AND Opportunity__c != null 
                                        AND Account__r.DSE_CustomerType__c != null
                                        AND Account__r.BillingState != null]){
                
                for(Co_Branding_Patner__c  cp :CB ){
                  
                    if( (cp.Financier__c == null ||  
                        (Lpo.Funding_Tranche__c != NULL && Lpo.Funding_Tranche__c.contains(cp.Financier__c)) ) 
                            && cp.State__c.contains(Lpo.Account__r.BillingState) && cp.DEAL_TYPE__c.contains(Lpo.Account__r.DSE_CustomerType__c) 
                            && (cp.SELLING_ENTITY__c == 'ALL' || Lpo.Account__r.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) 
                            && cp.OPPORTUNITY_STAGE__c.contains(Lpo.Opportunity__r.StageName)) {
                                tempList.add( Lpo.Account__c +','+cp.CO_BRAND_Partner__c); 
                    }   
                }      
            }
        }
            
            
    }
    
    /*FINSIH*/
    public override void finish(Boolean fromStart){
        
        if (fromStart) {
            //System.debug('AfterUpdate Finish(*************)');
            
            //Do GeoCode
            if(!accsToGeoCode.isEmpty() && !ReferralManagementCallout.inBatchContext) {
                //System.debug('GEOLIST SIZE ON AFTER UPDATE: &#&##&#&#&#&&#  ' + accsToGeoCode.size());
                //if(GeocodeAsyncHandler.scheduleBatch == false) { GeocodeAsyncHandler.setToTrue(); }
                
                if(GeocodeAsyncHandler.scheduleBatch == true) {
                    AccountHandlerUtilities.runGeoCodeFromTrigger(accsToGeocode);
                }
                
            }
            
            if(!lstCertifications.isEmpty()) {
                delete lstCertifications;
            }
            if(!Test.isRunningTest()) {
                Database.DMLOptions dlo = new Database.DMLOptions();
                dlo.EmailHeader.triggerUserEmail = true;
                //dlo.EmailHeader.triggerUserEmail = false; //added for testing purposes can be removed when deployed
                database.insert(newTasksForAccs, dlo);
                AccountHandlerUtilities.sendEmailForTaskCreation(newTasksForAccs, accsForTaskCreation); 
            }
            if(!usersToupdate.isEmpty()) {
                update usersToupdate;
            }
            if(!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
            }
            if(!accShares.isEmpty()) {
                accShares = removeDuplicates(accShares);
                if(!accShares.isEmpty()) {
                    Database.insert(accShares, false);
                }
            }
            if(!sharesToDelete.isEmpty()) {
                delete sharesToDelete;
            }
            if(!accIdsForOppOwnerUpdate.isEmpty())
                collectOppDataAndUpdate(accIdsForOppOwnerUpdate);
            
            if(!updateContactAddress.isEmpty()) {
                update updateContactAddress;
            }
            if(!areasToUpdate.isEmpty()) {
            	Set<CoverageArea__c> cleanAreas = new Set<CoverageArea__c>();
                cleanAreas.addAll(areasToUpdate);
                areasToUpdate.clear();
                areasToUpdate.addAll(cleanAreas);
                upsert areasToUpdate;
            }
            
            makeOriginationDocs();
            
            // co branding            
            if(tempList.size() > 0) {          
                for(Account acc : [SELECT Id, CO_BRAND_Partner__c FROM Account WHERE Id IN: Accid OR Id IN: LeaseAccid]){
                    for( string st : tempList) {
                        string s1 = st.substringBefore(',');
                        string s2 = st.substringAfter(',');
                    
                        if(s1 == acc.Id) {
                            acc.CO_BRAND_Partner__c = s2;                            
                            tempAccList.add(acc);
                        }     
                    }
                }  
            }
            if(tempAccList.size() > 0) {
                update tempAccList;
            } 
        }
    }
    
    // -------- Internal Classes --------
    //  Making call to Sales Tax Rate API class
    @future(callout = true)
    private static void callSalesTaxRate(Set<Id> accIds){
        AccountHandlerUtilities.updateSalesTax(accIds);
    }
    
    private static void makeOriginationDocs() {
        //Could use some explanation on this one please, mostly how does this checkbox get checked?
        List<Account> selectedAccounts = Select.Field.isEqual(Account.Run_Origination_Docs_Trigger__c, true).
                    andx(Select.Field.hasChanged(Account.Run_Origination_Docs_Trigger__c)).filter(accsForOriginationDocs, oldMapforOriginationDocs);
        if(!selectedAccounts.isEmpty())        
        AccountServices.createOriginationDocumentsForAccounts(selectedAccounts);
    }
    
    private static List<Task> createTaskForAccount(Account a){
        Account acct = a;
        Task tsk = new Task(
            whatid = acct.Id,                    
            ActivityDate = Date.today().addDays(2),
            OwnerId = acct.Primary_PSR__c,
            Subject = 'Create Oracle Account',
            Description = 'Please create an Oracle account and include the account number on the Account page in SFDC. Also ensure that the Oracle Operating Unit is accurate. Thank You Partner Experience'
        );
        if(acct.Country_Domain__c != 'cvar-us' && acct.Country_Domain__c != 'combo-us'&& acct.Country_Domain__c != 'rvar-us') {
            tsk.RecordTypeId = OnBoardingTaskRecTypeId;
            tsk.IsReminderSet = true;       
            //tsk.CreatedById = UserInfo.getUserId();
            tsk.Severity__c = 'P2 - Significant';                 
        }
        if(acct.Country_Domain__c == 'cvar-au' || acct.Country_Domain__c == 'combo-au' || acct.Country_Domain__c == 'rvar-au') {
            tsk.OwnerId = auManagerId;                    
        }
        
        newTasksForAccs.add(tsk);
        return newTasksForAccs;
    }
    
    private List<AccountShare> sharePartnerAccounts() {
        List<Group> grpList = new List<Group>();
        Map<String, AccountShare> accountSharesMap = new Map<String, AccountShare>();
        Map<String,ID> roleGrpMap = new Map<String,ID>();
        Map<ID,String> acctNames = new Map<ID,String>();
        
        //Get User and Group Data for Partner Account Sharing
        if(!usersForSharingUpdate.isEmpty()) {
            for(User user : usersForSharingUpdate){
                if(user.Contact.Account.IsPartner && user.UserType == 'PowerPartner'){
                    String accName = User.Contact.Account.Name.length() > 62 ? User.Contact.Account.Name.subString(0,62) : User.Contact.Account.Name;
                    acctNames.put(user.Contact.Account.ID, accName + ' Partner Executive');
                }
            }
            Map<Id, UserRole> userRolesMap = new Map<Id, UserRole>([SELECT Id, Name FROM UserRole WHERE Name IN: acctNames.values() LIMIT 1000]);
            grpList = [SELECT Id, RelatedID FROM Group WHERE Type = 'RoleAndSubordinates' AND relatedId IN: userRolesMap.keySet()];
            for (Group g : grpList) {
                UserRole uRole = (UserRole)userRolesMap.get(g.relatedId);
                roleGrpMap.put(uRole.Name, g.Id);
            }
            for(AccountShare share : [SELECT Id, AccountId, AccountAccessLevel, UserOrGroupId, OpportunityAccessLevel
                                      FROM AccountShare
                                      WHERE UserOrGroupId IN: userRolesMap.keySet() and AccountId != null]) {
                                          String name = acctNames.get(share.AccountId);
                                          if(name != null) {
                                              accountSharesMap.put(name, share);
                                          }
                                      }
            for(ID id : acctNames.keySet()){
                String acctName= acctNames.get(id);
                AccountShare accountShare = accountSharesMap.get(acctName);
                if(accountShare == null){
                    accountShare= new AccountShare();
                    accountShare.accountID= id;
                    accountShare.AccountAccessLevel ='Edit';
                    accountShare.UserorGroupID =roleGrpMap.get(acctName);
                    accountShare.OpportunityAccessLevel = 'None'; 
                    accShares.add(accountShare);
                    accountSharesMap.put(acctName, accountShare);
                }else{
                    if(accountShare.AccountAccessLevel !='Edit' || accountShare.OpportunityAccessLevel !='Edit'){
                        sharesToDelete.add(accountShare);
                        AccountShare accShare= new AccountShare();
                        accShare.accountID= id;
                        accShare.AccountAccessLevel ='Edit';
                        accShare.UserorGroupID = roleGrpMap.get(acctName);
                        accShare.OpportunityAccessLevel = 'None'; 
                        accShares.add(accShare);        
                    }
                } 
            }
        }
        usersForSharingUpdate.clear();
        return accShares;
    }
    
    private static List<AccountShare>  removeDuplicates(List<AccountShare> accountShares){
        Set<String> existingShares = new Set<String>();
        List<AccountShare> filteredShares = new List<AccountShare>(); 
        String sep ='~';
        List<AccountShare> dups = new List<AccountShare>();
        for(AccountShare share : accountShares){
            if(existingShares.contains(share.UserorGroupId + sep + share.AccountId)){
                dups.add(share);
            } else {
                existingShares.add(share.UserorGroupId + sep + share.AccountId);
                filteredShares.add(share);
            }
        }
        return filteredShares;
    }
    
    private void collectOppDataAndUpdate(Map<Id, Account> newAcctOwnerMap) {
        //fires dummy update so Owner data on opportunity is updated from account owner change
        Map<Id, Opportunity> newOwnerOppsMap = new Map<Id, Opportunity>();
        Map<Id, Account> acctData = new Map<Id, Account>([SELECT Id, Owner.Contact.AccountId, Owner.Contact.Account.RSM__c,
                                                          (SELECT Id, OwnerId, AccountId, Partner_Account_ID__c, RSMName__c
                                                           FROM Opportunities)
                                                         FROM Account WHERE ID IN: newAcctOwnerMap.keySet()]);
        
        for(Account a : acctData.values()) {
            for(Opportunity o : a.Opportunities) {
                o.OwnerId = a.OwnerId;
                if(a.Owner.Contact.AccountId != null) {
                    o.Partner_Account_Id__c = a.Owner.Contact.AccountId;
                    o.RSMName__c = a.Owner.Contact.Account.RSM__c;  // RRA - Case 00695096 - populate RSM Name at the same time Partner Account Id is populated.
                }
                newOwnerOppsMap.put(o.Id, o);
            }
        }
        
        if(!newOwnerOppsMap.isEmpty())
            update newOwnerOppsMap.values();
    }
    
    private List<Contact> primaryContactsToUpdate(List<Account> addressChangeList) {
       
        for(Account a : [SELECT Id, Phone, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet,email__c,
                                (SELECT Id, Phone, Primary__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet
                                 FROM Contacts WHERE Primary__c = true)
                         FROM Account
                         WHERE Id IN: addressChangeList AND RecordTypeId =: AccountResidentialRecTypeId]){
                         
                         if(!a.Contacts.isEmpty()) {
                             for(Contact c : a.Contacts) {
                                 if(c.MailingCity != a.BillingCity || c.MailingCountry != a.BillingCountry
                                    || c.MailingPostalCode != a.BillingPostalCode || c.MailingState != a.BillingState 
                                    || c.MailingStreet != a.BillingStreet || c.Phone != a.Phone) {
                                            c.MailingCity = a.BillingCity;
                                            c.MailingCountry = a.BillingCountry;
                                            c.MailingPostalCode= a.BillingPostalCode;
                                            c.MailingState= a.BillingState;
                                            c.MailingStreet= a.BillingStreet;
                                            c.Phone= a.Phone;
                                            //c.email= a.email__c;
                                            c.isUpdatedFromAccount__c= true;
                                            updateContactAddress.add(c);
                                  }
                             }
                         }
        }
        addressChangeList.clear();
        accsWithAddressChanges.clear();
        return updateContactAddress;
    }
    
     //Added by Chakra CR : 00665550
        private void newCoverageAreas(Account a) {

        if( a.type <> null && a.type.contains('Partner')){
     
            CoverageArea__c newArea;
            CoverageArea__c comArea;
            
            if( a.type.Contains('Combo')) {
                if(areasMap.get(a.Id) != null && areasMap.get(a.Id).size() > 0) {
                    for(CoverageArea__c ca : areasMap.get(a.Id)) {
                        newArea = new CoverageArea__c();
                        if(ca.Name == 'Billing Address') {
                            newArea.Account__c = a.Id; //KCM_06212016
                            newArea.Id = ca.Id;
                            newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                            newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                            newArea.Radius__c = 40;
                            newArea.Sector__c = 'Residential';
                            newArea.Need_Update_CoverageMap__c = true;
                            areasToUpdate.add(newArea);
                        }
                        else {
                            newArea.Account__c = a.Id; //KCM_06212016
                            newArea.Id = ca.Id;
                            newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                            newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                            newArea.Radius__c = 200;
                            newArea.Sector__c = 'Commercial';
                            newArea.Need_Update_CoverageMap__c = true;
                            areasToUpdate.add(newArea);                     
                        }
                    }
                }
                else {
                    newArea = new CoverageArea__c();
                    newArea.Name = 'Billing Address';
                    newArea.Account__c = a.Id;
                    newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                    newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                    newArea.Radius__c = 40;
                    newArea.Sector__c='Residential';
                    newArea.Need_Update_CoverageMap__c = true;
                    areasToUpdate.add(newArea); 
                    
                    comArea = new CoverageArea__c();
                    comArea.Name = 'Billing Address - Commercial';
                    comArea.Account__c = a.Id;
                    newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                    newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                    comArea.Sector__c='Commercial';
                    comArea.Radius__c = 200;
                    comArea.Need_Update_CoverageMap__c = true;
                    areasToUpdate.add(comArea);
                }
            } //end combo
            else {
                if(areasMap.get(a.Id) != null && areasMap.get(a.Id).size() > 0) {
                    for(CoverageArea__c ca : areasMap.get(a.Id)) {
                        newArea = new CoverageArea__c();
                        newArea.Account__c = a.Id; //KCM_06212016
                        newArea.Id = ca.Id;
                        newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                        newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                        if(a.type.contains('Commercial'))
                            newArea.Radius__c = 200;
                        else 
                            newArea.Radius__c = 40;
                        newArea.Need_Update_CoverageMap__c = true;
                        areasToUpdate.add(newArea);
                    }
                } 
                else {
                    newArea = new CoverageArea__c();                    
                    newArea.Account__c = a.Id; //KCM_06212016
                    if(a.type.contains('Commercial')){
                        newArea.Name = 'Billing Address - Commercial';
                        newArea.Radius__c = 200;
                        newArea.Sector__c='Commercial';
                        
                    }
                    else {
                        newArea.Name = 'Billing Address';
                        //KCM_06212016 newArea.Account__c = a.Id;
                        newArea.Radius__c = 40;
                        newArea.Sector__c='Residential';
                    }

                    newArea.Geolocation__Latitude__s = a.Geolocation__Latitude__s;
                    newArea.Geolocation__Longitude__s = a.Geolocation__Longitude__s;
                    newArea.Need_Update_CoverageMap__c = true;
                    areasToUpdate.add(newArea);
                }
            } 
        }
    }

}