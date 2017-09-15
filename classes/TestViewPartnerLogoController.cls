/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller ViewPartnerLogoController
*****************************************************
*****************************************************/


public class TestViewPartnerLogoController
{
    @isTest
    private static void Test_ViewPartnerLogoController()
    {
        Account acc= new Account();
        acc.Name = 'Test' + DateTime.now();
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402'; 
        acc.BillingCountry = 'USA';
        insert acc;
        
             
        Apexpages.Standardcontroller sController;
        sController = new ApexPages.Standardcontroller(acc);
        ViewPartnerLogoController controller ;
        controller = new ViewPartnerLogoController(sController) ;

        String url;
        url = controller.getLogoURL();
        acc.Partner_Logo__c='TestLogo';
        update acc;
        url = controller.getLogoURL();
        controller.logoURL='TestUrl';        
    }
    
    @isTest
    public static void checkAccountManagement(){
      TestAccountManagement.Test_AccountUpdate();
      TestAccountManagement.Test_TerminatedAccountUpdate();    
      TestCertificationManagement.checkCertificationManagement();
      
    }
}