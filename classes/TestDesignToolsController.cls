/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for controller DesignToolsController
********************************************************
*****************************************************/

@isTest
private class TestDesignToolsController{     
    /*COMMENTED 
    @isTest
    public static void Test_DesignToolsController1(){
      Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
      insert acct;
      
      Contact cont = new Contact (firstname='test' ,lastname= 'test');
      cont.Email= 'hello@world.com';
      cont.accountId=acct.Id;
      insert cont;
        
      acct.isPartner= true;
      upsert acct;
      
      String username ='hello@world.com';
      User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
      user.ContactId = cont.Id;
      user.Username = username;
      user.Alias = 'yoo';
      user.CommunityNickname = username.subString(0,7);
      user.Email = cont.Email;
      user.EmailEncodingKey = 'ISO-8859-1';
      user.TimeZoneSidKey = 'Europe/Paris';      
      user.LanguageLocaleKey = 'es';      
      user.LocaleSidKey = 'es';
      List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Delegated Administrator'];
      if(lstProfile.Size() > 0){
        user.ProfileId = lstProfile[0].Id;
        //insert user;
      }
      insert user; 
      Test.startTest();      
      System.runAs(user){
        DesignToolsController controller = new DesignToolsController();        
        String s = controller.getUserLocale();        
        String s2 = controller.currentSessionID;       
        //controller.getUserDomain();
        //String s3 = controller.currentOrgID;
        //String s5 = controller.getTTL();
        String s6 = controller.getBAS();
        //Boolean b = controller.getSFVisible();
        //Boolean b1 = controller.getECVisible();
        //Boolean b2 = controller.getSPVisible();
      }
      Test.stopTest();
    }    
    
    //@isTest
    public static void Test_DesignToolsController2(){
      Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
      insert acct;
      
      Contact contnext = new Contact (firstname='testNext' ,lastname= 'testNext');
      contnext.Email= 'hellos@world.com';
      contnext.accountId=acct.Id;
      insert contnext ;
      
      String usernameNext ='helloNext@world.com';
      User userNext = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
      userNext.ContactId = contnext.Id;
      userNext.Username = usernameNext ;
      userNext.Alias = 'yoo';
      userNext.CommunityNickname = usernameNext.subString(0,9);
      userNext.Email = contnext.Email;
      userNext.EmailEncodingKey = 'ISO-8859-1';
      userNext.TimeZoneSidKey = 'America/Los_Angeles';      
      userNext.LanguageLocaleKey = 'de';      
      userNext.LocaleSidKey = 'de';
      List<Profile> lstProfileNext = [select Id from Profile where Name = 'Partner Delegated Administrator'];
      if(lstProfileNext.Size()>0){
        userNext.ProfileId = lstProfileNext[0].Id;
        //insert userNext;
      }   
      insert userNext;  
      Test.startTest();   
      System.runAs(userNext){
        DesignToolsController controller = new DesignToolsController();
        //controller.strLocale = 'en_US';
        String s = controller.getUserLocale();
        //String s1 = controller.stringSizerBaseURL;
        String s2 = controller.currentSessionID;
        //controller.strLocale='estsgss';
        String s3 = controller.currentOrgID;
        String s5 = controller.getTTL();
        String s6 = controller.getBAS();
        Boolean b = controller.getSFVisible();
        Boolean b1 = controller.getECVisible();
        Boolean b2 = controller.getSPVisible();
      }
      Test.stopTest();
    }
    
    //@isTest
    public static void Test_DesignToolsController3(){
      Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
      insert acct;
      
      Contact contnext1 = new Contact (firstname='testNext1' ,lastname= 'testNext1');
      contnext1.Email= 'hellos1@world.com';
      contnext1.accountId=acct.Id;
      insert contnext1 ;
      
      String usernameNext1 ='helloNext1@world.com';
      User userNext1 = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
      userNext1.ContactId = contnext1.Id;
      userNext1.Username = usernameNext1 ;
      userNext1.Alias = 'yoo';
      userNext1.CommunityNickname = usernameNext1.subString(0,10);
      userNext1.Email = contnext1.Email;
      userNext1.EmailEncodingKey = 'ISO-8859-1';
      userNext1.TimeZoneSidKey = 'Europe/Amsterdam';      
      userNext1.LanguageLocaleKey = 'it';      
      userNext1.LocaleSidKey = 'it';
      List<Profile> lstProfileNext1 = [select Id from Profile where Name = 'Partner Delegated Administrator'];
      if(lstProfileNext1.Size()>0){
        userNext1.ProfileId = lstProfileNext1[0].Id;
        //insert userNext1;
      }
      insert userNext1;    
      Test.startTest();    
      System.runAs(userNext1){
        DesignToolsController controller = new DesignToolsController();
        //controller.strLocale = 'it';
        String s = controller.getUserLocale();
        //String s1 = controller.stringSizerBaseURL;
        String s2 = controller.currentSessionID;
        //controller.strLocale='estsgss';
        String s3 = controller.currentOrgID;
        String s5 = controller.getTTL();
        String s6 = controller.getBAS();
        Boolean b = controller.getSFVisible();
        Boolean b1 = controller.getECVisible();
        Boolean b2 = controller.getSPVisible();
      }
      Test.stopTest();
    }
    END COMMENT*/
    
