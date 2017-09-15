/*********************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller ContactManagement
*****************************************************/

public class TestContactManagement{
  
  @isTest
  public static void Test_TerminatedContactUpdate(){
   Test.StartTest();
    //set test data
   
    Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'banga';
    accountObj.BillingCountry = 'France';
    accountObj.BillingStreet = 'btm';
    accountObj.BillingPostalCode = '12311';
    accountObj.Sic = '0111';
    accountObj.Theater__c = 'Europe';
    accountObj.Territory__c = 'France';
    insert accountObj;
   
    
   
    Contact contactObj = new Contact();
    contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
    contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
    contactObj.AccountId = accountObj.Id;
    contactObj.LMS_Role__c='B-Owner/Training Liaison';
    insert contactObj;
   
      
    Certification__c certificationObj = new Certification__c();
    certificationObj.Account__c = accountObj.Id;
    //certificationObj.Contact__c = contactObj.Id;
    insert certificationObj;    
    
   
    
    
    
    
    contactObj.Terminated__c = true;
    //update contactObj;
    
    List<Contact> lstContact = new List<Contact>();
    lstContact.add(contactObj);
    ContactManagement.afterContactUpdate(lstContact, lstContact);
    
   
    
    
    ContactManagement.afterContactInsert(lstContact );
    ContactManagement.beforeContactUpdate (new Map<Id,Contact> (lstContact ),lstContact  );
    ContactManagement.validateLMSFunction(lstContact );
        
    ContactManagement.populateSupervisorForLMSFunction(lstContact ,lstContact );
    ContactManagement.updateSubscription (new Map<Id,Contact> (lstContact ),lstContact );
    
    //TestCheckContactDuplicate.testcheckContactDuplicate();
    //TestCertificationManagement.checkCertificationManagement();
    //TestAccountManagement.Test_AccountUpdate();
    Test.StopTest();
  } 
  

  
  @isTest
  public static void Test_TerminatedContactUpdate1(){
   List<Contact> lstContact = new List<Contact>();
    Map<Id,contact> conMap = new Map<Id,contact>();
    Contact contactObj = new Contact();
    //set test data
    try{
    Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'banga';
    accountObj.BillingCountry = 'France';
    accountObj.BillingStreet = 'btm';
    accountObj.BillingPostalCode = '12311';
    accountObj.Sic = '0111';
    accountObj.Theater__c = 'Europe';
    accountObj.Territory__c = 'France';
   
    insert accountObj;
   
    
   
    
    contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
    contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
    contactObj.AccountId = accountObj.Id;
    insert contactObj;
    
    AccountContactRole accContact = new AccountContactRole();
    accContact.accountId=accountObj.id;
    accContact.contactId=contactObj.id;
    accContact.role='Sales Manager';
    insert accContact;
    
    conMap = new Map<Id,contact>([select id,accountId,lastname,firstname from contact where id=:contactObj.id]);
   
    
    lstContact.add(contactObj);
      
    Certification__c certificationObj = new Certification__c();
    certificationObj.Account__c = accountObj.Id;
    insert certificationObj;    
    
    User user1=[select id from user where profile.name like 'system administrator' and isactive=true limit 1];
    
    system.runAs(user1){
    String username ='hellooo@world.com';
    User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
    user.Username = username;        
    user.Alias = 'yoo';  
    user.CommunityNickname = username.subString(0,7);
    user.TimeZoneSidKey = 'America/Los_Angeles';
    user.EmailEncodingKey = 'ISO-8859-1';
    user.LanguageLocaleKey = 'en_US';
    user.Email = 'testSharePartnerAccount@test.com';
    user.LocaleSidKey = 'en_US';
    user.isActive = true;
    
     List<Profile> lstProfile = [Select name, id From Profile  where Name like '%partner%' limit 1];
     if(lstProfile.Size()>0) { 
            for(Profile uProfile:lstProfile ){
                user.ProfileId = uProfile.id;
            }
            user.division='IT';
            user.country='USA';            
            user.ContactID = contactObj.id; 
            //insert user;
            Test.startTest();
            System.runAs(user){
                
                Contact updateContact = [select LMS_Role__c from contact where id=:contactObj.id];//new List<Contact>();
                updateContact.LMS_Role__c='B-Owner/Training Liaison';
                List<contact> newContactlst = new List<contact>();
                newContactlst.add(updateContact);
                ContactManagement.afterContactUpdate(newContactlst, lstContact);
                ContactManagement.validateLMSFunction(newContactlst);
                ContactManagement.updateSubscription(conMap,lstContact);
                Contact updateContactNew = [select LMS_Role__c from contact where id=:contactObj.id];//new List<Contact>();
                updateContactNew.LMS_Role__c='O-Owner';
                List<contact> newContactlst1 = new List<contact>();
                newContactlst1.add(updateContactNew);
                ContactManagement.afterContactUpdate(newContactlst1, newContactlst);
                }
                
            }
            Test.stopTest();
                
    }
   }
    catch(exception ex){} 
    
  }
  
}