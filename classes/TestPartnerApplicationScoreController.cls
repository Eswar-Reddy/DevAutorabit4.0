@isTest
private class TestPartnerApplicationScoreController{

 @isTest
 public static void test_PartnerApplicationScoreController(){    
    
        //create partner application
        
        Partner_Application__c partnerApp = new Partner_Application__c();
        partnerApp.Company_Name__c = 'Test CompanyNonCVAR';
        insert partnerApp;
        
        
        PageReference pg = ApexPages.currentPage();
        ApexPages.StandardController control1 = new ApexPages.StandardController(partnerApp);
        PartnerApplicationScoreController crAppControl = new PartnerApplicationScoreController(control1);  
        
       
        //check functionality of fetchPartnerData() for BGSM Type
        
        ApexPages.currentPage().getParameters().put('Type','BGSM');
        ApexPages.StandardController controller1 = new ApexPages.StandardController(partnerApp);
        PartnerApplicationScoreController testObj1 = new PartnerApplicationScoreController(controller1);
    
    
        // Insert Partner Application
       
        RecordType recType = [Select Id, Name From RecordType where SobjectType = 'Partner_Application__c' and Name='AUS Partner Application'];
    
          // Insert Partner Application
        
          Partner_Application__c partnerObj = new Partner_Application__c();
          partnerObj.Company_Name__c = 'Test Company11';
          partnerObj.Zip__c = '123456';
          partnerObj.New_to_Solar__c = true;
          partnerObj.Current_Industry__c ='PV or Solar';
          partnerObj.Years_in_Business__c =20;
          partnerObj.Language__c = 'Italian';
          partnerObj.RecordTypeId=recType.id;
          partnerObj.Website__c ='www.test.com';
          partnerObj.Insurance_Carrier_1__c='IC1';
          partnerObj.Insurance_Coverage_1__c='IC1';
          partnerObj.Solar_License_Certification__c=true;
          partnerObj.Bank_Guarantee__c = true;
          partnerObj.Location_1__c='Loc1';
          partnerObj.Current_Industry__c ='PV';
          partnerObj.Quality_Certification__c=true;
          partnerObj.Tabelle_e_abilitazioni_es_46_90__c=true;
          partnerObj.Web_Page__c = true;
          partnerObj.PV_Watts_Sold_Q1__c=7;
          partnerObj.PV_Watts_Sold_Q2__c=8;
          partnerObj.PV_Watts_Sold_Q3__c=7;
          partnerObj.PV_Watts_Sold_Q4__c=5;
          partnerObj.PV_Watts_Sold_last_year__c=60;
          partnerObj.PV_Watts_Sold_2_years_ago__c=15;
          partnerObj.PV_Watts_Sold_3_years_ago__c=12;
          partnerObj.PV_Experience_years__c = 12;
          partnerObj.Current_Industry__c = 'PV or Solar';
          partnerObj.Years_in_Business__c=7;
          partnerObj.Field_Level_Design_Employees__c=12;
          partnerObj.Showroom__c = true;
          partnerObj.CRM__c = true;
          partnerObj.Installation_Vehicle_Fleet__c = true;
          insert partnerObj;
      
          //check functionality of fetchPartnerData() for partnerObj
      
          ApexPages.currentPage().getParameters().put('id', partnerObj.Id);  
          ApexPages.StandardController controller = new ApexPages.StandardController(partnerObj);
          PartnerApplicationScoreController testObj = new PartnerApplicationScoreController(controller);
          PageReference pgRef1 = testObj.returnToApplication();
          PageReference pgRef2 = testObj.calculateFieldValues_ES();
          PageReference pgRef3 = testObj.quickSavePartnerApp_es();
          PageReference pgRef4 = testObj.savePartnerApp_es();
          Boolean b = testObj.calculate();
          
          
          // Insert Partner_Application__c to check else condition of fetchPartnerData() 
          
          Partner_Application__c partnerObj1 = new Partner_Application__c();
          partnerObj1.Company_Name__c = 'Test Company123';
          insert partnerObj1 ;
          ApexPages.currentPage().getParameters().put('id', partnerObj1.Id);  
          ApexPages.StandardController controller2 = new ApexPages.StandardController(partnerObj1);
          PartnerApplicationScoreController testObj2 = new PartnerApplicationScoreController(controller2);
          
          
     }
}