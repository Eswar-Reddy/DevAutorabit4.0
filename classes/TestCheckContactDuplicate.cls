public class TestCheckContactDuplicate{ 
  public static void createContacts() {
    Contact contact = new Contact();
    contact.FirstName = 'Test';
    contact.LastName = 'Duplicate';
    insert contact;   
  }
    
  @isTest  
  public static void testCheckContactDuplicate(){
    createContacts();
        
    Contact contactDuplicateCheck2 = new Contact (FirstName='Test', LastName='Duplicate2');    
    insert contactDuplicateCheck2;

    Contact contactDuplicateCheck3 = new Contact(FirstName='Test',LastName='Duplicate',Override_Duplicate_Check__c=TRUE);  
    insert contactDuplicateCheck3;
  } 
}