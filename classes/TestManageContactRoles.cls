//*********************************************************************
//Name : TestManageContactRoles
//Created On : 1st May, 2009
//Created By : Appirio (Aslam Bari)
//Implementation:
//Provide test class for controller ManageContactRoles
//**********************************************************************
public class TestManageContactRoles{
  
    @isTest
    static void TestManageContactRoles(){
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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(act);
        
        ManageContactRoles controller = new ManageContactRoles(sc);
        controller.AddMoreRoles();
        controller.getAllContactRoles()[0].IsDeleted = true;
        controller.getAllContactRoles()[1].IsDeleted = false;
        controller.getAllContactRoles()[1].AccountContactRole.ContactId = cnt.Id;
        controller.getAllContactRoles()[1].AccountContactRole.Role = role1.id;
        controller.getContactOptions();
        PageReference pg = controller.SaveRoles();
        System.assertNotEquals(pg,null);
        
        controller.getAllContactRoles()[1].IsDeleted = false;
        controller.getAllContactRoles()[1].AccountContactRole.ContactId = null;
        pg = controller.SaveRoles();
        
        act.Status__c = 'Terminated';
        update act;
        
        TestAccountManagement.Test_AccountUpdate();
    }    
}