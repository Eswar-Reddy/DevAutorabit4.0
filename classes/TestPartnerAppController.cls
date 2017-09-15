/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified-Jason Reiber
**Last Modified On-  Nov 17 2015
**Desciption- Test class for controller PartnerAppController
*****************************************************/
@isTest
private class TestPartnerAppController {

@isTest
public static void test_PartnerAppController(){    
    Partner_Application__c partnerApp = new Partner_Application__c();
    partnerApp.Company_Name__c = 'Test CompanyNonCVAR';
    insert partnerApp;
    
    Partner_Application__c partnerApp_CVAR = new Partner_Application__c();
    partnerApp_CVAR.Company_Name__c = 'Test CompanyCVAR';
    insert partnerApp_CVAR;
    
    Partner_Application__c partnerApp_fr = new Partner_Application__c();
    partnerApp_fr.Company_Name__c = 'Test CompanyFR';
    insert partnerApp_fr;
    
    Partner_Application__c partnerApp_de = new Partner_Application__c();
    partnerApp_de.Company_Name__c = 'Test CompanyDE';
    insert partnerApp_de;
    
    
    Partner_Application__c partnerApp_it = new Partner_Application__c();
    partnerApp_it.Company_Name__c = 'Test CompanyIT';
    insert partnerApp_it;
    
    Test.startTest();
    PageReference pg = ApexPages.currentPage();
    ApexPages.StandardController control1 = new ApexPages.StandardController(partnerApp);
    PartnerApplicationController crAppControl = new PartnerApplicationController(control1);  
    crAppControl.step1();
    crAppControl.step2();
    crAppControl.step3();
    crAppControl.savePartnerApplication();
    crAppControl.CancelPartner();
    
    
    ApexPages.StandardController contrl_CVAR = new ApexPages.StandardController(partnerApp_CVAR);
    PartnerApplicationController crAppControl_CVAR = new PartnerApplicationController(contrl_CVAR);
    crAppControl_CVAR.isCVARApplication=true;
    crAppControl_CVAR.step1();
    crAppControl_CVAR.step2();
    crAppControl_CVAR.step3();
    crAppControl_CVAR.savePartnerApplication();
    crAppControl_CVAR.CancelPartner();
    
    ApexPages.StandardController contrl_fr = new ApexPages.StandardController(partnerApp_fr);
    PartnerApplicationController crAppControl_fr = new PartnerApplicationController(contrl_fr);
    crAppControl_fr.step1_fr();
    crAppControl_fr.step2_fr();
    crAppControl_fr.step3_fr();
    crAppControl_fr.step4_fr();
    crAppControl_fr.CancelPartner_fr();
    
    
    ApexPages.StandardController contrl_uk = new ApexPages.StandardController(partnerApp_fr);
    PartnerApplicationController crAppControl_uk = new PartnerApplicationController(contrl_fr);
    crAppControl_uk.step1_uk();
    crAppControl_uk.step2_uk();
    crAppControl_uk.step3_uk();
    crAppControl_uk.CancelPartner_uk();
    
    ApexPages.StandardController contrl_it = new ApexPages.StandardController(partnerApp_it);
    PartnerApplicationController crAppControl_it = new PartnerApplicationController(contrl_it);
    crAppControl_it.step1_it();
    crAppControl_it.step2_it();
    crAppControl_it.step3_it();
    crAppControl_it.step4_it();
    crAppControl_it.CancelPartner_it();
    
     
    
    ApexPages.StandardController contrl_de = new ApexPages.StandardController(partnerApp_de);
    PartnerApplicationController crAppControl_de = new PartnerApplicationController(contrl_de);
    crAppControl_de.step1_de();
    crAppControl_de.step2_de();
    crAppControl_de.step3_de();
    crAppControl_de.step4_de();
    crAppControl_de.CancelPartner_de();
    
    
    Partner_Application__c partnerApp_es = new Partner_Application__c();
    partnerApp_es.Company_Name__c = 'Test CompanyES';
    // insert partnerApp_es;//Commented by Birlasoft
    ApexPages.StandardController contrl_es = new ApexPages.StandardController(partnerApp_es);
    PartnerApplicationController crAppControl_es = new PartnerApplicationController(contrl_es);
    crAppControl_es.step1_es();
    crAppControl_es.step2_es();
    crAppControl_es.step3_es();
    crAppControl_es.step4_es();
    crAppControl_es.savePartnerApplication();
    crAppControl_es.CancelPartner_es();
    
    Test.stopTest();
}

@isTest
public static void test_PartnerApplicationScoreController(){
  Partner_Application__c partnerObj = new Partner_Application__c();
  partnerObj.Company_Name__c = 'Test Company11';
  partnerObj.Zip__c = '123456';
  partnerObj.New_to_Solar__c = true;
  partnerObj.Current_Industry__c ='PV or Solar';
  partnerObj.Years_in_Business__c =5;
  insert partnerObj;
  
  ApexPages.currentPage().getParameters().put('id', partnerObj.Id);  
  ApexPages.StandardController controller = new ApexPages.StandardController(partnerObj);
  PartnerApplicationScoreController testObj = new PartnerApplicationScoreController(controller);
  PageReference pgRef = testObj.returnToApplication();
  testObj.calculate();
  testObj.calculateFieldValues_ES();
  testObj.quickSavePartnerApp_es();
  testObj.savePartnerApp_es();    
  testObj.returnToApplication();  
  
}

@isTest
public static void test_NewPartnerScorecardController(){
  Partner_Application__c partnerObj = new Partner_Application__c();
  partnerObj.Company_Name__c = 'Test Company22';
  partnerObj.Solar_License_Certification__c = true;
  partnerObj.Existing_Pending_Litigation__c = false;
  partnerObj.Location_1__c = 'TestLocation';
  partnerObj.Current_Industry__c = 'PV or Solar';
  partnerObj.Website__c = 'www.Testing.com';
  partnerObj.Solar_License_Certification__c = true;   
  partnerObj.Years_in_Business__c = 6; 
  partnerObj.License_Details__c = 'YES';
  partnerObj.License_or_qualification_Details__c = 'YES';
  partnerObj.Zip__c = '123456';
  insert partnerObj;
  
  ApexPages.currentPage().getParameters().put('id', partnerObj.Id);  
  ApexPages.StandardController controller = new ApexPages.StandardController(partnerObj);
  NewPartnerScorecardController testObj = new NewPartnerScorecardController(controller);
  testObj.calculateFieldValues();
  //testObj.quickSavePartnerApp();  
  testObj.savePartnerApp();  
}
@isTest
public static void test_PartnerAppController_au(){
    Lead lead = new Lead();
    lead.LastName = 'Test Lead';
    lead.Company = 'Test Company Name';
    lead.Status = 'Open';
    lead.LeadSource = 'Web';
    lead.Email = 'test@test.com';
    //lead.Phone = ;
    insert lead;
    Partner_Application__c partnerApp_au = new Partner_Application__c();
    partnerApp_au.Company_Name__c = 'Test CompanyAUS';    
    insert partnerApp_au;
    
    Partner_Application__c partnerApp = new Partner_Application__c();
    partnerApp.Company_Name__c = 'Test CompanyNonCVAR';
    insert partnerApp;
    
    Partner_Application__c partnerApp_CVAR = new Partner_Application__c();
    partnerApp_CVAR.Company_Name__c = 'Test CompanyCVAR';
    insert partnerApp_CVAR;
    
    Test.startTest();
    ApexPages.currentPage().getParameters().put('LId', lead.Id);  
    ApexPages.StandardController contrl_au = new ApexPages.StandardController(partnerApp_au);
    PartnerApplicationController crAppControl_au = new PartnerApplicationController(contrl_au);
    crAppControl_au.step1_au();
    crAppControl_au.step2_au();
    crAppControl_au.step3_au();
    crAppControl_au.step4_au();
    crAppControl_au.savePartnerApplication();
    crAppControl_au.CancelPartner_au();    
    
    PageReference pg = ApexPages.currentPage();
    ApexPages.currentPage().getParameters().put('LId', lead.Id);
      
    ApexPages.StandardController control1 = new ApexPages.StandardController(partnerApp);
    PartnerApplicationController crAppControl = new PartnerApplicationController(control1);  
    crAppControl.step1();
    crAppControl.step2();
    crAppControl.step3();
    crAppControl.savePartnerApplication();
    crAppControl.CancelPartner();    
    
    ApexPages.currentPage().getParameters().put('LId', lead.Id);  
    ApexPages.StandardController contrl_CVAR = new ApexPages.StandardController(partnerApp_CVAR);
    PartnerApplicationController crAppControl_CVAR = new PartnerApplicationController(contrl_CVAR);
    crAppControl_CVAR.isCVARApplication=true;
    crAppControl_CVAR.step1();
    crAppControl_CVAR.step2();
    crAppControl_CVAR.step3();
    crAppControl_CVAR.savePartnerApplication();
    crAppControl_CVAR.CancelPartner();
    crAppControl_CVAR.getYesNo();
    
    ApexPages.currentPage().getParameters().put('LId', lead.Id);  
    ApexPages.StandardController controller1 = new ApexPages.StandardController(partnerApp_CVAR);
    PartnerApplicationController crAppController = new PartnerApplicationController(controller1);
    crAppController.sendEmailToLeadOwner();
    crAppController.isCVARApplication=true;
    crAppController.step1_bg();
    crAppController.step2_bg();
    crAppController.step3_bg();
    crAppController.step4_bg();
    crAppController.CancelPartner_bg();
    
    Test.stopTest();
    
    
}

@isTest
// case 00424687 : If an owner field is populated, the corresponding DOB and % ownership fields cannot be blank
public static void test_validations_PartnerAppController(){    
    Partner_Application__c partnerApp = new Partner_Application__c();
    
    Test.startTest();
    PageReference pg = ApexPages.currentPage();
    ApexPages.StandardController control1 = new ApexPages.StandardController(partnerApp);
    PartnerApplicationController crAppControl = new PartnerApplicationController(control1);  
    // Owner 2 validation
    crAppControl.partnerApp.Owner_2__c = 'test';
    crAppControl.step1();
    crAppControl.partnerApp.Owner_2__c = null;
    // Owner 3 validation
    crAppControl.partnerApp.Owner_3__c = 'test';
    crAppControl.step1();
    crAppControl.partnerApp.Owner_3__c = null;
    // Owner 4 validation
    crAppControl.partnerApp.Owner_4__c = 'test';
    crAppControl.step1();
    crAppControl.partnerApp.Owner_4__c = null;
    // Owner 5 validation
    crAppControl.partnerApp.Owner_5__c = 'test';
    crAppControl.step1();
    crAppControl.partnerApp.Owner_5__c = null;   
    
    Test.stopTest();
}

}