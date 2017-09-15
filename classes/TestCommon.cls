/*********************************************************************
Name        : TestCommon 
Created On  : Nov 3, 2011
Created By  : Anjali Jain(Appirio Offshore)
Description : Common Test class 
History     : 1.0 Created   
**********************************************************************/
public class TestCommon {

  /*
        Create Partner Account(Customer) of Italy
    */
    public static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(name='test2'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Sitapura';
        acct.ShippingCountry = 'Italy';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302020';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Sitapura';
        acct.BillingCountry = 'Italy';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302020';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle2';
        acct.Theater__c = 'Europe';
        acct.CurrencyIsoCode='EUR';
        acct.Country_Domain__c = 'us';
        acct.Territory__c = 'Italy';
        acct.Type = 'Partner';
        //acct.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c; 
        return acct;                     
    }

    public static User getNAPartnerPortalUser(Account acct){
        User user = null;
       /* for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,
        Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,
        Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c,
         Contact.Account.Oracle_Account_Number__c ,Contact.Account.Lease2_0_Program_Partner__c,
        
        Contact.Account.Oracle_Customer_Classification__c,Contact.Account.Oracle_Warehouse__c,
        Contact.Account.Oracle_Account_Type__c,
        Contact.Account.Oracle_Order_Type__c
            
         from User where (Profile.Name = 'Partner Delegated Administrator') 
         and ContactID != null and Contact.Authorized_to_Order__c = true 
         and Contact.Account.Online_Order_Access__c = true 
         and Contact.Account.ShippingCountry != null 
         and Contact.Account.ShippingCity != null 
         and Contact.Account.ShippingStreet != null
          and Contact.Account.ShippingState != null 
          and Contact.Account.ShippingPostalCode != null 
and Contact.Account.Lease2_0_Program_Partner__c != null 
         and isActive=true LIMIT 1]) {
            user =u;
        }
        if(user != null) return user;
        */
        
        if(acct == null){
        	system.debug('** acct ' + acct);
            acct =  getPartnerAccount();
            acct.Oracle_Warehouse__c = 'ware1';
            insert acct;
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testcnbyPO2',LastName='testcnbyPO2');
        cont.Email ='t@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;   
         Test.startTest();     
        String username ='testcn22@world.com';
        user = new User(LastName = 'He222'+String.ValueOf(DateTime.Now()) ,FirstName = 'U'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.Edit_Partner_Users__c = true;
        user.LocaleSidKey = 'en_US'; 
        user.Country = 'US';
        user.Division = 'DD';
       // user.Partner_Role__c = 'Sales';   
     //   List<UserRole> lstRole = [select Id , Name from UserRole where Name like '%Partner User' LIMIT 1];
       // system.debug(' lstRole ' +lstRole);
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Delegated Administrator'];
        if(lstProfile.Size()>0 ){
            user.ProfileId = lstProfile[0].Id;
           // user.UserRoleId = lstRole[0].Id;  
            system.debug('** insering user 1111 ' + user);
            insert user;
        }
        Test.stopTest();
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, 
Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,
Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,
Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u; 
        return user;
        
    }
    
    public static User getEUPartnerPortalUser(Account acct){
        User user = null;
        /*for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,
        Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,
        Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c,
         Contact.Account.Oracle_Account_Number__c ,Contact.Account.Lease2_0_Program_Partner__c,
         
        Contact.Account.Oracle_Customer_Classification__c,Contact.Account.Oracle_Warehouse__c,
        Contact.Account.Oracle_Account_Type__c,
        Contact.Account.Oracle_Order_Type__c
            
         from User where (Profile.Name = 'EU Partner Delegated Administrator') and ContactID != null 
         and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true 
         and Contact.Account.ShippingCountry != null and Contact.Account.ShippingCity != null 
         and Contact.Account.ShippingStreet != null and Contact.Account.ShippingState != null 
         and Contact.Account.ShippingPostalCode != null 
         and isActive=true LIMIT 1]) {
            user =u;
        }
        if(user != null) return user;*/
        if(acct == null){
            acct =  getPartnerAccount();
            acct.Oracle_Warehouse__c = 'ware1';
            insert acct;
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;        
        Test.startTest();
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';  
        user.Edit_Partner_Users__c = true;  
        //user.Partner_Role__c = 'Sales'; 
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Delegated Administrator'];
       // List<UserRole> lstRole = [select Id , Name from UserRole where Name like '%Partner Executive' LIMIT 1];
        if(lstProfile.Size()>0 ){
            user.ProfileId = lstProfile[0].Id;
            //user.UserRoleId = lstRole[0].Id;  
        	system.debug('** insering user 2222 ' + user);
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        Test.stopTest();
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, 
Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,
Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,
Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u; 
        return user;
        
    }
    
     
      //Create Partner Portal user
     public static User getNXXXXXAPartnerPortalUser(Account acct){
        User user = null;   
           
        if(acct == null){
            acct =  getPartnerAccount();
        }
        acct.Lease2_0_Program_Partner__c = true;
       
        acct.Oracle_Warehouse__c = 'Wareh1';
        insert acct;
        
        Contact cont = new Contact(AccountID = acct.id,FirstName='testNA',LastName='testNA');
        cont.Email ='tNA@test.com';
        cont.Authorized_to_Order__c = true;
        cont.LMS_Role__c='O-Owner';
        cont.LMS_Job_ID__c='Sales';
        cont.Country_Domain__c = 'rvar-us'; 
        insert cont;        
       // User user = [Select id from user where id =: userInfo.getUserId()];  
        String username ='aj@test1.com';      
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'aj';
        user.Country = 'Italy';
        user.division = 'IT';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US'; 
        user.Email = cont.Email;
        user.Edit_Partner_Users__c = true;
        user.LocaleSidKey = 'en_US';   
       
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null) {
          for(User u:[select id,Name,contactId,Contact.AccountID, 
                Contact.Account.AccountNumber,Contact.Account.CurrencyIsoCode,
                Contact.Account.Name,
                Contact.Account.Country_Domain__c,
                Contact.Account.Theater__c,
                Contact.Account.ShippingStreet,
                Contact.Account.ShippingState,
                Contact.Account.ShippingCity,
                Contact.Account.ShippingCountry,
                Contact.Account.ShippingPostalCode,
                Contact.Account.Oracle_Operating_Unit__c,    
                Contact.Account.Oracle_Account_Number__c,
                Contact.Account.Lease2_0_Program_Partner__c,
               
                Contact.Account.Oracle_Warehouse__c,
                UserType,
                Profile.Name,
                IsPortalEnabled,
                Contact.Account.Primary_PSR__c,
                Contact.Account.BillingCountry 
                from User where id =:user.ID LIMIT 1]) {
                user = u; 
         }
        }
        return user;
        
    }
    
     //Create Partner Portal user     
  
  public static User getSysAdminUser() {
    
    Profile profile = [Select Id from Profile where Name = 'System Administrator' limit 1];

        User user = new User(LastName ='Test User1', ProfileId = profile.Id, 
        Username = 'Test1User@user.com', Email = 'Test1User@user.com');
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.country='USA'; 
        user.division= 'IT';
        user.Alias = 'yoo'+'1';
        user.Edit_Partner_Users__c = true;
        user.UserRoleId = UserInfo.getUserRoleId();
        insert user;
        return user;
   }

}