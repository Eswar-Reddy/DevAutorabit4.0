/*
Modifications : 1-Jul-2014 : Birlasoft : Uncommented the Country Domain Updation code for Australia

version: KCM_03142016
author: Kane Chelster Macaspac
last modified date/time: 03-14-2016 9:46PM Pacific
description:
1. removed hardcoded email addresses from the code and replaced them with a custom setting called 
   'Recipients List (Account Notifications)' so that changes to the list in the future can be managed better and faster.
2. a fix to the problem reported in case 00666261
3. please use the version name above as a search term in order to jump to the parts of the code specific to this version.
   These can be, but not limited to, lines of codes that already exist prior to this change but have been commented out since 
   they are being replaced entirely, newly introduced lines of codes, or changes to existing ones.
*/

public class AccountManagement {

    //created by sreekanth
   // public static List<RecordType> accRecordTypeList  = new List<RecordType> ([Select Id ,Name from RecordType where  sobjectType='Account']);
   /*   
   Case # 00073912 - Amit Saha - 09-21-02012 for  New country Domains  combo-rl,rvar-rl and cvar-rl
   Added the new country domain in the condition @ lines 803,836,1010
   */
   /***************** Birlasoft Rashmi ****************************/
    public static String strAcc = 'Account';
    public static List<RecordType> accRecordTypeList  = GW_RecTypes.getRecordTypeforSelectedObject(strAcc);    
    /***************** End *******************************************/
  //  static List<User> notificationUserlst = [select id from user where name ='Tom Dowley'];    
  //  static String notificationUserid = notificationUserlst.get(0).Id;
  
    //KCM_03142016: static variable to contain the custom setting values needed 
    private static Map<String, Recipients_List_Account_Notifications__c> csRecipients_map = Recipients_List_Account_Notifications__c.getAll();
  
    public static void beforeAccountInsert (List<Account> accountList){
        
        setAccountFields(accountList); 
        setCommercialAccountFields(accountList);  
        setRSMName(accountList);
        // Done for case # 00063008
        setCSATCycleCode(accountList , null);
    }    
    

    public static void beforeAccountUpdate (List<Account> accountList, 
        List<Account> oldAccountList , Map<Id,Account> oldAccountMap){
        setAccountFields(accountList);
        setRSMName(accountList);
        setOnlineOrderAccessDates(accountList);//for case # 00058232
        // Done for case # 00063008
        setCSATCycleCode(accountList , oldAccountMap);
    }
    
    public static void afterAccountInsert (List<Account> accountList)
    {
        //To update Account Nuumber(if blank) according to recordID and record type 
        setAccountNumber(accountList);
        String createContactProfile = Label.CreateContactProfile;
        ID profileid = UserInfo.getProfileId();
        if(createContactProfile.contains(profileid))
            createContact(accountList);
    }
     public static void createContact (List<Account> accountList)
    {
        list<Contact> listContact = new list<Contact>();
        for(Account objAccount : accountList){
            Contact objContact = new Contact();
            objContact.AccountId = objAccount.id;
            objContact.LastName = objAccount.name;
            objContact.Fax = objAccount.fax;
            objContact.Email = objAccount.Email__c;
            objContact.Phone = objAccount.Phone;
            objContact.HomePhone = objAccount.PersonHomePhone;
            /*
            objContact.MailingStreet = objAccount.ShippingStreet;
            objContact.MailingCity = objAccount.ShippingCity;
            objContact.MailingState = objAccount.ShippingState;
            objContact.MailingCountry = objAccount.ShippingCountry;
            objContact.MailingPostalCode = objAccount.ShippingPostalCode;
            */
            
            objContact.MailingStreet = objAccount.BillingStreet;
            objContact.MailingCity = objAccount.BillingCity;
            objContact.MailingState = objAccount.BillingState;
            objContact.MailingCountry = objAccount.BillingCountry;
            objContact.MailingPostalCode = objAccount.BillingPostalCode;
            
            
            
            listContact.add(objContact);
        }
        if(!listContact.isEmpty())
            insert listContact;
    }

    public static void afterAccountUpdate (List<Account> accountList, 
        List<Account> oldAccountList)
    {
        /* remove all certifications for a terminated account */
        processTerminatedAccount(accountList);
        ///createTaskOnOracleNoStatusChange(accountList,oldAccountList);  //Commented for Case#233049 and moved to Workflows (PartnerPortal&OnlineOrder-AU, PartnerPortal-OnlineOrder-SmartStore-ItDeFr, PartnerPortal&OnlineOrder-BeEsUkRl)
        createTaskOnAccountStatusChange(accountList,oldAccountList);
        
            
        //create a valid accounts for which we have to create opportunity share
        //valid account means for which status is changed from "Contract Pending" to "Active"
        //createValidAccountsMap(accountList, oldAccountList);
    }   
    
