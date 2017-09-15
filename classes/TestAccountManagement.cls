/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009 
**Last Modified- 
**Last Modified On- June 06 2009  
**Desciption- Test class for AccountManagement
*****************************************************/
public class TestAccountManagement { 
    
    @isTest
    public static void Test_AccountUpdate(){
           Account acct1 = new Account(Name='TestAccount_AccountUpdate');
           //added by sreekanth
           acct1.Type ='Commercial';
           acct1.BillingCity = 'banga';
           acct1.BillingCountry = 'France';
           acct1.BillingStreet = 'btm';
           acct1.BillingPostalCode = '12311';
           acct1.Sic = '0111';
           acct1.Theater__c = 'Europe';
           acct1.Territory__c = 'France';
           insert acct1;           
           acct1.IsPartner = true;
           acct1.Theater__c = 'Europe';
           acct1.Territory__c = 'Germany';
           acct1.Sic = '0742';
           upsert acct1;
           acct1.Sic = ' ';
           update acct1;
           acct1.Type =  AccountHandlerUtilities.PartnerRecTypeId;
           acct1.Geolocation__Latitude__s = 46;
           acct1.Geolocation__Longitude__s = -122.54578;
           acct1.Country_Domain__c = 'rvar-us';
           update acct1;
        
           Contact contactObj = new Contact();
           contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
           contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
           contactObj.AccountId = acct1.Id;
           insert contactObj;
           
           CoverageArea__c c_area = new CoverageArea__c();
           c_area.Account__c = acct1.Id;
           c_area.Is_Active__c = true;
           c_area.Geolocation__Latitude__s = 45.412016;
           c_area.Geolocation__Longitude__s = -122.54578;
           c_area.Name = 'Billing Address';
           insert c_area;
        
           acct1.Geolocation__Latitude__s = 45.412016;
           acct1.Country_Domain__c = 'cvar-us';
           update acct1;
        
           
        
    }//Function ends
    
    
    @isTest
    public static void Test_AccountUpdate_Update_Contact(){   
        Set<Id> UsersToSkipTrigger = new Set<Id>();
        for(UsersToSkipTrigger__c usrToSkipTrigger : UsersToSkipTrigger__c.getAll().values()){
            UsersToSkipTrigger.Add(Id.valueOf(usrToSkipTrigger.Name));
        }
        User u =  [SELECT Id,Contact.Account.Theater__c,Contact.Account.Territory__c FROM User WHERE Profile.Id = '00e800000013viM' AND Id NOT IN :UsersToSkipTrigger AND isActive=true LIMIT 1];      
        
        Account acct = new Account(Name='TestAccount_AccountUpdate_Contact');
        //added by sreekanth
        acct.Type ='Residential';
        acct.BillingState = 'IL';
        acct.BillingCity = 'Chicago';
        acct.BillingCountry = 'United States';
        acct.BillingStreet = '4057 S. Ellis Ave';
        acct.BillingPostalCode = '60606';
        acct.Email__c = 'ss@sunpowercorp.com';
        acct.Phone ='(832) 864-4574';
        acct.Sic = '6531';
        acct.Theater__c = 'North America';
        acct.Territory__c = 'France';
        acct.Sic = '0742';
        acct.RecordTypeId =  AccountHandlerUtilities.ResidentialRecTypeId;
        acct.Geolocation__Latitude__s = 46;
        acct.Geolocation__Longitude__s = -122.54578;
        acct.Country_Domain__c = 'rvar-us';
        
        Account acct1 = new Account(Name='TestAccount_AccountUpdate_Contact');
        acct1.BillingState = 'IL';
        acct1.BillingCity = 'Chicago';
        acct1.BillingCountry = 'United States';
        acct1.BillingStreet = '4057 S. Ellis Ave';
        acct1.BillingPostalCode = '60606';
        acct1.Phone ='(832) 864-5574';
        acct1.Email__c = 'ps@sunpowercorp.com';
        acct1.Sic = '6531';
        acct1.Theater__c = 'North America';
        acct1.Territory__c = 'United States';
        acct1.Sic = '0742';
        acct1.RecordTypeId =  AccountHandlerUtilities.PartnerRecTypeId;
        acct1.Type = 'Partner';
        acct1.Geolocation__Latitude__s = 46;
        acct1.Geolocation__Longitude__s = -122.54578;
        acct1.Country_Domain__c = 'cvar-us';
        acct1.Lead_Flow_opt_out__c = false;
        
        insert acct1;
        System.runAs(u){            
            insert acct;
        }
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test Res' + String.valueOf(DateTime.Now()) ;
        contactObj.LastName = 'Test Res' + String.valueOf(DateTime.Now());
        contactObj.AccountId = acct.Id;
        contactObj.MailingCity = 'Chicago';
        contactObj.MailingCountry = 'United States';
        contactObj.MailingStreet = '4057 S. Ellis Ave';
        contactObj.MailingPostalCode = '60606';
        contactObj.Country_Domain__c = 'rvar-us';
        contactObj.Email = 'ss@sunpowercorp.com';
        contactObj.Primary__c = true;
        
        Contact contactObj1 = new Contact();
        contactObj1.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
        contactObj1.LastName = 'Test' + String.valueOf(DateTime.Now());
        contactObj1.AccountId = acct1.Id;
        contactObj1.MailingCity = 'Chicago';
        contactObj1.MailingCountry = 'United States';
        contactObj1.MailingStreet = '4057 S. Ellis Ave';
        contactObj1.MailingPostalCode = '60606';
        contactObj1.Country_Domain__c = 'rvar-us';
        contactObj.Email = 'ps@sunpowercorp.com';
        contactObj1.Primary__c = true;
        
        insert contactObj1;
        System.runAs(u){
            insert contactObj;
        }
        acct.BillingStreet = '5005 S. Ellis Ave';
        acct.BillingPostalCode = '60607';
        acct.Territory__c = 'United States';
        acct.Phone ='(832) 864-4573';
        acct.Geolocation__Latitude__s = 45.412016;
        
        
        System.runAs(u){
           update acct;
        }
        User objUserPSR = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where UserRoleId = '00E800000010ZTJ' AND isActive=true limit 1];
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Test Opportunity FivePercent DP';
        oppObj.StageName = '25% - Site Audit Completed';
        oppObj.CloseDate = Date.today();
        oppObj.Lead_Manufacturer__c ='SunPower';
        oppObj.Is_Excluded_From_SLA_Score__c = true;
        oppObj.Partner_Account_Id__c =acct1.id;
        oppObj.AccountId =acct.id;
        oppObj.Amount=300;
        oppObj.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
        oppObj.OwnerId = objUser.id;
        oppObj.Primary_Contact__c = contactObj1.id;
        oppObj.Customer_Satisfaction_Survey_opt_in__c = true;
        oppObj.CRSM__c = objUserPSR.Id;
        oppObj.Down_Payment_Invoice_Number__c = '12345';
        
