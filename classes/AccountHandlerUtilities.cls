/*****
MODIFICATION HISTORY:

version: KCM_03142016
author: Kane Chelster Macaspac
last modified date/time: 03-15-2016 12:04AM Pacific
details:
1. removed hardcoded email addresses from the code and replaced them with a custom setting called 
   'Recipients List (Account Notifications)' so that changes to the list in the future can be managed better and faster.
2. a fix to the problem reported in case 00666261
3. please use the version name above as a search term in order to jump to the parts of the code specific to this version.
   These can be, but not limited to, lines of codes that already exist prior to this change but have been commented out since 
   they are being replaced entirely, newly introduced lines of codes, or changes to existing ones.
*****/
public with sharing class AccountHandlerUtilities {
    
    // -------- Constants --------
    // None
    
    // -------- Constructor --------
    public AccountHandlerUtilities() {}
    
    // -------- Variables --------
    
    /*public static ID ResidentialRecTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Residential Customer').RecordTypeId;
    public static ID PartnerRecTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Partner').RecordTypeId;
    public static Id CommercialRecTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Commercial Customer').RecordTypeId;
    public static Id OnBoardingTaskRecTypeId = Schema.SObjectType.Task.RecordTypeInfosByName.get('On-boarding task').RecordTypeId;
    public static ID ResidentialRecTypeId = util.GetRecordTypeIdsByDeveloperName(Account.SObjectType).get('Home_Owner');
    public static ID PartnerRecTypeId = util.GetRecordTypeIdsByDeveloperName(Account.SObjectType).get('Partner');
    public static Id CommercialRecTypeId = util.GetRecordTypeIdsByDeveloperName(Account.SObjectType).get('Commercial');
    public static Id OnBoardingTaskRecTypeId = util.GetRecordTypeIdsByDeveloperName(Task.SObjectType).get('On_boarding_task'); Replaced with SFDC cached queries Case# 541988*/
    public static Id ResidentialRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner');
    public static Id PartnerRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Partner');
    public static Id CommercialRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Commercial');
    public static Id OnBoardingTaskRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Task.sObjectType).get('On_boarding_task');
    public static List<Sunpower_Spectrum_Debug_Log__c> spectrumDebugList = new List<Sunpower_Spectrum_Debug_Log__c>();
    public static List<Exception_Log__c> exceptionLogList = new List<Exception_Log__c>();
    public static boolean firedGeoCallout = false;
    
    //KCM_03142016: static variable to contain the custom setting values needed 
    private static Map<String, Recipients_List_Account_Notifications__c> csRecipients_map = Recipients_List_Account_Notifications__c.getAll();
    
    // -------- Properties --------
    
    // -------- Methods --------
    public static Id getAUManagerId() {
        Id AUTaskManagerId = null;
        List<User> auTaskManager = new List<User>([select Id from User where Name = 'Carla Noelle Perfecto' limit 1]);
        if(!auTaskManager.isEmpty()) {
            AUTaskManagerId = auTaskManager.get(0).Id;
        }
     
        return AUTaskManagerId;
    }
    // -------- Internal Classes --------
    //
    public static Map<ID, Account> loadPartnerAccounts(Set<ID> accountIDs)
    {
        Map<ID, Account> result = new Map<ID, Account>();
        
        try
        {
            result = new Map<ID, Account>([SELECT ID, isSpectrumPartner__c FROM Account WHERE ID =: accountIDs]);
        }
        catch(QueryException error)
        {
            result = new Map<ID, Account>();
            Diagnostics.exception(error);
            SunPowerException.recordError('OpportunityUtilities', 'loadPartnerAccounts', error);
        }
        
        return result;
    }
    
    //begin Business Registration from Account trigger ln. 175-206
    //called from AccountAfterInsertHandler and AccountAfterUpdateHandler
    public static void createBusinessRegistration(List<Account> qualifiedBusinessRegAccounts) {
        System.debug('Accounts for Business Registrations: ' + qualifiedBusinessRegAccounts.size());
        List<Business_Registration__c> businessRegs = new List<Business_Registration__c>();
        for(Account acc : qualifiedBusinessRegAccounts) {
            Business_Registration__c br = new Business_Registration__c();
            
            if (acc.billingstate == null || acc.billingstate =='') {
                br.Name = acc.billingCountry;
            } else {
                br.Name = acc.billingstate;
            }
            br.Account__c = acc.id;
            br.Expires_On__c = acc.Contractors_Lic_Expiry__c;
            if(acc.Contractors_License__c == null || acc.Contractors_License__c == 'PENDING') {
                br.License_Number__c = '000000';
            } else {
                br.License_Number__c = acc.Contractors_License__c;
            }
            br.Country__c = acc.billingCountry;
            br.State__c = acc.billingstate;
            br.External1__c = br.Account__c + br.Name + br.License_Number__c;
            businessRegs.add(br);
        }
        if(!businessRegs.isEmpty())
            //upsert businessRegs External1__c;
        insert businessRegs;
    }
    
    //geoencode (from Account trigger ln. 111-140) called from AccountAfterInsertHandler and AccountAfterUpdateHandler
    public static List<Account> runGeoCodeFromTrigger(List<Account> accountsToGeoCode) {
        System.debug(LoggingLevel.ERROR,'-----------GeocodeAsyncHandler.scheduleBatch'+GeocodeAsyncHandler.scheduleBatch);
        if(GeocodeAsyncHandler.scheduleBatch) {
         System.debug(LoggingLevel.ERROR,'-----------accountsToGeoCode.size()'+accountsToGeoCode.size());
            if(accountsToGeoCode.size() == 1 && firedGeoCallout == false) {
                Account acc = accountsToGeoCode[0];
                String cleanAddress = GeocodeAsyncHandler.cleanAddress(acc.BillingStreet, acc.BillingCity, acc.BillingState, acc.BillingPostalCode, acc.BillingCountry);
                System.debug(LoggingLevel.ERROR,'-----------GeocodeAsyncHandler.futureGeoCode');
                GeocodeAsyncHandler.futureGeoCode(cleanAddress, acc.Id, 'Geolocation__c');
                firedGeoCallout = true;
                
            } else {
                if(firedGeoCallout == false) {
                    String ClassId = [Select Id, Name From ApexClass where Name = 'Batch_Geocode'].Id;
                    AsyncApexJob[] openJobs = [Select Id From AsyncApexJob where ApexClassId =: ClassId and Status in ('Queued', 'Processing') and JobType!='BatchApexWorker'];
                    
                    if (openJobs.size() == 0) {
                        Batch_Geocode startGeocoding = new Batch_Geocode('Account');
                        Database.executeBatch(startGeocoding, 1);
                        firedGeoCallout = true;
                    }
                }
            }
        } //end geocode
        return null;
    }
    
    public static void sendEmailForTaskCreation(List<Task> listTasks, Map<Id, Account> accsForTasks){
     // try{
            List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        List<Id> accountIds = new List<id>();
        for(Task tsk: listTasks){
            accountIds.add(tsk.WhatId);
        }
        
        Map<Id, Account> acctDetailMap = accsForTasks;
        List<String> toAusAddress = New List<String>();
       /* toAusAddress.add(Hardcoded__c.getValues('EmailForAccountTaskCreation').Email__c);
        toAusAddress.add(Hardcoded__c.getValues('EmailForAccountTaskCreation1').Email__c);
        toAusAddress.add(Hardcoded__c.getValues('EmailForAccountTaskCreation2').Email__c); */
        
        /***
        KCM_03142016: commented out hardcoded email addresses and replaced by custom setting
        toAusAddress.add('Christian.Manriza@sunpowercorp.com');
        toAusAddress.add('ma.cristina.pancho@sunpowercorp.com');
        toAusAddress.add('carlanoelle.perfecto@sunpowercorp.com'); 
        ***/
        
        /***
        KCM_03142016: this next code segment replaces the hardcoded values above.
                      loop through the custom setting and add to toAusAddress anything
                      that is identified as 'toAusOracleTask' and flagged Active.
        ***/
        for (Recipients_List_Account_Notifications__c rlan:csRecipients_map.values()){
            if(rlan.toAusOracleTask__c && rlan.active__c) {
                toAusAddress.add(rlan.email_address__c);
            }
        }
        
        list<string> toAddress = new list<String>();

        /*toAddress.add(Hardcoded__c.getValues('EmailForAccountTaskCreation').Email__c);
        toAddress.add(Hardcoded__c.getValues('EmailForAccountTaskCreation3').Email__c); */

        /***
        KCM_03142016: commented out the following hardcoded values and replaced with custom setting
        toAddress.add('Christian.Manriza@sunpowercorp.com');
        toAddress.add('SunpowerEUPSRSupervisor@sunpowercorp.com');
        ***/
        
        /***
        KCM_03142016: this next code segment replaces the hardcoded values above.
                      loop through the custom setting and add to toAddress anything
                      that is identified as 'toOracleTask' and flagged Active.
        ***/
        for (Recipients_List_Account_Notifications__c rlan:csRecipients_map.values()){
            if(rlan.toOracleTask__c && rlan.active__c) {
                toAddress.add(rlan.email_address__c);
            }
        }
        
        String taskUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        if(listTasks != null && listTasks.size()>0){            
            for(Task tsk:listTasks){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                if(acctDetailMap.get(tsk.WhatId).Country_Domain__c == 'cvar-au' || acctDetailMap.get(tsk.WhatId).Country_Domain__c == 'combo-au' || acctDetailMap.get(tsk.WhatId).Country_Domain__c == 'rvar-au'){
                    mail.setSubject('Please be informed that a task has been assigned to "Carla Noelle Perfecto"');
                    mail.setToAddresses(toAusAddress);
                    mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+'/'+tsk.Id+'>'+tsk.Id+'</a>  to create the Oracle Account for '+acctDetailMap.get(tsk.WhatId).name+' has been assigned to Carla Perfecto.<br> Thanks.');
                }else{
                    mail.setSubject('Oracle Account Task Created');
                    mail.setToAddresses(toAddress);
                    mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+'/'+tsk.Id+'>'+tsk.Id+'</a>  to create the Oracle Account for '+acctDetailMap.get(tsk.WhatId).name+' has been assigned to '+acctDetailMap.get(tsk.WhatId).Primary_PSR__r.name+'.<br> Thanks,<br> Partner Experience.');
                }           
                mail.saveAsActivity=false;
                emailMessages.add(mail);       
            }
        }
        if(emailMessages.size()>0){
            //Uncomment this when moved to production
            Messaging.sendEmail(emailMessages);
        }   
    //  } catch(Exception e){
    //      System.debug(e);
    // }  
            
    }
    
    //Account fields from AccountManagement.afterAccountInsert, setAccountNumber() ln.325-410
    //SIC Fields moved to BeforeInsert out of this method
    public static Account setAccountFields(Account a){
        String finalFieldValue;
        Account acc = a;
        //Account acc = a.clone(true, true, true, true);
        String accIdString = acc.Id;
        //system.debug(acc.Id + 'NEW ACCOUNT ID!');
        
        System.debug('RECORDTYPEID*****: '+acc.RecordTypeId+a.RecordTypeId);
        if(acc.RecordTypeId == PartnerRecTypeId) {
            acc.AccountNumber = 'P' + accIdString.subString(accIdString.length() - 8).toUpperCase();
            finalFieldValue = acc.AccountNumber;
            if(acc.Integration_ID__c == null || acc.Integration_ID__c == '') {
                acc.Integration_ID__c = finalFieldValue;
            }
            if(acc.ACBParanet_ID__c == null || acc.ACBParanet_ID__c == '') {
                    acc.ACBParanet_ID__c = acc.Integration_ID__c;
            }
        }
        if(ResidentialRecTypeId == acc.RecordTypeId) {
            acc.AccountNumber = 'C' + accIdString.subString(accIdString.length() - 8).toUpperCase();
            finalFieldValue = acc.AccountNumber;
            if(acc.Integration_ID__c == null || acc.Integration_ID__c == '') {
                acc.Integration_ID__c = finalFieldValue;
            }
            if(acc.ACBParanet_ID__c == null || acc.ACBParanet_ID__c == '') {
                acc.ACBParanet_ID__c = acc.Integration_ID__c;
            }
        }      
        return acc;
    }

    // method that will be called for which sales tax needs to be updated by making API call
    public static void updateSalesTax(Set<Id> accountIds){
        List<Account> accountListToBeUpdated = new List<Account>();
        for(Account acc : [select id,Sales_Tax_Rate__c,BillingStreet,BillingCity,BillingState,BillingPostalCode from Account where ID IN :accountIds]){
            acc.Sales_Tax_Rate__c = SalesTaxRateAPICall.retrieveSalesTax(acc.BillingStreet,acc.BillingCity, acc.BillingState, acc.BillingPostalCode,acc.Id);
            if(acc.Sales_Tax_Rate__c != null)
              accountListToBeUpdated.add(acc);
        }
        spectrumDebugList = SalesTaxRateAPICall.spectrumDebugList;
        exceptionLogList = SalesTaxRateAPICall.exceptionLogList;
        Sunpower_Spectrum_Debug_Log__c debugLog;
        try{
            if(!accountListToBeUpdated.isEmpty()){
              List<Database.SaveResult> SaveResultList = Database.update(accountListToBeUpdated,false);
                for(Database.SaveResult sr : saveResultList){
                    if(!sr.isSuccess()){
                         debugLog = new Sunpower_Spectrum_Debug_Log__c();
                         String errorMsg = '';
                       String errorCds = '';
                         for(Database.Error error : sr.getErrors()) {
                             errorMsg += error.getMessage();
                             errorCds += error.getStatusCode();
                         }
                         debugLog.Response__c = errorMsg + ' ' + errorCds;
                         debugLog.Account__c = sr.getId();
                         debugLog.Service__c = 'SalesTaxRateUpdate';
                         spectrumDebugList.add(debugLog);   
                    }                     
                }   
          }
        }
        catch(Exception e){
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString());
        }
        try{
            if(!spectrumDebugList.isEmpty())
              insert spectrumDebugList;
            if(!exceptionLogList.isEmpty())
              insert exceptionLogList;
        }
        catch(Exception ex){
            system.debug('Error is '+ex.getMessage()+ ' and stack trace is '+ex.getStackTraceString());
        }
    }
  /*
     @Name        :  updatePrimaryPSREmail
     @description : function to update primary PSR on related Lease Payment records
     @parameters  :  List<Id> of accounts
     @returns     :  None
   */
  public static void updatePrimaryPSREmail(Map<Id,Account> accToUpdatePSREmail){
         List<LeasePayment__c> lpToUpdate = new List<LeasePayment__c>();
         try{
               for(Account acc : [select Id,Primary_PSR__r.Email,(select id,PSR_Email__c from Leases1__r) from Account where Id IN : accToUpdatePSREmail.keyset()]){
                  for(LeasePayment__c lp : acc.Leases1__r){
                        lp.PSR_Email__c = acc.Primary_PSR__r.Email;
                        lpToUpdate.add(lp);
                 }
               }
             Database.SaveResult[] srList = Database.update(lpToUpdate, false) ;
             for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                   // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        accToUpdatePSREmail.get(sr.getId()).addError('PSR on related Lease can not updated because' + err.getMessage());
                    }
                }
             }
          }
          catch(Exception E){
                system.debug('--' + E.getMessage() + E.getLineNumber() + E.getCause());
          }
    }
}