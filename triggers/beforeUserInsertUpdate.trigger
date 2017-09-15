/**************************************************
Backup On 9/21/2012
Author : Appirio (Prakash G.)
Ref:- PR-2030
Date:-20- June -2009
Purpose:- 
// 1- If the user is a partner user then lookup the account object for this partner user. Retrieve the Account.Country_Domain__c field from the partner Account. Set the user.Country_Domain__c field to the same value as the account. This should only be done for partner users. We should not update this field if the user is not a partner user.
// 2- Update the user.LocaleSidKey and user.LanguageLocaleKey so that it matches the language for the specified User.Country_Domain__c field. Use the following mapping from the User.Country_Domain__c field to the User.Locale and User.Language. This should be done for all users not just partner users.
//Country_Domain , LocaleSid , LanguageKey
rvar-us en_US en_US
rvar-es es es
rvar-fr fr fr
rvar-it it it
rvar-de de de
cvar-us en_US en_US
cvar-es es es
cvar-fr fr fr
cvar-it it it
cvar-de de de
combo-us en_US en_US
combo-es es es
combo-fr fr fr
combo-it it it
combo-de de de
//...................................
----------------
VERSION HISTORY:
----------------
Version Name: Case# 00149047 - 3 new country domains:combo-rl,rvar-rl,cvar-rl
Author: unknown
Last Modified Date/Time: unknown
Version Details:
    1. Made changes in these functions- fetchLanguageLocaleKey(),fetchLocaleSidKey(),fetchUserCurrency()


Version Name: KCM_09.14.2015 (items specific to this version will have this tag on the comments)
Author: Kane Chelster M. Macaspac
Last Modified Date/Time: 09/14/2015 05:02 PM PDT
Version Details:
    1. converted the functionality of the following functions:
        -fetchLanguageLocaleKey()
        -fetchLocaleSidKey()
        -fetchUserCurrency()
       ...from a nested if-else statement into a for-loop that utilizes a custom setting called UserCountryDomain.

       This change should allow for a more dynamic and easier management of the list of country domains for end-users 
       and eliminates the need to submit code changes for approval for deployment in the future as the country domains are
       no longer hardcoded into this trigger.
**************************************************/


