/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- Prakash Gyamlani
**Last Modified On- June 20 2009  
**Desciption- Test class for controller UserManagement
*****************************************************/
@isTest
private class TestUserManagement {
  
    @isTest
  public static void Test_UserUpdate(){
     try {
        Set<ID> uIds = new Set<ID>();
        Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
        acct.Type ='Commercial';
        acct.BillingCity = 'san mateo';
        acct.BillingStreet = 'Concar drive';
        acct.BillingPostalCode ='94402';
        acct.BillingCountry = 'USA';        
        insert acct;
        
        Contact cont = new Contact (firstname='test' ,lastname= 'test');
        cont.Email= 'hello@world.com';
        cont.accountId=acct.Id;
        insert cont;
        
        acct.isPartner= true;
        upsert acct;

        String username ='hello1@world.com';        
        User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        } 
        Test.stopTest();  
      } catch (Exception ex) {}
    }//Function ends
    
    
    /***********Test Method for User Before Insert and Update ************/
        @isTest
        public static void Test_UserInsertUpdate(){
          try {
             // isTestPurpose = true;

            Account acct = new Account(name= 'test2221' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-us';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            acct.isPartner =true;
            update acct;
            Contact cont = new Contact (firstname='test' ,lastname= 'test');
            cont.Email= 'hello1010@test.com';
            cont.accountId=acct.Id;
            insert cont;
            acct.isPartner= true;
            upsert acct;
            String username ='hello1010@world.com';
            User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo123';
            user.Country_Domain__c ='rvar-fr';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
               Test.startTest();
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }

           Test.stopTest();
            //isTestPurpose =false;
          } catch (Exception ex) {}
       }

    
    /***********Test Method for User Before Insert and Update ************/
 
 @isTest
   public static void Test_UserInsertUpdate1(){
        try {
            Account acct = new Account(name= 'te2221' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h101010@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'rvar-it';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
       } catch (Exception ex) {}
   }

 @isTest
   public static void Test_UserInsertUpdate2(){
       try {
            Account acct = new Account(name= 'te231' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h101011@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'rvar-us';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}  
   }

 @isTest
   public static void Test_UserInsertUpdate3(){
       try {
            Account acct = new Account(name= 'te22231' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h11101@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'rvar-de';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}
   
   }

 @isTest
   public static void Test_UserInsertUpdate4(){
        try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello01011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h10101@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-us';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }            
            Test.stopTest();
       } catch (Exception ex) {}
   
   }

 @isTest
   public static void Test_UserInsertUpdate5(){
       try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h210101@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-es';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
       } catch (Exception ex) {}
   
   }
 @isTest
   public static void Test_UserInsertUpdate6(){
        try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h101013@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-fr';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}
   }
 @isTest
   public static void Test_UserInsertUpdate7(){
       try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h23210101@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'rvar-es';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}
   
   }
 @isTest
   public static void Test_UserInsertUpdate8(){
       try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h1110101@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-fr';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}
   
   }