    public static void setAccountFields(List<Account> accountList){                      
        
        List<String> countries = new List<String> ();
         
        Map<String,String> countryMap =  new Map<String,String> ();
                                      
        for(Account acct : accountList){   
                 
            /* Get all countries */
            if(acct.BillingCountry != null && !countryMap.containsKey(acct.BillingCountry)){              
                countries.add(acct.BillingCountry);
                countryMap.put(acct.BillingCountry, acct.BillingCountry);
            } 
                        
        }           
                        
        Map<String,String> countryTheaterMap = new Map<String,String> ();
           
        if(countries.size()>0){
            
            for(Country_Reference__c countryRef : [select Country__c, Theater__c 
                from Country_Reference__c where Country__c in : countries])
            {                    
                countryTheaterMap.put(countryRef.country__c, countryRef.theater__c);        
            }              

        }        
        
        for(Account acct : accountList){
        
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
          if(acct.Theater__c=='Australia' && acct.Type !=null)
          {
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
      }
                 
    }
    
      public static void setCommercialAccountFields(List<Account> accountList){
       // Commented by sreekanth
       //List<RecordType> recordTypeList =new List<RecordType> ([Select Id ,Name from RecordType where Name='Commercial Customer' and sobjectType='Account']);
       List<RecordType> recordTypeList = new List<RecordType>();
       
       // add with reference case : 00029642 by Appirio developer ( Lokesh)
       RecordType objcommercialAccountRecordType;
       RecordType objresidentialAccountRecordType;
       //
       
       if(accRecordTypeList.size() > 0){
         for(RecordType nextRecType :accRecordTypeList ){
          if(nextRecType.name =='Commercial Customer'){
              objcommercialAccountRecordType = nextRecType;
          }
          // Add residential record type in recordtype object.
          if (nextRecType.name =='Residential Customer') {
            objresidentialAccountRecordType = nextRecType;
          }
         }
        }
        Set<String> ownerIdSet = new Set<String>();
         
        List<User> userList = new List<User>([Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Id = :userInfo.getUserId() and Profile.Name like 'Partner%']);
        User currentUser;
        if(userList!=null && userList.size()>0){
            currentUser = userList.get(0);
        }
        if(currentUser!=null){
            for(Account account :accountList){
                if (objcommercialAccountRecordType != null && account.RecordTypeId == objcommercialAccountRecordType.Id) {
                    account.Status__c= 'Active';
                    account.CurrencyIsoCode = 'USD' ;
                    account.Theater__c = currentUser.Contact.Account.Theater__c;
                    account.Territory__c = currentUser.Contact.Account.Territory__c;
                }
                // set theater value if account recordtype is of residential type.
                else if (objresidentialAccountRecordType != null && account.RecordTypeId == objresidentialAccountRecordType.Id) {
                   account.Theater__c = currentUser.Contact.Account.Theater__c;
                }
            }
        }
    }


    public static void updateUserCountryDomain(Map<Id,Account> newMap,List<Account> accountList,
    Map<Id,Account> oldMap){
            
            List<User> lstUserToUpdate = new List<User>();
            List<User> lstUser = [Select id,name,Country_Domain__c,Contact.AccountId from user where Contact.AccountId in : newMap.keySet() and UserType = 'PowerPartner'];
            for(Account acc : accountList){
              if(acc.isPartner == true){
                if(acc.Country_Domain__c != oldMap.get(acc.id).Country_Domain__c){                
                   for(User usr : lstUser){
                     if(usr.Contact.AccountId == acc.id){ 
                       usr.Country_Domain__c = acc.Country_Domain__c;
                       lstUserToUpdate.add(usr);
                     }                
                   }
                 }
              } 
            }
            
            if(lstUserToUpdate.size() > 0)
            update lstUserToUpdate;
            
          
    }
    
    //Done for the case-00013120
    //Update country domain of all the Contacts of the Accounts coming for updation and set 
    //Contact's country domain same as their Account's country domain
    public static void updateContactCountryDomain(Map<Id,Account> newMap,List<Account> accountList,
    Map<Id,Account> oldMap){
            
            List<Contact> lstContactToUpdate = new List<Contact>();            
            for(Contact con:[Select id,name,Country_Domain__c,AccountID from Contact where AccountId in : newMap.keySet() and isPersonAccount=false]){
                if(newMap.containsKey(con.AccountID) && con.Country_Domain__c!=newMap.get(con.AccountID).Country_Domain__c){
                    con.Country_Domain__c = newMap.get(con.AccountID).Country_Domain__c;                    
                    lstContactToUpdate.Add(con);                    
                }
            }                       
            if(lstContactToUpdate.size() > 0)
                update lstContactToUpdate;  
    }
 
    private static void processTerminatedAccount(List<Account> lstAccounts){
        
      //if the account status is 'Terminated' 
      //delete all associated certifications
      
      Set<Id> setAccountIds = new Set<Id>();
      
      for(Account accountObj : lstAccounts){
        if(accountObj.Status__c == 'Terminated'){
          setAccountIds.add(accountObj.Id);                
        }
      }
      
      if(setAccountIds.size() == 0){
        return;
      }
      
      List<Certification__c> lstCertifications = new List<Certification__c>();
      lstCertifications = [select Id, Name from Certification__c 
        where Account__c in :setAccountIds];
      
      if(lstCertifications.size() > 0){
        delete lstCertifications;
      }          
    } 
    
    //To update Account Nuumber(if blank) according to recordID and record type 
    private static void setAccountNumber(List<Account> lstAccounts){
        //List of those Accounts which needs to be updated
        List<Account> lstAccToUpdate = new List<Account>();
         Set<String> accid = new Set<String>();
         List<SIC__c> sicList = new List<SIC__c>();
         Map<String,SIC__c> sicMap = new Map<String,SIC__c>();
        //Prepare map for recordtypeID with name of Account
        Map<String,String> mapRecIDRecName = new Map<String,String>();
        //Commented by sreekanth
        /*for(RecordType recType :[Select id,name from RecordType where sObjectType='Account']){
           mapRecIDRecName.put(recType.id,recType.name); 
           }*/
        if(accRecordTypeList.size() > 0){
        for(RecordType recType :accRecordTypeList ){
            mapRecIDRecName.put(recType.id,recType.name);
        }
        }
        // code to get the sic code for the account
        for(Account an : lstAccounts){
            accid.add(an.Sic);
        }
        sicList= [select Id,SIC_Code__c,First_Level__c,Second_Level__c,Third_Level__c,SPWR_Industry_Type__c from SIC__c where SIC_Code__c IN : accid];
        for(SIC__c s: sicList){
            sicMap.put(s.SIC_Code__c,s);
        }
    //Process through each record
        for(Account accountObj : lstAccounts){                        
            //To strore value for integrationID and AccountNumber
            String finalFieldValue = '';
            //Check if map exists for recordType
            if(mapRecIDRecName.containskey(accountObj.recordTypeID)){
                Account acc = new Account(ID=accountObj.ID);                
                String AccountID = accountObj.ID;                
                //If partner Record type
                if(mapRecIDRecName.get(accountObj.recordTypeID) == 'Partner'){
                    finalFieldValue = 'P' + AccountID.subString(AccountID.length()-8).toUpperCase();                    
                }
                //If customer Record type
                if(mapRecIDRecName.get(accountObj.recordTypeID) == 'Residential Customer' || mapRecIDRecName.get(accountObj.recordTypeID) == 'Commercial Customer'){
                    finalFieldValue = 'C' + AccountID.subString(AccountID.length()-8).toUpperCase();                    
                }
                //To check if any field value has been changed
                Boolean isChanged = false;
                //If AccountNumber is blank
                if(accountObj.AccountNumber==null || accountObj.AccountNumber==''){
                    acc.AccountNumber = finalFieldValue;
                    isChanged = true;                    
                }
                //If IntegrationID is blank
                if(accountObj.Integration_ID__c==null || accountObj.Integration_ID__c==''){
                    acc.Integration_ID__c = finalFieldValue;
                    isChanged = true;                    
                }
                                //If ACBParanet_ID is blank
                if(accountObj.ACBParanet_ID__c==null || accountObj.ACBParanet_ID__c==''){
                    acc.ACBParanet_ID__c = acc.Integration_ID__c;
                    isChanged = true;                     
                }

                if(accountObj.sic!=null){
                    SIC__c si = sicMap.get(accountObj.sic);
                    acc.First_Level_SIC_Name__c = si.First_Level__c; 
                    acc.Second_Level_SIC_Name__c = si.Second_Level__c;
                    acc.Third_Level_SIC_Name__c = si.Third_Level__c;     
                    acc.SPWR_Industry_Type__c = si.SPWR_Industry_Type__c;
                    isChanged = true;
                    
                }
                //if field value is changed, then add the record to the list to update
                if(isChanged){
                    lstAccToUpdate.add(acc);
                }
            }
            
            if (lstAccToUpdate.size()>=200){
                update lstAccToUpdate;
                lstAccToUpdate.clear();             
            }
        }
        
        //Update Accounts
        if (lstAccToUpdate.size()>0)
            update lstAccToUpdate;
    }

    
    public static void setRSMName(List<Account> accountList){
        
        Set<ID> rsmOwnerUsers = new Set<ID>();
        Set<ID> ownerIDs = new Set<ID>();

        Id partnerAccountRecordId = null;
        //Commented by sreekanth
        /*for(RecordType recType :[Select id from RecordType where sObjectType='Account' and name = 'Partner' limit 1]){
          partnerAccountRecordId = recType.Id;
         }*/
        
        if(accRecordTypeList.size() > 0){
        for(RecordType nextRecType:accRecordTypeList){
            if(nextRecType.name== 'Partner'){
                 partnerAccountRecordId = nextRecType.Id;
            }
        }
        }
       /* for(RecordType recType :
            [Select id from RecordType 
                where sObjectType='Account' and name = 'Partner' limit 1]){
                    
            partnerAccountRecordId = recType.Id;
        }*/
        

        if (partnerAccountRecordId==null)
            return;
        
        for(Account a:accountList){
            if(a.RSM__c == null)
                ownerIDs.add(a.ownerID);
        }
        
       
        
        //if RSM__c is not blank then return
        if(ownerIDs == null || ownerIDs.size() ==0) return;
        
        for(User u: 
            [select id,UserRole.Name,username from User 
                //where id in :ownerIDs and UserRole.Name = 'Regional Sales Manager']){
                /* Done for the case # 00050543 */
                where id in :ownerIDs and UserRole.Name LIKE '%Regional Sales Manager%']){
                    
            rsmOwnerUsers.add(u.id);
        }
        
        //if RSM owner users is not role of 'Regional Sales Manager' then return
        if(rsmOwnerUsers == null || rsmOwnerUsers.size() ==0) return;
        
        //Else set the value of RSM Owner
        for(Account a:accountList){
            if(a.RSM__c == null && rsmOwnerUsers.contains(a.ownerID))
                a.RSM__c = a.OwnerID;
        }
    }




    public static void SharePartnerAccount(Map<ID,Account> mapAccountOld,List<Account> lstAccountNew){
        //Preapare the set of those Account IDs whose owner has been changed        
        Set<String> setAccountID = new Set<String>();
        for(Account acc:lstAccountNew){
            Account accOld = mapAccountOld.get(acc.id);
            if(acc.ownerID!=accOld.ownerID && acc.isPartner){
                setAccountID.Add(acc.id);
            }
        }
        
        //Prepare the set of those Account which has at least one portal user       
        List<User> userList =new List<User>();
        for(List<Contact> conts:
            [Select id,partner_portal_user__c,partner_portal_user__r.id,
                partner_portal_user__r.Contact.Account.IsPartner,partner_portal_user__r.UserType,
                partner_portal_user__r.Contact.Account.ID,partner_portal_user__r.Contact.Account.Name 
                    from Contact 
                    where contact.AccountID in :setAccountID and partner_portal_user__c!=null]){            
                for(Contact cont:conts){
                    userList.Add(cont.partner_portal_user__r);
                }
        }
        
        //Call trigger if Account Owner has changed & account is a Partner account & there's at least 1 portal user associated with the partner account
        //For last two conditions, just check the list size because only partner account can have partner user and owner check has already been put
        if(userList.size() == 0){
            return;
        }
                
        List <AccountShare> accShares = new List<AccountShare>();
        boolean doUpdate = false;
        Map<String,ID> roleGrpMap = new Map<String,ID>();
        Map<ID,String> acctNames = new Map<ID,String>();
        //// get a map of account id and partner executive roles          
        for(User user:userList){
            if(user.Contact.Account.IsPartner && user.UserType == 'PowerPartner'){
                //acctNames.put(user.Contact.Account.ID, user.Contact.Account.Name + ' Partner Executive');//for case #00067176
                String accName = user.Contact.Account.Name.length() > 62? user.Contact.Account.Name.subString(0,62):user.Contact.Account.Name;//for case #00067176
                acctNames.put(user.Contact.Account.ID, accName + ' Partner Executive');//for case #00067176
            }
        }
        
        //Fetch related UserRoles
        Map<ID,UserRole> userRolesMap  = null;
            userRolesMap = new Map<ID,UserRole>
            ([select ID,Name from UserRole where Name in :acctNames.values() LIMIT 1000]);
        
        Map<String, AccountShare> accountSharesMap = new Map<String,AccountShare>();
        List<AccountShare> newShares = new List<AccountShare>();
        List<AccountShare> deletedShares = new List<AccountShare>();
        //Fetch related Group
        List<Group> grpList = [select ID,RelatedID from Group 
            where Type = 'RoleAndSubordinates' and relatedId in :userRolesMap.keySet()];
         
        //Fill Map with  Role Name and related Group Record 
        for(Group grp:grpList){
              UserRole uRole = (UserRole)userRolesMap.get(grp.relatedID);
              roleGrpMap.put(uRole.Name,grp.Id);
        }
        
        //Fill AccountSharesMap
        for(AccountShare share :[select ID,accountID,
            AccountAccessLevel,UserorGroupID,OpportunityAccessLevel 
            from AccountShare where UserorGroupID in :userRolesMap.keySet() and accountID != null]){
            String name= acctNames.get(share.accountID);
            if(name != null)
                accountSharesMap.put(name,share);
        }
        
        for(ID id:acctNames.keySet()){
               String acctName= acctNames.get(id);
               AccountShare accountShare = accountSharesMap.get(acctName);
               if(accountShare == null){
                   accountShare= new AccountShare();
                   accountShare.accountID= id;
                   accountShare.AccountAccessLevel ='Edit';
                   accountShare.UserorGroupID =roleGrpMap.get(acctName);
                   accountShare.OpportunityAccessLevel = 'None'; 
                   //accountShare.ContactAccessLevel = 'Edit';
                   newShares.add(accountShare);
                   accountSharesMap.put(acctName,accountShare);
               }else{
                    if(accountShare.AccountAccessLevel !='Edit' || accountShare.OpportunityAccessLevel !='Edit'){
                        deletedShares.add(accountShare);
                        doUpdate =true;
                        AccountShare accShare= new AccountShare();
                        accShare.accountID= id;
                        accShare.AccountAccessLevel ='Edit';
                        accShare.UserorGroupID =roleGrpMap.get(acctName);
                        accShare.OpportunityAccessLevel = 'None'; 
                        //accShare.ContactAccessLevel = 'Edit';
                        newShares.add(accShare);        
                    }
               } 
        }
        if(doUpdate && deletedShares.size()>0)
            delete deletedShares;
            
        //Update Here            
        if(newShares.size() >0){
           //insert newShares;
           newShares = removeDuplicates(newShares);
           if(newShares.size() >0)
                Database.insert(newShares,false);
        }      
        }//Function ends

        private static List<AccountShare>  removeDuplicates(List<AccountShare> accountShares){
            Set<String> existingShares = new Set<String>();
            List<AccountShare> filteredShares = new List<AccountShare>(); 
            String sep ='~';
            List<AccountShare> dups = new List<AccountShare>();
            for(AccountShare share :accountShares){
                System.debug('Here UserID::'+share.UserorGroupId+'::::AccountID:::'+share.AccountId);
                if(existingShares.contains(share.UserorGroupId+sep+share.AccountId)){
                    dups.add(share);
                }else{
                    existingShares.add(share.UserorGroupId+sep+share.AccountId);
                    filteredShares.add(share);
                }
            }

            return filteredShares;
        }
        
        //This function will create a list of valid accounts and create opportunity share for them.
        //valid means the accounts in the Trigger.New for which status is changed from "Contract Pending" to "Active"
/*        
        private static void  createValidAccountsMap(List<Account> accountList, List<Account> oldAccountList){
             //creating map of old account records
            Map<ID, Account> oldAccountsMap = new Map<ID, Account>();
            for(Account oldAcct : oldAccountList)
                oldAccountsMap.put(oldAcct.ID, oldAcct);
            //map of valid accounts for which status is changed from "Contract Pending" to "Active"
            Map<ID,Account> validNewAccounts = new Map<ID,Account>();
            //fill the valid new accounts map
            for(Account acct:accountList){
                if(acct.Status__c != null && oldAccountsMap.get(acct.ID).Status__c != null && acct.Status__c == 'Active' && oldAccountsMap.get(acct.ID).Status__c == 'Contract Pending')
                    validNewAccounts.put(acct.ID,acct);
            }
            //create opportunity share for valid accounts
            if(validNewAccounts.size() > 0)
                shareOpportunity(validNewAccounts);
        }//function ends
*/        
        //create opportunity sharing rule if the account status is going to be "Active" from "Contract Pending"             
        //newAccountsList - Map of corresponding new accounts for which status changed from "Contract Pending" to "Active"
        // 1) create the list of role names for partner user in the account
        // 2) fetch the user roles (map) from UserRole for the above list
        // 3) fetch the Groups for above map
        // 4) fetch the opportunities for the new accounts map and 
        //      create a mapping for each partner account and opportunities list
        // 5) fetch the already existing opportunity shares
        // 6) create the opportunity share for opportunities 
        //      after checking in the existing opportunity share map
        // 7) update the account's field "Allow_all_to_view_Opportunities__c" to true
/*      
        private static void shareOpportunity(Map<ID,Account> newAccountsMap){
            //set of account ids which needs to be updated
            Set<ID> accountsToBeUpdated = new Set<Id>();    
            //if there are no account in the coming map then return back
            if(newAccountsMap == null && newAccountsMap.size() <= 0)
                return ;
            //list of opportunity share to be inserted
            List<OpportunityShare> lstOppShareInsert = new List<OpportunityShare>();        
            //list of role names for Partner Users
            List<String> roleNameList = new List<String>();
            //for each account add the role name in the list
            for(Account acct:newAccountsMap.values()){              
                roleNameList.add(acct.Name + ' Partner User');
            }
            Map<ID,UserRole> userRoleMap  ;
            //fetch all userRoles for which Name is in the role name list
            userRoleMap = new Map<ID,UserRole>([select Id, Name from UserRole where Name IN : roleNameList]);
            //map of role name and group id
            Map<String,ID> acctIDGpID = new Map<String,ID>();
            //fetch group for userRole ids
            Map<Id,Group> groupMap = new Map<Id,Group>();
            for(Group gp : [select Id, Name,RelatedId from Group where RelatedId IN : userRoleMap.keyset()]){
                groupMap.put(gp.ID,gp);
                acctIDGpID.put(userRoleMap.get(gp.RelatedId).Name, gp.ID);              
            }
            //map of Account ids and corresponding opportunities
            Map<ID,List<Opportunity>> opportunityMap = new Map<ID,List<Opportunity>>();
            for(List<Opportunity> lstOpps : [select Id, Name,PartnerAccountId from Opportunity where PartnerAccountId IN :newAccountsMap.keySet()]){
                opportunityMap.put(lstOpps[0].PartnerAccountId,lstOpps);
            }
            //map of existing opportunity id and opportunity shares
            Map<ID,OpportunityShare> exisingOppSharesMap =new Map<ID,OpportunityShare>();
            for(OpportunityShare oppshare : [select Id, OpportunityId, UserOrGroupId from OpportunityShare  where OpportunityId IN :opportunityMap.keyset() and OpportunityAccessLevel = 'Edit'  and UserOrGroupId IN :groupMap.keyset()]){
                exisingOppSharesMap.put(oppshare.OpportunityId, oppshare);
            }
            //creating share rule if does not exist
            for(List<Opportunity> lstOpps:opportunityMap.values()){
                for(Opportunity oppObj : lstOpps){
                    //if sharing rule is not already exist
                    if(!exisingOppSharesMap.containsKey(oppObj.Id)){
                      //create sharing rule 
                      OpportunityShare oppShare = new OpportunityShare();
                      oppShare.OpportunityId = oppObj.Id;
                      oppShare.OpportunityAccessLevel = 'Edit';
                      //adding accounts in the set to be updated
                      accountsToBeUpdated.add(oppObj.PartnerAccountId);
                      if(oppObj.PartnerAccountId != null && newAccountsMap.containsKey(oppObj.PartnerAccountId) && acctIDGpID.containsKey(newAccountsMap.get(oppObj.PartnerAccountId).Name+' Partner User')){
                        oppShare.UserOrGroupId = (ID)(acctIDGpID.get(newAccountsMap.get(oppObj.PartnerAccountId).Name+' Partner User'));
                        //add in the list
                        lstOppShareInsert.add(oppShare);
                      } 
                    }
                }
            }
            // inserting opportunity shares
            if(lstOppShareInsert.size() > 0){               
                insert lstOppShareInsert;
             }
             //list of accounts which needs to be updated
             List<Account> acctListToUpdate  = new List<Account>();
             // fetching accounts which needs to be updated
             for(Account acct : [Select Id, Name,Allow_all_to_view_Opportunities__c from Account where Id IN:accountsToBeUpdated]){
                if(acct.Allow_all_to_view_Opportunities__c == false){
                    acct.Allow_all_to_view_Opportunities__c = true;
                    acctListToUpdate.add(acct);
                }   
             }
             //updating accounts
             if(acctListToUpdate.size() > 0)
                update acctListToUpdate;                        
    }//function ends
*/  

   
      public static Map<String,ID> getTaskRecordType(){
            /************************Getting the record types for task*****************************/
            Map<String,ID> taskRecordTypes = new Map<String,ID>();
            Set<String> objTypes = new Set<String>();
            objTypes.add('Task');
            
            Schema.DescribeSObjectResult da = Schema.SObjectType.Task;
            Map<Id,Schema.RecordTypeInfo> taskMapById = da.getRecordTypeInfosById();
            for(ID i:taskMapById.keySet()){
                taskRecordTypes.put(taskMapById.get(i).name,string.valueOf(i));
            }    
            return taskRecordTypes;
            /************************Getting the record types for task End*****************************/
      }
    public static Map<String,ID> getAccountRecordType(){
            /************************Getting the record types for account*****************************/
            Map<String,ID> AccountRecordTypes = new Map<String,ID>();
            Set<String> objTypes = new Set<String>();
            objTypes.add('Account');
            
            Schema.DescribeSObjectResult da = Schema.SObjectType.Account;
            Map<Id,Schema.RecordTypeInfo> accountMapById = da.getRecordTypeInfosById();
            for(ID i:accountMapById.keySet()){
                AccountRecordTypes.put(accountMapById.get(i).name,string.valueOf(i));
            }    
            return AccountRecordTypes;
            /************************Getting the record types for account End*****************************/
      }
    private static void  createTaskOnAccountStatusChange(List<Account> accountList, List<Account> oldAccountList){
             //creating map of old account records
            Map<ID, Account> oldAccountsMap = new Map<ID, Account>();
            for(Account oldAcct : oldAccountList){
                oldAccountsMap.put(oldAcct.ID, oldAcct);
            } 
            //map of valid accounts for which status is changed from "Contract Pending" to "Active"
            Map<ID,Account> validNewAccounts = new Map<ID,Account>();
            //fill the valid new accounts map
            Id accountRecordTypeId=getAccountRecordType().get('Partner');
            for(Account acct:accountList){              
                if(acct.RecordTypeId!= null && accountRecordTypeId!=null && accountRecordTypeId==acct.RecordTypeId){
                    if(acct.Status__c != null && oldAccountsMap.get(acct.ID).Status__c != null && acct.Status__c == 'Active' && oldAccountsMap.get(acct.ID).Status__c == 'Contract Pending'){
                        validNewAccounts.put(acct.ID,acct);
                    }
                }
            }
            
             List<Task> task = new List<Task>();
              if(validNewAccounts.size() > 0){
                //Start 00105774
                list<User> auTaskManager = new list<User>([select Id from User where Name = 'Carla Noelle Perfecto' limit 1]);
                Id userId;
                if(auTaskManager.size() > 0)
                     userId = auTaskManager.get(0).id;
                //End 00105774
                for(Account acct:validNewAccounts.values()){
                    task tsk = new Task();
                    tsk = new Task(
                    whatid=acct.Id,                    
                    ActivityDate= Date.today().addDays(2),
                    OwnerId=acct.Primary_PSR__c,
                    Subject= 'Create Oracle Account',
                    Description= 'Please create an Oracle account and include the account number on the Account page in SFDC. Also ensure that the Oracle Operating Unit is accurate. Thank You Partner Experience'
                    );
                if(acct.Country_Domain__c!='cvar-us' && acct.Country_Domain__c!='combo-us'&& acct.Country_Domain__c!='rvar-us'){
                    tsk.RecordTypeId = getTaskRecordType().get('On-boarding task');
                    tsk.IsReminderSet = true;       
                    tsk.CreatedById = UserInfo.getUserId();
                    tsk.Severity__c='P2 - Significant';                 
                }
                //Start 00105774
                if(acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c =='combo-au' || acct.Country_Domain__c =='rvar-au'){
                    tsk.OwnerId = userId;                    
                }
                //End 00105774
                    task.add(tsk);
                }
                 //insert task;
                  
                 Database.DMLOptions dlo = new Database.DMLOptions();
                 dlo.EmailHeader.triggerUserEmail = true;
                 database.insert(task, dlo);
                 sendEmailOnOracletaskCreation(task);
            }
              
        }//function ends
        
        
         private static void  createTaskOnOracleNoStatusChange(List<Account> accountList, List<Account> oldAccountList){
            
            /************************Getting the record types for task*****************************/
            Map<String,ID> taskRecordTypes = new Map<String,ID>();
            Set<String> objTypes = new Set<String>();
            objTypes.add('Task');
            
            Schema.DescribeSObjectResult da = Schema.SObjectType.Task;
            Map<Id,Schema.RecordTypeInfo> taskMapById = da.getRecordTypeInfosById();
            for(ID i:taskMapById.keySet()){
                taskRecordTypes.put(taskMapById.get(i).name,string.valueOf(i));
            }    
            /************************Getting the record types for task End*****************************/
             //creating map of old account records
            Map<ID, Account> oldAccountsMap = new Map<ID, Account>();
            for(Account oldAcct : oldAccountList){
                oldAccountsMap.put(oldAcct.ID, oldAcct);
            }
            //map of valid accounts for which status is changed from "Contract Pending" to "Active"
            Map<ID,Account> validNewAccounts = new Map<ID,Account>();
            Id accountRecordTypeId=getAccountRecordType().get('Partner');
            //fill the valid new accounts map
            for(Account acct:accountList){
                //if(acct.Oracle_Account_Number__c != null && oldAccountsMap.get(acct.ID).Status__c == null)
                if(acct.RecordTypeId!= null && accountRecordTypeId!=null && accountRecordTypeId==acct.RecordTypeId){
                    if(acct.Oracle_Account_Number__c != null && oldAccountsMap.get(acct.ID).Oracle_Account_Number__c == null){
                        validNewAccounts.put(acct.ID,acct);
                    }
                }
            }
            
             List<Task> task = new List<Task>();             
             Id userId=null;
              if(validNewAccounts.size() > 0){
                //Map<ID,User> mapPartnerAmbassador = new Map<ID,User>([select Id,Country_Domain__c from User where UserRole.name = 'Partner Ambassador']);//for Case#00080181
                //Start 00105774
                List<UserName__c> UserName = UserName__c.getAll().values(); // Case # 00222230 - Adding users to custom settings. 
                List<String> csName = new List<String>();
                for(UserName__c s:UserName)
                {
                    csName.add(s.Name);
                }
                list<User> euTaskManager = new list<User>([select Id from User where Name in :csName order by Name]);
                //list<User> euTaskManager = new list<User>([select Id from User where name ='Andrea Grimaldi']);
                //End 00105774
                
                //Map<ID,User> mapPartnerAmbassador = new Map<ID,User>();
                for(Account acct:validNewAccounts.values()){
                    //for case # 00047239 - closed by customer
                    //Start 00105774
                    //if(acct.BillingCountry!='Australia' && (acct.Country_Domain__c== 'combo-us' || acct.Country_Domain__c== 'cvar-us' || acct.Country_Domain__c== 'rvar-us' || acct.Country_Domain__c== 'rvar-it' || acct.Country_Domain__c== 'cvar-it'|| acct.Country_Domain__c== 'combo-it'|| acct.Country_Domain__c== 'rvar-de'|| acct.Country_Domain__c== 'cvar-de'|| acct.Country_Domain__c== 'combo-de'|| acct.Country_Domain__c=='rvar-fr' || acct.Country_Domain__c == 'cvar-fr'|| acct.Country_Domain__c== 'combo-fr'|| acct.Country_Domain__c== 'rvar-es'|| acct.Country_Domain__c== 'cvar-es'|| acct.Country_Domain__c== 'combo-es' 
                    if((acct.Country_Domain__c== 'combo-us' || acct.Country_Domain__c== 'cvar-us' || acct.Country_Domain__c== 'rvar-us' || acct.Country_Domain__c== 'rvar-it' || acct.Country_Domain__c== 'cvar-it'|| acct.Country_Domain__c== 'combo-it'|| acct.Country_Domain__c== 'rvar-de'|| acct.Country_Domain__c== 'cvar-de'|| acct.Country_Domain__c== 'combo-de'|| acct.Country_Domain__c=='rvar-fr' || acct.Country_Domain__c == 'cvar-fr'|| acct.Country_Domain__c== 'combo-fr'|| acct.Country_Domain__c== 'rvar-es'|| acct.Country_Domain__c== 'cvar-es'|| acct.Country_Domain__c== 'combo-es'
                    //|| acct.Country_Domain__c== 'combo-au' || acct.Country_Domain__c== 'cvar-au' || acct.Country_Domain__c== 'rvar-au' 
                    //Case # 00072314
                    
                    || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c =='combo-au' || acct.Country_Domain__c =='rvar-au'
                    //End 00105774
                    || acct.Country_Domain__c== 'rvar-uk'|| acct.Country_Domain__c== 'cvar-uk'|| acct.Country_Domain__c== 'combo-uk'
                    || acct.Country_Domain__c== 'combo-be' || acct.Country_Domain__c== 'cvar-be' || acct.Country_Domain__c== 'rvar-be'
                    //Case # 00073912 - Amit Saha - 09-21-02012 for  New country Domains  combo-rl,rvar-rl and cvar-rl
                    || acct.Country_Domain__c== 'combo-rl' || acct.Country_Domain__c== 'cvar-rl' || acct.Country_Domain__c== 'rvar-rl'
                    //End 00073912
                    )){                    
                        if(euTaskManager.size()>0){
                                if(acct.Country_Domain__c!='combo-us' && acct.Country_Domain__c!= 'cvar-us' &&  acct.Country_Domain__c!= 'rvar-us'){
                                    //Start 00105774
                                    if(acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c =='combo-au' || acct.Country_Domain__c =='rvar-au'){
                                        userId = euTaskManager.get(1).id;
                                    }else{
                                        userId = euTaskManager.get(0).id;
                                    }
                                    //End 00105774
                                        //userId = euTaskManager.get(0).id;
                                }
                        }
                        String subject;
                        String description;
                        //Changes for case 00056861 , added 'fr'
                        if(acct.Country_Domain__c=='rvar-it'|| acct.Country_Domain__c=='cvar-it'||acct.Country_Domain__c=='combo-it'||acct.Country_Domain__c=='rvar-de'|| acct.Country_Domain__c=='cvar-de'|| acct.Country_Domain__c=='combo-de' ||acct.Country_Domain__c=='rvar-fr'|| acct.Country_Domain__c=='cvar-fr'|| acct.Country_Domain__c=='combo-fr'){
                                system.debug('======00056861=====if Provide Partner Portal access');
                                subject= 'Provide Partner Portal access, enable Online Ordering & Provide SmartStore Access';
                                description= 'Please Provide Partner Portal access, enable Online Ordering & Provide SmartStore Access. Thank You Partner Experience.';
                        // Changes for case 00056861 , added whole 'if condition'
                        // Changes for case 00063335 , modified 'if condition' for US country domains
                        }else if(acct.Country_Domain__c=='rvar-be'|| acct.Country_Domain__c=='cvar-be'||acct.Country_Domain__c=='combo-be'||acct.Country_Domain__c=='rvar-es'|| acct.Country_Domain__c=='cvar-es'||acct.Country_Domain__c=='combo-es' 
                        //|| acct.Country_Domain__c=='cvar-us'|| acct.Country_Domain__c=='combo-us'||acct.Country_Domain__c=='rvar-us'//for Case#00080181
                        //Case # 00072314
                        ||acct.Country_Domain__c=='rvar-uk'|| acct.Country_Domain__c=='cvar-uk'|| acct.Country_Domain__c=='combo-uk'
                        //Start 00105774
                        || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c =='combo-au' || acct.Country_Domain__c =='rvar-au'
                        //End 00105774 
                        //Case # 00073912 - Amit Saha - 09-21-02012 for  New country Domains  combo-rl,rvar-rl and cvar-rl
                        || acct.Country_Domain__c== 'combo-rl' || acct.Country_Domain__c== 'cvar-rl' || acct.Country_Domain__c== 'rvar-rl'
                        //End 00073912                      
                        ){
                                system.debug('======00056861=====else Provide Partner Portal access');
                                subject= 'Provide Partner Portal access & enable Online Ordering';
                                description= 'Please Provide Partner Portal access & enable Online Ordering. Thank You Partner Experience.';
                        }
                        
                        
                        if(userId != null){    
                        task tsk = new Task(
                            whatid=acct.Id,                                             
                            ActivityDate= Date.today().addDays(2),
                            OwnerId=userId, 
                            //OwnerId=userId,                           
                            Subject= subject,
                            Description=description 
                            );
                            
                            if(acct.Country_Domain__c!='cvar-us' && acct.Country_Domain__c!='combo-us'&& acct.Country_Domain__c!='rvar-us'){
                                tsk.RecordTypeId = getTaskRecordType().get('On-boarding task');     
                                tsk.Severity__c='P2 - Significant';
                                tsk.CreatedById = UserInfo.getUserId();                 
                                tsk.IsReminderSet = true;
                            }
                            task.add(tsk);                            
                        }
                    }
                }
                if(task.size()>0){                  
                 Database.DMLOptions dlo = new Database.DMLOptions();
                 dlo.EmailHeader.triggerUserEmail = true;
                 database.insert(task, dlo);                 
                }
            }
              
        }
        
        // start for case # 00056861
        public static List<String> getSunpowerEUPSRSupervisorManilaEmailAddr() {
                system.debug('======00056861=====in function getSunpowerEUPSRSupervisorManilaEmailAddr');
                List<String> idList = new List<String>();
                
                List<String> mailToAddresses = new List<String>();
                
                // will be using on deployement
                Group g =[SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Sunpower EU PSR Supervisor Manila'];

                // using for testing purpose
                //Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Test Group For Case 00056861'];

                for (GroupMember gm : g.groupMembers) {             
                    idList.add(gm.userOrGroupId);               
                }
    
                User[] usr ;
                if(idList.size() > 0)
                    usr = [SELECT email FROM user WHERE id IN :idList];
                
                for(User u : usr) {             
                    mailToAddresses.add(u.email);               
                }               
                system.debug('======00056861====='+mailToAddresses);
                return mailToAddresses;
        }
      // end for case # 00056861          
       
         public static List<String> getEUAmbassadorsEmailAddr() {

                List<String> idList = new List<String>();
                
                List<String> mailToAddresses = new List<String>();
                
                Group g =[SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'EU Dealer Ambassadors'];
                
                for (GroupMember gm : g.groupMembers) {             
                    idList.add(gm.userOrGroupId);               
                }
                
                User[] usr = [SELECT email FROM user WHERE id IN :idList];
                
                for(User u : usr) {             
                    mailToAddresses.add(u.email);               
                }               
                return mailToAddresses;
        }
  
        //start for case # 00058232
        public static void setOnlineOrderAccessDates(List<Account> accountList){            
            //creating map of account records
            Map<ID, Account> accountsMap = new Map<ID, Account>();
            for(Account acct : accountList){
                if(acct.Online_Order_Access__c 
                //&& acct.Online_Order_Access_Date__c == null
                )
                    accountsMap.put(acct.ID, acct);
            }
            if(accountsMap.size()==0) return;
            Map<Id, Task> taskMap = new Map<Id, Task>([select Id, WhatId, Subject, Completed_Date__c from Task where WhatId = :accountsMap.keySet()
            and (Subject = 'Provide Partner Portal access, enable Online Ordering & Provide SmartStore Access' or Subject ='Provide Partner Portal access & enable Online Ordering')
            and RecordType.Name ='On-boarding task']);
            Map<Id, Date> accountCompletionDate = new Map<Id, Date>();
            for(Task t : taskMap.values()){
                if(t.Completed_Date__c!=null)
                    accountCompletionDate.put(t.WhatId, t.Completed_Date__c.date());
            }
            for(Account acc : accountsMap.values()){
                if(accountCompletionDate.get(acc.Id)!=null)
                    acc.Online_Order_Access_Date__c = accountCompletionDate.get(acc.Id);
            }
        }
        //end for case # 00058232
       public static void afterUpdateTask(Map<ID,Task> newMap, Map<ID,Task> oldListTask){        
        Set<String> setAccounts;
        Set<String> setPartnerKitReadyAccounts;
        Set<String> setPartnerWelcomeKitReadyAccounts;
        Set<String> setPartnerITDEAccounts;
        Set<String> setPartnerFRNAccounts;
        String status,subject;
        Map<Id,STRING> mapSubjectAccountId = new Map<Id,STRING>();
        Map<Id,DateTime> mapTaskCompltedAccountId = new Map<Id,DateTime>();//for case # 00058232        
        
        if(newMap.Size()>0){

            String preFix=Account.SObjectType.getDescribe().getKeyPrefix();
            String AccountId;
            
            for(Task t:newMap.values()){  

                AccountId = t.WhatId;
                status = t.Status;
                subject = t.Subject;
                //Case#00086598
                //Put completed date check so that email should not go out twice because of worflow field(completed date) update
                if(status!=null && AccountId!=null && AccountId.startsWith(preFix) && status != oldListTask.get(t.Id).Status && status.toUpperCase() == 'COMPLETED' && t.Completed_Date__c!=null){
                    if(subject.toUpperCase() == 'CREATE ORACLE ACCOUNT'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase());
                        mapTaskCompltedAccountId.put(AccountId, t.Completed_Date__c);//for case # 00058232
                    }
                    if(subject.toUpperCase() == 'SEND PARTNER STARTER KIT'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase()); 
                    }
                    if(subject.toUpperCase() == 'SEND PARTNER WELCOME KIT'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase());
                    }
                    if(subject.toUpperCase() == 'PROVIDE PARTNER PORTAL ACCESS, ENABLE ONLINE ORDERING & PROVIDE SMARTSTORE ACCESS'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase());                        
                    }
                    if(subject.toUpperCase() =='PROVIDE PARTNER PORTAL ACCESS & ENABLE ONLINE ORDERING'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase());
                    }
                    //Start 00105774
                    if(subject.toUpperCase() =='ENTER CREDIT LIMIT ON ORACLE'){
                        mapSubjectAccountId.put(AccountId,subject.toUpperCase());
                    }        
                    //End 00105774
                }
            }
                        
            List<Account> listAccountOwner = new List<Account>();
            List<Account> listPartnerKitReadyAccountOwner = new List<Account>();
            List<Account> listStaterKitReadyAccountOwner = new List<Account>();
            List<Account> listITDEOracleNoAccountOwner = new List<Account>();
            List<Account> listNAFROracleNoAccountOwner = new List<Account>();
            //Start 00105774
            //Map<id,Account> mapAccountIdAccount = new Map<id,Account>([Select Id,Country_Domain__c,Theater__c, Owner.id,Owner.email, Online_Order_Access__c From Account where Id in :mapSubjectAccountId.keyset()]);
            Map<id,Account> mapAccountIdAccount = new Map<id,Account>([Select Id,Country_Domain__c,Theater__c, Owner.id,Owner.email, Online_Order_Access__c, RSM__r.Email, Primary_PSR__c, Primary_PSR__r.Email From Account where Id in :mapSubjectAccountId.keyset()]);
            List<Account> listAusAccountOwner = new List<Account>();
            List<Account> listAusOracleNoAccountOwner = new List<Account>();
            List<Account> listAusOracleAccounts = new List<Account>();
            List<Account> listAusCreditLimitAccounts = new List<Account>();
            //End 00105774
            List<Account> listUpdateAccount = new List<Account>();//for case # 00058232

          if(mapAccountIdAccount.size()>0){
           for(ID acctid:mapAccountIdAccount.keySet()){
            if (mapAccountIdAccount.get(acctid) != null){
                
                Account acct = mapAccountIdAccount.get(acctid);
                 //Changes for case 00056861 , added 'fr'
                 if(mapSubjectAccountId.get(acct.id)=='SEND PARTNER STARTER KIT'&& acct.Theater__c=='Europe' && (acct.Country_Domain__c=='rvar-fr'||acct.Country_Domain__c=='cvar-fr'||acct.Country_Domain__c=='combo-fr'||acct.Country_Domain__c=='rvar-it'||acct.Country_Domain__c=='cvar-it'||acct.Country_Domain__c=='combo-it'||acct.Country_Domain__c=='rvar-de'||acct.Country_Domain__c=='cvar-de'||acct.Country_Domain__c=='combo-de')){                  
                        listPartnerKitReadyAccountOwner.add(acct);
                 // Changes for case 00056861 , added 'be', removed 'fr' 
                 }else if(mapSubjectAccountId.get(acct.id)=='SEND PARTNER WELCOME KIT' && acct.Theater__c=='Europe' && (acct.Country_Domain__c=='rvar-be'||acct.Country_Domain__c=='cvar-be'||acct.Country_Domain__c=='combo-be'||acct.Country_Domain__c=='rvar-es'||acct.Country_Domain__c=='cvar-es'||acct.Country_Domain__c=='combo-es' ||acct.Country_Domain__c=='rvar-uk'||acct.Country_Domain__c=='cvar-uk'||acct.Country_Domain__c=='combo-uk'
                 //Case # 00073912
                 ||acct.Country_Domain__c=='rvar-rl'||acct.Country_Domain__c=='cvar-rl'||acct.Country_Domain__c=='combo-rl')){             
                        listStaterKitReadyAccountOwner.add(acct);
                 //Start 00105774
                 }else if(mapSubjectAccountId.get(acct.id)=='SEND PARTNER WELCOME KIT' && acct.Theater__c=='Australia' && (acct.Country_Domain__c=='rvar-au' || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c=='combo-au')){             
                        listAusAccountOwner.add(acct);
                 //End 00105774
                 }else if(mapSubjectAccountId.get(acct.id)=='CREATE ORACLE ACCOUNT'){
                        //start for case # 00058232
                        if(mapTaskCompltedAccountId.get(acct.id)!=null){
                            acct.Oracle_Account_Created_Date__c = mapTaskCompltedAccountId.get(acct.id).date();
                            listUpdateAccount.add(acct);
                        }
                        //end for case # 00058232
                        //Start 00111075
                        //if(acct.Theater__c!='Europe')
                        //End 00111075
                            listAccountOwner.add(acct);
                        if(acct.Theater__c=='Australia' && (acct.Country_Domain__c=='rvar-au' || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c=='combo-au'))
                            listAusOracleAccounts.add(acct);                                            
                 }else if(mapSubjectAccountId.get(acct.id)=='PROVIDE PARTNER PORTAL ACCESS, ENABLE ONLINE ORDERING & PROVIDE SMARTSTORE ACCESS'){                        
                        listITDEOracleNoAccountOwner.add(acct);                                 
                 }
                 //Start 00105774
                 else if(mapSubjectAccountId.get(acct.id)=='ENTER CREDIT LIMIT ON ORACLE' && acct.Theater__c=='Australia' && (acct.Country_Domain__c=='rvar-au' || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c=='combo-au')){
                    listAusCreditLimitAccounts.add(acct);
                 }
                 else if(mapSubjectAccountId.get(acct.id)=='PROVIDE PARTNER PORTAL ACCESS & ENABLE ONLINE ORDERING' && acct.Theater__c=='Australia' && (acct.Country_Domain__c=='rvar-au' || acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c=='combo-au')){
                    listAusOracleNoAccountOwner.add(acct);
                 }else if(mapSubjectAccountId.get(acct.id)=='PROVIDE PARTNER PORTAL ACCESS & ENABLE ONLINE ORDERING'){                        
                 //End 00105774
                        listNAFROracleNoAccountOwner.add(acct);
                 }
             }
            }
           }
           //Start 00105774
           if(listUpdateAccount.size() > 0)
           //End 00105774
            update listUpdateAccount;//for case # 00058232
           //return;
           Map<String,ID> emailTemplates = new Map<String,ID>();
           if(mapAccountIdAccount.size()>0){
            //Start 00105774
            /*for(EmailTemplate eTemp:
                    [select Id, DeveloperName 
                        from EmailTemplate 
                        where DeveloperName in('Oracle_Account_Creation_Task_Completed','Partner_Starter_Kit_sent','Partner_Welcome_Kit_sent','portal_access_provided_for_IT_and_De','portal_access_provided_for_Fr_and_NA') and isActive = true]){
                        */
               for(EmailTemplate eTemp: [select Id, DeveloperName from EmailTemplate 
                        where DeveloperName in('Oracle_Account_Creation_Task_Completed','Partner_Starter_Kit_sent','Partner_Welcome_Kit_sent',
                        'portal_access_provided_for_IT_and_De','portal_access_provided_for_Fr_and_NA', 'Credit_Limit_Set_Up') and isActive = true]){                                      
                        emailTemplates.put(eTemp.DeveloperName,eTemp.ID);
                }
            //End 00105774
           }
           //Start 00105774
           if(listAusAccountOwner.size() > 0){
                sendMailToAusWelcomeKit(listAusAccountOwner,emailTemplates.get('Partner_Welcome_Kit_sent'));
           }
           if(listAusOracleNoAccountOwner.size() > 0){
               sendMailToAusPortal(listAusOracleNoAccountOwner,emailTemplates.get('portal_access_provided_for_Fr_and_NA'));         
            }
            if(listAusOracleAccounts.size() > 0){
                createCreditLimitTask(listAusOracleAccounts);
            }
            if(listAusCreditLimitAccounts.size() > 0){
                sendMailToAusCreditLimit(listAusCreditLimitAccounts,emailTemplates.get('Credit_Limit_Set_Up'));
            }
           //End 00105774
           if(listAccountOwner.Size()>0){
                //Start 00111075
               //sendMailToAccountOwner(listAccountOwner,emailTemplates.get('Oracle_Account_Creation_Task_Completed'));
               sendMailToAccountOwner(listAccountOwner,emailTemplates.get('Oracle_Account_Creation_Task_Completed'), true);
               //End 00111075
            }
            if(listPartnerKitReadyAccountOwner.Size()>0){
                //Start 00111075
               //sendMailToAccountOwner(listPartnerKitReadyAccountOwner,emailTemplates.get('Partner_Starter_Kit_sent'));
               sendMailToAccountOwner(listPartnerKitReadyAccountOwner,emailTemplates.get('Partner_Starter_Kit_sent'), false);
               //End 00111075
            }     
            if(listStaterKitReadyAccountOwner.Size()>0){
                //Start 00111075
               //sendMailToAccountOwner(listStaterKitReadyAccountOwner,emailTemplates.get('Partner_Welcome_Kit_sent'));
               sendMailToAccountOwner(listStaterKitReadyAccountOwner,emailTemplates.get('Partner_Welcome_Kit_sent'), false);
               //End 00111075
            } 
            
            if(listITDEOracleNoAccountOwner.size()>0){
                //Start 00111075
                //sendMailToAccountOwner(listITDEOracleNoAccountOwner,emailTemplates.get('portal_access_provided_for_IT_and_De'));
                sendMailToAccountOwner(listITDEOracleNoAccountOwner,emailTemplates.get('portal_access_provided_for_IT_and_De'), false);
                //End 00111075                
            }            
            if(listNAFROracleNoAccountOwner.size()>0){
                //Start 00111075            
               //sendMailToAccountOwner(listNAFROracleNoAccountOwner,emailTemplates.get('portal_access_provided_for_Fr_and_NA'));
               sendMailToAccountOwner(listNAFROracleNoAccountOwner,emailTemplates.get('portal_access_provided_for_Fr_and_NA'), false);
               //End 00111075         
            }
            
        }   
    }
    //Start 00105774
    private static void  createCreditLimitTask(List<Account> accountList){
            
             List<Task> task = new List<Task>();
              if(accountList.size() > 0){
                list<User> auTaskManager = new list<User>([select Id from User where Name = 'Genalyn Angeles' limit 1]);
                Id userId;
                if(auTaskManager.size() > 0)
                     userId = auTaskManager.get(0).id;
                for(Account acct:accountList){
                    task tsk = new Task();
                    tsk = new Task(
                    whatid=acct.Id,                    
                    ActivityDate= Date.today().addDays(2),
                    Subject= 'Enter Credit Limit on Oracle',
                    Description= 'An oracle account has been created, please set up partner credit limit'
                    );
                
                //Start 00105774
                if(acct.Country_Domain__c=='cvar-au' || acct.Country_Domain__c =='combo-au' || acct.Country_Domain__c =='rvar-au'){
                    tsk.OwnerId = userId;
                    tsk.RecordTypeId = getTaskRecordType().get('On-boarding task');     
                    tsk.Severity__c='P2 - Significant';
                    tsk.CreatedById = UserInfo.getUserId();                 
                    tsk.IsReminderSet = true;                   
                }
                //End 00105774
                    task.add(tsk);
                }
                 insert task;
                  
                 //Database.DMLOptions dlo = new Database.DMLOptions();
                 //dlo.EmailHeader.triggerUserEmail = true;
                 //database.insert(task, dlo);
                 sendEmailOnCredittaskCreation(task, accountList);
            }
              
        }//function ends
        
    public static void sendEmailOnCredittaskCreation(List<Task> listTasks, List<Account> accountList){
        
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        Map<id,Account> accountDetailMap = new Map<id,Account>();
        for(Account acc: accountList){
            accountDetailMap.put(acc.Id, acc);
        }
        list<string> toAusAddress=new list<String>();
        
        /*KCM_03142016: this piece of the code is being replaced with a custom setting
        toAusAddress.add('Genalyn.angles@sunpowercorp.com');
        toAusAddress.add('anamarie.molano@sunpowercorp.com');
        toAusAddress.add('ma.cristina.pancho@sunpowercorp.com');
        toAusAddress.add('Christian.manriza@sunpowercorp.com');        
        toAusAddress.add('carlanoelle.perfecto@sunpowercorp.com');
        //toAusAddress.add('jkothari@appirio.com');
        */
        
        /***
        KCM_03142016: this piece of code replaces the hardcoded values above
                      loop through the custom setting and add to toAusAddress 
                      anything that is designated as 'toAusCreditTask' and flagged as Active
        ***/
        for (Recipients_List_Account_Notifications__c rlan:csRecipients_map.values()){
            if(rlan.toAusCreditTask__c && rlan.active__c) {
                toAusAddress.add(rlan.email_address__c);
            }
        }
        
        String PORTAL_PROD_URL = 'https://login.salesforce.com/';
        String PORTAL_SB_URL = 'https://test.salesforce.com/';
        String taskUrl = '';
      /*  
        if(SalesforceOrgUtils.isProductionOrg()){
            taskUrl = PORTAL_PROD_URL;
        }else{
            taskUrl = PORTAL_SB_URL;
        }
        */
    taskUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        if(listTasks != null && listTasks.size()>0){            
            for(Task tsk:listTasks){
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setSubject('Credit Limit Task Created');
                 mail.setToAddresses(toAusAddress);
                 mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+tsk.Id+'>'+tsk.Id+'</a>  to enter Credit Limit for '+accountDetailMap.get(tsk.WhatId).name+' has been assigned to Genalyn Angeles .<br> Thanks,<br> Partner Experience.');                           
                 mail.saveAsActivity=false;
                 emailMessages.add(mail);       
            }
       }
        if(emailMessages.size()>0){

            Messaging.sendEmail(emailMessages);
        }       
        
    }
    
    public static void sendMailToAusCreditLimit(List<Account> listAccountOwner, Id templateId){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();        
        List<Contact> lstcontactexist = new List<Contact>();
        List<String> lstEmailAdd = new List<String>();
        
       List<Contact> cntList = [Select id, Email from Contact where Email = 'DealerServiceRepresentativeAU@sunpowercorp.com' limit 1];
        //List<Contact> cntList = [Select id, Email from Contact where Email = 'jituit2004@gmail.com' limit 1];                   
                  
        if (cntList.isEmpty()) {                    
            Contact cont = new Contact();
            cont.LastName = 'testAuCOntactInsert';
            //cont.Email = 'jituit2004@gmail.com';
            cont.Email = 'DealerServiceRepresentativeAU@sunpowercorp.com';
            insert cont;
            cntList.add(cont);
         }

        if(listAccountOwner != null && listAccountOwner.size()>0){                      
            for(Account acc:listAccountOwner){
                if(acc.Country_Domain__c == 'cvar-au' || acc.Country_Domain__c == 'combo-au' || acc.Country_Domain__c == 'rvar-au'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(templateId);
                            
                    List<String> mailToAddresses = new List<String>();                    
                    if(acc.RSM__r.Email != null)                      
                        mailToAddresses.add(acc.RSM__r.Email);
                        
                    //KCM_03142016: commented out hardcoded email address below.     
                    //mailToAddresses.add('anamarie.molano@sunpowercorp.com');  
                    
                    //KCM_03142016: this for loop replaces the hardcoded value above.
                    for (Recipients_List_Account_Notifications__c rlan:csRecipients_map.values()){
                        if(rlan.toAusCreditLimit__c && rlan.active__c) {
                            mailToAddresses.add(rlan.email_address__c);
                        }
                    }
                                                               
                    mail.setToAddresses(mailToAddresses);
                
                    mail.setTargetObjectId(cntList.get(0).Id);
                    mail.setWhatId(acc.Id);                     
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId() != null)
                        emailMessages.add(mail);
                }   
             }
        }
        if(emailMessages.size() > 0){
            Messaging.sendEmail(emailMessages);
        }
    }
    
    public static void sendMailToAusWelcomeKit(List<Account> listAccountOwner, Id templateId){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();        
        List<Contact> lstcontactexist = new List<Contact>();
        List<String> lstEmailAdd = new List<String>();
        
        List<Contact> cntList = [Select id, Email from Contact where Email = 'DealerServiceRepresentativeAU@sunpowercorp.com' limit 1];
        //List<Contact> cntList = [Select id, Email from Contact where Email = 'jituit2004@gmail.com' limit 1];                   
                  
        if (cntList.isEmpty()) {                    
            Contact cont = new Contact();
            cont.LastName = 'testAuCOntactInsert';
            //cont.Email = 'jituit2004@gmail.com';
            cont.Email = 'DealerServiceRepresentativeAU@sunpowercorp.com';
            insert cont;
            cntList.add(cont);
         }

        if(listAccountOwner != null && listAccountOwner.size()>0){                      
            for(Account acc:listAccountOwner){
                if(acc.Country_Domain__c == 'cvar-au' || acc.Country_Domain__c == 'combo-au' || acc.Country_Domain__c == 'rvar-au'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(templateId);
                            
                    List<String> mailToAddresses = new List<String>();
                    if(acc.Primary_PSR__r.Email != null)                      
                        mailToAddresses.add(acc.Primary_PSR__r.Email);
                    if(acc.RSM__r.Email != null)                      
                        mailToAddresses.add(acc.RSM__r.Email);
                        
                    //KCM_03142016: commented out hardcoded email address below.
                    //mailToAddresses.add('Christian.Manriza@sunpowercorp.com');
                    
                    //KCM_03142016: this for loop replaces the hardcoded value above.
                    for (Recipients_List_Account_Notifications__c rlan:csRecipients_map.values()){
                        if(rlan.toAusWelcomeKit__c && rlan.active__c) {
                            mailToAddresses.add(rlan.email_address__c);
                        }
                    }
                                            
                    mail.setToAddresses(mailToAddresses);
                
                    mail.setTargetObjectId(cntList.get(0).Id);
                    mail.setWhatId(acc.Id);                     
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId() != null)
                        emailMessages.add(mail);
                }   
             }
        }
        if(emailMessages.size() > 0){
            Messaging.sendEmail(emailMessages);
        }
    }
    public static void sendMailToAusPortal(List<Account> listAccountOwner, Id templateId){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();        
        List<Contact> lstcontactexist = new List<Contact>();
        List<String> lstEmailAdd = new List<String>();
        List<Contact> cntList = [Select id, Email from Contact where Email = 'customerservice.australia2@sunpowercorp.com' limit 1];
        //List<Contact> cntList = [Select id, Email from Contact where Email = 'jituit2004@gmail.com' limit 1];                   
                  
        if (cntList.isEmpty()) {                    
            Contact cont = new Contact();
            cont.LastName = 'testAuCOntactInsert';
            //cont.Email = 'jituit2004@gmail.com';
            cont.Email = 'customerservice.australia2@sunpowercorp.com';
            insert cont;
            cntList.add(cont);
         }
        if(listAccountOwner != null && listAccountOwner.size()>0){                      
            for(Account acc:listAccountOwner){
                if(acc.Country_Domain__c == 'cvar-au' || acc.Country_Domain__c == 'combo-au' || acc.Country_Domain__c == 'rvar-au'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(templateId);
                            
                    List<String> mailToAddresses = new List<String>();
                    if(acc.Primary_PSR__r.Email != null)                      
                        mailToAddresses.add(acc.Primary_PSR__r.Email);
                    
                    mail.setToAddresses(mailToAddresses);
                
                    mail.setTargetObjectId(cntList.get(0).Id);
                    mail.setWhatId(acc.Id);                     
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId() != null)
                        emailMessages.add(mail);
                }   
             }
        }
        if(emailMessages.size() > 0){
            Messaging.sendEmail(emailMessages);
        }        
    }
    //End 00105774
    // start for case # 00056861
    public static void sendEmailAfterOracleAccountTaskCreation(List<Task> taskList){
    
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        List<id> accountIds = new List<Id>();
        
        for(Task tsk : taskList) {
            accountIds.add(tsk.WhatId);
        }
        
        Map<id,Account> accountDetailMap = new Map<id,Account>([Select id,Name,Country_Domain__c,Primary_PSR__r.Name from Account where id IN :accountIds]); 
                
        List<String> sunpowerEUPSRSupervisorManilaEmail = new List<String>();
        sunpowerEUPSRSupervisorManilaEmail = getSunpowerEUPSRSupervisorManilaEmailAddr();                    
        List<String> mailToAddresses = new List<String>();        
        if(sunpowerEUPSRSupervisorManilaEmail!=null && sunpowerEUPSRSupervisorManilaEmail.size()>0){        
            mailToAddresses = sunpowerEUPSRSupervisorManilaEmail;
        }
        system.debug('====00056861====='+mailToAddresses);        
        
        String PORTAL_PROD_URL = 'https://login.salesforce.com/';
        String PORTAL_SB_URL = 'https://cs12.salesforce.com/';
        String taskUrl = '';
        /*
        if(SalesforceOrgUtils.isProductionOrg()){
            taskUrl = PORTAL_PROD_URL;
        }else{
            taskUrl = PORTAL_SB_URL;
        }
        */
    taskUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        for(Task tsk : taskList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Please create an Oracle Account for '+accountDetailMap.get(tsk.WhatId).Name+' + '+accountDetailMap.get(tsk.WhatId).Country_Domain__c);
            mail.setToAddresses(mailToAddresses);
            mail.setHtmlBody('Please create an Oracle Account for '+accountDetailMap.get(tsk.WhatId).Name+' + '+accountDetailMap.get(tsk.WhatId).Country_Domain__c+'.<br>Once created please ask the "Primary PSR-'+accountDetailMap.get(tsk.WhatId).Primary_PSR__r.Name+'" to close the assigned task <a href='+taskUrl+tsk.Id+'>'+tsk.Id+'</a>.<br><a href='+taskUrl+tsk.WhatId+'>Account Link</a><br><br>Thanks,<br>Partner Experience.');
            
            mail.saveAsActivity=false;
            emailMessages.add(mail);
        }
        
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }
    }
    // end for case # 00056861

    public static void sendEmailOnOracletaskCreation(List<Task> listTasks){
        
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        list<id> accountId = new list<id>();
        for(Task tsk: listTasks){
            accountId.add(tsk.WhatId);
        }
        //Start 00105774
        //map<id,Account> listAccountDetail = new map<id,Account>([select id,name,Primary_PSR__r.name from account where id in :accountId]);
        map<id,Account> listAccountDetail = new map<id,Account>([select id,name,Primary_PSR__r.name, Country_Domain__c from account where id in :accountId]);
        list<string> toAusAddress=new list<String>();
        
        /***
        KCM_03142016: commented out hardcoded email addresses below and will be replaced with a custom setting
                      so that changes to the list in the future can be managed better and faster.
        
        toAusAddress.add('Christian.Manriza@sunpowercorp.com');
        toAusAddress.add('ma.cristina.pancho@sunpowercorp.com');
        toAusAddress.add('carlanoelle.perfecto@sunpowercorp.com');
        //toAusAddress.add('jkothari@appirio.com');
        //End 00105774
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
        
        list<string> toAddress=new list<String>();
       
        /***
        KCM_03142016: commented out hardcoded email addresses below and will be replaced with a custom setting
                      so that changes to the list in the future can be managed better and faster.
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
        
        
        String PORTAL_PROD_URL = 'https://login.salesforce.com/';
        String PORTAL_SB_URL = 'https://test.salesforce.com/';
        String taskUrl = '';
        
        /*
        if(SalesforceOrgUtils.isProductionOrg()){
            taskUrl = PORTAL_PROD_URL;
        }else{
            taskUrl = PORTAL_SB_URL;
        }*/
    
    taskUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
    if(listTasks != null && listTasks.size()>0){
            
            for(Task tsk:listTasks){
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 //Start 00105774
                 if(listAccountDetail.get(tsk.WhatId).Country_Domain__c == 'cvar-au' || listAccountDetail.get(tsk.WhatId).Country_Domain__c == 'combo-au' || listAccountDetail.get(tsk.WhatId).Country_Domain__c == 'rvar-au'){
                     mail.setSubject('Please be informed that a task has been assigned to "Carla Noelle Perfecto"');
                     mail.setToAddresses(toAusAddress);
                     mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+tsk.Id+'>'+tsk.Id+'</a>  to create the Oracle Account for '+listAccountDetail.get(tsk.WhatId).name+' has been assigned to Carla Perfecto.<br> Thanks.');
                 }else{
                     mail.setSubject('Oracle Account Task Created');
                     mail.setToAddresses(toAddress);
                     mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+tsk.Id+'>'+tsk.Id+'</a>  to create the Oracle Account for '+listAccountDetail.get(tsk.WhatId).name+' has been assigned to '+listAccountDetail.get(tsk.WhatId).Primary_PSR__r.name+'.<br> Thanks,<br> Partner Experience.');
                 }
                 /*mail.setSubject('Oracle Account Task Created');
                     mail.setToAddresses(toAddress);
                     //start Changes done for case # 00056861 , anchor tag is redirecting on a  link 'https://cs1.salesforce.com/"00TS00000071FMUMA2"'. which is wrong.
                     //mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+'"'+tsk.Id+'">'+tsk.Id+'</a>  to create the Oracle Account for '+listAccountDetail.get(tsk.WhatId).name+' has been assigned to '+listAccountDetail.get(tsk.WhatId).Primary_PSR__r.name+'.<br> Thanks,<br> Partner Experience.');
                      mail.setHtmlBody('Please be informed that a task  <a href='+taskUrl+tsk.Id+'>'+tsk.Id+'</a>  to create the Oracle Account for '+listAccountDetail.get(tsk.WhatId).name+' has been assigned to '+listAccountDetail.get(tsk.WhatId).Primary_PSR__r.name+'.<br> Thanks,<br> Partner Experience.');                 
                     // end changes for case # 00056861*/
                 //End 00105774                 
                 mail.saveAsActivity=false;
                 emailMessages.add(mail);       
            }
       }
        if(emailMessages.size()>0){

            Messaging.sendEmail(emailMessages);
        }       
        
    }
    //Start 00111075
    //public static void sendMailToAccountOwner(List<Account> listAccountOwner,Id templateId){
    public static void sendMailToAccountOwner(List<Account> listAccountOwner,Id templateId, Boolean isOracle){
    //End 00111075
        String separator='~';
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();        
        Map <Id,String> mapAccIdEmail = new Map<Id,String>(); 
        List<Contact> lstcontactexist = new List<Contact>();
        List<Contact> lstcontactNew = new List<Contact>();
        Map<String,Contact> mapEmailtoContact = new Map<String,Contact>();
        List<String> lstEmailAdd = new List<String>(); 
        Map<Id,Contact> mapAccIdContact = new Map<Id,Contact>();
        
        for(Account acc : listAccountOwner) {
            mapAccIdEmail.put(acc.Owner.id,acc.Owner.Email);
        }
        
        lstcontactexist = [Select id, Email from Contact where Email in :mapAccIdEmail.values()];
            
         if (lstcontactexist.size() > 0) {        
             for ( Contact cnt : lstcontactexist) {                    
                  mapEmailtoContact.put(cnt.Email , cnt);
              }
         }
         
        for (String email : mapAccIdEmail.values()) {         
                if (mapEmailtoContact.get(email) == null) {                    
                    Contact cont = new Contact();
                    cont.LastName = 'testCOntactInsert';
                    cont.Email = email;
                    lstcontactNew.add(cont);
                    mapEmailtoContact.put(email,cont);
                }
         }            
         
         insert lstcontactNew;
         
         for(Account acc : listAccountOwner) {
            mapAccIdContact.put(acc.Id,mapEmailtoContact.get(acc.Owner.Email));
         }         
        

        if(listAccountOwner != null && listAccountOwner.size()>0){                      
            for(Account acc:listAccountOwner){
                if(acc.Owner.email != null && acc.Owner.email != ''){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   // mail.setTemplateId(emailTemplates.get('Oracle_Account_Creation_Task_Completed'));
                    mail.setTemplateId(templateId);
                    //Start 00105774
                    //if(acc.Country_Domain__c == 'cvar-us' || acc.Country_Domain__c == 'combo-us' || acc.Country_Domain__c == 'rvar-us'){
                    if(acc.Country_Domain__c == 'cvar-us' || acc.Country_Domain__c == 'combo-us' || acc.Country_Domain__c == 'rvar-us'
                      || acc.Country_Domain__c == 'cvar-au' || acc.Country_Domain__c == 'combo-au' || acc.Country_Domain__c == 'rvar-au'){
                    //End 00105774
                        mail.setToAddresses(new String[] {acc.Owner.email});
                    }else{
                        List<String> euAmbesadorEmail = new List<String>();
                         euAmbesadorEmail = getEUAmbassadorsEmailAddr();
                                    
                        List<String> mailToAddresses = new List<String>();
                        
                        if(euAmbesadorEmail!=null && euAmbesadorEmail.size()>0){
                        
                            mailToAddresses = euAmbesadorEmail;
                        }
                        //Start 00111075
                        if(!isOracle)
                        //End 00111075
                            mailToAddresses.add(acc.Owner.email);
                        mail.setToAddresses(mailToAddresses);
                    }
                    mail.setTargetObjectId(mapAccIdContact.get(acc.id).Id);
                    mail.setWhatId(acc.Id);                     
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId()!=null)
                        emailMessages.add(mail);   
                }
            }
        }
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        } 
         if (lstcontactNew.size() > 0){           
             delete lstcontactNew;     
         } 
    } 
    
    //Case#00070729  start  
    // Done for case # 00063008
    private static void setCSATCycleCode(List<Account> accountList , Map<Id,Account> oldAccountMap){
            
        //Get recordtypeId of type 'Partner'
        String partnerAccountRecordId = '';       
        for(RecordType nextRecType : accRecordTypeList){
            if(nextRecType.name == 'Partner')
                 partnerAccountRecordId = nextRecType.Id;
        }
                        
        Boolean isAnyActivatedAccount = false;
         for(Account acc : accountList){
            if((oldAccountMap == null || (oldAccountMap != null && oldAccountMap.get(acc.Id).Status__c != 'Active')) && acc.RecordTypeId == partnerAccountRecordId && acc.Status__c == 'Active'){
                isAnyActivatedAccount = true;
                break;
            }
         }          
        if(!isAnyActivatedAccount)
            return;
        
        Map<String , List<Account>> theaterAccCSATCodeOneMap = new Map<String , List<Account>>();
        Map<String , List<Account>> theaterAccCSATCodeTwoMap = new Map<String , List<Account>>();

        //Prepare map to get the Account number for both cycle code in each theater
        for(Account acc : [select id,Theater__c,Status__c , CSAT_Cycle_Code__c from Account 
                                where RecordTypeId = :partnerAccountRecordId  AND Status__c = 'Active' 
                                AND Theater__c IN ('North America','Europe','Australia')
                                 ]){
           if(acc.CSAT_Cycle_Code__c == '1') {
               if(theaterAccCSATCodeOneMap.containsKey(acc.Theater__c)) {
                 theaterAccCSATCodeOneMap.get(acc.Theater__c).add(acc);                            
               } else {
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
        
        
        
        //Assign CSAT cycle code to keep the accounts balanced for both cycle code in a particular theater
        for(Account acc : accountList){
            if((oldAccountMap == null || (oldAccountMap != null && oldAccountMap.get(acc.Id).Status__c != 'Active')) && acc.RecordTypeId == partnerAccountRecordId && acc.Status__c == 'Active'){
                if(theaterAccCSATCodeOneMap.get(acc.Theater__c)!=null && theaterAccCSATCodeTwoMap.get(acc.Theater__c)!=null){
                    if(theaterAccCSATCodeOneMap.get(acc.Theater__c).size() > theaterAccCSATCodeTwoMap.get(acc.Theater__c).size()){
                        acc.CSAT_Cycle_Code__c = '2';
                        theaterAccCSATCodeTwoMap.get(acc.Theater__c).add(acc);
                    }else {
                        acc.CSAT_Cycle_Code__c = '1';
                        theaterAccCSATCodeOneMap.get(acc.Theater__c).add(acc);
                    }  
                }
            }
        }
    }
    //Case#00070729  end
    
    //case #00641878  Starts
    public static void afterAccountUpdateCoBranding (List<Account> accountList, Map<Id,Account> oldAccountMap)
    {
    
    
         system.debug('-------in side co Branding-----');
        List<string> tempList = new List<string>();
        List<Account> tempAccList = new List<Account>();
        set<Id> Accid = new set<Id>();
        
        for(Account acc : accountList){
            
            if(acc.DSE_IsCustomer__c == true && acc.DSE_CustomerType__c <> NULL && oldAccountMap.get(acc.Id).DSE_CustomerType__c != acc.DSE_CustomerType__c){
                
                Accid.add(acc.Id);
            }
        }
        if(Accid.size() > 0){
        
        
             List<Co_Branding_Patner__c> CB = Co_Branding_Patner__c.getall().values();
          
            for(Opportunity  opp : [ Select Id,AccountId,StageName,Account.BillingState,Account.DSE_CustomerType__c,Account.Partner_Account__r.Name from Opportunity where AccountId in :Accid]){
                
                
                for(Co_Branding_Patner__c  cp :CB ){
                    
                    if( cp.State__c.contains(opp.Account.BillingState) && cp.DEAL_TYPE__c.contains(opp.Account.DSE_CustomerType__c) && (cp.SELLING_ENTITY__c == 'ALL' || opp.Account.Partner_Account__r.Name.contains(cp.SELLING_ENTITY__c)) && cp.OPPORTUNITY_STAGE__c.contains(opp.StageName)) {
                        
                        tempList.add( opp.AccountId +','+cp.CO_BRAND_Partner__c);
                            
                    }   
                }   
                
            }
        }
        
        if(tempList.size()>0){
        system.debug('------------'+tempList);
            for(Account acc : accountList){
                for( string st : tempList){
                        system.debug('------------'+st);
                        string s1 = st.substringBefore(',');
                        string s2 = st.substringAfter(',');
                    
                        if(s1 == acc.Id){
                            
                                acc.CO_BRAND_Partner__c = s2;
                                tempAccList.add(acc);
                            
                        }
                    
                }
            }   

        }
        if(tempAccList.size()>0){
            
            update tempAccList;
        }       

    }   
   //case #00641878  Ends
        
}//Class end