trigger beforeUserInsertUpdate on User (before Insert,before Update) {
    if(util.isSkipTrigger()){
        return;
    }
    
    //KCM_09.14.2015: find all the UserCountryDomain values in the custom setting
    Map<String, Account_Country_Domains__c> userCountryDomain_setting = Account_Country_Domains__c.getAll();
    
    //Call on update
    if(Trigger.isInsert){
        UserManagement.beforeUserInsert(Trigger.New);
    }
    
    //Start 00112468
    if(Trigger.isUpdate){
        UserManagement.beforeUserUpdate(Trigger.New, Trigger.oldMap);
    }
    //End 00112468
    
    //Fetch Partner users
    List<User> partnerUsers =new List<User>();
    
    //Fetch all users
    List<User> lstAllUsers = new List<User>();
       
    // Fetch Contact and Account ID
    Set<ID> contactIDs = new Set<ID>();
    
    //Fetch contact Ids
    Set<Id> setAllContactIds = new Set<Id>(); 
    
    for(User u : Trigger.new){
      if(u.contactId != null){
        lstAllUsers.add(u);
        setAllContactIds.add(u.contactId);
      }
      if(u.usertype == 'PowerPartner' && u.contactId != null){
            partnerUsers.add(u);            
            contactIDs.add(u.contactID);
      }
    }
    //populate UserContactRole 
    if(lstAllUsers.size() > 0 && setAllContactIds.size() > 0){
      List<AccountContactRole> lstAccountContactRole = new List<AccountContactRole>();
      Map<Id, AccountContactRole> mapAccountContactRole = new Map<Id, AccountContactRole>();
      
      //get all AccountContactRole records having contact ids already fetched
      lstAccountContactRole = [select Id, ContactId, Role from AccountContactRole where ContactId in :setAllContactIds];
      
      //put all records in map with contactId as key
      for(AccountContactRole obj : lstAccountContactRole){
        mapAccountContactRole.put(obj.ContactId, obj);
      }
      
      //for all users populate UserContactRole field
      for(User userObj : lstAllUsers){
        if(mapAccountContactRole.containsKey(userObj.ContactId)){
          userObj.UserContactRole__c = mapAccountContactRole.get(userObj.ContactId).Role;
        }
      }
    }
    //end update
    //Partner users Found
    Map<ID,Contact> contacts = null;
    if(partnerUsers.size()>0)
        contacts = new Map<Id,Contact>([select ID,Account.Country_Domain__c,AccountId from Contact where id in :contactIDs]);
                
        for(User u:Trigger.New){
            //For Partner USers only 
            if(u.userType == 'PowerPartner' && u.contactId != null){
                if(contacts != null && contacts.get(u.contactId).Account.Country_Domain__c != null){
                    u.Country_Domain__c = contacts.get(u.contactId).Account.Country_Domain__c;
                }
             }
            //For only Partner Users.  SunPower Internal users should see English. 
            if(u.Country_Domain__c != null && u.usertype == 'PowerPartner'){
                String oldLocale =u.LanguageLocaleKey;
                String oldSid =u.LocaleSidKey;
                
                String newLanguageLocaleKey = fetchLanguageLocaleKey(u);
                if (newLanguageLocaleKey != null && newLanguageLocaleKey != '') {
                    u.LanguageLocaleKey = newLanguageLocaleKey;
                }
                String newLocaleSidKey = fetchLocaleSidKey(u);
                if (newLocaleSidKey != null && newLocaleSidKey != '') {
                    u.LocaleSidKey = newLocaleSidKey;
                }
                
                //Here code starts for Currency
                System.debug('Here the Currency before::'+ u.CurrencyIsoCode);
                String newCurrency = fetchUserCurrency(u.Country_Domain__c);
                System.debug('Here the Currency by function::'+newCurrency);
                if(newCurrency != null && newCurrency != ''){
                    u.CurrencyIsoCode = newCurrency;
                    u.DefaultCurrencyIsoCode = newCurrency;
                }
                //Here code ends for Currency
                System.debug('Here the Currency after::'+u.CurrencyIsoCode);
                if(u.LanguageLocaleKey  =='') u.LanguageLocaleKey =oldLocale; 
                if(u.LocaleSidKey =='') u.LocaleSidKey = oldSid ;
            }
         }
//....................................
// 1-(Ends) If the user is a partner user then lookup the account object for this partner user. Retrieve the Account.Country_Domain__c field from the partner Account. Set the user.Country_Domain__c field to the same value as the account. This should only be done for partner users. We should not update this field if the user is not a partner user.
//...................................

    public String fetchLanguageLocaleKey(User usr){
 
         String countryDomain = usr.Country_Domain__c;                  
         
         //KCM_09.14.2015: start of FOR-LOOP; compare user record's countrydomain with the values in the custom setting
         //return the corresponding language if a match is found
         /* special case for the following:
             cvar-be
             rvar-be
             combo-be
             
             Check if language is either French or Dutch.  
             If not, throw error prompting user to choose either of the two said values.
             
             Check with Rej regarding nl_NL and en_US part of the original condition...
         */         
         for(String ucd: userCountryDomain_setting.keySet()) {
              if(countryDomain.trim().tolowercase().equals(ucd)) {
                  //KCM_09.14.2015: if there is only one language locale key listed in the custom setting
                  if (!userCountryDomain_setting.get(ucd).language_locale_key1__c.contains(',')) {
                      return userCountryDomain_setting.get(ucd).language_locale_key1__c;
                  }
                  //KCM_09.14.2015: if there is more than one language locale key listed in the custom setting 
                  else {
                      //KCM_09.14.2015: if a match is found, return the value for usr.languagelocalekey
                      if (userCountryDomain_setting.get(ucd).language_locale_key1__c.contains(usr.languagelocalekey)) {
                          return usr.languagelocalekey;
                      } 
                      //KCM_09.14.2015: otherwise, throw the error below...
                      else 
                      {                                                                                      
                          usr.LanguageLocaleKey.addError('Language for country domain ' + ucd + ' should be ' + 
                                                         userCountryDomain_setting.get(ucd).language_locale_key1__c);
                      }
                  }
             }
         } //KCM_09.14.2015: end of FOR-LOOP
         
         /* KCM_09.14.2015: Commented out original code and replaced by the one directly above
         if(contrydomain.trim().tolowercase().equals('rvar-us'))
             return 'en_us';
         else if(contrydomain.trim().tolowercase().equals('rvar-es'))
             return 'es';    
         else if(contrydomain.trim().tolowercase().equals('rvar-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('rvar-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('rvar-de'))
             return 'de';    
          else if(contrydomain.trim().tolowercase().equals('cvar-us'))
             return 'en_US';    
          else if(contrydomain.trim().tolowercase().equals('cvar-es'))
             return 'es';    
          else if(contrydomain.trim().tolowercase().equals('cvar-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('cvar-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('cvar-de'))
                 return 'de';   
          else if(contrydomain.trim().tolowercase().equals('combo-us'))
             return 'en_US';    
          else if(contrydomain.trim().tolowercase().equals('combo-es'))
             return 'es';    
          else if(contrydomain.trim().tolowercase().equals('combo-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('combo-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('combo-de'))
                 return 'de';
          //Start for Case#00073912
          else if(contrydomain.trim().tolowercase().equals('rvar-uk') 
                || contrydomain.trim().tolowercase().equals('cvar-uk') 
                || contrydomain.trim().tolowercase().equals('combo-uk'))
             return 'en_us';          
          //End for Case#00073912
          //Start 00105774
          else if(contrydomain.trim().tolowercase().equals('rvar-au')
             || contrydomain.trim().tolowercase().equals('cvar-au')
             || contrydomain.trim().tolowercase().equals('combo-au'))
             return 'en_us';
          //End 00105774
          //Start for Case#00149047-09/21/2012-Amit Saha
          else if(contrydomain.trim().tolowercase().equals('rvar-rl') 
                || contrydomain.trim().tolowercase().equals('cvar-rl') 
                || contrydomain.trim().tolowercase().equals('combo-rl'))
             return 'fr_BE'; // Updated to fr_BE FROM en_GB
          //End for Case#0014904          
          // Added for Case 00050644
          else if (contrydomain.trim().tolowercase().contains('-be') && usr.LanguageLocaleKey != 'fr' && usr.LanguageLocaleKey != 'nl_NL' && usr.LanguageLocaleKey != 'en_us') //MAM 26.MAR.2015 added && usr.LanguageLocaleKey != 'en_us' for case 00484705
             usr.LanguageLocaleKey.addError('Language of Belgium portal user should be French or Dutch.');             
          //KCM_09.14.2015: end of commented out code
          */
      
      return '';
    }

    public  String fetchLocaleSidKey (User usr){
        String countrydomain = usr.Country_Domain__c;
        
        //KCM_09.14.2015: start of FOR-LOOP; compare user record's countrydomain with the values in the custom setting
        //return the corresponding localesidkey if a match is found
        /* special case for the following:
             cvar-be
             rvar-be
             combo-be
             
             Check if locale is either French (Belgium) or Dutch (Belgium).  
             If not, throw error prompting user to choose either of the two said values.
         */ 
        for(String ucd: userCountryDomain_setting.keySet()) {
            if(countryDomain.trim().tolowercase().equals(ucd)) {
                //KCM_09.14.2015: if there is only one locale sid key listed in the custom setting
                if (!userCountryDomain_setting.get(ucd).locale_sid_key1__c.contains(',')) {
                      return userCountryDomain_setting.get(ucd).locale_sid_key1__c;
                } 
                //KCM_09.14.2015: if there is more than one locale sid key listed in the custom setting
                else {
                    //KCM_09.14.2015: if a match is found, return the user record's locale sid key
                    if (userCountryDomain_setting.get(ucd).locale_sid_key1__c.contains(usr.LocaleSIDKey)) {
                        return usr.LocaleSIDKey;
                    } 
                    //KCM_09.14.2015: otherwise, throw the error below...
                    else {
                        usr.LocaleSIDKey.addError('Language for country domain ' + ucd + ' should be ' + 
                                                  userCountryDomain_setting.get(ucd).locale_sid_key1__c);
                    }
                }
            }
        } //KCM_09.14.2015: end of FOR-LOOP

        /*   //KCM_09.14.2015: commented out original code and replaced with the one directly above
         if(contrydomain.trim().tolowercase().equals('rvar-us'))
             return 'en_us';
         else if(contrydomain.trim().tolowercase().equals('rvar-es'))
             return 'es';    
         else if(contrydomain.trim().tolowercase().equals('rvar-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('rvar-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('rvar-de'))
             return 'de';    
          else if(contrydomain.trim().tolowercase().equals('cvar-us'))
             return 'en_US';    
          else if(contrydomain.trim().tolowercase().equals('cvar-es'))
             return 'es';    
          else if(contrydomain.trim().tolowercase().equals('cvar-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('cvar-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('cvar-de'))
             return 'de';   
          else if(contrydomain.trim().tolowercase().equals('combo-us'))
             return 'en_US';    
          else if(contrydomain.trim().tolowercase().equals('combo-es'))
             return 'es';    
          else if(contrydomain.trim().tolowercase().equals('combo-fr'))
             return 'fr';    
          else if(contrydomain.trim().tolowercase().equals('combo-it'))
             return 'it';    
          else if(contrydomain.trim().tolowercase().equals('combo-de'))
             return 'de'; 
          //Start for Case#00073912
          else if(contrydomain.trim().tolowercase().equals('rvar-uk') 
                || contrydomain.trim().tolowercase().equals('cvar-uk') 
                || contrydomain.trim().tolowercase().equals('combo-uk'))
             return 'en_GB';
          //End for Case#00073912
          // Added for Case 00050644
          //Start 00105774
          else if(contrydomain.trim().tolowercase().equals('rvar-au')
             || contrydomain.trim().tolowercase().equals('cvar-au')
             || contrydomain.trim().tolowercase().equals('combo-au'))
             return 'en_au';
          //Start for Case#00149047-09/21/2012-Amit Saha
          else if(contrydomain.trim().tolowercase().equals('rvar-rl') 
                || contrydomain.trim().tolowercase().equals('cvar-rl') 
                || contrydomain.trim().tolowercase().equals('combo-rl'))
             return 'fr_BE';
             
          //End for Case#00149047            
          // Added for Case 00050644
          else if (contrydomain.trim().tolowercase().contains('-be') && usr.LocaleSidKey != 'fr_BE' && usr.LocaleSidKey != 'nl_BE')
             usr.LocaleSidKey.addError('Locale of Belgium portal user should be French (Belgium) or Dutch (Belgium).');
        //KCM_09.14.2015: end of commented out code
        */
        
          return '';
    }  
     
    /*  Here the function for populating Currency starts
        PR:- PR-02814
        Author:- Prakash 
    */
    public String fetchUserCurrency(String countrydomain){        
        //KCM_09.14.2015: start of FOR-LOOP; compare user record's countrydomain with the values in the custom setting
        //return the corresponding currency if a match is found
        for(String ucd: userCountryDomain_setting.keySet()) {
            if(countryDomain.trim().tolowercase().equals(ucd)) {
                return userCountryDomain_setting.get(ucd).currency_code__c;
            }
        } //KCM_09.14.2015: end of FOR-LOOP
    
      /*
      if(contrydomain.trim().tolowercase().equals('rvar-us') || contrydomain.trim().tolowercase().equals('cvar-us') || contrydomain.trim().tolowercase().equals('combo-us'))
           return 'USD';
      else if(contrydomain.trim().tolowercase().equals('cvar-it') || contrydomain.trim().tolowercase().equals('rvar-it') || contrydomain.trim().tolowercase().equals('combo-it') || 
                    contrydomain.trim().tolowercase().equals('cvar-de') || contrydomain.trim().tolowercase().equals('rvar-de') || contrydomain.trim().tolowercase().equals('combo-de') || 
                    contrydomain.trim().tolowercase().equals('cvar-es') || contrydomain.trim().tolowercase().equals('rvar-es') || contrydomain.trim().tolowercase().equals('combo-es') ||
                    contrydomain.trim().tolowercase().equals('cvar-fr') || contrydomain.trim().tolowercase().equals('rvar-fr') || contrydomain.trim().tolowercase().equals('combo-fr') ||//added for case # 00060471
                    //Added for Sunpower case 00050644
                    contrydomain.trim().tolowercase().equals('cvar-be') || contrydomain.trim().tolowercase().equals('rvar-be') || contrydomain.trim().tolowercase().equals('combo-be') || 
                    //Added for Sunpower case Case#00149047-09/21/2012-Amit Saha
                    contrydomain.trim().tolowercase().equals('cvar-rl') || contrydomain.trim().tolowercase().equals('rvar-rl') || contrydomain.trim().tolowercase().equals('combo-rl'))                 
             return 'EUR';
        else if(contrydomain.trim().tolowercase().equals('cvar-uk') || contrydomain.trim().tolowercase().equals('rvar-uk') || contrydomain.trim().tolowercase().equals('combo-uk'))//for Case#00073912
             return 'GBP';     
        //Start 00105774
        else if(contrydomain.trim().tolowercase().equals('rvar-au') || contrydomain.trim().tolowercase().equals('cvar-au') || contrydomain.trim().tolowercase().equals('combo-au'))
             return 'AUD';
        //End 00105774
        */
        
        // By default return USD
        return 'USD';    
    }            
}