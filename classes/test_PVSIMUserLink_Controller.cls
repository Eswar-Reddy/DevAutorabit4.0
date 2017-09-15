@istest(seeAllData = true)
public class test_PVSIMUserLink_Controller
{                 
  /*  public static testmethod void test1()
    {           
            User Obj1 = createCustomerUser('pTest3@test.com', 'LastName1', true);            
                 
            System.runAs(Obj1){
                 
            PVSIMUserLink_Controller PVSIM_Obj = new PVSIMUserLink_Controller();
            PVSIM_Obj.isInvokedFromTestMethod = true;
            
            PVSIM_Obj.RedirectUser();
            PVSIM_Obj.checkUserForAccessKey();
            PVSIMUserLink_Controller.updateLoggedInUser(Obj1.Id, '2354234-24234-234234-234234');
         }        
    }
    
    
    public static testmethod void test2()
    {
       
            User Obj1 = createCustomerUser('Tesst43@test.com', 'LastName1', false);            
                 
            System.runAs(Obj1){                  
            PVSIMUserLink_Controller PVSIM_Obj = new PVSIMUserLink_Controller();
            PVSIM_Obj.isInvokedFromTestMethod = true;
            PVSIM_Obj.RedirectUser();
            PVSIM_Obj.checkUserForAccessKey();
        }        
    }
    
    public static testmethod void test3()
    {
       
            User Obj1 = createCustomerUser('pTest10@test.com', 'LastName1', false);          
                 
            System.runAs(Obj1){                
                PVSIMUserLink_Controller PVSIM_Obj = new PVSIMUserLink_Controller();
                PVSIM_Obj.RedirectUser();
            }        
    }  
    
      public static User createCustomerUser(String username, String lastName, boolean isAccessKeyNull){
        
        Account acc = new Account(Name = 'TestAcc1', type = 'Authorized-Partner-Combo', country_domain__c = 'cvar-us',
        CurrencyIsoCode = 'USD');
        database.insert(acc);
            
        String profileName = 'Partner Sales';

        String alias = username.split('@').get(0);
        
        Profile profile = [Select Id from Profile where Name=:profileName];
        
        Contact contact = new Contact(AccountId = acc.Id, LastName = lastName);
        insert contact;
        
        UserRole r = [select Id from UserRole where name = 'The Solar Company Partner User'];
        
        User user = new User(
            ContactId = contact.Id,
            Username = username,
            Email = username,
            LastName = lastName,
            Alias = alias,
            ProfileID = profile.Id,
            CommunityNickname = 'Test11231313213',
            UserRole = r,
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8',
            PVSIM_Access_Key__c = isAccessKeyNull ? null : '123414-123123-12398'   );
            
        insert user;
        
        return user;
    }  */
   
}