/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Class SetPartnerLogoController
*****************************************************/

public class TestSetPartnerLogoController
{
    @isTest
    private static void Test_SetPartnerLogoController()
    {
        Account accObj = new Account(Name='TestAccountName',Partner_Logo__c='TestLogo');
        accObj.Type ='Commercial';
        accObj.BillingCity = 'san mateo';
	    accObj.BillingStreet = 'Concar drive';
	    accObj.BillingPostalCode ='94402';
	    accObj.BillingCountry = 'USA'; 
        insert accObj;
        
        Attachment attachObj = new Attachment();
        attachObj.ParentId = accObj.Id;
        attachObj.Name = 'Image';
        attachObj.Body = blob.valueOf('Test String attachment');
        attachObj.ContentType = 'image/jpg';        
        insert attachObj;     
        
        Apexpages.Standardcontroller sController = new ApexPages.Standardcontroller(accObj);
        SetPartnerLogoController controller = new SetPartnerLogoController(sController);
        PageReference page ;
        controller.imageName='TestImage';
        controller.logo = blob.valueOf('Test String attachment');         
        page = controller.save();
        page = controller.setPartnerLogo();          
        
        accObj.Status__c = 'Terminated';
        update accObj;
    }
}