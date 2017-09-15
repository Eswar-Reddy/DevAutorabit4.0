/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- may 13 2009
**Last Modified- Anuradha Suthar
**Last Modified On- July 23 2009   
**Desciption- Test class for Controller DuplicateContactCheck
*****************************************************/
public class TestDuplicateContactCheck{
  
  @isTest
  public static void checkDuplicateContactCheck(){
    //set test data
    Account accountObj = new Account();
    accountObj.Name = 'Testing purpose account';
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;    
    
    List<Contact> lstContact = new List<Contact>();    
    Contact contact1 = new Contact();
    contact1.AccountId = accountObj.Id;
    contact1.FirstName = 'testContact';
    contact1.LastName = 'testContact';
    contact1.Email = 'testcheck@testing.com';
    contact1.Phone = '123456';      
    lstContact.add(contact1);
    insert contact1;
    String testStr= DuplicateContactCheck.processRecords(lstContact,contact1);
  }
}