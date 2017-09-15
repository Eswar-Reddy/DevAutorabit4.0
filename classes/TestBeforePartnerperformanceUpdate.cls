/************************************
**PR-01948
**By- 
**On- 
**Modified - Kapil Goutam
**Modified On- June 17 2009
**Description- Test Class for trigger BeforePartnerPerformanceUpdate
**************************************/
public class TestBeforePartnerperformanceUpdate{
	@isTest
  public static void checkBeforePartnerperformanceUpdate(){
    Account accountObj = new Account();
      accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
      accountObj.Type ='Commercial';
      accountObj.billingCity = 'TestCity';
      accountObj.BillingCountry = 'TestCountry';
      accountObj.BillingPostalCode = '12345';
      accountObj.BillingState = 'TestState';
      accountObj.BillingStreet = 'TestStreet';
      insert accountObj;    
        
       PartnerPerformance__c partnerRec = new PartnerPerformance__c(Partner_Account__c=accountObj.Id);
       insert partnerRec;
   
        List<PartnerPerformance__c> oldpartnerPerformanceList = new List<PartnerPerformance__c>();
        PartnerPerformance__c pp = new PartnerPerformance__c(Id=partnerRec.Id);
        pp.Brand_Guidelines__c = null;
              
        update  pp;
        oldpartnerPerformanceList.add(pp);
        pp.Brand_Guidelines__c = 5;
        pp.Logo_Gear__c=null;
        update pp;
        oldpartnerPerformanceList.add(pp);
        pp.Logo_Gear__c=3;
        pp.MDTF_Funds_Used__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.MDTF_Funds_Used__c = 4;
         pp.Marketing_Material__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Marketing_Material__c = 3;
         pp.Office_Display__c = null;
                 update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Office_Display__c = 4;
         pp.Vehicle_Signage__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Vehicle_Signage__c = 3;
         pp.Website_Logo__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Website_Logo__c = 3;
         pp.Sales_Training_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
        pp.Sales_Training_Score__c = 4;
        pp.Install_Training_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
       pp.Install_Training_Score__c = 3;
       pp.Design_Training_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
        pp.Design_Training_Score__c = 4;
        pp.Opportunity_Contact__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Opportunity_Contact__c = 3;
         pp.Home_Inspection_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Home_Inspection_Score__c = 3;
         pp.On_Time_Sales_Forecast_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.On_Time_Sales_Forecast_Score__c = 2;
         pp.Warranty_Card_Return_Score__c = null;
        update pp;
        oldpartnerPerformanceList.add(pp);
         pp.Warranty_Card_Return_Score__c = 3;
        update pp;
        oldpartnerPerformanceList.add(pp);
        PartnerPerformanceManagement.beforePartnerPerformanceUpdate(oldpartnerPerformanceList,oldpartnerPerformanceList);
        
        TestAccountManagement.Test_AccountUpdate();
  }
}