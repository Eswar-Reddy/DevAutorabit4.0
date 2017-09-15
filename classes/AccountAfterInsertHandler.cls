/*

Child of HandlerBase for handling account trigger actions

Class:              AccountAfterInsertHandler
Date:               12/18/2014
Version:            1
Last Updated:       12/18/2014


Refactor by: Crystal
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class AccountAfterInsertHandler extends TriggerHandlerBase {
    
    // -------- Constants --------
    private static Id AccountResidentialRecTypeId = AccountHandlerUtilities.ResidentialRecTypeId;
    private static Id AccountPartnerRecTypeId = AccountHandlerUtilities.PartnerRecTypeId;
    static String createContactProfile = Label.CreateContactProfile;//xxx SunPower Service User
    static ID profileid = UserInfo.getProfileId();
    
    // -------- Constructor --------
    public AccountAfterInsertHandler(){}
    
    // -------- Variables --------
    Set<Id> accsForFieldVals = new Set<Id>();
    Set<Id> accsForSicLevels = new Set<Id>();
    String finalFieldValue;
    Set<Account> accsToUpdate = new Set<Account>();
    /*Collections for Contact creation and updating*/
    List<Account> accsForCreateContact = new List<Account>();
    List<Contact> contactsToBeInserted = new List<Contact>();
    /*Collections for GeocodeAsync*/
    List<Account> accsToGeoCode;
    List<Account> accsToUpdateCounty;
    /*Collections for Origination docs and Business Registration*/
    List<Account> accsForBusinessRegistration = new List<Account>();
    /*List<TestLeadConversionHelper__c> lchList = new List<TestLeadConversionHelper__c>();*/
    static List<Account> accsForOriginationDocs;
    List<Account> accsForIntegrationNums = new List<Account>();
    /*Collections for ship and bill tos */
    Map<Id, Account> accsForShipTos;
    
    // -------- Properties --------
    // Qualified records
    private Map<Id, Account> qualifiedAccounts;
    
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
        accsToGeoCode = new List<Account>();
        accsForShipTos = new Map<Id, Account>(); 
        accsToUpdateCounty = new List<Account>();                                             
                                                    
        for(Account a : newAccountList) {  
            
            //from Account trigger ln. 156
            //MDM User Skip
            if(!Util.isSkipTrigger('MDMUserAccountBypass',null)){
                //add to geoencode 
                //from Account trigger ln. 111-140
                if(a.Geo__Latitude__s == null || a.Geo__Longitude__s == null || a.IsAddressUpdated__c == true) {
                    accsToGeoCode.add(a);
                }
                 
                if(a.RecordTypeId == AccountPartnerRecTypeId) {
                    if(a.Type != null && (a.Type.contains('Partner-Residential') || a.Type.contains('Partner-Combo')) &&
                       (a.Theater__c =='North America' || a.Theater__c == 'Europe' || a.Theater__c == 'Central America and the Caribbean')) {
                           accsForBusinessRegistration.add(a);
                           qualifiedAccounts.put(a.Id, a);
                       }
                }
                if(a.RecordTypeId == AccountResidentialRecTypeId){
                    qualifiedAccounts.put(a.Id, a);
                }
                if(a.theater__c != 'North America') {
                    accsForOriginationDocs.add(a);
                }
            }
            
            //from afterAccountInsert trigger, AccountManagement.afterAccountInsert, setAccountNumber()
            //no bypasses listed
            if((a.AccountNumber == null || a.AccountNumber == '')
               || (a.Integration_ID__c == null || a.Integration_ID__c == '')
               || (a.ACBParanet_ID__c == null || a.ACBParanet_ID__c == '')){
                   accsForFieldVals.add(a.Id);
                   //system.debug('acc added for account number.');
                   qualifiedAccounts.put(a.Id, a);
            }
            
            //from afterAccountInsert trigger, AccountManagement.afterAccountInsert, createContact()
            //not in context of leadconversion
            if(!Util.isInContextOfLeadConversion()){
                if(createContactProfile.contains(profileid)){
                    accsForCreateContact.add(a); 
                    qualifiedAccounts.put(a.Id, a);
                }
            }
            
           /* Lead convertedLead = Util.isInContextOfLeadConversion2();
            if(convertedLead!=null){
                TestLeadConversionHelper__c lch = new TestLeadConversionHelper__c(Lead__c = convertedLead.Id, Account__c = a.Id);
                lchList.add(lch);
            } */
            
            if(a.Oracle_County__c != null || a.Oracle_County__c != '' && a.RecordTypeId == AccountResidentialRecTypeId){
                accsForShipTos.put(a.Id, a);
            }
        } 
        //begin createShipBillTos from AccountCreateShipBillTos trigger, AccountServices.createShipBillTos
        if(!util.isSkipTrigger()) {
            AccountServices2.createShipBillTos(accsForShipTos, oldAccountMap);
        }                                            
    }
    
    // Start processing
    public override void start() { 
         
        //begin Business Registration from Account trigger ln. 175-206
        if(!accsForBusinessRegistration.isEmpty()) {
            AccountHandlerUtilities.createBusinessRegistration(accsForBusinessRegistration);
        }
        Set<Id> customerAccountIds = new Set<Id>();
        Set<Id> queueCustomerAccountIds = new Set<Id>();
        /*Begin Qualified Account Looping stuff*/
        if(!qualifiedAccounts.isEmpty()) {
            
            /*BEGIN PROCESSING QUALIFIED ACCOUNTS*/
            for(Account account : qualifiedAccounts.values()) {
                //gathering the residential customer accounts that doesn't have sales tax not set yet
                if(account.RecordTypeId == AccountResidentialRecTypeId){
                    if(System.isFuture()){
                        queueCustomerAccountIds.add(account.Id);
                    }
                    else{
                        customerAccountIds.add(account.Id);
                    }
                }
                //begin setting field vals
                if(accsForFieldVals.contains(account.Id)) {
                    //system.debug('Going to setAccountFields');
                    setAccountFields(account);
                }
            }//end qualifiedAccounts loop
            //begin processing newContacts
            if(accsForCreateContact != null && !accsForCreateContact.isEmpty()){
                createContacts(accsForCreateContact);
            }
            system.debug('customerAccountIds '+customerAccountIds);
            // calling Sales Tax Rate API for residential customer accounts
            if(customerAccountIds != null && customerAccountIds.size() > 0){
                callSalesTaxRate(customerAccountIds);
            }
            if(queueCustomerAccountIds != null && queueCustomerAccountIds.size()>0){
                UpdateAccountSalesTaxQueue uast = new UpdateAccountSalesTaxQueue(queueCustomerAccountIds);
                ID jobID = System.enqueueJob(uast);
            }
        }
    }     
    //Finish and DML
    public override void finish(Boolean fromStart){
           
        if (fromStart) {
            
            System.debug('accsForIntegrationNums' + accsForIntegrationNums);
            if(!accsForIntegrationNums.isEmpty()) {
                update accsForIntegrationNums;
            }
            
            //begin Geocode
            if(!accsToGeocode.isEmpty() && !ReferralManagementCallout.inBatchContext) {
                //System.debug('GEOLIST SIZE ON AFTER INSERT: &#&##&#&#&#&&#  ' + accsToGeoCode.size());
                //if(GeocodeAsyncHandler.scheduleBatch == false) { GeocodeAsyncHandler.setToTrue(); }
                AccountHandlerUtilities.runGeoCodeFromTrigger(accsToGeocode);
            }
            
            List<Account> fieldUpdateList = new List<Account>();
            if(!accsToUpdate.isEmpty()) {     
                fieldUpdateList.addAll(accsToUpdate);
            }
            update fieldUpdateList;
            
            if(contactsToBeInserted != null && !contactsToBeInserted.isEmpty()) {
                insert contactsToBeInserted;
            }

            /*
            if(!lchList.isEmpty()){
                insert lchList;
            }*/
            
            //begin Origination Document creation from Account trigger (145-158)
            //MDM User Skip
            if(!accsForOriginationDocs.isEmpty())
            AccountServices.createOriginationDocumentsForAccounts(accsForOriginationDocs);
        }
        
    }

    // -------- Internal Classes --------
    //  Making call to Sales Tax Rate API class
    @future(callout = true)
    private static void callSalesTaxRate(Set<Id> accIds){
        AccountHandlerUtilities.updateSalesTax(accIds);
    }
  
    //Account fields from AccountManagement.afterAccountInsert, setAccountNumber() ln.325-410
    //SIC Fields moved to BeforeInsert out of this method
    public Account setAccountFields(Account a){
        String finalFieldValue;
        Account acc = new Account(id = a.Id);
        //Account acc = a.clone(true, true, true, true);
        String accIdString = acc.Id;
        //system.debug(acc.Id + 'NEW ACCOUNT ID!');
        
        //System.debug('RECORDTYPEID*****: '+acc.RecordTypeId+a.RecordTypeId);
        System.debug('acc '+ acc + ' AccountPartnerRecTypeId '+ AccountPartnerRecTypeId + ' AccountResidentialRecTypeId '+ AccountResidentialRecTypeId ); 
               
        if(AccountPartnerRecTypeId != null & acc.RecordTypeId == AccountPartnerRecTypeId) { //MAM 10.MAR.2015 Check if the RecordType ID is null to avoid duplicate Integration name entries
            acc.AccountNumber = 'P' + accIdString.subString(accIdString.length() - 8).toUpperCase();
            finalFieldValue = acc.AccountNumber;
            if(acc.Integration_ID__c == null || acc.Integration_ID__c == '') {
                acc.Integration_ID__c = finalFieldValue;
            }
            if(acc.ACBParanet_ID__c == null || acc.ACBParanet_ID__c == '') {
                acc.ACBParanet_ID__c = acc.Integration_ID__c;
            }
            accsForIntegrationNums.add(acc);
        }
        if(AccountResidentialRecTypeId  != null & AccountResidentialRecTypeId == acc.RecordTypeId) { //MAM 10.MAR.2015 Check if the RecordType ID is null to avoid duplicate Integration name entries
            acc.AccountNumber = 'C' + accIdString.subString(accIdString.length() - 8).toUpperCase();
            finalFieldValue = acc.AccountNumber;
            if(acc.Integration_ID__c == null || acc.Integration_ID__c == '') {
                acc.Integration_ID__c = finalFieldValue;
            }
            if(acc.ACBParanet_ID__c == null || acc.ACBParanet_ID__c == '') {
                acc.ACBParanet_ID__c = acc.Integration_ID__c;
            }
            accsForIntegrationNums.add(acc);
        }
        
        return acc;
    }
    
    //from AccountManagement.afterAccountInsert, createContact(); ln 46-77
    private List<Contact> createContacts(List<Account> accListForContacts) {
        for(Account acc : accsForCreateContact) {
            Contact newContact = new Contact();
            newContact.AccountId = acc.Id;
            newContact.LastName = acc.Name;
            newContact.Fax = acc.Fax;
            newContact.Email = acc.Email__c;
            newContact.Phone = acc.Phone;
            newContact.HomePhone = acc.PersonHomePhone;
            newContact.MailingStreet = acc.BillingStreet;
            newContact.MailingState = acc.BillingState;
            newContact.MailingCountry = acc.BillingCountry;
            newContact.MailingPostalCode = acc.BillingPostalCode;
            
            contactsToBeInserted.add(newContact);
        }
        return contactsToBeInserted;
    }
}