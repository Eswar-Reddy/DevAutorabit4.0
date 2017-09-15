/**************************************************
** Case # 00039606
**Created By- Aashish Mathur
**Created On- Dec 12,2010
**Desciption- Test class for controller TestPartnerApplicationLinkController
*****************************************************/
	
public class TestPartnerApplicationLinkController {
	@isTest
  public static void testPALinkController(){
  	Lead leadObj = new Lead();  	
    
    //Check for Lead insert
    leadObj.FirstName = 'Test';
    leadObj.LastName = 'Commercial';
    leadObj.Lead_Type__c='Commercial';
    leadObj.Company = 'TEST Company A';
    leadObj.Country = 'North America';
    leadObj.Email = 'testEmail@test123.com';
    leadObj.Phone = '09829098290';
    leadObj.LeadSource = 'Web';
    insert leadObj;    
    
  	Test.startTest(); 
     ApexPages.StandardController controller = new ApexPages.StandardController(leadObj);
    PartnerApplicationLinkController testObj = new PartnerApplicationLinkController(controller);  
    testObj.createSpanishPA();
     testObj.createFrenchPA();    
     testObj.createGermanPA();
     testObj.createItalianPA(); 
    testObj.createAusPA();
     testObj.createCommPA();
     testObj.createResPA();  
    Test.stopTest();
  }
}