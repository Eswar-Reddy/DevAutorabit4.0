@isTest
public class TestAccountContactRolesNew{

  public static testMethod void testMyController() {
        
    
        Account act = new Account();
        act.Name = 'Test Account 1' +String.valueOf(DateTime.Now());
        act.Type ='Commercial';
        act.BillingCity = 'san mateo';
      act.BillingStreet = 'Concar drive';
      act.BillingPostalCode ='94402';
      act.BillingCountry = 'USA'; 
        insert act; 
        
        Contact cnt = new Contact();
        cnt.LastName = 'Test contact 1' +String.valueOf(DateTime.Now());
        cnt.AccountId = act.Id;
        insert cnt;
        
        Contact cnt2 = new Contact();
        cnt2.LastName = 'Test contact2';
        cnt2.AccountId = act.Id;
        insert cnt2;
        
        AccountContactRole role1 = new AccountContactRole();
        role1.AccountId = act.Id;
        role1.ContactId = cnt.id;
        insert role1;
        
        AccountContactRole role2 = new AccountContactRole();
        role2.AccountId = act.Id;
        role2.ContactId = cnt2.id;
        role2.isPrimary = true;
        insert role2;
        
        //Test.setCurrentPageReference(new PageReference('Page.AccountContactRoleNew')); 
        //System.currentPageReference().getParameters().put('accountId', act.id);
        
        PageReference tpageRef = Page.AccountContactRoleNew;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('accountId', act.Id);
        AccountContactRoleNew controller = new AccountContactRoleNew();
        controller.submit();
        
        
    }   

}