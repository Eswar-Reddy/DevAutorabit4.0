/**************************************************************************************************************
** PR-02084
**Created By- Kapil Goutam (Appirio)
**Created On- June 30, 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test Class for My_SubscriptionsController
**************************************************************************************************************/
@isTest //MAM 24.APR.2015 - Moved isTest prefix for the test class 
public class TestMy_SubscriptionsController {
    
    //@isTest
    public static testMethod void Test_My_SubscriptionsController(){ //MAM 24.APR.2015 - Moved isTest prefix for the test class 
        //TestUserManagement.Test_UserInsertUpdate();
        //TestAccountManagement.Test_AccountUpdate();
        //TestAccountManagement.Test_CertificationManagement();
        
        //create Account
        Account acc = new Account(Name='TestAcc');
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
      acc.BillingStreet = 'Concar drive';
      acc.BillingPostalCode ='94402';
      acc.BillingCountry = 'USA'; 
        insert acc;
        //Create Contact
        Contact con = new Contact(lastname='Testlast'+String.valueOf(datetime.now()),AccountID=acc.id);
        insert con;
        
        Test.startTest();
        List<User> lstUser;
        lstUser  = new List<User>([select id,userName from User where Profile.Name ='Partner Delegated Administrator' and isActive = true LIMIT 1]);
        User u = null;
        if(lstUser.Size()>0){
            u = lstUser.get(0);
        }
        if(u != null){        
          system.runAs(u){
            Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(new User());
            My_SubscriptionsController obj = new My_SubscriptionsController(controller);
            User currentUser = obj.getCurrentUser();            
            obj.save();
          }
        }
        Test.stopTest();                       
    }
}