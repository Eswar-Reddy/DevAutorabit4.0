/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 10 2009 
**Last Modified- Kapil G.
**Last Modified On-  July 13 2009 
**Desciption- Test class for controller NewPartnerScorecardController
*****************************************************/
	@isTest
private class TestNewPartnerScorecardController{
	@isTest
  public static void checkNewPartnerScorecardController(){
  	String id = '';
    Partner_Application__c partnerAppObj = new Partner_Application__c();
    partnerAppObj.Solar_License_Certification__c = true;
    //partnerAppObj.Total_Employee_Base__c = 7;
    partnerAppObj.Existing_Pending_Litigation__c = false;
    partnerAppObj.Location_1__c = 'test location';
    partnerAppObj.Current_Industry__c = 'PV or Solar';
    //partnerAppObj.Manager_Level_Employees__c = 2;
    //partnerAppObj.Sales_Employees__c = 2;
    partnerAppObj.Website__c = 'www.testing.com';
    partnerAppObj.New_to_Solar__c = true;
    partnerAppObj.Years_in_Business__c = 4;
    partnerAppObj.Company_Name__c = 'Test Company'+string.valueOf(DateTime.now());
    partnerAppObj.Zip__c = '123456';
    insert partnerAppObj;    
    id = partnerAppObj.Id;
    
    ApexPages.currentPage().getParameters().put('id', partnerAppObj.Id);
    ApexPages.StandardController controller = new ApexPages.StandardController(partnerAppObj);
    NewPartnerScorecardController testObj = new NewPartnerScorecardController(controller);
    testObj.partnerObj.Years_in_Business__c = 4;
    testObj.partnerObj.Current_Industry__c='PV or Solar';
    testObj.calculate();
    
    testObj.partnerObj.Years_in_Business__c = 2;
    testObj.partnerObj.Current_Industry__c='PV or Solar';
    testObj.calculate();
    
    testObj.partnerObj.Years_in_Business__c = 2;
    testObj.partnerObj.Current_Industry__c=null;
    testObj.calculate();
 
    
    testObj.autoComplete = false;
    //testObj.quickSavePartnerApp();
    testObj.savePartnerApp();
    //partnerAppObj = [Select Id from Partner_Application__c where Id =: id];
    //testObj.calculateFieldValues_CVAR();
    
    testObj.calculateFieldValues();
       
    //testObj.quickSavePartnerApp_CVAR();
    
    testObj.quickSavePartnerApp_EU();
    //partnerAppObj = [Select Id from Partner_Application__c where Id =: id];
    //testObj = new NewPartnerScorecardController(controller);
    testObj.quickSavePartnerApp_FR();
    //partnerAppObj = [Select Id from Partner_Application__c where Id =: id];
    //testObj = new NewPartnerScorecardController(controller);
    testObj.quickSavePartnerApp_IT();
    //partnerAppObj = [Select Id from Partner_Application__c where Id =: id];
    //testObj = new NewPartnerScorecardController(controller);
    testObj.quickSavePartnerApp_GE();    
    
    //TestPartnerApplicationManagement.Test_PartnerApplicationManagement();
    
    testObj.quickSavePartnerApp();
    testObj.quickSavePartnerApp();
    testObj.calculateFieldValues();
    testObj.calculateFieldValues_GE();
    testObj.calculateFieldValues_EU();
    testObj.calculateFieldValues_IT();
    testObj.calculateFieldValues_ES();
    testObj.calculateFieldValues_FR();
  }
  @isTest
   public static void checkNewPartnerScorecardControllerEU(){
  	String id = '';
    Partner_Application__c partnerAppObj = new Partner_Application__c();
    partnerAppObj.Solar_License_Certification__c = true;
    //partnerAppObj.Total_Employee_Base__c = 7;
    partnerAppObj.Existing_Pending_Litigation__c = false;
    partnerAppObj.Location_1__c = 'test location';
    partnerAppObj.Current_Industry__c = 'PV or Solar';
    //partnerAppObj.Manager_Level_Employees__c = 2;
    //partnerAppObj.Sales_Employees__c = 2;
    partnerAppObj.Website__c = 'www.testing.com';
    partnerAppObj.New_to_Solar__c = true;
    partnerAppObj.Years_in_Business__c = 4;
    partnerAppObj.Company_Name__c = 'Test Company'+string.valueOf(DateTime.now());
    partnerAppObj.Zip__c = '123456';
    partnerAppObj.PV_Watts_Sold_Q4__c = 30;
    partnerAppObj.PV_Watts_Sold_Q1__c = 15;
    partnerAppObj.PV_Watts_Sold_Q2__c = 20;
    partnerAppObj.PV_Watts_Sold_Q3__c = 25;
    insert partnerAppObj;    
    id = partnerAppObj.Id;
    Test.startTest();
    ApexPages.currentPage().getParameters().put('id', partnerAppObj.Id);
     ApexPages.currentPage().getParameters().put('Type','BGSM');     
     ApexPages.StandardController controller = new ApexPages.StandardController(partnerAppObj);
    NewPartnerScorecardController testObj = new NewPartnerScorecardController(controller);  
    testObj.quickSavePartnerApp_au();
     testObj.savePartnerApp_au();    
     testObj.quickSavePartnerApp_au();
   
    
    Test.stopTest();
  }
  
}