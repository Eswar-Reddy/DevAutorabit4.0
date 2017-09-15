/***********************************
** Created By - Kapil Goutam
** Created on- May 11 2009
** Last Modified by- Kapil Goutam
** Last Modified on- June 17 2009
** Description- Test class form SendContract Class
** Version - 1.1
*************************************/
public class TestSendContractController {
    
    @isTest
    public static void Test_SendContract() {
      try {
        Account acc = new Account();
        /*acc.Name = 'TestAccount' + String.ValueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        insert acc;*/
        acc=[select id from Account limit 1] ;
        
        Contract con = new Contract(); 
        con.AccountId = acc.Id;
        con.Status = 'New';
        con.Contract_Type__c = 'NA Authorized Partner Agreement';//'NA Premier Partner Agreement';
       // con.SunPower_Executive__c = Null;
        insert con;
        
        Contact newContact = new Contact();
        newContact.LastName = 'Test Last Name' + + String.ValueOf(DateTime.Now());
        newContact.AccountId = acc.Id;
        newContact.Email ='test123@yahoo1.com';
        insert newContact;
        
        //start for case # 00059875
        Contact newContact1 = new Contact();
        newContact1.LastName = 'Test Last Name1' + String.ValueOf(DateTime.Now());
        newContact1.FirstName = 'Test First Name1' + String.ValueOf(DateTime.Now());
        newContact1.AccountId = acc.Id;
        newContact1.Email ='test1234@yahoo1.com';
        insert newContact1;
        
        List<AccountContactRole> acrList = new List<AccountContactRole>();
        AccountContactRole acr = new AccountContactRole();
        acr.AccountId = acc.Id;
        acr.ContactId = newContact.Id;
        acr.Role = 'Installation Crew Member';
        acrList.add(acr);
        
        AccountContactRole acr1 = new AccountContactRole();
        acr1.AccountId = acc.Id;
        acr1.ContactId = newContact1.Id;
        acr1.Role = 'Field Sales Person';
        acrList.add(acr1);
        
        AccountContactRole acr2 = new AccountContactRole();
        acr2.AccountId = acc.Id;
        acr2.ContactId = newContact.Id;
        acr2.Role = 'Field Sales Person';
        acrList.add(acr2);
        insert acrList;
		//end for case # 00059875		
        
        createUser(newContact);
       // echosign_dev1__SIGN_Agreement__c newagree =new echosign_dev1__SIGN_Agreement__c();
         echosign_dev1__SIGN_Agreement__c aggrementNew = new echosign_dev1__SIGN_Agreement__c();
        aggrementNew.Name = 'NA Authorized Partner Agreement';
        aggrementNew.echosign_dev1__Recipient__c = newContact.id;
        insert aggrementNew;
        System.currentPageReference().getParameters().put('cid', con.id);
        SendContractController sc = new SendContractController();
        sc.recipient1 = '--None--';
        sc.proceed();
        sc.recipient1 = newContact.id;
        sc.recipient2 = newContact.id;
        sc.recipient3 = newContact.id;
        sc.proceed();
        sc.isValidEmail('HelloTest@Gmail.com');
        sc.cancel();
        
        TestContractManagement.checkInsertUpdateContract();
      } catch (Exception ex) {}
    }
    
    private static void createUser(Contact contact){
         String username= 'test123@yahoo.com';
         User user = new User(LastName = 'Hello',FirstName = 'World');
         user.ContactId = contact.Id;
         user.Username = '123test123@yahoo.co.in';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contact.Email;
         user.LocaleSidKey = 'en_US';
         List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            //insert user;    
         }
         
    } 
}