@isTest
   public static void Test_UserInsertUpdate9(){
       try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            insert cont;
            String username ='h1010155@world.com';
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-it';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
        } catch (Exception ex) {}
   
   }
   
   @isTest
   public static void Test_UserInsertUpdate10(){
       try {
            Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            acct.isPartner =true;
            update acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011170210@test.com';
            cont.accountId=acct.Id;
            insert cont;
            Contact cont2 = new Contact (firstname='test112' ,lastname= 'test112');
            cont2.Email= 'hello1011@tes2t.com';
            cont2.accountId=acct.Id;
            insert cont2;
            String strUnique = string.valueOf(DateTime.now()).replace('-','').replace(':','');
            String username ='h1010199@world.com';            
            List<User> uList = new List<User>();            
            User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-de';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                //insert user;
                uList.add(user);
            }
            //String strUnique = string.valueOf(DateTime.now()).replace('-','').replace(':','');
            username= 'g170210@gg.com';
            
            User user2 = new User(LastName = 'Hello2211'+String.ValueOf(DateTime.Now()) ,FirstName = 'W1'+         String.ValueOf(DateTime.Now()));
            user2.ContactId = cont2.Id;
            user2.Username = username;
            user2.Alias = 'yo2322';
            user2.Country_Domain__c = 'cvar-de';
            user2.CommunityNickname = username.subString(0,6);
            user2.TimeZoneSidKey = 'America/Los_Angeles';
            user2.EmailEncodingKey = 'ISO-8859-1';
            user2.LanguageLocaleKey = 'en_US';
            user2.Email = cont2.Email;
            user2.LocaleSidKey = 'en_US';
           // Test.startTest();
            lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user2.ProfileId = lstProfile[0].Id;
                //insert user;
                uList.add(user2);
            }
            if(uList.size()>0){
            	insert uList;
            }
            Test.stopTest();
       } catch (Exception ex) {}
   
   }

 @isTest
   public static void Test_UserInsertUpdate11(){
   		
           List<User> uList =[select Id,Name,Contact.AccountID,Contact.Account.Country_Domain__c from User where contactID != null and Contact.Account.isPartner =true and Usertype = 'PowerPartner' LIMIT 1];
           if(uList != null && uList.size()>0){
               User user = uList[0];
               Account acct = [select Country_Domain__c from Account where ID =:user.Contact.AccountID];
               acct.Country_Domain__c ='rvar-us';
               update acct;
        		Test.startTest();       
                   //update user;
        		Test.stopTest();
           }
           
    }  
    
@isTest
   public static void Test_UserInsertUpdate12(){
           List<User> uList =[select Id,Name,Contact.AccountID,Contact.Account.Country_Domain__c from User where contactID != null and Contact.Account.isPartner =true and Usertype = 'PowerPartner' LIMIT 1];
           if(uList != null && uList.size()>0){
               User user = uList[0];
               Account acct = [select id,name,Country_Domain__c from Account where ID =:user.Contact.AccountID];
               System.debug('Prak Test:::Account Name is::'+acct.Name);
               acct.Country_Domain__c =null;
               update acct;
               Test.startTest();
                  update user;
               Test.stopTest();
           }
   
   }
   

   @isTest
   public static void Test_UserManagement13(){
     Set<Id> setIds = new Set<Id>();
     setIds.add(UserInfo.getUserId());           
   }
   @isTest
   public static void Test_UserManagement14(){
   		try {
   			Account acct = new Account(name= 'te22244' + String.ValueOf(DateTime.Now()));
     		acct.Country_Domain__c = 'rvar-es';
     		acct.Type ='Commercial';
     		acct.BillingCity = 'san mateo';
	        acct.BillingStreet = 'Concar drive';
	        acct.BillingPostalCode ='94402';
	        acct.BillingCountry = 'USA'; 
            insert acct;
            acct.isPartner =true;
            update acct;
            Contact cont = new Contact (firstname='test11' ,lastname= 'test11');
            cont.Email= 'hello1011@test.com';
            cont.accountId=acct.Id;
            cont.Partner_Portal_User__c =null;
            insert cont;
            String strUnique = string.valueOf(DateTime.now()).replace('-','').replace(':','');
            String username ='h1010144@world.com';
            User user = new User(LastName = 'Hello22212'+String.ValueOf(DateTime.Now()) ,FirstName = 'W2'+         String.ValueOf(DateTime.Now()));
            user.ContactId = cont.Id;
            user.Username = username;
            user.Alias = 'yoo12322';
            user.Country_Domain__c = 'cvar-de';
            user.CommunityNickname = username.subString(0,7);
            user.TimeZoneSidKey = 'America/Los_Angeles';
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.Email = cont.Email;
            user.LocaleSidKey = 'en_US';
            Test.startTest();
            List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
            if(lstProfile.Size()>0){
                user.ProfileId = lstProfile[0].Id;
                insert user;
            }
            Test.stopTest();
            
            UserManagement.updateContact(new List<User>{user});
	    } catch (Exception ex) {}
   }
   //
       
}