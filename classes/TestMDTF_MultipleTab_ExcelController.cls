/**************************************************
**Created By- Debasish Paul
**Created On- October 14 2016
**Case 00505731-Pivotal #114607243 - Release 45
**Desciption- Test class for controller MDTF_MultipleTab_ExcelController
*****************************************************/

@isTest 
public class TestMDTF_MultipleTab_ExcelController {
	
public static testMethod void checkMDTF_MultipleTab_ExcelController(){ 
    Test.startTest();
    //String xmlheader1;
    /*{
                get {
                String strHeader = '';
                strHeader += '<?xml version="1.0"?>';
                strHeader += '<?mso-application progid="Excel.Sheet"?>';
                return strHeader;
            }
    }*/
    Account accountObj = new Account();
    accountObj.Name = 'Test' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'san mateo';
    accountObj.BillingStreet = 'Concar drive';
    accountObj.BillingPostalCode ='94402';
    accountObj.BillingCountry = 'USA';
    
    accountObj.ShippingCity = 'san mateo';
    accountObj.ShippingStreet = 'Concar drive';
    accountObj.ShippingPostalCode ='94402';
    accountObj.ShippingCountry = 'USA'; 
    
    accountObj.Oracle_County__c = 'USA';
    
    insert accountObj;
    Test.stopTest();   
   
    ApexPages.CurrentPage().getParameters().put('Id', accountObj.Id);
    //ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);    
    MDTF_MultipleTab_ExcelController testObj = new MDTF_MultipleTab_ExcelController();
  }
}