        insert oppObj;
        
    }//Function ends
    
    @isTest
    public static void Test_AccountUpdate_CoBranding(){   
        Set<Id> UsersToSkipTrigger = new Set<Id>();
        for(UsersToSkipTrigger__c usrToSkipTrigger : UsersToSkipTrigger__c.getAll().values()){
            UsersToSkipTrigger.Add(Id.valueOf(usrToSkipTrigger.Name));
        }
        User u =  [SELECT Id,Contact.Account.Theater__c,Contact.Account.Territory__c FROM User WHERE Profile.Id = '00e800000013viM' AND Id NOT IN :UsersToSkipTrigger AND isActive=true LIMIT 1];      
        
        Account acct = new Account(Name='TestAccount_CoBranding_Cash');
        acct.Type ='Residential';
        acct.BillingState = 'NY';
        acct.BillingCity = 'Houston';
        acct.BillingCountry = 'United States';
        acct.BillingStreet = '7114 Bayou Forest Drive';
        acct.BillingPostalCode = '77088';
        acct.Sic = '6531';
        acct.Theater__c = 'North America';
        acct.Territory__c = 'France';
        acct.Sic = '0742';
        acct.RecordTypeId =  AccountHandlerUtilities.ResidentialRecTypeId;
        acct.Geolocation__Latitude__s = 46;
        acct.Geolocation__Longitude__s = -122.54578;
        acct.Country_Domain__c = 'rvar-us';
        acct.DSE_IsCustomer__c = true;
        acct.DSE_CustomerType__c = 'Cash';
        acct.CO_BRAND_Partner__c = '';
        
        Account acct2 = new Account(Name='TestAccount_CoBranding_Lease');
        acct2.Type ='Residential';
        acct2.BillingState = 'NY';
        acct2.BillingCity = 'Austin';
        acct2.BillingCountry = 'United States';
        acct2.BillingStreet = '12308 Havelock Dr';
        acct2.BillingPostalCode = '78759';
        acct2.Sic = '6531';
        acct2.Theater__c = 'North America';
        acct2.RecordTypeId =  AccountHandlerUtilities.ResidentialRecTypeId;
        acct2.Geolocation__Latitude__s = 46;
        acct2.Geolocation__Longitude__s = -122.54578;
        acct2.Country_Domain__c = 'rvar-us';
        acct2.DSE_IsCustomer__c = true;
        acct2.DSE_CustomerType__c = 'Loan';
        acct2.CO_BRAND_Partner__c = '';
        
        Account acct1 = new Account(Name='TXU TestAccount_CoBranding');
        acct1.BillingState = 'IL';
        acct1.BillingCity = 'Chicago';
        acct1.BillingCountry = 'United States';
        acct1.BillingStreet = '4057 S. Ellis Ave';
        acct1.BillingPostalCode = '60606';
        acct1.Sic = '6531';
        acct1.Theater__c = 'North America';
        acct1.Territory__c = 'United States';
        acct1.Sic = '0742';
        acct1.RecordTypeId =  AccountHandlerUtilities.PartnerRecTypeId;
        acct1.Type = 'Partner';
        acct1.Geolocation__Latitude__s = 46;
        acct1.Geolocation__Longitude__s = -122.54578;
        acct1.Country_Domain__c = 'cvar-us';
        acct1.Lead_Flow_opt_out__c = false;
        
        insert acct1;
        System.runAs(u){ 
            List<Account> a = new List<Account>();
            a.add(acct);
            a.add(acct2);
            insert a;
        }
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test Res Cash' + String.valueOf(DateTime.Now()) ;
        contactObj.LastName = 'Test Res Cash' + String.valueOf(DateTime.Now());
        contactObj.AccountId = acct.Id;
        contactObj.MailingCity = 'Chicago';
        contactObj.MailingCountry = 'United States';
        contactObj.MailingStreet = '4057 S. Ellis Ave';
        contactObj.MailingPostalCode = '60606';
        contactObj.Country_Domain__c = 'rvar-us';
        
        Contact contactObj2 = new Contact();
        contactObj2.FirstName = 'Test Res Lease' + String.valueOf(DateTime.Now()) ;
        contactObj2.LastName = 'Test Res Lease' + String.valueOf(DateTime.Now());
        contactObj2.AccountId = acct2.Id;
        contactObj2.MailingCity = 'Chicago';
        contactObj2.MailingCountry = 'United States';
        contactObj2.MailingStreet = '4058 S. Ellis Ave';
        contactObj2.MailingPostalCode = '60606';
        contactObj2.Country_Domain__c = 'rvar-us';
        
        
        Contact contactObj1 = new Contact();
        contactObj1.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
        contactObj1.LastName = 'Test' + String.valueOf(DateTime.Now());
        contactObj1.AccountId = acct1.Id;
        contactObj1.MailingCity = 'Chicago';
        contactObj1.MailingCountry = 'United States';
        contactObj1.MailingStreet = '4057 S. Ellis Ave';
        contactObj1.MailingPostalCode = '60606';
        contactObj1.Country_Domain__c = 'rvar-us';
        
        insert contactObj1;
        System.runAs(u){
            List<Contact> c = new List<Contact>();
            c.add(contactObj);
            c.add(contactObj2);
            insert c;
        }
        acct.BillingState = 'TX';
	    acct.BillingCity = 'Houston';
        acct.BillingStreet = '3809 Linkview';
        acct.BillingPostalCode = '77021';
        acct.Territory__c = 'United States';
        acct.Geolocation__Latitude__s = 45.412016;
        
        
        acct2.BillingState = 'TX';
	    acct2.BillingCity = 'Austin';
        acct2.BillingStreet = '400 Wye Oak St.';
        acct2.BillingPostalCode = '78748';
        acct2.Territory__c = 'United States';
        
        
        System.runAs(u){
            List<Account> a2 = new List<Account>();
            a2.add(acct);
            a2.add(acct2);
            update a2;
        }
        User objUserPSR = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where UserRoleId = '00E800000010ZTJ' AND isActive=true limit 1];
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Test Opportunity Cash';
        oppObj.StageName = 'Contract signed';
        oppObj.CloseDate = Date.today();
        oppObj.Lead_Manufacturer__c ='SunPower';
        oppObj.Is_Excluded_From_SLA_Score__c = true;
        oppObj.Partner_Account_Id__c =acct1.id;
        oppObj.AccountId =acct.id;
        oppObj.Amount=300;
        oppObj.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
        oppObj.OwnerId = objUser.id;
        oppObj.Primary_Contact__c = contactObj1.id;
        oppObj.Customer_Satisfaction_Survey_opt_in__c = true;
        oppObj.CRSM__c = objUserPSR.Id;
        oppObj.Down_Payment_Invoice_Number__c = '12345';
        
        
        Opportunity oppObj2 = new Opportunity();
        oppObj2.Name = 'Test Opportunity Lease';
        oppObj2.StageName = 'Contract signed';
        oppObj2.CloseDate = Date.today();
        oppObj2.Lead_Manufacturer__c ='SunPower';
        oppObj2.Is_Excluded_From_SLA_Score__c = true;
        oppObj2.Partner_Account_Id__c =acct1.id;
        oppObj2.AccountId =acct2.id;
        oppObj2.Amount=300;
        oppObj2.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
        oppObj2.OwnerId = objUser.id;
        oppObj2.Primary_Contact__c = contactObj1.id;
        oppObj2.Customer_Satisfaction_Survey_opt_in__c = true;
        oppObj2.CRSM__c = objUserPSR.Id;
        oppObj2.Down_Payment_Invoice_Number__c = '12346';
        
        
        insert oppObj;
        
    }//Function ends
    
    
    @isTest
    public static void Test_PartnerCombo_BillingAddress_Account_Coverage(){
           Account acct1 = new Account(Name='TestAccount_AccountUpdate_Contact');
           acct1.BillingCity = 'Chicago';
           acct1.BillingCountry = 'United States';
           acct1.BillingStreet = '4057 S. Ellis Ave';
           acct1.BillingPostalCode = '60606';
           acct1.Sic = '6531';
           acct1.Theater__c = 'North America';
           acct1.Territory__c = 'United States';
           acct1.Sic = '0742';
           acct1.RecordTypeId =  AccountHandlerUtilities.PartnerRecTypeId;
           acct1.Type = 'Premier-Partner-Combo';
           acct1.Geolocation__Latitude__s = 46;
           acct1.Geolocation__Longitude__s = -122.54578;
           acct1.Country_Domain__c = 'cvar-us';
           acct1.Lead_Flow_opt_out__c = false;
           insert acct1;
        
           Contact contactObj = new Contact();
           contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
           contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
           contactObj.AccountId = acct1.Id;
           contactObj.MailingCity = 'Chicago';
           contactObj.MailingCountry = 'United States';
           contactObj.MailingStreet = '4057 S. Ellis Ave';
           contactObj.MailingPostalCode = '60606';
           contactObj.Country_Domain__c = 'rvar-us';
           insert contactObj;
        
           CoverageArea__c c_area = new CoverageArea__c();
           c_area.Account__c = acct1.Id;
           c_area.Is_Active__c = true;
           c_area.Geolocation__Latitude__s = 45.412016;
           c_area.Geolocation__Longitude__s = -122.54578;
           c_area.Name = 'Billing Address';
           insert c_area;
        
           acct1.BillingStreet = '5005 S. Ellis Ave';
           acct1.BillingPostalCode = '60607';
           acct1.Geolocation__Latitude__s = 45.412016;
           acct1.Lead_Flow_opt_out__c = true;
           update acct1;
        
           
        
    }//Function ends
    
    @isTest
    public static void Test_PartnerCombo_Account_Coverage(){
           Account acct1 = new Account(Name='TestAccount_AccountUpdate_Contact');
           acct1.BillingCity = 'Chicago';
           acct1.BillingCountry = 'United States';
           acct1.BillingStreet = '4057 S. Ellis Ave';
           acct1.BillingPostalCode = '60606';
           acct1.Sic = '6531';
           acct1.Theater__c = 'North America';
           acct1.Territory__c = 'United States';
           acct1.Sic = '0742';
           acct1.RecordTypeId =  AccountHandlerUtilities.PartnerRecTypeId;
           acct1.Type = 'Premier-Partner-Combo';
           acct1.Geolocation__Latitude__s = 46;
           acct1.Geolocation__Longitude__s = -122.54578;
           acct1.Country_Domain__c = 'cvar-us';
           acct1.Lead_Flow_opt_out__c = false;
           insert acct1;
        
           Contact contactObj = new Contact();
           contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
           contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
           contactObj.AccountId = acct1.Id;
           contactObj.MailingCity = 'Chicago';
           contactObj.MailingCountry = 'United States';
           contactObj.MailingStreet = '4057 S. Ellis Ave';
           contactObj.MailingPostalCode = '60606';
           contactObj.Country_Domain__c = 'rvar-us';
           insert contactObj;
        
           CoverageArea__c c_area = new CoverageArea__c();
           c_area.Account__c = acct1.Id;
           c_area.Is_Active__c = true;
           c_area.Geolocation__Latitude__s = 45.412016;
           c_area.Geolocation__Longitude__s = -122.54578;
           c_area.Name = 'Test Address';
           insert c_area;
        
           acct1.BillingStreet = '5005 S. Ellis Ave';
           acct1.BillingPostalCode = '60607';
           acct1.Geolocation__Latitude__s = 45.412016;
           acct1.Lead_Flow_opt_out__c = true;
           update acct1;
        
    }//Function ends
    
    @isTest
    public static void Test_Partner_Account_Coverage(){
           Account acct1 = new Account(Name='TestAccount_AccountUpdate_Contact');
           acct1.BillingCity = 'Chicago';
           acct1.BillingCountry = 'United States';
           acct1.BillingStreet = '4057 S. Ellis Ave';
           acct1.BillingPostalCode = '60606';
           acct1.Sic = '6531';
           acct1.Theater__c = 'North America';
           acct1.Territory__c = 'United States';
           acct1.Sic = '0742';
           acct1.RecordTypeId =  AccountHandlerUtilities.PartnerRecTypeId;
           acct1.Type = 'Partner';
           acct1.Geolocation__Latitude__s = 46;
           acct1.Geolocation__Longitude__s = -122.54578;
           acct1.Country_Domain__c = 'cvar-us';
           acct1.Lead_Flow_opt_out__c = false;
           insert acct1;
        
           Contact contactObj = new Contact();
           contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
           contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
           contactObj.AccountId = acct1.Id;
           contactObj.MailingCity = 'Chicago';
           contactObj.MailingCountry = 'United States';
           contactObj.MailingStreet = '4057 S. Ellis Ave';
           contactObj.MailingPostalCode = '60606';
           contactObj.Country_Domain__c = 'rvar-us';
           insert contactObj;
        
           CoverageArea__c c_area = new CoverageArea__c();
           c_area.Account__c = acct1.Id;
           c_area.Is_Active__c = true;
           c_area.Geolocation__Latitude__s = 45.412016;
           c_area.Geolocation__Longitude__s = -122.54578;
           c_area.Name = 'Billing Address';
           insert c_area;
        
           acct1.BillingStreet = '5005 S. Ellis Ave';
           acct1.BillingPostalCode = '60607';
           acct1.Geolocation__Latitude__s = 45.412016;
           acct1.Lead_Flow_opt_out__c = true;
           update acct1;
        
           
        
    }//Function ends
        
    
    @isTest
    public static void Test_TerminatedAccountUpdate(){
      //set test data
       
      Account accountObj = new Account();
      accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
      accountObj.Type ='Commercial';
      
           accountObj.BillingCity = 'chicago';
           accountObj.BillingCountry = 'Spain';
           accountObj.BillingStreet = 'btm';
           accountObj.BillingPostalCode = '12311';
           accountObj.Theater__c = 'Europe';
           accountObj.Territory__c = 'Spain';
           accountObj.Status__c = 'Active';
           accountObj.Country_Domain__c = 'rvar-us';
      insert accountObj;      
      
      Contact contactObj = new Contact();
      contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
      contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
      contactObj.AccountId = accountObj.Id;
      
      insert contactObj;
      
      Certification__c certification = new Certification__c();
      certification.Account__c = accountObj.Id;
      //certification.Contact__c = contactObj.Id;
      insert certification;
         
      
      accountObj.Country_Domain__c = 'cvar-us';
      accountObj.Status__c = 'Terminated';
      update accountObj;      
    }
    

    @isTest
    public static void Test_CertificationManagement(){
      //TestCertificationManagement.checkCertificationManagement();
    }

    @isTest
    public static void Test_RSMFieldPopulate1(){          
      
      User  user = null;
      /* Done for case # 00050543 on 19Feb2011 */
      //List<User> userList = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      List<User> userList = [select id from User where UserRole.Name LIKE '%Regional Sales Manager%' Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;        
        user.Alias = 'yoo';       
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        /* Done for case # 00050543 on 19Feb2011 */
        //List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name LIKE '%Regional Sales Manager%' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
      Test.stopTest();
      }
      else{
        user = userList[0];
      }
      //added by sreekanth
      Account a = new Account(name='TestRSMName',RSM__c = user.ID);
      
      a.Type = 'Authorized-Partner-Combo';
      a.BillingCity = 'hyd';
      a.BillingCountry = 'Italy';
      a.BillingStreet = 'abc';
      a.BillingPostalCode = '1223454';
      a.Theater__c = 'Europe';
      a.Territory__c = 'Italy';
      insert a;
            
    }
    
    @isTest
    public static void Test_RSMFieldPopulate2(){
      User  user = null;
      /* Done for case # 00050543 on 19Feb2011 */
      // List<User> userList = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      List<User> userList = [select id from User where UserRole.Name LIKE '%Regional Sales Manager%' Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        /* Done for case # 00050543 on 19Feb2011 */
        // List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name LIKE '%Regional Sales Manager%' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
      Test.stopTest();
      }
      else{
        user = userList[0];
      }
      Account a = new Account(name='TestRSMName',RSM__c = null);
      a.Type = 'Authorized-Partner-Residential';
      a.BillingCity = 'vij';
      a.BillingCountry = 'Spain';
      a.BillingStreet = 'new';
      a.BillingPostalCode = '1223789';
      a.Theater__c = 'Europe';
      a.Territory__c = 'Spain';
      insert a;
    }
    
    @isTest
    public static void Test_SharePartnerAccount(){ 
      Account a = new Account(name='TestAAA',RSM__c = null);
      a.Type = 'Authorized-Partner-Residential';
      a.BillingCity = 'ong';
      a.BillingCountry = 'uk';
      a.BillingStreet = 'xyz';
      a.BillingPostalCode = '231234';
      a.Theater__c = 'North America';
      insert a;
      a.Type = 'Authorized-Partner-Combo';
      upsert a; 
                  
      Contact cc = new Contact(FirstName = 'First1' + String.valueOf(DateTime.Now()),LastName = 'Last1' + String.valueOf(DateTime.Now()),AccountID=a.id);
      insert cc;
      //cc = [Select id,Account.Name from Contact where AccountID!=null and partner_portal_user__c!=null limit 1];
            
      
      User  user = null;
      List<User> userList = [select id from User where UserType = 'PowerPartner' and isActive = true Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hellooo@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;        
        user.Alias = 'yoo';  
        if(cc!=null){
            user.ContactID = cc.id;
        }     
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testSharePartnerAccount@test.com';
        user.LocaleSidKey = 'en_US';
        user.isActive = true;
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        String roleName = cc.Account.Name + 'Partner Executive';
        List<UserRole> lstRole = [select Id from UserRole where Name = :roleName LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;           
            insert user;
        }
        
      Test.stopTest();
      }
      else{
        user = userList[0];
      }           
     
     
      User  user1 = null;
      /* Done for the case # 00050543 on 19Feb2011 */
      //List<User> userList1 = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      List<User> userList1 = [select id from User where UserRole.Name LIKE '%Regional Sales Manager%' Limit 1];
      if(userList1 == null || userList1.size() ==0){
        String username ='hello@world.com';
        user1 = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user1.Username = username;
        user1.Alias = 'yoo';
        user1.CommunityNickname = username.subString(0,7);
        user1.TimeZoneSidKey = 'America/Los_Angeles';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.LanguageLocaleKey = 'en_US';
        user1.Email = 'testRSMPopulate@test.com';
        user1.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        /* Done for the case # 00050543 on 19Feb2011 */
        // List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name LIKE '%Regional Sales Manager%' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user1.ProfileId = lstProfile[0].Id;
            user1.UserRoleId = lstRole[0].Id;
            insert user1;
        }
      Test.stopTest();
      }
      else{
        user1 = userList1[0];
      }
     
     
        
      //Contact c = new Contact(partner_portal_user__c=user.id,FirstName = 'First' + String.valueOf(DateTime.Now()),LastName = 'Last' + String.valueOf(DateTime.Now()),AccountID=a.id);
      //insert c;  
      cc.partner_portal_user__c = user.id;
      update cc;
      
      a.isPartner=true;  
      if(user1.id != null){    
          a.ownerID = user1.id;
      }
      update a;
    }  
          
    @isTest
    public static void Test_createTaskOnAccountStatusChange(){
      User  user = null;
      List<User> userList = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
      Test.stopTest();
      }
      else{
        user = userList[0];
      }
      Account a = new Account(name='TestRSMName',RSM__c = null);
      a.Type = 'Authorized-Partner-Residential';
      a.BillingCity = 'vij';
      a.BillingCountry = 'Spain';
      a.BillingStreet = 'new';
      a.BillingPostalCode = '1223789';
      a.Theater__c = 'Europe';
      a.Territory__c = 'Spain';
      a.Status__c = 'Contract Pending';
      a.Country_Domain__c='combo-us';
      insert a;
      
      a.Status__c = 'Active';
      a.Oracle_Account_Number__c = '5678';
      update a;     
     
      AccountManagement.getEUAmbassadorsEmailAddr();
    }
  
    @isTest
    public static void Test_afterUpdateTask(){
      User  user = null;
      List<User> userList = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
      Test.stopTest();
      }
      else{
        user = userList[0];
      }
     
      Account a = new Account(name='TestName',RSM__c = null);
      a.Type = 'Authorized-Partner-Residential';
      a.BillingCity = 'vij';
      a.BillingCountry = 'Spain';
      a.BillingStreet = 'new';
      a.BillingPostalCode = '1223789';
      a.Theater__c = 'Europe';
      a.Territory__c = 'Spain';
      a.Status__c = 'Contract Pending';
      a.Country_Domain__c='combo-us';
      insert a;
      
      Task ts  = new Task();
      ts.status = 'Not Started';
      ts.subject = 'Test';
      if(user.Id != null)
      ts.OwnerId = user.Id;
      ts.WhatId = a.Id;
      insert ts;
      
      ts.status = 'COMPLETED';
      ts.subject = 'CREATE ORACLE ACCOUNT';
      update ts;
      List<Task> tasks = new List<Task>();
      tasks.Add(ts);
      AccountManagement.sendEmailOnOracletaskCreation(tasks);
    }
    
    //JAJA 20.JUNE.2015
    @isTest
    public static void Test_accountCreation(){
      User  user = null;
      List<User> userList = [select id from User where UserRole.Name = 'Regional Sales Manager' Limit 1];
      if(userList == null || userList.size() ==0){
        String username ='hello@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = 'testRSMPopulate@test.com';
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales' LIMIT 1];
        List<UserRole> lstRole = [select Id from UserRole where Name = 'Regional Sales Manager' LIMIT 1];
        if(lstProfile.Size()>0 && lstRole.size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.UserRoleId = lstRole[0].Id;
            insert user;
        }
      Test.stopTest();
      }
      else{
        user = userList[0];
      }
        
      Account a = new Account(name='TestName',RSM__c = null);
      a.Type = 'Authorized-Partner-Residential';
      a.BillingCity = 'vij';
      a.BillingCountry = 'Spain';
      a.BillingStreet = 'new';
      a.BillingPostalCode = '1223789';
      a.Theater__c = 'Europe';
      a.Territory__c = 'Spain';
      a.Status__c = 'Contract Pending';
      a.Country_Domain__c='combo-us';
      insert a;
      
      Task ts  = new Task();
      ts.status = 'Not Started';
      ts.subject = 'Test';
      if(user.Id != null)
      ts.OwnerId = user.Id;
      ts.WhatId = a.Id;
      insert ts;
      
      ts.status = 'COMPLETED';
      ts.subject = 'CREATE ORACLE ACCOUNT';
      update ts;
      List<Task> tasks = new List<Task>();
      tasks.Add(ts);
        
        list<id> accountId = new list<id>();
        for(Task tsk: tasks){
            accountId.add(tsk.WhatId);
        }
        
        List<Account> listacc = new List<Account>();
        listacc.add(a);
        map<id,Account> listAccountDetail = new map<id,Account>([select id,name,Primary_PSR__r.name, Country_Domain__c from account where id in :accountId]);
        AccountHandlerUtilities.sendEmailForTaskCreation(tasks, listAccountDetail);
        AccountHandlerUtilities.createBusinessRegistration(listacc);
        AccountHandlerUtilities.runGeoCodeFromTrigger(listacc);
    }
    
    @isTest
    public static void Test_createTaskOnAccountStatusChange_update(){
        RecordType recType = [select id from RecordType where name like 'Partner%' and SobjectType='Account'];
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.BillingCity = 'chicago';
        accountObj.BillingCountry = 'Spain';
        accountObj.BillingStreet = 'btm';
        accountObj.BillingPostalCode = '12311';
        accountObj.Theater__c = 'Europe';
        accountObj.Territory__c = 'Spain';
        accountObj.RecordTypeId = recType.id;
        accountObj.status__c='Contract Pending';
        insert accountObj;  
        
        accountObj.status__c='Active';
        update accountObj;
        
    }
    
    static testMethod void Test_setCommercialAccountFields(){
      //set test data
      RecordType recType = [select id from RecordType where name like 'Commercial Customer' and SobjectType='Account'];
      
      User  user = null;
      List<User> userList = [select id from User where Profile.Name like 'Partner%' and isActive = true Limit 1];
      user = userList[0];
      System.runAs(user){
          Account accountObj = new Account();
          accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
          accountObj.Type ='Commercial';
          accountObj.BillingCity = 'chicago';
          accountObj.BillingCountry = 'Spain';
          accountObj.BillingStreet = 'btm';
          accountObj.BillingPostalCode = '12311';
          accountObj.Theater__c = 'Europe';
          accountObj.Territory__c = 'Spain';
          accountObj.RecordTypeId = recType.id;
          insert accountObj;  
          
          Contact contactObj = new Contact();
          contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
          contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
          contactObj.AccountId = accountObj.Id;
          insert contactObj; 
        
      }  
   }

   //RRA - 24.JUN.2015 - Added test method for beforeAccountInsert method on AccountManagement
   @isTest
   public static void Test_beforeAccountInsert(){

      List<Account> accountToInsert = new List<Account>();
      Map<Id,Account> accountMap = new Map<Id,Account>();

      //Commercial Account - US
      Account acc1 = new Account();
      acc1.name='TestAccount1';
      acc1.RSM__c = null;
      acc1.Type = 'Authorized-Partner-Commercial';
      acc1.BillingCity = 'Phoenix';
      acc1.BillingCountry = 'United States';
      acc1.BillingState = 'AZ';
      acc1.BillingStreet = 'TestStreet';
      acc1.BillingPostalCode = '86509';
      acc1.Theater__c = 'North America';
      acc1.Territory__c = 'NACCalifornia';
      acc1.Status__c = 'Contract Pending';
      acc1.Country_Domain__c='cvar-us';
      insert acc1;

      accountToInsert.add(acc1);

      //Residenttial Account - US
      Account acc2 = new Account();
      acc2.name='TestAccount2';
      acc2.RSM__c = null;
      acc2.Type = 'Authorized-Partner-Residential';
      acc2.BillingCity = 'Sacramento';
      acc2.BillingCountry = 'United States';
      acc2.BillingState = 'CA';
      acc2.BillingStreet = 'TestStreet2';
      acc2.BillingPostalCode = '95757';
      acc2.Theater__c = 'North America';
      acc2.Territory__c = 'RLCNA';
      acc2.Status__c = 'Contract Pending';
      acc2.Country_Domain__c='rvar-us';
      insert acc2;

      accountToInsert.add(acc2);

      //Combo Account - US
      Account acc3 = new Account();
      acc3.name='TestAccount3';
      acc3.RSM__c = null;
      acc3.Type = 'Authorized-Partner-Combo';
      acc3.BillingCity = 'Crowell';
      acc3.BillingCountry = 'United States';
      acc3.BillingState = 'TX';
      acc3.BillingStreet = 'TestStreet3';
      acc3.BillingPostalCode = '79260';
      acc3.Theater__c = 'North America';
      acc3.Territory__c = 'NACEastUS';
      acc3.Status__c = 'Contract Pending';
      acc3.Country_Domain__c='combo-us';
      insert acc3;

      accountToInsert.add(acc3);

      //Commercial Account - AU
      Account acc4 = new Account();
      acc4.name='TestAccount4';
      acc4.RSM__c = null;
      acc4.Type = 'Authorized-Partner-Commercial';
      acc4.BillingCity = 'SYDNEY';
      acc4.BillingCountry = 'Australia';
      acc4.BillingState = 'TestStateAU1';
      acc4.BillingStreet = 'TestStreet4';
      acc4.BillingPostalCode = '2055';
      acc4.Theater__c = 'Australia';
      acc4.Territory__c = 'NACFederal';
      acc4.Status__c = 'Contract Pending';
      acc4.Country_Domain__c='cvar-au';
      insert acc4;

      accountToInsert.add(acc4);

      //Residential Account - AU
      Account acc5 = new Account();
      acc5.name='TestAccount5';
      acc5.RSM__c = null;
      acc5.Type = 'Authorized-Partner-Residential';
      acc5.BillingCity = 'SYDNEY';
      acc5.BillingCountry = 'Australia';
      acc5.BillingState = 'TestStateAU2';
      acc5.BillingStreet = 'TestStreet5';
      acc5.BillingPostalCode = '2055';
      acc5.Theater__c = 'Australia';
      acc5.Territory__c = 'NACFederal';
      acc5.Status__c = 'Contract Pending';
      acc5.Country_Domain__c='rvar-au';
      insert acc5;

      accountToInsert.add(acc5);

      //Combo Account - AU
      Account acc6 = new Account();
      acc6.name='TestAccount6';
      acc6.RSM__c = null;
      acc6.Type = 'Authorized-Partner-Combo';
      acc6.BillingCity = 'SYDNEY';
      acc6.BillingCountry = 'Australia';
      acc6.BillingState = 'TestStateAU3';
      acc6.BillingStreet = 'TestStreet6';
      acc6.BillingPostalCode = '2055';
      acc6.Theater__c = 'Australia';
      acc6.Territory__c = 'NACFederal';
      acc6.Status__c = 'Contract Pending';
      acc6.Country_Domain__c='combo-au';
      insert acc6;

      accountToInsert.add(acc6);

      if(!accountToInsert.isEmpty()){
        for(Account acc: accountToInsert){
          accountMap.put(acc.Id,acc);
        }
      }

      AccountManagement.beforeAccountInsert(accountToInsert);
      AccountManagement.afterAccountInsert(accountToInsert);

      acc6.BillingCity = 'SYDNEY';
      update acc6;
      AccountManagement.afterAccountUpdate(accountToInsert,accountToInsert);
      AccountManagement.beforeAccountUpdate(accountToInsert,accountToInsert,accountMap);

   }     
}