    @isTest
    public static void Test_DesignToolsController4(){
      /***User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'es' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
      }
      ***/
      User user =[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive  =true Limit 1] ;
      if(user == null){
         Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'test1239990@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed in DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }
    
    @isTest
    public static void Test_DesignToolsController5(){
      /**User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'de' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
      }
      ****/
      User user =[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive  =true Limit 1] ;
      if(user == null){
       Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testA123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          String s7 = controller.getSpTabName();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed the method name in DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }
    
    @isTest
    public static void Test_DesignToolsController6(){
      /**User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'it' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
      }****/
      User user =[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive  =true Limit 1] ;
      if(user == null){
       Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed in the DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }
    
     @isTest
    public static void Test_DesignToolsController7(){
      /**User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'it' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
      }****/
      User user = null;
      for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true and LanguageLocaleKey = 'es' Limit 1] ){
        user=u;
      }
      if(user == null){
        for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true Limit 1] ){
            user=u;
            user.LanguageLocaleKey = 'es';
            update user; 
        }
      }
      if(user == null){
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed in the DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }
    
    @isTest
    public static void Test_DesignToolsController8(){
      /**User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'it' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
      }****/
      User user = null;
      for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true and LanguageLocaleKey = 'de' Limit 1] ){
        user=u;
      }
      if(user == null){
        for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true Limit 1] ){
            user=u;
            user.LanguageLocaleKey = 'de';
            update user; 
        }
      }
      if(user == null){
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed in the DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }

    @isTest
    public static void Test_DesignToolsController9(){
      /**User userObj;
      List<User> lstUser = new List<User>();
      lstUser = [select Id, EmailEncodingKey, TimeZoneSidKey, LanguageLocaleKey, LocaleSidKey from User where LocaleSidKey = 'it' Limit 1];
      if(lstUser.size() > 0){
        userObj = lstUser[0];
        ****/
      User user = null;
      for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true and LanguageLocaleKey = 'it' Limit 1] ){
        user=u;
      }
      if(user == null){
        for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true Limit 1] ){
            user=u;
            user.LanguageLocaleKey = 'it';
            update user; 
        }
      }
      if(user == null){
       Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now()); 
        accountObj.Type ='Commercial';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
    
         String username= 'test123@yahoo.com';
         user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;        
         }
      }
      Test.startTest();    
      if(user != null){
        System.runAs(user){
          DesignToolsController controller = new DesignToolsController();          
          String s = controller.getUserLocale();          
          String s2 = controller.currentSessionID;          
          String s3 = controller.currentOrgID;
          String s5 = controller.getTTL();
          String s6 = controller.getBAS();
          Boolean b = controller.getSFVisible();
          Boolean b1 = controller.getECVisible();
          //Boolean b2 = controller.getSPVisible(); changed in the DesignToolsController
          Boolean b2 = controller.getSmartPackVisible();
        }
      }
      Test.stopTest();
    }
    
    @isTest
    public static void Test_DesignToolsController10(){
        User user = null;
        for(User u :[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true and LanguageLocaleKey = 'it' Limit 1]){
            user =u;
        }
        if(user == null){
            for(User u :[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true Limit 1]){
                user =u;
                user.LanguageLocaleKey='it';
                update user;
            }
        }
        Test.startTest();    
        if(user != null){
            System.runAs(user){
                DesignToolsController controller = new DesignToolsController();
                String st = controller.getTTL();
                System.assert( st != null);
            }
        }
        Test.stopTest();
    }
      
    @isTest
    public static void Test_DesignToolsController11(){
    User user = null;
      for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true and LanguageLocaleKey = 'it' Limit 1] ){
        user=u;
      }
      if(user == null){
        for(User u:[select id,Name from User where Profile.Name ='Partner Delegated Administrator' and contactID != null and isActive =true Limit 1] ){
            user=u;
            user.LanguageLocaleKey = 'it';
            update user; 
        }
      }
        String st;
        Test.startTest();    
        if(user != null){
            System.runAs(user){
                DesignToolsController controller = new DesignToolsController();
                st = controller.getInitPage();
                System.assert( st != null);
                st = controller.getUserDomain();
                System.assert( st != null);
                st = controller.getProfileName();
                System.assert( st != null);
                st = controller.designToolsBaseURL;
                System.assert( st != null);
            }
        }
        Test.stopTest();
    }
    //Creating German User
    @isTest
    public static void Test_DesignToolsController12(){
    
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        accountObj.BillingCity = 'Xanten';
        accountObj.BillingCountry = 'German';
        accountObj.BillingStreet = 'acb';
        accountObj.BillingPostalCode = '12311';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
     
      
         String username= 'test123@yahoo.com';
         User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.division='IT';
         user.country='Germany';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'Europe/Berlin';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'de';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'de_DE';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Executive' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            User u = [select Id from User where Profile.Name = 'System Administrator' and Id != :Userinfo.getUserId() and isactive = true LIMIT 1];
            system.runAs(u){
                insert user;
                Test.startTest();    
                System.runAs(user){
                    String st;  
                    DesignToolsController controller = new DesignToolsController();
                    st = controller.getInitPage();
                    System.assert( st != null);
                    st = controller.getUserDomain();
                    System.assert( st != null);
                    st = controller.getProfileName();
                    System.assert( st != null);
                    st = controller.designToolsBaseURL;
                    System.assert( st != null);
                    st = controller.getTTL();
                    st = controller.getBAS();
                } 
                Test.stopTest(); 
            }
           
        }  
         
   }
   //Creating Italian User
   @isTest
    public static void Test_DesignToolsController13(){
    
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        accountObj.BillingCity = 'Rome';
        accountObj.BillingCountry = 'Italy';
        accountObj.BillingStreet = 'acb';
        accountObj.BillingPostalCode = '12311';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
     
      
         String username= 'test123@yahoo.com';
         User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.division='IT';
         user.country='Italy';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'Europe/Rome';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'it';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'it';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Executive' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            User u = [select Id from User where Profile.Name = 'System Administrator' and Id != :Userinfo.getUserId() and isactive = true LIMIT 1];
            system.runAs(u){
                insert user;
                Test.startTest();    
                System.runAs(user){
                    String st;  
                    DesignToolsController controller = new DesignToolsController();
                    st = controller.getInitPage();
                    System.assert( st != null);
                    st = controller.getUserDomain();
                    System.assert( st != null);
                    st = controller.getProfileName();
                    System.assert( st != null);
                    st = controller.designToolsBaseURL;
                    System.assert( st != null);
                    st = controller.getTTL();
                    st = controller.getBAS();
                } 
                Test.stopTest(); 
            }
           
        }  
         
   }
  // Creating User For France
   @isTest
    public static void Test_DesignToolsController14(){
    
        Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        accountObj.BillingCity = 'Paris';
        accountObj.BillingCountry = 'France';
        accountObj.BillingStreet = 'acb';
        accountObj.BillingPostalCode = '12311';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
     
      
         String username= 'test123@yahoo.com';
         User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testB123@yahoo.com';
         user.division='IT';
         user.country='France';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'Europe/Paris';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'fr';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'fr';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Executive' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            User u = [select Id from User where Profile.Name = 'System Administrator' and Id != :Userinfo.getUserId() and isactive = true LIMIT 1];
            system.runAs(u){
                insert user;
                Test.startTest();    
                System.runAs(user){
                    String st;  
                    DesignToolsController controller = new DesignToolsController();
                    st = controller.getInitPage();
                    System.assert( st != null);
                    st = controller.getUserDomain();
                    System.assert( st != null);
                    st = controller.getProfileName();
                    System.assert( st != null);
                    st = controller.designToolsBaseURL;
                    System.assert( st != null);
                    st = controller.getTTL();
                    st = controller.getBAS();
                } 
                Test.stopTest(); 
            }
           
        }  
         
   }
    /*
    public static User GetExistingPartnerUser() {
        List<User> userList = new List<User>([select Id  from User where Profile.Name = 'EU Partner Sales']);
        User partnerUser = null;
        if(userList.Size()>0){
            partnerUser = userList.get(0);
        }
        return partnerUser;        
    }*/
}