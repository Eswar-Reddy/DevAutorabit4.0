/***********************************************
***Created By- Kapil Goutam
***Created On- May 30 2009 
***Last Modified By - 
***Last Modified On- 
***Description- Test Class for PartnerActivationChecklistController class
*************************************************
***********************************************/
public class TestPartnerActivationChecklist {
    @istest
    public static void test_checklist(){
        Account acc  = new Account();
        acc.Name = 'Test Account' + String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
      acc.BillingStreet = 'Concar drive';
      acc.BillingPostalCode ='94402';
      acc.BillingCountry = 'USA'; 
        insert acc;
        
        Contact contact = new Contact();
        contact.FirstName =  'Test Contact F Name' + String.valueOf(DateTime.Now());
        contact.LastName =  'Test Contact L Name' + String.valueOf(DateTime.Now());
        contact.AccountId = acc.Id;
        insert contact;
        
        ApexPages.Standardcontroller con = new Apexpages.Standardcontroller(acc);
        Apexpages.currentPage().getParameters().put('id', acc.id);
        PartnerActivationChecklistController chklist = new PartnerActivationChecklistController(con);
        chklist.quickSaveChecklist();
        chklist.saveChecklist();
        
        TestAccountManagement.Test_TerminatedAccountUpdate();
        //TestAccountManagement.Test_CertificationManagement();
        Certification__c certification = new Certification__c();
        certification.Account__c = acc.Id;
        //certification.Contact__c = contact.Id; 
        insert certification;
        
    }
}