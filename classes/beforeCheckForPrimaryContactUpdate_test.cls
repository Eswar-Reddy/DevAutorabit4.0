@isTest
public class beforeCheckForPrimaryContactUpdate_test {

    private static Account setupTestAccount() {
        Account a = new Account(Name='Test Account',
                                BillingStreet='Test Street',
                                BillingCity='Test City',
                                BillingCountry='Test Country',
                                BillingPostalCode='12345');
                                  
        return a;
    }
    
    
    private static Contact setupTestContact(Account a) {        
        Id conRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Contact.SobjectType).get('Customer');        
        
        Contact c = new Contact(LastName='Contact',
                                FirstName='Test',
                                RecordTypeId = conRecTypeId,
                                Primary__c = true,
                                Phone = '1234567890',
                                MailingStreet='Test Street',
                                MailingCity='Test City',
                                MailingCountry='Test Country',
                                MailingPostalCode='12345',
                                AccountId=a.Id);                                
        
        return c;
    }

    private static testMethod void updateContactTest1() {
        //setting up account and contact records for testing... 
        Account a = setupTestAccount();
        
        insert a;
        
        Contact c = setupTestContact(a);
        
        insert c;                    
        //end of initial setup of account and contact records
        
        //setup conditions related to this test method
                      
        Test.startTest();
        
        try {
            c.isUpdatedFromAccount__c = false;             
            c.Phone = '0987654321'; 
            c.MailingStreet='Test Street 2';
            c.MailingCity='Test City 2';
            c.MailingCountry='Test Country 2';
            c.MailingPostalCode='12346'; 
        
            update c;
        } catch (DMLException e) {
        } 
        Test.stopTest();    
        
        Contact c2 = [SELECT Phone
                      FROM Contact
                      WHERE AccountId =: a.Id
                      LIMIT 1];
                      
        System.assertEquals(c2.Phone, '1234567890', 'The contact record should not have updated.');          
    } 
    
    private static testMethod void updateContactTest2() {
        Account a = setupTestAccount();
        
        insert a;
        
        Contact c = setupTestContact(a);                
                
        insert c;
        
        Test.startTest();
        c.isUpdatedFromAccount__c = true;             
        c.Phone = '0987654321';
            
        update c;
        Test.stopTest();                      
    }       
}